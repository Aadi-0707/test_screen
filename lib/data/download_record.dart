class DownloadRecord {
  final String id;
  final String title;
  final String size;
  final String type;
  final String platform;
  final String url;
  final String localPath;
  final String status; // completed | active | failed
  final String kind; // video | image | other
  final String createdAt; // ISO8601
  final String timeLabel; // e.g. 9:30 AM
  final String group; // today | yesterday | earlier

  DownloadRecord({
    required this.id,
    required this.title,
    required this.size,
    required this.type,
    required this.platform,
    required this.url,
    required this.localPath,
    required this.status,
    required this.kind,
    required this.createdAt,
    required this.timeLabel,
    required this.group,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'size': size,
        'type': type,
        'platform': platform,
        'url': url,
        'local_path': localPath,
        'status': status,
        'kind': kind,
        'created_at': createdAt,
        'time_label': timeLabel,
        'group': group,
      };

  factory DownloadRecord.fromJson(Map<String, dynamic> json) => DownloadRecord(
        id: json['id'] as String,
        title: json['title'] as String,
        size: json['size'] as String,
        type: json['type'] as String,
        platform: json['platform'] as String,
        url: json['url'] as String,
        localPath: json['local_path'] as String,
        status: json['status'] as String,
        kind: json['kind'] as String,
        createdAt: json['created_at'] as String,
        timeLabel: json['time_label'] as String,
        group: json['group'] as String,
      );

  DownloadRecord copyWith({
    String? status,
    String? localPath,
    String? size,
  }) {
    return DownloadRecord(
      id: id,
      title: title,
      size: size ?? this.size,
      type: type,
      platform: platform,
      url: url,
      localPath: localPath ?? this.localPath,
      status: status ?? this.status,
      kind: kind,
      createdAt: createdAt,
      timeLabel: timeLabel,
      group: group,
    );
  }
}
