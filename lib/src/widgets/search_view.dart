import 'package:bible_app/src/databases/bible_database.dart';
import 'package:bible_app/src/models/verse_model.dart';
import 'package:bible_app/src/providers/last_index_provider.dart';
import 'package:bible_app/src/providers/scroll_controller_provider.dart';
import 'package:bible_app/src/widgets/picker_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SearchView extends ConsumerStatefulWidget {
  final List<Verse> verses;
  const SearchView(this.verses, {super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SearchViewState();
}

class _SearchViewState extends ConsumerState<SearchView> {
  String? _selectedBook;
  int? _selectedChapter;
  Verse? _selectedVerse;

  List<Verse> versesInSelectedBook() =>
      widget.verses.where((test) => test.book == _selectedBook).toList();

  List<int> chaptersInSelectedBook() =>
      versesInSelectedBook().map((e) => e.chapter).toSet().toList();

  @override
  void initState() {
    final index = ref.read(lastIndexProvider);
    final verse = widget.verses[index];
    _selectedBook = verse.book;
    _selectedChapter = verse.chapter;
    _selectedVerse = verse;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          PickerView(
            books: BibleDatabase.bibleBooks,
            chapters: chaptersInSelectedBook(),
            verses: versesInSelectedBook(),
            selectedBook: _selectedBook,
            selectedChapter: _selectedChapter,
            selectedVerse: _selectedVerse,
            onBookTapped: (book) {
              setState(() {
                _selectedBook = book;
              });
            },
            onChapterTapped: (chapter) {
              setState(() {
                _selectedChapter = chapter;
              });
            },
            onVerseTapped: (verse) {
              setState(() {
                _selectedVerse = verse;
              });
            },
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: _selectedVerse != null
                    ? () {
                        final index = widget.verses.indexWhere((test) =>
                            test.toString() == _selectedVerse.toString());
                        ScrollControllerProvider.jumpTo(ref: ref, index: index);
                        Navigator.pop(context);
                      }
                    : null,
                child: const Text("Confirm"),
              ),
            ),
          ),
          SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
        ],
      ),
    );
  }
}
