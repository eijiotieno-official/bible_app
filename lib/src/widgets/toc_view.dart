import 'package:bible_app/src/models/book_model.dart';
import 'package:bible_app/src/models/chapter_model.dart';
import 'package:bible_app/src/models/verse_model.dart';
import 'package:bible_app/src/providers/book_provider.dart';
import 'package:bible_app/src/providers/chapters_provider.dart';
import 'package:bible_app/src/providers/scroll_controller_provider.dart';
import 'package:bible_app/src/providers/verse_provider.dart';
import 'package:bible_app/src/widgets/chapters_grid.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TocView extends ConsumerStatefulWidget {
  final String? book;
  final int? chapter;
  final int? verse;
  const TocView({
    super.key,
    required this.chapter,
    required this.book,
    required this.verse,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _TocViewState();
}

class _TocViewState extends ConsumerState<TocView> {
  bool _isLoading = true;

  List<Verse> _verses = [];

  List<Chapter> _chapters = [];

  List<Book> _books = [];

  // final AutoScrollController _scrollController = AutoScrollController();

  void _jumpToBook() {
    Future.delayed(
      const Duration(milliseconds: 100),
      () {
        final versesState = ref.watch(versesProvider);

        final chaptersState = ref.watch(chaptersProvider);

        final booksState = ref.watch(booksProvider);

        setState(() {
          _verses = versesState.asData?.value ?? [];
          _chapters = chaptersState.asData?.value ?? [];
          _books = booksState.asData?.value ?? [];
          _isLoading = false;
        });

        if (widget.book != null) {
          final bookIndex =
              _books.indexWhere((test) => test.title == widget.book);

          // _scrollController.scrollToIndex(bookIndex);
        }
      },
    );
  }

  @override
  void initState() {
    _activeBook = widget.book;
    _initBook = widget.book;
    _activeChapter = widget.chapter;
    _activeVerse = widget.verse;
    _jumpToBook();
    super.initState();
  }

  String? _initBook;
  String? _activeBook;
  int? _activeChapter;
  int? _activeVerse;

  @override
  Widget build(BuildContext context) {
    Widget buildBook(Book book) {
      return DecoratedBox(
        decoration: BoxDecoration(
          color: _activeBook == book.title
              ? Theme.of(context).colorScheme.primaryContainer.withOpacity(0.05)
              : null,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
              onTap: () {
                if (_activeBook != book.title) {
                  setState(() {
                    _activeBook = book.title;
                  });
                }
              },
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(book.title),
                  Icon(_activeBook == book.title
                      ? Icons.arrow_drop_up_rounded
                      : Icons.arrow_drop_down_rounded),
                ],
              ),
            ),
            if (_activeBook == book.title)
              ChaptersGrid(
                verses: _verses,
                onChapterTapped: (index) {
                  setState(() {
                    _activeChapter = index;
                  });
                  // scrollTo(verse: _verses[index], ref: ref);
                },
                book: book,
                initBook: _initBook,
                activeChapter: _activeChapter,
              ),
          ],
        ),
      );
    }

    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.75,
      child: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
                strokeCap: StrokeCap.round,
              ),
            )
          : ListView.builder(
              // controller: _scrollController,
              physics: const BouncingScrollPhysics(),
              itemCount: _books.length,
              itemBuilder: (context, index) {
                final book = _books[index];
                // return AutoScrollTag(
                //   key: ValueKey(index),
                //   controller: _scrollController,
                //   index: index,
                //   highlightColor:
                //       Theme.of(context).colorScheme.primary.withOpacity(0.25),
                //   child: buildBook(book),
                // );
              },
            ),
    );
  }
}
