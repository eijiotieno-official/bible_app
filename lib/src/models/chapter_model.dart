import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'verse_model.dart';

class Chapter {
  final String book;
  final int title;
  final List<Verse> verses;
  Chapter({
    required this.book,
    required this.title,
    required this.verses,
  });
 

  Chapter copyWith({
    String? book,
    int? title,
    List<Verse>? verses,
  }) {
    return Chapter(
      book: book ?? this.book,
      title: title ?? this.title,
      verses: verses ?? this.verses,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'book': book,
      'title': title,
      'verses': verses.map((x) => x.toMap()).toList(),
    };
  }

  factory Chapter.fromMap(Map<String, dynamic> map) {
    return Chapter(
      book: map['book'] ?? '',
      title: map['title']?.toInt() ?? 0,
      verses: List<Verse>.from(map['verses']?.map((x) => Verse.fromMap(x))),
    );
  }

  String toJson() => json.encode(toMap());

  factory Chapter.fromJson(String source) => Chapter.fromMap(json.decode(source));

  @override
  String toString() => 'Chapter(book: $book, title: $title, verses: $verses)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is Chapter &&
      other.book == book &&
      other.title == title &&
      listEquals(other.verses, verses);
  }

  @override
  int get hashCode => book.hashCode ^ title.hashCode ^ verses.hashCode;
}
