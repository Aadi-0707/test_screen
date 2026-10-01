import 'package:flutter/material.dart';

class AppStringsModel {
  final String appName;
  final String appTagline;
  final AppColorsConfig colors;
  final ImagesConfig images;
  final SplashStrings splash;
  final HomeStrings home;
  final DetectStrings detect;
  final MediaPreviewStrings mediaPreview;
  final DownloadingStrings downloading;
  final DownloadCompleteStrings downloadComplete;
  final DownloadsStrings downloads;
  final HistoryStrings history;
  final SettingsStrings settings;
  final SideMenuStrings sideMenu;
  final ApiConfig api;

  AppStringsModel({
    required this.appName,
    required this.appTagline,
    required this.colors,
    required this.images,
    required this.splash,
    required this.home,
    required this.detect,
    required this.mediaPreview,
    required this.downloading,
    required this.downloadComplete,
    required this.downloads,
    required this.history,
    required this.settings,
    required this.sideMenu,
    required this.api,
  });

  factory AppStringsModel.fromJson(Map<String, dynamic> json) {
    return AppStringsModel(
      appName: json['app_name'] as String,
      appTagline: json['app_tagline'] as String,
      colors: AppColorsConfig.fromJson(json['colors'] as Map<String, dynamic>),
      images: ImagesConfig.fromJson(json['images'] as Map<String, dynamic>),
      splash: SplashStrings.fromJson(json['splash'] as Map<String, dynamic>),
      home: HomeStrings.fromJson(json['home'] as Map<String, dynamic>),
      detect: DetectStrings.fromJson(json['detect'] as Map<String, dynamic>),
      mediaPreview: MediaPreviewStrings.fromJson(
          json['media_preview'] as Map<String, dynamic>),
      downloading: DownloadingStrings.fromJson(
          json['downloading'] as Map<String, dynamic>),
      downloadComplete: DownloadCompleteStrings.fromJson(
          json['download_complete'] as Map<String, dynamic>),
      downloads:
          DownloadsStrings.fromJson(json['downloads'] as Map<String, dynamic>),
      history: HistoryStrings.fromJson(json['history'] as Map<String, dynamic>),
      settings:
          SettingsStrings.fromJson(json['settings'] as Map<String, dynamic>),
      sideMenu:
          SideMenuStrings.fromJson(json['side_menu'] as Map<String, dynamic>),
      api: ApiConfig.fromJson(json['api'] as Map<String, dynamic>),
    );
  }
}

class AppColorsConfig {
  final Color gradientStart;
  final Color gradientMid;
  final Color gradientEnd;
  final Color skyBlue;
  final Color skyBlueGlow;
  final Color neonPurple;
  final Color neonPink;
  final Color neonCyan;
  final Color darkBg1;
  final Color darkBg2;
  final Color darkBg3;
  final Color lightBg1;
  final Color lightBg2;
  final Color lightBg3;
  final Color darkTextPrimary;
  final Color darkTextSecondary;
  final Color darkTextTertiary;
  final Color lightTextPrimary;
  final Color lightTextSecondary;
  final Color lightTextTertiary;
  final Color success;
  final Color error;
  final Color glassBorderDark;
  final Color glassBorderLight;
  final Color platformInstagram;
  final Color platformFacebook;
  final Color platformPinterest;
  final Color platformXDark;
  final Color platformXLight;
  final Color white;
  final Color black;

  AppColorsConfig({
    required this.gradientStart,
    required this.gradientMid,
    required this.gradientEnd,
    required this.skyBlue,
    required this.skyBlueGlow,
    required this.neonPurple,
    required this.neonPink,
    required this.neonCyan,
    required this.darkBg1,
    required this.darkBg2,
    required this.darkBg3,
    required this.lightBg1,
    required this.lightBg2,
    required this.lightBg3,
    required this.darkTextPrimary,
    required this.darkTextSecondary,
    required this.darkTextTertiary,
    required this.lightTextPrimary,
    required this.lightTextSecondary,
    required this.lightTextTertiary,
    required this.success,
    required this.error,
    required this.glassBorderDark,
    required this.glassBorderLight,
    required this.platformInstagram,
    required this.platformFacebook,
    required this.platformPinterest,
    required this.platformXDark,
    required this.platformXLight,
    required this.white,
    required this.black,
  });

