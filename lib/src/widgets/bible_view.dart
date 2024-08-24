import 'package:bible_app/src/databases/bible_database.dart';
import 'package:bible_app/src/models/chapter_model.dart';
import 'package:bible_app/src/providers/chapters_provider.dart';
import 'package:bible_app/src/providers/scroll_controller_provider.dart';
import 'package:bible_app/src/providers/verse_provider.dart';
import 'package:bible_app/src/services/scroll_cache_service.dart';
import 'package:bible_app/src/services/show_toc.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

import 'verse_item.dart';

class BibleView extends ConsumerStatefulWidget {
  const BibleView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _BibleViewState();
}

class _BibleViewState extends ConsumerState<BibleView> {
  late AutoScrollController _scrollController;
  Future<void> _lastPixel() async {
    await Future.delayed(
      const Duration(milliseconds: 150),
      () async {
        final pixels = await ScrollCacheService.read();
        if (pixels != null) {
          _scrollController.animateTo(pixels,
              duration: const Duration(milliseconds: 700),
              curve: Curves.decelerate);
        }
      },
    );
  }

  @override
  void initState() {
    _scrollController = ref.read(scrollControllerProvider)
      ..addListener(
        () {
          final pixels = _scrollController.position.pixels;
          ScrollCacheService.save(pixels);
        },
      );
    super.initState();
    _lastPixel();
  }

  @override
  Widget build(BuildContext context) {
    final versesState = ref.watch(versesProvider);

    final verses = versesState.value ?? [];

    return GroupedListView(
      shrinkWrap: true,
      physics: const BouncingScrollPhysics(),
      controller: _scrollController,
      elements: verses.sorted((a, b) {
        final bookIndexA = BibleDatabase.bibleBooks.indexOf(a.book);
        final bookIndexB = BibleDatabase.bibleBooks.indexOf(b.book);
        if (bookIndexA != bookIndexB) {
          return bookIndexA.compareTo(bookIndexB);
        } else {
          if (a.chapter != b.chapter) {
            return a.chapter.compareTo(b.chapter);
          } else {
            return a.verse.compareTo(b.verse);
          }
        }
      }),
      itemComparator: (a, b) => a.verse.compareTo(b.verse),
      floatingHeader: true,
      useStickyGroupSeparators: true,
      groupBy: (verse) {
        final chapter =
            verse.chapter < 10 ? "0${verse.chapter}" : "${verse.chapter}";
        return "${BibleDatabase.bibleBooks.indexOf(verse.book)} - $chapter";
      },
      groupComparator: (value1, value2) => value1.compareTo(value2),
      groupHeaderBuilder: (verse) => SizedBox(
        height: 75,
        child: Center(
          child: GestureDetector(
            onTap: () {
              final chaptersState = ref.watch(chaptersProvider);
              final chapters = chaptersState.asData?.value ?? [];
              final chapter =
                  chapters.firstWhere((test) => test.book == verse.book && test.verses.any((test) => test == verse));

              showTOC(context: context, chapter: chapter);
            },
            child: Card(
              color: Theme.of(context).colorScheme.primaryContainer,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8.0,
                  vertical: 4.0,
                ),
                child: Text(
                  "${verse.book} ${verse.chapter}",
                  style: TextStyle(
                    fontSize: Theme.of(context).textTheme.bodyLarge?.fontSize!,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      indexedItemBuilder: (context, verse, index) {
        return AutoScrollTag(
          key: ValueKey(index),
          controller: _scrollController,
          index: index,
          highlightColor:
              Theme.of(context).colorScheme.primary.withOpacity(0.25),
          child: VerseItem(verse: verse),
        );
      },
    );
  }
}
