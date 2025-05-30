import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import '../databases/bible_database.dart';
import '../models/verse_model.dart';
import '../providers/scroll_controller_provider.dart';
import '../providers/selected_verses_provider.dart';
import '../widgets/picker_view.dart';

Future<void> showPicker({
  required BuildContext context,
  required List<Verse> verses,
  required WidgetRef ref,
}) async {
  final selected = ref.watch(selectedVersesProvider);

  final isVerseSelected = selected.isNotEmpty;

  if (!isVerseSelected) {
    final positions = ref
        .read(ScrollControllerProvider.itemPositionsListenerProvider)
        .itemPositions
        .value
        .toList();

    final first = positions
        .where((ItemPosition position) => position.itemTrailingEdge > 0)
        .reduce((ItemPosition min, ItemPosition position) =>
            position.itemTrailingEdge < min.itemTrailingEdge ? position : min)
        .index;

    final firstIndex = first + 1;

    final activeVerse = verses[firstIndex];

    await showVersePicker(context: context, verses: verses, verse: activeVerse);
  }
}

Future<void> showVersePicker({
  required BuildContext context,
  required List<Verse> verses,
  required Verse verse,
}) async =>
    await showModalBottomSheet(
      useSafeArea: true,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      showDragHandle: true,
      context: context,
      builder: (context) {
        return _VersePickerView(verses: verses, verse: verse);
      },
    );

class _VersePickerView extends ConsumerStatefulWidget {
  final List<Verse> verses;
  final Verse verse;
  const _VersePickerView({
    required this.verses,
    required this.verse,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      __VersePickerViewState();
}

class __VersePickerViewState extends ConsumerState<_VersePickerView> {
  String? _selectedBook;
  int? _selectedChapter;
  Verse? _selectedVerse;

  @override
  void initState() {
    _selectedVerse = widget.verse;
    _selectedBook = widget.verse.book;
    _selectedChapter = widget.verse.chapter;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final verses = widget.verses
        .where((test) =>
            test.book == _selectedBook && test.chapter == _selectedChapter)
        .toList();

    final chapters = widget.verses
        .where((test) => test.book == _selectedBook)
        .toList()
        .map((e) => e.chapter)
        .toSet()
        .toList();

    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.75,
      child: Column(
        children: [
          PickerView(
            books: BibleDatabase.books,
            chapters: chapters,
            verses: verses,
            selectedBook: _selectedBook,
            selectedChapter: _selectedChapter,
            selectedVerse: _selectedVerse,
            onBookTapped: (book) {
              setState(() {
                _selectedBook = book;
                _selectedVerse = Verse(
                  book: book!,
                  chapter: _selectedChapter!,
                  verse: _selectedVerse?.verse ?? 1,
                  text: _selectedVerse?.text ?? "",
                );
              });
            },
            onChapterTapped: (chapter) {
              setState(() {
                _selectedChapter = chapter;
                _selectedVerse = Verse(
                  book: _selectedBook!,
                  chapter: chapter!,
                  verse: _selectedVerse?.verse ?? 1,
                  text: _selectedVerse?.text ?? "",
                );
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
                onPressed: widget.verse.toString() == _selectedVerse?.toString()
                    ? null
                    : () {
                        final index = widget.verses.indexWhere((test) =>
                            test.book == _selectedVerse?.book &&
                            test.chapter == _selectedVerse?.chapter &&
                            test.verse == _selectedVerse?.verse);

                        final validIndex =
                            (index >= 0 && index < widget.verses.length)
                                ? index
                                : 0;

                        ScrollControllerProvider.jumpTo(
                            ref: ref, index: validIndex);

                        Navigator.pop(context);
                      },
                child: Text(
                    "Go to $_selectedBook $_selectedChapter:${_selectedVerse?.verse}"),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
