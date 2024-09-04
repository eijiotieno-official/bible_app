import 'package:bible_app/src/models/verse_model.dart';
import 'package:bible_app/src/widgets/chapters_grid.dart';
import 'package:bible_app/src/widgets/verses_grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PickerView extends ConsumerWidget {
  final List<String> books;
  final List<Verse> verses;
  final List<int> chapters;
  final String? selectedBook;
  final int? selectedChapter;
  final Verse? selectedVerse;
  final Function(String?) onBookTapped;
  final Function(int?) onChapterTapped;
  final Function(Verse?) onVerseTapped;

  const PickerView({
    super.key,
    required this.books,
    required this.verses,
    required this.chapters,
    required this.selectedBook,
    required this.onBookTapped,
    required this.onChapterTapped,
    required this.onVerseTapped,
    required this.selectedChapter,
    required this.selectedVerse,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(
              "Books",
              style: TextStyle(
                color: Theme.of(context).colorScheme.primaryContainer,
              ),
            ),
            subtitle: DropdownButton<String>(
              isExpanded: true,
              underline: const SizedBox.shrink(),
              borderRadius: BorderRadius.circular(16.0),
              value: selectedBook,
              items: books
                  .map(
                    (e) => DropdownMenuItem<String>(
                      value: e,
                      child: Text(e),
                    ),
                  )
                  .toList(),
              onChanged: (String? value) {
                onBookTapped(value);
              },
            ),
          ),
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(
              "Chapters",
              style: TextStyle(
                color: Theme.of(context).colorScheme.primaryContainer,
              ),
            ),
            subtitle: ChaptersGrid(
              chapters: chapters,
              selectedChapter: selectedChapter,
              onChapterTapped: onChapterTapped,
            ),
          ),
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(
              "Verses",
              style: TextStyle(
                color: Theme.of(context).colorScheme.primaryContainer,
              ),
            ),
            subtitle: VersesGrid(
              verses: verses,
              selectedVerse: selectedVerse,
              onVerseTapped: onVerseTapped,
            ),
          ),
        ],
      ),
    );
  }
}
