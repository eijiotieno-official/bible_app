import 'package:bible_app/src/models/verse_model.dart';
import 'package:bible_app/src/providers/scroll_controller_provider.dart';
import 'package:bible_app/src/providers/verse_provider.dart';
import 'package:bible_app/src/services/scroll_cache_service.dart';
import 'package:bible_app/src/services/show_toc.dart';
import 'package:bible_app/src/widgets/grouped_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import 'verse_item.dart';

class BibleView extends ConsumerStatefulWidget {
  const BibleView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _BibleViewState();
}

class _BibleViewState extends ConsumerState<BibleView> {
  late ItemScrollController itemScrollController;
  late ScrollOffsetController scrollOffsetController;
  late ItemPositionsListener itemPositionsListener;
  late ScrollOffsetListener scrollOffsetListener;

  // Future<void> _lastPixel() async {
  //   final pixels = await ScrollCacheService.read();
  //   if (pixels != null) {
  //     _scrollController.animateTo(
  //       pixels,
  //       duration: const Duration(seconds: 3),
  //       curve: Curves.easeIn,
  //     );
  //   }
  // }

  @override
  void initState() {
    itemScrollController = ref.read(itemScrollControllerProvider);
    scrollOffsetController = ref.read(scrollOffsetControllerProvider);
    itemPositionsListener = ref.read(itemPositionsListenerProvider)
      ..itemPositions.addListener(
        () {
          final positions = itemPositionsListener.itemPositions.value.toList();

          final first = positions
              .where((ItemPosition position) => position.itemTrailingEdge > 0)
              .reduce((ItemPosition min, ItemPosition position) =>
                  position.itemTrailingEdge < min.itemTrailingEdge
                      ? position
                      : min)
              .index;

          final last = positions
              .where((ItemPosition position) => position.itemLeadingEdge < 1)
              .reduce((ItemPosition max, ItemPosition position) =>
                  position.itemLeadingEdge > max.itemLeadingEdge
                      ? position
                      : max)
              .index;

          debugPrint("FIRST: $first LAST: $last");
        },
      );
    scrollOffsetListener = ref.read(scrollOffsetListenerProvider)
      ..changes.listen(
        (pixels) {
          ScrollCacheService.save(pixels);
        },
      );

    super.initState();
    // _lastPixel();
  }

  Verse? _topVerse;

  @override
  Widget build(BuildContext context) {
    final versesState = ref.watch(versesProvider);

    final verses = versesState.value ?? [];

    return GroupedList(
      items: verses,
      itemScrollController: itemScrollController,
      scrollOffsetController: scrollOffsetController,
      itemPositionsListener: itemPositionsListener,
      scrollOffsetListener: scrollOffsetListener,
      itemBuilder: (context, index) {
        return VerseItem(verse: verses[index]);
      },
      header: SizedBox(
        height: 75,
        child: Center(
          child: GestureDetector(
            onTap: () {
              showTOC(
                context: context,
                book: _topVerse?.book,
                chapter: _topVerse?.chapter,
                verse: _topVerse?.verse,
              );
            },
            child: Card(
              color: Theme.of(context).colorScheme.primaryContainer,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8.0,
                  vertical: 4.0,
                ),
                child: Text(
                  "${_topVerse?.book} ${_topVerse?.chapter}",
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
    );

    // GroupedListView(
    //   shrinkWrap: true,
    //   physics: const BouncingScrollPhysics(),
    //   controller: _scrollController,
    //   elements: verses.sorted((a, b) {
    //     final bookIndexA = BibleDatabase.bibleBooks.indexOf(a.book);
    //     final bookIndexB = BibleDatabase.bibleBooks.indexOf(b.book);
    //     if (bookIndexA != bookIndexB) {
    //       return bookIndexA.compareTo(bookIndexB);
    //     } else {
    //       if (a.chapter != b.chapter) {
    //         return a.chapter.compareTo(b.chapter);
    //       } else {
    //         return a.verse.compareTo(b.verse);
    //       }
    //     }
    //   }),
    //   itemComparator: (a, b) => a.verse.compareTo(b.verse),
    //   floatingHeader: true,
    //   useStickyGroupSeparators: true,
    //   groupBy: (verse) {
    //     final chapter =
    //         verse.chapter < 10 ? "0${verse.chapter}" : "${verse.chapter}";
    //     return "${BibleDatabase.bibleBooks.indexOf(verse.book)} - $chapter";
    //   },
    //   groupComparator: (value1, value2) => value1.compareTo(value2),
    // groupHeaderBuilder: (verse) => SizedBox(
    //   height: 75,
    //   child: Center(
    //     child: GestureDetector(
    //       onTap: () {
    //         showTOC(
    //             context: context,
    //             book: verse.book,
    //             chapter: verse.chapter,
    //             verse: verse.verse);
    //       },
    //       child: Card(
    //         color: Theme.of(context).colorScheme.primaryContainer,
    //         child: Padding(
    //           padding: const EdgeInsets.symmetric(
    //             horizontal: 8.0,
    //             vertical: 4.0,
    //           ),
    //           child: Text(
    //             "${verse.book} ${verse.chapter}",
    //             style: TextStyle(
    //               fontSize: Theme.of(context).textTheme.bodyLarge?.fontSize!,
    //               fontWeight: FontWeight.w500,
    //             ),
    //           ),
    //         ),
    //       ),
    //     ),
    //   ),
    // ),
    //   indexedItemBuilder: (context, verse, index) {
    //     return AutoScrollTag(
    //       key: ValueKey(index),
    //       controller: _scrollController,
    //       index: index,
    //       highlightColor:
    //           Theme.of(context).colorScheme.primary.withOpacity(0.25),
    //       child: VerseItem(verse: verse),
    //     );
    //   },
    // );
  }
}
