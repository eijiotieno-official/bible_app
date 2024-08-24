import 'package:bible_app/src/models/book_model.dart';
import 'package:bible_app/src/models/chapter_model.dart';
import 'package:bible_app/src/models/verse_model.dart';
import 'package:bible_app/src/providers/book_provider.dart';
import 'package:bible_app/src/providers/chapters_provider.dart';
import 'package:bible_app/src/providers/scroll_controller_provider.dart';
import 'package:bible_app/src/providers/verse_provider.dart';
import 'package:bible_app/src/widgets/chapters_grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

class TocView extends ConsumerStatefulWidget {
  final Chapter? chapter;
  const TocView({super.key, this.chapter});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _TocViewState();
}

class _TocViewState extends ConsumerState<TocView> {
  bool _isLoading = true;

  List<Verse> _verses = [];

  List<Chapter> _chapters = [];

  List<Book> _books = [];

  final AutoScrollController _scrollController = AutoScrollController();

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
        });

        if (widget.chapter != null) {
          final bookIndex =
              _books.indexWhere((test) => test.title == widget.chapter?.book);

          _scrollController.scrollToIndex(bookIndex);
        }
      },
    );
  }

  @override
  void initState() {
    _activeChapter = widget.chapter;
    _jumpToBook();
    super.initState();
  }

  Chapter? _activeChapter;

  String? _activeBook;

  @override
  Widget build(BuildContext context) {
    Widget buildBook(Book book) {
      return ListTile(
        onTap: () {
          if (_activeChapter?.book != book.title) {

            setState(() {
              _activeChapter = ;
            });
          }
        },
        title: Text(book.title),
        subtitle: _activeChapter?.book == book.title
            ? ChaptersGrid(
                verses: _verses,
                scrollToIndex: (index) {
                  scrollTo(verse: _verses[index], ref: ref);
                },
                book: book,
                activeChapter: _activeChapter,
              )
            : const SizedBox.shrink(),
      );
    }

    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.75,
      child: ListView.builder(
        controller: _scrollController,
        physics: const BouncingScrollPhysics(),
        itemCount: _books.length,
        itemBuilder: (context, index) {
          final book = _books[index];
          return AutoScrollTag(
            key: ValueKey(index),
            controller: _scrollController,
            index: index,
            highlightColor:
                Theme.of(context).colorScheme.primary.withOpacity(0.25),
            child: buildBook(book),
          );
        },
      ),
    );
  }
}
