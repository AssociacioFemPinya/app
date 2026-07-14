import 'package:dio/dio.dart';
import 'package:fempinya3_flutter_app/core/service_locator.dart';
import 'home_api_endpoints.dart';

class HomeData {
  final int unreadCount;
  final List<NoticiaItem> recent;
  final String? lastLoginAt;
  final int loginCount;

  const HomeData({
    required this.unreadCount,
    required this.recent,
    required this.lastLoginAt,
    required this.loginCount,
  });

  factory HomeData.fromJson(Map<String, dynamic> json) {
    final noticies = json['noticies'] as Map<String, dynamic>;
    final stats    = json['loginStats'] as Map<String, dynamic>;
    return HomeData(
      unreadCount: noticies['unread_count'] as int,
      recent:      (noticies['recent'] as List).map((e) => NoticiaItem.fromJson(e)).toList(),
      lastLoginAt: stats['lastLoginAt'] as String?,
      loginCount:  stats['loginCount']  as int,
    );
  }
}

class NoticiaItem {
  final int id;
  final String title;
  final List<String> labels;
  final String publishedAt;
  final bool unread;
  final String? body;

  const NoticiaItem({
    required this.id,
    required this.title,
    required this.labels,
    required this.publishedAt,
    required this.unread,
    this.body,
  });

  factory NoticiaItem.fromJson(Map<String, dynamic> json) => NoticiaItem(
        id:          json['id'] as int,
        title:       json['title'] as String,
        labels:      (json['labels'] as List?)?.cast<String>() ?? [],
        publishedAt: json['published_at'] as String,
        unread:      json['unread'] as bool? ?? false,
        body:        json['body'] as String?,
      );
}

class HomeService {
  final Dio _dio = sl<Dio>();

  Future<HomeData> fetchHome() async {
    final response = await _dio.get(HomeApiEndpoints.getHome);
    return HomeData.fromJson(response.data as Map<String, dynamic>);
  }

  Future<List<NoticiaItem>> fetchNoticies() async {
    final response = await _dio.get(HomeApiEndpoints.getNoticies);
    final data = response.data as Map<String, dynamic>;
    return (data['noticies'] as List).map((e) => NoticiaItem.fromJson(e)).toList();
  }
}
