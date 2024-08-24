import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'chapter_model.dart';

class Book {
  final String title;
  final List<Chapter> chapters;
  Book({
    required this.title,
    required this.chapters,
  });

  Book copyWith({
    String? title,
    List<Chapter>? chapters,
  }) {
    return Book(
      title: title ?? this.title,
      chapters: chapters ?? this.chapters,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'chapters': chapters.map((x) => x.toMap()).toList(),
    };
  }

  factory Book.fromMap(Map<String, dynamic> map) {
    return Book(
      title: map['title'] ?? '',
      chapters:
          List<Chapter>.from(map['chapters']?.map((x) => Chapter.fromMap(x))),
    );
  }

  String toJson() => json.encode(toMap());

  factory Book.fromJson(String source) => Book.fromMap(json.decode(source));

  @override
  String toString() => 'Book(title: $title, chapters: $chapters)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Book &&
        other.title == title &&
        listEquals(other.chapters, chapters);
  }

  @override
  int get hashCode => title.hashCode ^ chapters.hashCode;
}