  /// Safe hex parse — never throws on null/missing keys
  static Color _hex(dynamic value, [String fallback = '#FFFFFF']) {
    final raw = (value is String && value.isNotEmpty) ? value : fallback;
    var hex = raw.replaceAll('#', '');
    if (hex.length == 6) hex = 'FF$hex';
    if (hex.length != 8) hex = 'FFFFFFFF';
    return Color(int.parse(hex, radix: 16));
  }

  factory AppColorsConfig.fromJson(Map<String, dynamic> json) {
    return AppColorsConfig(
      gradientStart: _hex(json['gradient_start'], '#FF4ECD'),
      gradientMid: _hex(json['gradient_mid'], '#7B5CFF'),
      gradientEnd: _hex(json['gradient_end'], '#00D4FF'),
      skyBlue: _hex(json['sky_blue'], '#00D4FF'),
      skyBlueGlow: _hex(json['sky_blue_glow'], '#4DE8FF'),
      neonPurple: _hex(json['neon_purple'], '#7B5CFF'),
      neonPink: _hex(json['neon_pink'], '#FF4ECD'),
      neonCyan: _hex(json['neon_cyan'], '#00D4FF'),
      darkBg1: _hex(json['dark_bg_1'], '#0A0B1E'),
      darkBg2: _hex(json['dark_bg_2'], '#12103A'),
      darkBg3: _hex(json['dark_bg_3'], '#0D1B3A'),
      lightBg1: _hex(json['light_bg_1'], '#F5F7FF'),
      lightBg2: _hex(json['light_bg_2'], '#E8EBFF'),
      lightBg3: _hex(json['light_bg_3'], '#DDE4FF'),
      darkTextPrimary: _hex(json['dark_text_primary'], '#FFFFFF'),
      darkTextSecondary: _hex(json['dark_text_secondary'], '#B0B3C8'),
      darkTextTertiary: _hex(json['dark_text_tertiary'], '#7A7D9A'),
      lightTextPrimary: _hex(json['light_text_primary'], '#1A1B35'),
      lightTextSecondary: _hex(json['light_text_secondary'], '#5A5D7A'),
      lightTextTertiary: _hex(json['light_text_tertiary'], '#8A8DAB'),
      success: _hex(json['success'], '#00E676'),
      error: _hex(json['error'], '#FF4757'),
      glassBorderDark: _hex(json['glass_border_dark'], '#00D4FF'),
      glassBorderLight: _hex(json['glass_border_light'], '#4DE8FF'),
      platformInstagram: _hex(json['platform_instagram'], '#E1306C'),
      platformFacebook: _hex(json['platform_facebook'], '#1877F2'),
      platformPinterest: _hex(json['platform_pinterest'], '#E60023'),
      platformXDark: _hex(json['platform_x_dark'], '#FFFFFF'),
      platformXLight: _hex(json['platform_x_light'], '#000000'),
      white: _hex(json['white'], '#FFFFFF'),
      black: _hex(json['black'], '#000000'),
    );
  }

  LinearGradient get threeColorGradient => LinearGradient(
        colors: [gradientStart, gradientMid, gradientEnd],
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
      );

  LinearGradient get primaryGradient => LinearGradient(
        colors: [gradientMid, gradientEnd],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );
}

class ImagesConfig {
  final String homeBgDark;
  final String homeBgLight;
  final String platformInstagram;
  final String platformFacebook;
  final String platformPinterest;
  final String platformX;

  ImagesConfig({
    required this.homeBgDark,
    required this.homeBgLight,
    required this.platformInstagram,
    required this.platformFacebook,
    required this.platformPinterest,
    required this.platformX,
  });

