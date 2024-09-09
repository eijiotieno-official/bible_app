import 'package:bible_app/src/models/verse_model.dart';
import 'package:bible_app/src/providers/last_index_provider.dart';
import 'package:bible_app/src/providers/scroll_controller_provider.dart';
import 'package:bible_app/src/widgets/grouped_list.dart';
import 'package:bible_app/src/widgets/header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'verse_item.dart';

class BibleView extends ConsumerStatefulWidget {
  final List<Verse> verses;
  const BibleView(this.verses, {super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _BibleViewState();
}

class _BibleViewState extends ConsumerState<BibleView> {
  Future<void> _jumpToLastIndex() async {
    await Future.delayed(
      const Duration(milliseconds: 100),
      () async {
        final index = ref.read(lastIndexProvider);

        ScrollControllerProvider.jumpTo(
            ref: ref, index: index == 0 ? index : (index + 1));
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _jumpToLastIndex();
  }

  @override
  Widget build(BuildContext context) {
    return GroupedList(
      items: widget.verses,
      itemScrollController:
          ref.read(ScrollControllerProvider.itemScrollControllerProvider),
      scrollOffsetController:
          ref.read(ScrollControllerProvider.scrollOffsetControllerProvider),
      itemPositionsListener:
          ref.read(ScrollControllerProvider.itemPositionsListenerProvider),
      scrollOffsetListener:
          ref.read(ScrollControllerProvider.scrollOffsetListenerProvider),
      itemBuilder: (context, index) {
        final verse = widget.verses[index];
        return VerseItem(verse: verse);
      },
      header: Header(widget.verses),
    );
  }
}
