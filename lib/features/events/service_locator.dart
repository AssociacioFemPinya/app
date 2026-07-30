import 'package:dio/dio.dart';
import 'package:femcastells/features/events/data/mocks/events_service/events_service.dart';
import 'package:femcastells/features/events/domain/useCases/get_event.dart';
import 'package:femcastells/features/events/domain/useCases/post_event.dart';
import 'package:femcastells/features/events/data/repositories/events_repository_impl.dart';
import 'package:femcastells/features/events/data/sources/events_service.dart';
import 'package:femcastells/features/events/domain/repositories/events_repository.dart';
import 'package:femcastells/features/events/domain/useCases/get_events_list.dart';
import 'package:get_it/get_it.dart';

final sl = GetIt.instance;

Future<void> setupEventsServiceLocator(bool useMockApi) async {
  sl.registerSingleton<EventsService>(EventsServiceImpl());
  sl.registerSingleton<EventsRepository>(EventsRepositoryImpl());
  sl.registerSingleton<GetEventsList>(GetEventsList());
  sl.registerSingleton<GetEvent>(GetEvent());
  sl.registerSingleton<PostEvent>(PostEvent());

  setupMockInterceptor(useMockApi);
}

void setupMockInterceptor(bool useMockApi) {
  if (useMockApi) {
    Dio? _dio = sl<Dio>();
    _dio.interceptors.add(EventsDioMockInterceptor());
  }
}