  factory ImagesConfig.fromJson(Map<String, dynamic> json) {
    return ImagesConfig(
      homeBgDark: json['home_bg_dark'] as String,
      homeBgLight: json['home_bg_light'] as String,
      platformInstagram: json['platform_instagram'] as String,
      platformFacebook: json['platform_facebook'] as String,
      platformPinterest: json['platform_pinterest'] as String,
      platformX: json['platform_x'] as String,
    );
  }

  String platformIcon(String key) {
    switch (key) {
      case 'instagram':
        return platformInstagram;
      case 'facebook':
        return platformFacebook;
      case 'pinterest':
        return platformPinterest;
      case 'x':
        return platformX;
      default:
        return platformInstagram;
    }
  }
}

class SplashStrings {
  final String loadingText;
  final String version;
  SplashStrings({required this.loadingText, required this.version});
  factory SplashStrings.fromJson(Map<String, dynamic> json) => SplashStrings(
        loadingText: json['loading_text'] as String,
        version: json['version'] as String,
      );
}

class RecentItem {
  final String title;
  final String size;
  final String type;

  RecentItem({
    required this.title,
    required this.size,
    required this.type,
  });

  factory RecentItem.fromJson(Map<String, dynamic> json) => RecentItem(
        title: json['title'] as String,
        size: json['size'] as String,
        type: json['type'] as String,
      );
}

class HomeStrings {
  final String title;
  final String titleHighlight;
  final String subtitle;
  final String pasteHint;
  final String downloadButton;
  final String recentDownloads;
  final String seeAll;
  final String invalidUrlTitle;
  final String invalidUrlMessage;
  final String invalidUrlOk;
  final String emptyUrlMessage;
  final String apiErrorTitle;
  final String networkError;
  final Map<String, String> platforms;
  final Map<String, String> nav;
  final List<RecentItem> recentItems;

  HomeStrings({
    required this.title,
    required this.titleHighlight,
    required this.subtitle,
    required this.pasteHint,
    required this.downloadButton,
    required this.recentDownloads,
    required this.seeAll,
    required this.invalidUrlTitle,
    required this.invalidUrlMessage,
    required this.invalidUrlOk,
    required this.emptyUrlMessage,
    required this.apiErrorTitle,
    required this.networkError,
    required this.platforms,
    required this.nav,
    required this.recentItems,
  });

  factory HomeStrings.fromJson(Map<String, dynamic> json) => HomeStrings(
        title: json['title'] as String,
        titleHighlight: json['title_highlight'] as String,
        subtitle: json['subtitle'] as String,
        pasteHint: json['paste_hint'] as String,
        downloadButton: json['download_button'] as String,
        recentDownloads: json['recent_downloads'] as String,
        seeAll: json['see_all'] as String,
        invalidUrlTitle: json['invalid_url_title'] as String,
        invalidUrlMessage: json['invalid_url_message'] as String,
        invalidUrlOk: json['invalid_url_ok'] as String,
        emptyUrlMessage: json['empty_url_message'] as String,
        apiErrorTitle: json['api_error_title'] as String,
        networkError: json['network_error'] as String,
        platforms: Map<String, String>.from(json['platforms'] as Map),
        nav: Map<String, String>.from(json['nav'] as Map),
        recentItems: (json['recent_items'] as List<dynamic>)
            .map((e) => RecentItem.fromJson(e as Map<String, dynamic>))
            .toList(),
      );
}

class DetectStrings {
  final String title, subtitle, success, continueButton;
  DetectStrings(
      {required this.title,
      required this.subtitle,
      required this.success,
      required this.continueButton});
  factory DetectStrings.fromJson(Map<String, dynamic> json) => DetectStrings(
      title: json['title'] as String,
      subtitle: json['subtitle'] as String,
      success: json['success'] as String,
      continueButton: json['continue_button'] as String);
}

class MediaPreviewItem {
  final String title;
  final String type;
  final String size;
  final String quality;
  final String platform;

  MediaPreviewItem({
    required this.title,
    required this.type,
    required this.size,
    required this.quality,
    required this.platform,
  });

  factory MediaPreviewItem.fromJson(Map<String, dynamic> json) =>
      MediaPreviewItem(
        title: json['title'] as String,
        type: json['type'] as String,
        size: json['size'] as String,
        quality: json['quality'] as String,
        platform: json['platform'] as String,
      );
}

