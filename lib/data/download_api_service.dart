import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../core/utils/strings_service.dart';

/// Single media item returned by backend API.
class MediaItemResult {
  final String url;
  final String thumbnail;
  final String title;
  final String type; // MP4 | JPG
  final String quality;
  final String size;

  MediaItemResult({
    required this.url,
    required this.thumbnail,
    required this.title,
    required this.type,
    required this.quality,
    required this.size,
  });
}

class DownloadApiResult {
  final bool success;
  final String? error;
  final List<MediaItemResult> items;

  DownloadApiResult.ok(this.items)
      : success = true,
        error = null;

  DownloadApiResult.fail(this.error)
      : success = false,
        items = const [];
}

/// Calls backend:
/// POST {base}/instagram|facebook|pinterest|x/download
/// body: { "downloadUrl": "<page url>" }
class DownloadApiService {
  DownloadApiService._();
  static final DownloadApiService instance = DownloadApiService._();

  static String platformFromUrl(String url) {
    final lower = url.toLowerCase();
    if (lower.contains('instagram') || lower.contains('instagr.am')) {
      return 'instagram';
    }
    if (lower.contains('facebook') ||
        lower.contains('fb.watch') ||
        lower.contains('fb.com')) {
      return 'facebook';
    }
    if (lower.contains('pinterest') || lower.contains('pin.it')) {
      return 'pinterest';
    }
    if (lower.contains('twitter') ||
        lower.contains('x.com') ||
        lower.contains('t.co')) {
      return 'x';
    }
    return 'instagram';
  }

  static bool isSupportedUrl(String url) {
    final lower = url.trim().toLowerCase();
    if (lower.isEmpty) return false;
    return lower.contains('instagram.com') ||
        lower.contains('instagr.am') ||
        lower.contains('facebook.com') ||
        lower.contains('fb.watch') ||
        lower.contains('fb.com') ||
        lower.contains('pinterest.com') ||
        lower.contains('pin.it') ||
        lower.contains('twitter.com') ||
        lower.contains('x.com') ||
        lower.contains('t.co');
  }

  Future<DownloadApiResult> fetchMedia(
    String pageUrl, {
    String? platformKey,
  }) async {
    final api = StringsService.strings.api;
    final home = StringsService.strings.home;
    final key = platformKey ?? platformFromUrl(pageUrl);
    final endpoint = api.endpointFor(key);
    final uri = Uri.parse(endpoint);

    try {
      final response = await http
          .post(
            uri,
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
            body: json.encode({'downloadUrl': pageUrl}),
          )
          .timeout(Duration(seconds: api.timeoutSeconds));

      Map<String, dynamic>? body;
      try {
        final decoded = json.decode(response.body);
        if (decoded is Map<String, dynamic>) {
          body = decoded;
        } else if (decoded is Map) {
          body = Map<String, dynamic>.from(decoded);
        }
      } catch (_) {
        body = null;
      }

      // HTTP error — still try parse message
      if (response.statusCode >= 400) {
        final msg = _extractError(body) ??
            (response.statusCode == 403
                ? 'This platform API is not available (not subscribed).'
                : home.networkError);
        return DownloadApiResult.fail(msg);
      }

      final items = _parseItems(body, pageUrl);
      if (items.isEmpty) {
        return DownloadApiResult.fail(
          _extractError(body) ?? 'No media found for this URL.',
        );
      }
      return DownloadApiResult.ok(items);
    } catch (e) {
      debugPrint('DownloadApiService error: $e');
      return DownloadApiResult.fail(home.networkError);
    }
  }

  String? _extractError(Map<String, dynamic>? body) {
    if (body == null) return null;
    final err = body['error'];
    if (err is String && err.trim().isNotEmpty) return err.trim();
    final details = body['details'];
    if (details is Map) {
      final m = details['message'];
      if (m is String && m.trim().isNotEmpty) return m.trim();
      // private post style: error on outer, empty result inside details
      final err2 = details['error'];
      if (err2 is String && err2.trim().isNotEmpty) return err2.trim();
    }
    final message = body['message'];
    if (message is String && message.trim().isNotEmpty) return message.trim();
    return null;
  }

  List<MediaItemResult> _parseItems(
    Map<String, dynamic>? body,
    String pageUrl,
  ) {
    if (body == null) return [];
    final out = <MediaItemResult>[];

    // Collect possible result lists from several response shapes
    final candidates = <dynamic>[];

    void addList(dynamic v) {
      if (v is List) candidates.add(v);
    }

    addList(body['result']);
    if (body['details'] is Map) {
      addList((body['details'] as Map)['result']);
      addList((body['details'] as Map)['media']);
    }
    if (body['data'] is Map) {
      final data = body['data'] as Map;
      addList(data['result']);
      addList(data['media']);
      // single object in data
      final du = data['downloadUrl'] ?? data['url'];
      if (du is String && du.trim().isNotEmpty) {
        out.add(MediaItemResult(
          url: du.trim(),
          thumbnail: '${data['thumbnail'] ?? ''}',
          title: '${data['title'] ?? 'Media'}',
          type: _typeFromUrl(du),
          quality: '${data['quality'] ?? 'HD'}',
          size: '${data['fileSizeMB'] ?? data['size'] ?? ''}',
        ));
      }
    }
    addList(body['media']);

    var index = 0;
    for (final list in candidates) {
      for (final e in list as List) {
        if (e is! Map) continue;
        final map = Map<String, dynamic>.from(e);
        final mediaUrl =
            '${map['url'] ?? map['downloadUrl'] ?? map['download_url'] ?? ''}'
                .trim();
        if (mediaUrl.isEmpty) continue;
        final thumb =
            '${map['thumbnail'] ?? map['thumb'] ?? map['thumbUrl'] ?? ''}';
        index++;
        out.add(MediaItemResult(
          url: mediaUrl,
          thumbnail: thumb,
          title: '${map['title'] ?? 'Media $index'}',
          type: _typeFromMapOrUrl(map, mediaUrl),
          quality: '${map['quality'] ?? 'HD'}',
          size: '${map['size'] ?? map['fileSizeMB'] ?? ''}',
        ));
      }
    }

    // Deduplicate by url
    final seen = <String>{};
    return out.where((e) => seen.add(e.url)).toList();
  }

  String _typeFromMapOrUrl(Map<String, dynamic> map, String url) {
    final t = '${map['type'] ?? ''}'.toLowerCase();
    if (t == 'image' ||
        t == 'photo' ||
        t == 'jpg' ||
        t == 'jpeg' ||
        t == 'png') {
      return 'JPG';
    }
    if (t == 'video' || t == 'mp4' || t == 'reel') return 'MP4';
    return _typeFromUrl(url);
  }

  String _typeFromUrl(String url) {
    final lower = url.toLowerCase();
    if (lower.contains('.jpg') ||
        lower.contains('.jpeg') ||
        lower.contains('.png') ||
        lower.contains('.webp') ||
        lower.contains('.gif')) {
      return 'JPG';
    }
    return 'MP4';
  }

  Future<List<int>?> downloadBytes(String mediaUrl) async {
    try {
      final res = await http.get(Uri.parse(mediaUrl)).timeout(
            Duration(seconds: StringsService.strings.api.timeoutSeconds),
          );
      if (res.statusCode >= 200 && res.statusCode < 300) {
        return res.bodyBytes;
      }
    } catch (e) {
      debugPrint('downloadBytes error: $e');
    }
    return null;
  }
}
