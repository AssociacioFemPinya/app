import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:femcastells/core/navigation/route_names.dart';
import 'package:femcastells/core/service_locator.dart';
import 'package:femcastells/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:go_router/go_router.dart';

/// Background message handler for Firebase Cloud Messaging
/// This runs in a separate isolate when the app is in the background or terminated
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Initialize Firebase if not already initialized
  if (Firebase.apps.isEmpty) {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }
  
  // Store notification data for later processing when the app is fully initialized
  if (message.data.containsKey('action_url')) {
    FirebaseNotificationService._pendingNotification = PendingNotification(
      message.data['action_url'],
      message.data['resource_id'] ?? ''
    );
  }
}

/// Model class to store pending notification data
/// Used when a notification is received while the app is not fully initialized
class PendingNotification {
  /// The route path name to navigate to
  final String pathName;
  
  /// The resource ID associated with the notification (e.g., event ID)
  final String resourceId;
  
  PendingNotification(this.pathName, this.resourceId);
  
  @override
  String toString() => 'PendingNotification(pathName: $pathName, resourceId: $resourceId)';
}

/// Service for handling Firebase Cloud Messaging notifications
/// Responsible for initializing FCM, handling notifications, and navigation
class FirebaseNotificationService {
  // Private constructor for singleton pattern
  FirebaseNotificationService._();
  
  /// Singleton instance of the service
  static final FirebaseNotificationService instance = FirebaseNotificationService._();
      
  /// Store pending notification for when the app is fully initialized
  static PendingNotification? _pendingNotification;
  
  /// Check if there's a pending notification to process
  static PendingNotification? get pendingNotification => _pendingNotification;
  
  /// Clear the pending notification after processing
  static void clearPendingNotification() {
    _pendingNotification = null;
  }
  
  /// Process any pending notifications after the app is fully initialized
  static void processPendingNotifications() {
    if (_pendingNotification != null) {
      debugPrint('INFO: Processing pending notification: ${_pendingNotification!}');
      instance._handleActionRouting(_pendingNotification!.pathName, _pendingNotification!.resourceId);
      clearPendingNotification();
    }
  }

  /// Firebase Messaging instance
  final _messaging = FirebaseMessaging.instance;
  
  /// Flutter Local Notifications Plugin instance
  final _localNotifications = FlutterLocalNotificationsPlugin();
  
  /// Flag to track if local notifications are initialized
  bool _isFlutterLocalNotificationPluginInitialized = false;
  
  /// Channel ID for Android notifications
  static const String _channelId = 'fempinya_channel';
  
  /// Channel name for Android notifications
  static const String _channelName = 'Fempinya Channel';
  
  /// Channel description for Android notifications
  static const String _channelDescription = 'Channel for Fempinya notifications';

  /// Initialize the Firebase Notification Service
  /// Sets up background handlers, local notifications, and message handlers
  Future<void> initialize() async {
    // Set up background message handler first
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    
    // Initialize the Flutter Local Notifications Plugin
    await _setupLocalNotifications();
    
    // Request permissions
    await _requestPermission();

    // Set up message handlers
    await _setupMessageHandlers();

    // Get FCM token for device registration
    final token = await _messaging.getToken();
    debugPrint('FCM Token: $token');
    if (token != null) {
      await _sendTokenToBackend(token);
    }

    // Refresh token when it changes
    _messaging.onTokenRefresh.listen(_sendTokenToBackend);
  }

  Future<void> syncToken() async {
    final token = await _messaging.getToken();
    if (token != null) await _sendTokenToBackend(token);
  }

  Future<void> _sendTokenToBackend(String token) async {
    try {
      await sl<Dio>().post(
        '/api-fempinya/device-token',
        data: {'token': token},
      );
      debugPrint('FCM token sent to backend');
    } catch (e) {
      debugPrint('WARNING: Could not send FCM token to backend: $e');
    }
  }

  /// Request notification permissions from the user
  Future<void> _requestPermission() async {
    final settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
      announcement: false,
      carPlay: false,
      criticalAlert: false,
    );
    
