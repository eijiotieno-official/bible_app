import 'package:flutter/material.dart';

class ChaptersGrid extends StatelessWidget {
  final List<int> chapters;
  final int? selectedChapter;
  final Function(int) onChapterTapped;
  const ChaptersGrid({
    super.key,
    required this.chapters,
    required this.selectedChapter,
    required this.onChapterTapped,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Wrap(
        spacing: 8.0,
        runSpacing: 8.0,
        children: List.generate(
          chapters.length,
          (index) {
            final chapter = chapters[index];
            return GestureDetector(
              onTap: () {
                onChapterTapped(index);
              },
              child: SizedBox(
                width: 40,
                height: 40,
                child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0)),
                  margin: EdgeInsets.zero,
                  color: selectedChapter == chapter
                      ? Theme.of(context).colorScheme.primaryContainer
                      : null,
                  child: Center(child: Text(chapter.toString())),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
