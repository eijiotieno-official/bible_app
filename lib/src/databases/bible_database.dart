import 'dart:convert';

import '../models/bible_version_model.dart';
import '../models/verse_model.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class BibleDatabase {
  final BibleVersion version;
  BibleDatabase(this.version);

  static List<BibleVersion> bibleVersions = [
    BibleVersion(title: "King James", path: "assets/kjv.json"),
    BibleVersion(title: "American Standard", path: "assets/asv.json"),
    // BibleVersion(title: "Bible in Basic English", path: "assets/bbe.json"),
    BibleVersion(title: "Darby English Bible", path: "assets/dby.json"),
    BibleVersion(title: "Webster's Bible", path: "assets/wbt.json"),
    BibleVersion(title: "World English Bible", path: "assets/web.json"),
    BibleVersion(title: "Young's Literal Translation", path: "assets/ylt.json"),
  ];

  static List<String> books = [
    'Genesis',
    'Exodus',
    'Leviticus',
    'Numbers',
    'Deuteronomy',
    'Joshua',
    'Judges',
    'Ruth',
    '1 Samuel',
    '2 Samuel',
    '1 Kings',
    '2 Kings',
    '1 Chronicles',
    '2 Chronicles',
    'Ezra',
    'Nehemiah',
    'Esther',
    'Job',
    'Psalms',
    'Proverbs',
    'Ecclesiastes',
    'Song of Solomon',
    'Isaiah',
    'Jeremiah',
    'Lamentations',
    'Ezekiel',
    'Daniel',
    'Hosea',
    'Joel',
    'Amos',
    'Obadiah',
    'Jonah',
    'Micah',
    'Nahum',
    'Habakkuk',
    'Zephaniah',
    'Haggai',
    'Zechariah',
    'Malachi',
    'Matthew',
    'Mark',
    'Luke',
    'John',
    'Acts',
    'Romans',
    '1 Corinthians',
    '2 Corinthians',
    'Galatians',
    'Ephesians',
    'Philippians',
    'Colossians',
    '1 Thessalonians',
    '2 Thessalonians',
    '1 Timothy',
    '2 Timothy',
    'Titus',
    'Philemon',
    'Hebrews',
    'James',
    '1 Peter',
    '2 Peter',
    '1 John',
    '2 John',
    '3 John',
    'Jude',
    'Revelation'
  ];

  Future<List<Verse>> _parseVerses(String jsonString) async {
    final List jsonList = json.decode(jsonString);

    return jsonList.map((json) => Verse.fromMap(json)).toList();
  }

  Future<Either<String, List<Verse>>> getVerses() async {
    try {
      List<Verse> verses = [];

      String jsonString = await rootBundle
          .loadString(version.path);

      final parsedVerses = await compute(_parseVerses, jsonString);

      verses = parsedVerses;

      verses.sort((a, b) {
        final bookIndexA = books.indexOf(a.book);
        final bookIndexB = books.indexOf(b.book);
        if (bookIndexA != bookIndexB) {
          return bookIndexA.compareTo(bookIndexB);
        } else {
          if (a.chapter != b.chapter) {
            return a.chapter.compareTo(b.chapter);
          } else {
            return a.verse.compareTo(b.verse);
          }
        }
      });

      return Right(verses);
    } catch (e) {
      return Left("Failed to get verses: $e");
    }
  }
}
