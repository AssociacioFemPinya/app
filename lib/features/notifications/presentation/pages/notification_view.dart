import 'package:fempinya3_flutter_app/features/notifications/presentation/bloc/notifications_view/notifications_view_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NotificationViewPageView extends StatelessWidget {
  final int notificationID;

  const NotificationViewPageView({super.key, required this.notificationID});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<NotificationViewBloc>(
          create: (context) => NotificationViewBloc()
            ..add(LoadNotification(notificationID)),
        ),
      ],
      child: notificationView(context),
    );
  }

  Widget notificationView(BuildContext context) {
    return BlocBuilder<NotificationViewBloc, NotificationViewState>(
      builder: (context, state) {
        if (state is NotificationViewInitial) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final notification = state.notification;

        if (notification == null) {
          return const Scaffold(
            body: Center(child: Text('Notification not found.')),
          );
        }

        final formattedDate = DateFormat('yyyy-MM-dd HH:mm').format(notification.createdAt);

        return Scaffold(
          appBar: AppBar(
            title: const Text('Notification'),
            centerTitle: true,
          ),
          body: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  notification.title,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 12),
                Text(
                  'From: ${notification.sender}',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Colors.grey[700],
                      ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Sent: $formattedDate',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey[600],
                      ),
                ),
                const Divider(height: 32),
                Expanded(
                  child: SingleChildScrollView(
                    child: Text(
                      notification.message,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            fontSize: 16,
                          ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
