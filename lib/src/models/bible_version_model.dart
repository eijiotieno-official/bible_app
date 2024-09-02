import 'dart:convert';

class BibleVersion {
  final String title;
  final String path;
  BibleVersion({
    required this.title,
    required this.path,
  });

  BibleVersion copyWith({
    String? title,
    String? path,
  }) {
    return BibleVersion(
      title: title ?? this.title,
      path: path ?? this.path,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'path': path,
    };
  }

  factory BibleVersion.fromMap(Map<String, dynamic> map) {
    return BibleVersion(
      title: map['title'] ?? '',
      path: map['path'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory BibleVersion.fromJson(String source) => BibleVersion.fromMap(json.decode(source));

  @override
  String toString() => 'BibleVersion(title: $title, path: $path)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is BibleVersion &&
      other.title == title &&
      other.path == path;
  }

  @override
  int get hashCode => title.hashCode ^ path.hashCode;
}
