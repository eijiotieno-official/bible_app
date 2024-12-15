import 'dart:convert';

import 'verse_model.dart';

class Bookmark {
  final Verse verse;
  final DateTime time;
  Bookmark({
    required this.verse,
    required this.time,
  });

  Bookmark copyWith({
    Verse? verse,
    DateTime? time,
  }) {
    return Bookmark(
      verse: verse ?? this.verse,
      time: time ?? this.time,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'verse': verse.toMap(),
      'time': time.millisecondsSinceEpoch,
    };
  }

  factory Bookmark.fromMap(Map<String, dynamic> map) {
    return Bookmark(
      verse: Verse.fromMap(map['verse']),
      time: DateTime.fromMillisecondsSinceEpoch(map['time']),
    );
  }

  String toJson() => json.encode(toMap());

  factory Bookmark.fromJson(String source) => Bookmark.fromMap(json.decode(source));

  @override
  String toString() => 'Bookmark(verse: $verse, time: $time)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is Bookmark &&
      other.verse == verse &&
      other.time == time;
  }

  @override
  int get hashCode => verse.hashCode ^ time.hashCode;
}
