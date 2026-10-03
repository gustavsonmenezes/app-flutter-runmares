abstract final class AppRoutes {
  static const String login = '/login';
  static const String home = '/home';
  static const String history = '/history';
  static const String profile = '/profile';
  static const String recording = '/recording';
  static const String settings = '/settings';

  static const String activityIdParam = 'activityId';

  static String activityDetails(String activityId) => '$history/$activityId';
}
