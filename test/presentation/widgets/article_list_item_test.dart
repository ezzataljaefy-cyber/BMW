import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_troubleshooter/domain/entities/article.dart';
import 'package:mobile_troubleshooter/presentation/widgets/article_list_item.dart';

void main() {
  final tArticle = Article(
    id: 'art001',
    title: 'Test Article Title',
    author: 'John Doe',
    date: DateTime(2023, 1, 1),
    isPremium: true,
    tags: ['test'],
    content: '<p>This is the content that should be excerpted.</p>',
  );

  testWidgets('ArticleListItem displays article data correctly', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: ArticleListItem(article: tArticle),
      ),
    ));

    // Verify that the title, author, and premium tag are displayed.
    expect(find.text('Test Article Title'), findsOneWidget);
    expect(find.text('John Doe'), findsOneWidget);
    expect(find.text('Premium'), findsOneWidget);
    expect(find.byIcon(Icons.star), findsOneWidget);

    // Verify that the date is displayed
    expect(find.text('1/1/2023'), findsOneWidget);
  });

   testWidgets('ArticleListItem does not display premium tag for non-premium article', (WidgetTester tester) async {
    final tNonPremiumArticle = Article(
      id: 'art002',
      title: 'Non-Premium Article',
      author: 'Jane Doe',
      date: DateTime(2023, 1, 2),
      isPremium: false,
      tags: [],
      content: 'Free content.',
    );
    // Build our app and trigger a frame.
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: ArticleListItem(article: tNonPremiumArticle),
      ),
    ));

    // Verify that the title and author are displayed.
    expect(find.text('Non-Premium Article'), findsOneWidget);
    expect(find.text('Jane Doe'), findsOneWidget);

    // Verify that the premium tag is NOT displayed.
    expect(find.text('Premium'), findsNothing);
    expect(find.byIcon(Icons.star), findsNothing);
  });
}