class MediaPreviewStrings {
  final String title;
  final String downloadNow;
  final String share;
  final String copyLink;
  final List<MediaPreviewItem> sampleItems;

  MediaPreviewStrings({
    required this.title,
    required this.downloadNow,
    required this.share,
    required this.copyLink,
    required this.sampleItems,
  });

  factory MediaPreviewStrings.fromJson(Map<String, dynamic> json) =>
      MediaPreviewStrings(
        title: json['title'] as String,
        downloadNow: json['download_now'] as String,
        share: json['share'] as String,
        copyLink: json['copy_link'] as String,
        sampleItems: (json['sample_items'] as List<dynamic>)
            .map((e) => MediaPreviewItem.fromJson(e as Map<String, dynamic>))
            .toList(),
      );
}

class DownloadingStrings {
  final String title, downloadingText, pause, cancel, resume, speedUnit;
  DownloadingStrings({
    required this.title,
    required this.downloadingText,
    required this.pause,
    required this.cancel,
    required this.resume,
    required this.speedUnit,
  });
  factory DownloadingStrings.fromJson(Map<String, dynamic> json) =>
      DownloadingStrings(
        title: json['title'] as String,
        downloadingText: json['downloading_text'] as String,
        pause: json['pause'] as String,
        cancel: json['cancel'] as String,
        resume: json['resume'] as String,
        speedUnit: json['speed_unit'] as String,
      );
}

class DownloadCompleteStrings {
  final String title, subtitle, openFile, share, viewInFolder;
  DownloadCompleteStrings({
    required this.title,
    required this.subtitle,
    required this.openFile,
    required this.share,
    required this.viewInFolder,
  });
  factory DownloadCompleteStrings.fromJson(Map<String, dynamic> json) =>
      DownloadCompleteStrings(
        title: json['title'] as String,
        subtitle: json['subtitle'] as String,
        openFile: json['open_file'] as String,
        share: json['share'] as String,
        viewInFolder: json['view_in_folder'] as String,
      );
}

class DownloadListItem {
  final String title, size, type, status;
  DownloadListItem({
    required this.title,
    required this.size,
    required this.type,
    required this.status,
  });
  factory DownloadListItem.fromJson(Map<String, dynamic> json) =>
      DownloadListItem(
        title: json['title'] as String,
        size: json['size'] as String,
        type: json['type'] as String,
        status: json['status'] as String,
      );
}

class DownloadsStrings {
  final String title, statusCompleted, statusActive, statusFailed;
  final Map<String, String> tabs;
  final List<DownloadListItem> items;
  DownloadsStrings({
    required this.title,
    required this.tabs,
    required this.statusCompleted,
    required this.statusActive,
    required this.statusFailed,
    required this.items,
  });
  factory DownloadsStrings.fromJson(Map<String, dynamic> json) =>
      DownloadsStrings(
        title: json['title'] as String,
        tabs: Map<String, String>.from(json['tabs'] as Map),
        statusCompleted: json['status_completed'] as String,
        statusActive: json['status_active'] as String,
        statusFailed: json['status_failed'] as String,
        items: (json['items'] as List<dynamic>)
            .map((e) => DownloadListItem.fromJson(e as Map<String, dynamic>))
            .toList(),
      );
}

class HistoryListItem {
  final String title, size, platform, time, group, kind;
  HistoryListItem({
    required this.title,
    required this.size,
    required this.platform,
    required this.time,
    required this.group,
    required this.kind,
  });
  factory HistoryListItem.fromJson(Map<String, dynamic> json) =>
      HistoryListItem(
        title: json['title'] as String,
        size: json['size'] as String,
        platform: json['platform'] as String,
        time: json['time'] as String,
        group: json['group'] as String,
        kind: json['kind'] as String,
      );
}

