import 'dart:convert';

import 'package:bible_app/src/models/bible_version_model.dart';
import 'package:bible_app/src/models/verse_model.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/services.dart';

class BibleDatabase {
  final BibleVersion? version;
  BibleDatabase({this.version});

  static List<BibleVersion> bibleVersions = [
    BibleVersion(title: "King James", path: "assets/kjv.json"),
    BibleVersion(title: "American Standard", path: "assets/asv.json"),
    // BibleVersion(title: "Bible in Basic English", path: "assets/bbe.json"),
    BibleVersion(title: "Darby English Bible", path: "assets/dby.json"),
    BibleVersion(title: "Webster's Bible", path: "assets/wbt.json"),
    BibleVersion(title: "World English Bible", path: "assets/web.json"),
    BibleVersion(title: "Young's Literal Translation", path: "assets/ylt.json"),
  ];

  static List<String> bibleBooks = [
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

  Future<Either<String, List<Verse>>> getVerses() async {
    try {
      List<Verse> verses = [];

      String jsonString = await rootBundle
          .loadString(version?.path ?? bibleVersions.first.path);

      final jsonList = json.decode(jsonString);

      for (var json in jsonList) {
        final verse = Verse.fromMap(json);
        verses.add(verse);
      }

      verses.sort((a, b) {
        final bookIndexA = bibleBooks.indexOf(a.book);
        final bookIndexB = bibleBooks.indexOf(b.book);
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

  // Future<Either<String, List<Chapter>>> getChapters() async {
  //   try {
  //     final getBooksResult = await getBooks();

  //     return getBooksResult.fold(
  //       (error) => Left(error),
  //       (books) {
  //         List<Chapter> chapters = [];

  //         books.sortByCompare(
  //           (keyOf) => keyOf,
  //           (a, b) {
  //             final bookIndexA = bibleBooks.indexOf(a.title);
  //             final bookIndexB = bibleBooks.indexOf(b.title);
  //             return bookIndexA.compareTo(bookIndexB);
  //           },
  //         );

  //         for (var book in books) {
  //           final thisChapters = book.chapters.sortedByCompare(
  //             (keyOf) => keyOf.title,
  //             (a, b) {
  //               return a.compareTo(b);
  //             },
  //           );
  //           chapters.addAll(thisChapters);
  //         }

  //         return Right(chapters);
  //       },
  //     );
  //   } catch (e) {
  //     return Left("Failed to get chapters: $e");
  //   }
  // }

  // Future<Either<String, List<Book>>> getBooks() async {
  //   try {
  //     final getVersesResult = await getVerses();

  //     return getVersesResult.fold(
  //       (error) => Left(error),
  //       (verses) {
  //         List<Book> books = [];

  //         // Iterate through each unique book title to organize chapters and verses
  //         for (var bibleBook in bibleBooks) {
  //           // Filter verses based on the current book title
  //           List<Verse> availableVerses =
  //               verses.where((v) => v.book == bibleBook).toList();

  //           // Extract unique chapter numbers from the filtered verses
  // List<int> availableChapters =
  //     availableVerses.map((e) => e.chapter).toSet().toList();

  //           List<Chapter> chapters = [];

  //           // Iterate through each unique chapter number to organize verses
  //           for (var element in availableChapters) {
  //             // Create a Chapter object for each unique chapter
  //             Chapter chapter = Chapter(
  //               book: bibleBook,
  //               title: element,
  //               verses:
  //                   availableVerses.where((v) => v.chapter == element).toList(),
  //             );

  //             chapters.add(chapter);
  //           }

  //           chapters.sortByCompare(
  //             (keyOf) => keyOf.title,
  //             (a, b) {
  //               return a.compareTo(b);
  //             },
  //           );

  //           // Create a Book object for the current book title and its organized chapters
  //           Book book = Book(title: bibleBook, chapters: chapters);

  //           books.add(book);
  //         }

  //         return Right(books);
  //       },
  //     );
  //   } catch (e) {
  //     return Left("Failed to get books: $e");
  //   }
  // }
}
