import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/localization/app_localizations.dart';
import '../../providers/article_providers.dart';
import '../auth/login_screen.dart';
import '../chat/chat_screen.dart';
import '../../widgets/article_list_item.dart';
import '../../widgets/search_bar.dart';

// Provider to manage the selected index of the BottomNavigationBar
final homeScreenIndexProvider = StateProvider<int>((ref) => 0);

class HomeScreen extends ConsumerWidget {
  const HomeScreen({Key? key}) : super(key: key);

  static const List<Widget> _widgetOptions = <Widget>[
    ArticleList(), // A new widget to encapsulate the article list and search
    Text('Bookmarks (Not Implemented)'), // Placeholder
    ChatScreen(),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final selectedIndex = ref.watch(homeScreenIndexProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.translate('appTitle')),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {},
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Text('Menu', style: TextStyle(color: Colors.white, fontSize: 24)),
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: Text(l10n.translate('logout')),
              onTap: () {
                // TODO: Implement logout
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                );
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.bug_report, color: Colors.red),
              title: const Text('Test Crash'),
              onTap: () {
                FirebaseCrashlytics.instance.crash();
              },
            ),
          ],
        ),
      ),
      body: Center(
        child: _widgetOptions.elementAt(selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: const Icon(Icons.home),
            label: l10n.translate('home'),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.bookmark),
            label: l10n.translate('bookmarks'),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.chat_bubble_outline),
            label: l10n.translate('aiChat'),
          ),
        ],
        currentIndex: selectedIndex,
        onTap: (int index) {
          ref.read(homeScreenIndexProvider.notifier).state = index;
        },
      ),
    );
  }
}

// A new widget to encapsulate the article list and search bar logic
class ArticleList extends ConsumerWidget {
  const ArticleList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final articlesAsyncValue = ref.watch(articlesProvider);
    final searchedArticlesAsyncValue = ref.watch(searchedArticlesProvider);
    final searchQuery = ref.watch(searchQueryProvider);
    final showAds = ref.watch(gdprConsentProvider);
    final remoteConfig = ref.watch(remoteConfigServiceProvider);

    final articlesToShow = searchQuery.isEmpty ? articlesAsyncValue : searchedArticlesAsyncValue;

    return Column(
      children: [
        // Optional Promotional Message from Remote Config
        if (remoteConfig.showPromotionalMessage)
          Container(
            padding: const EdgeInsets.all(12),
            color: Colors.blue.shade100,
            child: Text(
              remoteConfig.promotionalMessage,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.blue.shade900),
            ),
          ),
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: SearchBarWidget(),
        ),
        Expanded(
          child: articlesToShow.when(
            data: (articles) {
              if (articles.isEmpty) {
                return Center(
                  child: Text(searchQuery.isEmpty
                      ? 'No articles found.'
                      : 'No results for "$searchQuery"'),
                );
              }
              return RefreshIndicator(
                onRefresh: () => ref.refresh(articlesProvider.future),
                child: ListView.builder(
                  itemCount: articles.length,
                  itemBuilder: (context, index) {
                    final article = articles[index];
                    return ArticleListItem(article: article);
                  },
                ),
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, stack) => Center(child: Text('An error occurred: $err')),
          ),
        ),
        // Show banner ad if consent is given
        if (showAds == true)
          const Padding(
            padding: EdgeInsets.only(top: 8.0),
            child: BannerAdWidget(),
          ),
      ],
    );
  }
}
