import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:fempinya3_flutter_app/features/events/domain/entities/event.dart';
import 'package:fempinya3_flutter_app/features/events/domain/useCases/get_events_list.dart';
import 'package:fempinya3_flutter_app/features/events/service_locator.dart'
    as events_locator;
import 'package:fempinya3_flutter_app/features/login/domain/entities/token.dart';
import 'package:fempinya3_flutter_app/features/login/domain/useCase/get_token.dart';
import 'package:fempinya3_flutter_app/features/login/service_locator.dart'
    as login_locator;
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:test/test.dart';

const _apiBaseUrl = String.fromEnvironment('API_BASE_URL');
const _testEmail = String.fromEnvironment('API_TEST_EMAIL');
const _testPassword = String.fromEnvironment('API_TEST_PASSWORD');
final _isConfigured =
    _apiBaseUrl.isNotEmpty && _testEmail.isNotEmpty && _testPassword.isNotEmpty;

void main() {
  final serviceLocator = GetIt.instance;

  setUpAll(() async {
    if (!_isConfigured) {
      return;
    }

    await serviceLocator.reset();
    serviceLocator.registerSingleton<Dio>(Dio(BaseOptions(
      baseUrl: _apiBaseUrl,
      connectTimeout: const Duration(seconds: 20),
      receiveTimeout: const Duration(seconds: 20),
      headers: const {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
    )));
    serviceLocator.registerSingleton<Logger>(Logger(level: Level.nothing));

    await login_locator.setupLoginServiceLocator(false);
    await events_locator.setupEventsServiceLocator(false);
  });

  tearDownAll(() async {
    if (_isConfigured) {
      await serviceLocator.reset();
    }
  });

  test(
    'GetToken and GetEventsList retrieve events from the local API',
    () async {
      final tokenResult = await serviceLocator<GetToken>()(
        params: GetTokenParams(mail: _testEmail, password: _testPassword),
      );
      final token = _expectRight<TokenEntity>(tokenResult, 'login');
      expect(token.access_token, isNotEmpty);

      serviceLocator<Dio>().options.headers['Authorization'] =
          'Bearer ${token.access_token}';

      final eventsResult = await serviceLocator<GetEventsList>()(
        params: GetEventsListParams(),
      );
      final events = _expectRight<List<EventEntity>>(eventsResult, 'events');

      expect(events, hasLength(greaterThanOrEqualTo(5)));
      expect(events.first.id, greaterThan(0));
      expect(events.first.title, isNotEmpty);
    },
    skip: _isConfigured
        ? false
        : 'Set API_BASE_URL, API_TEST_EMAIL and API_TEST_PASSWORD with --dart-define to run this local integration test.',
  );
}

T _expectRight<T>(Either<dynamic, dynamic> result, String operation) {
  return result.fold(
    (failure) => throw TestFailure('$operation failed: $failure'),
    (value) => value as T,
  );
}
