class EventsApiEndpoints {
  static const String getEvents = '/api-fempinya/mobile_events';

  static String updateAttendance(int eventId) =>
      '/api-fempinya/mobile_events/$eventId';
}
