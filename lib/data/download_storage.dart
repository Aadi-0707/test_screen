import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'download_record.dart';

/// All download / history data lives in local storage (not hardcoded).
class DownloadStorage {
  DownloadStorage._();
  static final DownloadStorage instance = DownloadStorage._();

  static const _fileName = 'downloads_db.json';
  List<DownloadRecord> _cache = [];
  bool _ready = false;
  final List<VoidCallback> _listeners = [];

  bool get isReady => _ready;
  List<DownloadRecord> get all => List.unmodifiable(_cache);

  List<DownloadRecord> get completed =>
      _cache.where((e) => e.status == 'completed').toList();

  List<DownloadRecord> get recent => completed.take(20).toList();

  void addListener(VoidCallback cb) => _listeners.add(cb);
  void removeListener(VoidCallback cb) => _listeners.remove(cb);
  void _notify() {
    for (final cb in List<VoidCallback>.from(_listeners)) {
      cb();
    }
  }

  Future<void> init() async {
    if (_ready) return;
    try {
      final file = await _dbFile();
      if (await file.exists()) {
        final raw = await file.readAsString();
        if (raw.trim().isNotEmpty) {
          final list = json.decode(raw) as List<dynamic>;
          _cache = list
              .map((e) => DownloadRecord.fromJson(e as Map<String, dynamic>))
              .toList();
          _refreshGroups();
        }
      }
    } catch (e) {
      debugPrint('DownloadStorage init error: $e');
      _cache = [];
    }
    _ready = true;
  }

  Future<File> _dbFile() async {
    final dir = await getApplicationDocumentsDirectory();
    return File('${dir.path}/$_fileName');
  }

  Future<Directory> mediaDir() async {
    final dir = await getApplicationDocumentsDirectory();
    final media = Directory('${dir.path}/InstaDownloader');
    if (!await media.exists()) {
      await media.create(recursive: true);
    }
    return media;
  }

  Future<void> _persist() async {
    final file = await _dbFile();
    final data = _cache.map((e) => e.toJson()).toList();
    await file.writeAsString(json.encode(data));
    _notify();
  }

  void _refreshGroups() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));

    _cache = _cache.map((e) {
      final dt = DateTime.tryParse(e.createdAt) ?? now;
      final day = DateTime(dt.year, dt.month, dt.day);
      String group;
      if (day == today) {
        group = 'today';
      } else if (day == yesterday) {
        group = 'yesterday';
      } else {
        group = 'earlier';
      }
      if (group == e.group) return e;
      return DownloadRecord(
        id: e.id,
        title: e.title,
        size: e.size,
        type: e.type,
        platform: e.platform,
        url: e.url,
        localPath: e.localPath,
        status: e.status,
        kind: e.kind,
        createdAt: e.createdAt,
        timeLabel: e.timeLabel,
        group: group,
      );
    }).toList();
  }

  static String _timeLabel(DateTime dt) {
    final h = dt.hour;
    final m = dt.minute.toString().padLeft(2, '0');
    final period = h >= 12 ? 'PM' : 'AM';
    final hour12 = h == 0 ? 12 : (h > 12 ? h - 12 : h);
    return '$hour12:$m $period';
  }

  static String kindFromType(String type) {
    final t = type.toUpperCase();
    if (t == 'JPG' || t == 'JPEG' || t == 'PNG' || t == 'WEBP' || t == 'GIF') {
      return 'image';
    }
    if (t == 'MP4' || t == 'MOV' || t == 'WEBM' || t == 'MKV') {
      return 'video';
    }
    return 'other';
  }

  /// Save a completed download to local storage and write a local file marker.
  Future<DownloadRecord> saveCompleted({
    required String title,
    required String size,
    required String type,
    required String platform,
    required String url,
    List<int>? bytes,
  }) async {
    await init();
    final now = DateTime.now();
    final id = now.millisecondsSinceEpoch.toString();
    final safeName = title.replaceAll(RegExp(r'[^\w\.\- ]'), '_');
    final dir = await mediaDir();
    final filePath = '${dir.path}/${id}_$safeName';

    if (bytes != null && bytes.isNotEmpty) {
      await File(filePath).writeAsBytes(bytes);
    } else {
      // Store metadata sidecar so path always exists
      await File(filePath).writeAsString(
        json.encode({
          'title': title,
          'url': url,
          'type': type,
          'platform': platform,
          'saved_at': now.toIso8601String(),
        }),
      );
    }

    final record = DownloadRecord(
      id: id,
      title: title,
      size: size,
      type: type,
      platform: platform,
      url: url,
      localPath: filePath,
      status: 'completed',
      kind: kindFromType(type),
      createdAt: now.toIso8601String(),
      timeLabel: _timeLabel(now),
      group: 'today',
    );

    _cache.insert(0, record);
    await _persist();
    return record;
  }

  Future<void> remove(String id) async {
    await init();
    final idx = _cache.indexWhere((e) => e.id == id);
    if (idx < 0) return;
    final path = _cache[idx].localPath;
    _cache.removeAt(idx);
    try {
      final f = File(path);
      if (await f.exists()) await f.delete();
    } catch (_) {}
    await _persist();
  }

  Future<void> clearAll() async {
    await init();
    for (final e in _cache) {
      try {
        final f = File(e.localPath);
        if (await f.exists()) await f.delete();
      } catch (_) {}
    }
    _cache.clear();
    await _persist();
  }

  List<DownloadRecord> filter({
    String status = 'all',
    String kind = 'all',
    String query = '',
  }) {
    return _cache.where((e) {
      if (status != 'all' && e.status != status) return false;
      if (kind != 'all' && e.kind != kind) return false;
      if (query.isNotEmpty &&
          !e.title.toLowerCase().contains(query.toLowerCase())) {
        return false;
      }
      return true;
    }).toList();
  }
}
