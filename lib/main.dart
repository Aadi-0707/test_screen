import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:insta_downloader/screen/main_shell.dart';
import 'package:insta_downloader/screen/splash_screen.dart';
import 'core/theme/app_theme.dart';
import 'core/utils/strings_service.dart';
import 'data/download_storage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // UI strings from JSON + download history from local storage
  await StringsService.init();
  await DownloadStorage.instance.init();

  // Status bar style
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
  );

  runApp(const InstaDownloaderApp());
}

class InstaDownloaderApp extends StatelessWidget {
  const InstaDownloaderApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'InstaDownloader',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.dark, // Default is Dark
      home: const SplashToHome(),
    );
  }
}

/// Splash → MainShell (Home + bottom nav)
class SplashToHome extends StatefulWidget {
  const SplashToHome({super.key});

  @override
  State<SplashToHome> createState() => _SplashToHomeState();
}

class _SplashToHomeState extends State<SplashToHome> {
  bool _showHome = false;

  @override
  Widget build(BuildContext context) {
    if (_showHome) {
      return const MainShell();
    }
    return SplashScreen(
      onFinished: () {
        setState(() => _showHome = true);
      },
    );
  }
}
