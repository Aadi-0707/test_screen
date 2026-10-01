import 'package:flutter_test/flutter_test.dart';
import 'package:insta_downloader/main.dart';

void main() {
  testWidgets('InstaDownloader splash screen loads',
      (WidgetTester tester) async {
    await tester.pumpWidget(const InstaDownloaderApp());

    // Wait for data.json to load
    await tester.pumpAndSettle();

    // App name (split into two Text widgets)
    expect(find.text('Insta'), findsOneWidget);
    expect(find.text('Downloader'), findsOneWidget);

    // Tagline parts
    expect(find.text('Download'), findsOneWidget);
    expect(find.text('Save'), findsOneWidget);
    expect(find.text('Enjoy'), findsOneWidget);

    // Loading + Version
    expect(find.text('Loading amazing content...'), findsOneWidget);
    expect(find.text('Version 1.0.0'), findsOneWidget);
  });
}