class HistoryStrings {
  final String title, searchHint, today, yesterday;
  final Map<String, String> filters;
  final List<HistoryListItem> items;
  HistoryStrings({
    required this.title,
    required this.searchHint,
    required this.filters,
    required this.today,
    required this.yesterday,
    required this.items,
  });
  factory HistoryStrings.fromJson(Map<String, dynamic> json) => HistoryStrings(
        title: json['title'] as String,
        searchHint: json['search_hint'] as String,
        filters: Map<String, String>.from(json['filters'] as Map),
        today: json['today'] as String,
        yesterday: json['yesterday'] as String,
        items: (json['items'] as List<dynamic>)
            .map((e) => HistoryListItem.fromJson(e as Map<String, dynamic>))
            .toList(),
      );
}

class SettingsStrings {
  final String title,
      downloadLocation,
      downloadLocationValue,
      wifiOnly,
      autoStart,
      notifications,
      theme,
      themeValue,
      accentColor,
      animations,
      storageUsage,
      storageUsageValue,
      clearHistory,
      privacyPolicy,
      termsOfService,
      aboutApp;
  final Map<String, String> sections;
  SettingsStrings({
    required this.title,
    required this.sections,
    required this.downloadLocation,
    required this.downloadLocationValue,
    required this.wifiOnly,
    required this.autoStart,
    required this.notifications,
    required this.theme,
    required this.themeValue,
    required this.accentColor,
    required this.animations,
    required this.storageUsage,
    required this.storageUsageValue,
    required this.clearHistory,
    required this.privacyPolicy,
    required this.termsOfService,
    required this.aboutApp,
  });
  factory SettingsStrings.fromJson(Map<String, dynamic> json) =>
      SettingsStrings(
        title: json['title'] as String,
        sections: Map<String, String>.from(json['sections'] as Map),
        downloadLocation: json['download_location'] as String,
        downloadLocationValue: json['download_location_value'] as String,
        wifiOnly: json['wifi_only'] as String,
        autoStart: json['auto_start'] as String,
        notifications: json['notifications'] as String,
        theme: json['theme'] as String,
        themeValue: json['theme_value'] as String,
        accentColor: json['accent_color'] as String,
        animations: json['animations'] as String,
        storageUsage: json['storage_usage'] as String,
        storageUsageValue: json['storage_usage_value'] as String,
        clearHistory: json['clear_history'] as String,
        privacyPolicy: json['privacy_policy'] as String,
        termsOfService: json['terms_of_service'] as String,
        aboutApp: json['about_app'] as String,
      );
}

class SideMenuStrings {
  final String home,
      downloads,
      history,
      settings,
      shareApp,
      rateUs,
      moreApps,
      premiumTitle,
      premiumSubtitle;
  SideMenuStrings(
      {required this.home,
      required this.downloads,
      required this.history,
      required this.settings,
      required this.shareApp,
      required this.rateUs,
      required this.moreApps,
      required this.premiumTitle,
      required this.premiumSubtitle});
  factory SideMenuStrings.fromJson(Map<String, dynamic> json) =>
      SideMenuStrings(
          home: json['home'] as String,
          downloads: json['downloads'] as String,
          history: json['history'] as String,
          settings: json['settings'] as String,
          shareApp: json['share_app'] as String,
          rateUs: json['rate_us'] as String,
          moreApps: json['more_apps'] as String,
          premiumTitle: json['premium_title'] as String,
          premiumSubtitle: json['premium_subtitle'] as String);
}

class ApiConfig {
  final String baseUrl;
  final Map<String, String> endpoints;
  final int timeoutSeconds;

  ApiConfig({
    required this.baseUrl,
    required this.endpoints,
    required this.timeoutSeconds,
  });

  factory ApiConfig.fromJson(Map<String, dynamic> json) => ApiConfig(
        baseUrl: json['base_url'] as String,
        endpoints: Map<String, String>.from(json['endpoints'] as Map),
        timeoutSeconds: (json['timeout_seconds'] as num).toInt(),
      );

  String endpointFor(String platformKey) {
    final path = endpoints[platformKey];
    if (path == null) {
      return '$baseUrl${endpoints['instagram']}';
    }
    return '$baseUrl$path';
  }
}
