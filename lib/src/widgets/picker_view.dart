import 'package:bible_app/src/widgets/book_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/verse_model.dart';
import 'chapters_grid.dart';
import 'verses_grid.dart';

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
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: ListView(
          physics: const BouncingScrollPhysics(),
          children: [
            ListTile(
              onTap: () async {
                final result = await BookPicker.pick(
                  context: context,
                  initialBook: selectedBook ?? books.first,
                  books: books,
                );

                if (result != null) {
                  onBookTapped(result);
                }
              },
              tileColor: Theme.of(context).hoverColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0),
              ),
              title: Text(
                "Books",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              subtitle: Text(selectedBook ?? books.first),
              trailing: Icon(Icons.arrow_drop_down_rounded),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: ListTile(
                tileColor: Theme.of(context).hoverColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0),
                ),
                title: Text(
                  "Chapters",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                subtitle: ChaptersGrid(
                  chapters: chapters,
                  selectedChapter: selectedChapter,
                  onChapterTapped: onChapterTapped,
                ),
              ),
            ),
            ListTile(
              tileColor: Theme.of(context).hoverColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0),
              ),
              title: Text(
                "Verses",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
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
      ),
    );
  }
}
