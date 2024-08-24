import 'dart:convert';

class Verse {
  final String book;
  final int chapter;
  final int verse;
  final String text;
  Verse({
    required this.book,
    required this.chapter,
    required this.verse,
    required this.text,
  });

  Verse copyWith({
    String? book,
    int? chapter,
    int? verse,
    String? text,
  }) {
    return Verse(
      book: book ?? this.book,
      chapter: chapter ?? this.chapter,
      verse: verse ?? this.verse,
      text: text ?? this.text,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'book': book,
      'chapter': chapter,
      'verse': verse,
      'text': text,
    };
  }

  factory Verse.fromMap(Map<String, dynamic> map) {
    return Verse(
      book: map['book'] ?? '',
      chapter: int.parse(map['chapter']),
      verse: int.parse(map['verse']),
      text: map['text'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory Verse.fromJson(String source) => Verse.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Verse(book: $book, chapter: $chapter, verse: $verse, text: $text)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Verse &&
        other.book == book &&
        other.chapter == chapter &&
        other.verse == verse &&
        other.text == text;
  }

  @override
  int get hashCode {
    return book.hashCode ^ chapter.hashCode ^ verse.hashCode ^ text.hashCode;
  }
}
