import 'package:bible_app/src/models/book_model.dart';
import 'package:bible_app/src/models/chapter_model.dart';
import 'package:bible_app/src/models/verse_model.dart';
import 'package:flutter/material.dart';

class ChaptersGrid extends StatelessWidget {
  final Book book;
  final String? initBook;
  final List<Verse> verses;
  final int? activeChapter;
  final Function(int) onChapterTapped;
  const ChaptersGrid({
    super.key,
    required this.verses,
    required this.activeChapter,
    required this.onChapterTapped,
    required this.book,
    required this.initBook,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Wrap(
        spacing: 8.0,
        runSpacing: 8.0,
        children: List.generate(
          book.chapters.length,
          (index) {
            Chapter chapter = book.chapters[index];
            return GestureDetector(
              onTap: () {
                int idx = verses.indexWhere((element) =>
                    element.chapter == chapter.title &&
                    element.book == book.title &&
                    element.verse == 1);
                onChapterTapped(idx);
                Navigator.pop(context);
              },
              child: SizedBox(
                width: 40,
                height: 40,
                child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0)),
                  margin: EdgeInsets.zero,
                  color: activeChapter == chapter.title &&
                          initBook == book.title
                      ? Theme.of(context).colorScheme.primaryContainer
                      : null,
                  child: Center(child: Text(chapter.title.toString())),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
