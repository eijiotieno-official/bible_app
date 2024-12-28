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
              contentPadding: EdgeInsets.zero,
              title: Text(
                "Books",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
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
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(e),
                            ),
                            if (e == "Malachi") Divider(),
                          ],
                        ),
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
                  color: Theme.of(context).colorScheme.primary,
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

  Widget _buildBooks({
    required List<String> books,
    required Function(String book) onBookTapped,
  }) {
    return Flexible(
      child: GridView.builder(
        itemCount: books.length,
        physics: NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 4.0,
          crossAxisSpacing: 4.0,
        ),
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              onBookTapped(books[index]);
            },
            child: Text(
              books[index],
            ),
          );
        },
      ),
    );
  }
}
