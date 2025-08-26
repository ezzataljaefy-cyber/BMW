import 'package:firebase_analytics/firebase_analytics.dart';

class AnalyticsService {
  final FirebaseAnalytics _analytics;

  AnalyticsService({FirebaseAnalytics? analytics})
      : _analytics = analytics ?? FirebaseAnalytics.instance;

  // Login event
  Future<void> logLogin() async {
    await _analytics.logLogin(loginMethod: 'google');
  }

  // Article view event
  Future<void> logArticleView(String articleId, String articleTitle) async {
    await _analytics.logEvent(
      name: 'view_article',
      parameters: {
        'article_id': articleId,
        'article_title': articleTitle,
      },
    );
  }

  // Search event
  Future<void> logSearch(String searchTerm) async {
    await _analytics.logSearch(searchTerm: searchTerm);
  }
}

// Provider for the AnalyticsService
final analyticsServiceProvider = Provider<AnalyticsService>((ref) {
  return AnalyticsService();
});
