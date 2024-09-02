import 'package:bible_app/src/models/verse_model.dart';
import 'package:bible_app/src/providers/scroll_controller_provider.dart';
import 'package:bible_app/src/providers/selected_verses_provider.dart';
import 'package:bible_app/src/providers/verse_provider.dart';
import 'package:bible_app/src/services/bible_list_cache_service.dart';
import 'package:bible_app/src/services/show_toc.dart';
import 'package:bible_app/src/utils/font_size_util.dart';
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

  Future<void> _lastPixel() async {
    await Future.delayed(
      const Duration(milliseconds: 100),
      () async {
        final index = await BibleListCacheService.read() ?? 0;

        final versesState = ref.read(versesProvider);
        final verses = versesState.asData?.value ?? [];

        itemScrollController.jumpTo(index: index, alignment: 0.05);

        setState(() {
          _activeVerse = verses[index];
        });
      },
    );
  }

  @override
  void initState() {
    itemScrollController = ref.read(itemScrollControllerProvider);
    scrollOffsetController = ref.read(scrollOffsetControllerProvider);
    scrollOffsetListener = ref.read(scrollOffsetListenerProvider);
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

          BibleListCacheService.save(first);

          final versesState = ref.read(versesProvider);
          final verses = versesState.asData?.value ?? [];

          final firstVerseInViewPort = verses[first + 2];

          final previousActiveVerse = _activeVerse ?? verses.first;

          if (firstVerseInViewPort.book != previousActiveVerse.book ||
              firstVerseInViewPort.chapter != previousActiveVerse.chapter) {
            setState(() {
              _activeVerse = firstVerseInViewPort;
            });
          }
        },
      );

    super.initState();
    _lastPixel();
  }

  Verse? _activeVerse;

  @override
  Widget build(BuildContext context) {
    final versesState = ref.watch(versesProvider);

    final verses = versesState.value ?? [];

    final selected = ref.watch(selectedVersesProvider);

    final isVerseSelected = selected.isNotEmpty;

    return GroupedList(
      items: verses,
      itemScrollController: itemScrollController,
      scrollOffsetController: scrollOffsetController,
      itemPositionsListener: itemPositionsListener,
      scrollOffsetListener: scrollOffsetListener,
      itemBuilder: (context, index) {
        return VerseItem(verse: verses[index]);
      },
      header: _activeVerse == null
          ? null
          : Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: () {
                    if (!isVerseSelected) {
                      showTOC(
                        context: context,
                        book: _activeVerse?.book,
                        chapter: _activeVerse?.chapter,
                        verse: _activeVerse?.verse,
                      );
                    }
                  },
                  child: Card(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12.0,
                        vertical: 4.0,
                      ),
                      child: Text(
                        "${_activeVerse?.book} ${_activeVerse?.chapter}",
                        style: TextStyle(
                          fontSize: FontSizeUtil.font3(context),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}