    debugPrint('User notification permission status: ${settings.authorizationStatus}');
  }

  /// Set up local notifications for displaying FCM messages
  Future<void> _setupLocalNotifications() async {
    // Skip if already initialized
    if (_isFlutterLocalNotificationPluginInitialized) {
      return;
    }

    // Android notification channel setup
    const channel = AndroidNotificationChannel(
      _channelId,
      _channelName,
      description: _channelDescription,
      importance: Importance.high,
      playSound: true,
      enableVibration: true,
      showBadge: true,
    );

    // Create the Android notification channel
    await _localNotifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    // Android initialization settings
    // TODO: Replace with your app's icon when available
    const initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    // iOS initialization settings
    final initializationSettingsDarwin = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    // Combined initialization settings
    final initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin,
    );

    // Initialize the local notifications plugin
    await _localNotifications.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: _onNotificationResponse,
    );

    _isFlutterLocalNotificationPluginInitialized = true;
  }
  
  /// Handler for when a notification is tapped
  void _onNotificationResponse(NotificationResponse response) async {
    final String? payload = response.payload;
    
    if (payload != null) {
      try {
        final data = Map<String, dynamic>.from(jsonDecode(payload));
        
        // Handle the notification data
        if (data.containsKey('action_url')) {
          _handleActionRouting(data['action_url'], data['resource_id'] ?? '');
        } else {
          // Create a RemoteMessage-like object to reuse the same handler
          final message = RemoteMessage(data: data);
          _handleBackgroundMessage(message);
        }
      } catch (e) {
        debugPrint('Error processing notification payload: $e');
      }
    } else {
      debugPrint('WARNING: Notification payload is null');
    }
  }

  /// Display a local notification from a Firebase message
  Future<void> showNotification(RemoteMessage message) async {    
    final RemoteNotification? notification = message.notification;
    
    // Make sure we have notification data to display
    if (notification == null) {
      debugPrint('WARNING: Cannot show notification - notification is null');
      return;
    }
    
    try {
      // Encode the message data as payload for when the notification is tapped
      final encodedPayload = jsonEncode(message.data);
      
      // Show the notification
      await _localNotifications.show(
        notification.hashCode, // Use hashCode as notification ID
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            _channelId,
            _channelName,
            channelDescription: _channelDescription,
            importance: Importance.high,
            priority: Priority.high,
            icon: '@mipmap/ic_launcher', // TODO: Replace with your app's icon
            playSound: true,
            enableVibration: true,
            autoCancel: true,  // Auto dismiss when tapped
            ongoing: false,    // Not persistent
            channelShowBadge: true,
            fullScreenIntent: true,  // Important for user interaction
          ),
          iOS: const DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
            interruptionLevel: InterruptionLevel.active,  // Important for user interaction
          ),
        ),
        payload: encodedPayload,
      );
    } catch (e) {
      debugPrint('ERROR: Failed to show notification: $e');
    }
  }

  /// Set up Firebase message handlers for different app states
  Future<void> _setupMessageHandlers() async {
    // Foreground message handler - when the app is open and in the foreground
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint('Foreground message received: ${message.notification?.title}');
      showNotification(message);
    });

    // App opened from terminated state via notification
    final initialMessage = await _messaging.getInitialMessage();
    if (initialMessage != null) {
      debugPrint('App opened from terminated state via notification');
      _handleBackgroundMessage(initialMessage);
    }
    
    // App opened from background state via notification
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      debugPrint('App opened from background state via notification');
      _handleBackgroundMessage(message);
    });
  }

  /// Handle messages received when app was in background or terminated
  void _handleBackgroundMessage(RemoteMessage message) {    
    debugPrint('Handling background message: ${message.messageId}');
    
    // Extract routing information if available
    if (message.data.containsKey('action_url')) {
      final actionUrl = message.data['action_url'];
      final resourceId = message.data['resource_id'] ?? '';
      
      debugPrint('Routing to: $actionUrl with resource ID: $resourceId');
      _handleActionRouting(actionUrl, resourceId);
    } else {
      debugPrint('No action_url in message data, cannot route');
    }
  }

  /// Handle navigation based on the notification's action URL and resource ID
  void _handleActionRouting(String pathName, String resourceId) {
    try {
      // If the app is not fully initialized yet, store the notification data for later
      if (!sl.isRegistered<GoRouter>()) {
        debugPrint('INFO: App not fully initialized, storing notification data for later');
        _pendingNotification = PendingNotification(pathName, resourceId);
        return;
      }
      
      // Get the router from the service locator
      final router = sl<GoRouter>();
      
      // Handle different routes based on the pathName
      switch (pathName) {
        case 'event':
          debugPrint('Navigating to event: $resourceId');
          router.pushNamed(eventRoute, pathParameters: {'eventID': resourceId});
          break;
        case 'noticia':
          debugPrint('Navigating to notifications (notícia received)');
          router.pushNamed(notificationsRoute);
          break;
        default:
          debugPrint('WARNING: Unknown route: $pathName');
          break;
      }
    } catch (e) {
      debugPrint('ERROR: Failed to navigate to $pathName: $e');
      // Store for later processing when the app is fully initialized
      _pendingNotification = PendingNotification(pathName, resourceId);
    }
  }
}