import 'package:bible_app/src/models/book_model.dart';
import 'package:bible_app/src/models/chapter_model.dart';
import 'package:bible_app/src/models/verse_model.dart';
import 'package:flutter/material.dart';

class ChaptersGrid extends StatelessWidget {
  final Book book;
  final List<Verse> verses;
  final Chapter? activeChapter;
  final Function(int) scrollToIndex;
  const ChaptersGrid({
    super.key,
    required this.verses,
    required this.activeChapter,
    required this.scrollToIndex,
    required this.book,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.4,
      child: Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: GridView.builder(
          itemCount: book.chapters.length,
          physics: const BouncingScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 8,
            mainAxisSpacing: 8.0,
            crossAxisSpacing: 8.0,
          ),
          itemBuilder: (context, index) {
            Chapter chapter = book.chapters[index];
            return GestureDetector(
              onTap: () {
                int idx = verses.indexWhere((element) =>
                    element.chapter == chapter.title &&
                    element.book == book.title);
                scrollToIndex(idx);
                Navigator.pop(context);
              },
              child: Card(
                margin: const EdgeInsets.all(0),
                color: activeChapter?.title == chapter.title
                    ? Theme.of(context).colorScheme.primaryContainer
                    : null,
                child: Center(
                  child: Text(
                    chapter.title.toString(),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
