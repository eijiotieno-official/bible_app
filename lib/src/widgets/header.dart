import 'package:bible_app/src/models/verse_model.dart';
import 'package:bible_app/src/providers/last_index_provider.dart';
import 'package:bible_app/src/providers/scroll_controller_provider.dart';
import 'package:bible_app/src/providers/selected_verses_provider.dart';
import 'package:bible_app/src/services/show_verse_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class Header extends ConsumerWidget {
  final List<Verse> verses;
  const Header(this.verses, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final index = ref.watch(lastIndexProvider);

    final verse = verses[index];

    final selected = ref.watch(selectedVersesProvider);

    final isVerseSelected = selected.isNotEmpty;

    Future<void> openShowVersions() async {
      if (!isVerseSelected) {
        final positions = ref
            .read(ScrollControllerProvider.itemPositionsListenerProvider)
            .itemPositions
            .value
            .toList();

        final first = positions
            .where((ItemPosition position) => position.itemTrailingEdge > 0)
            .reduce((ItemPosition min, ItemPosition position) =>
                position.itemTrailingEdge < min.itemTrailingEdge
                    ? position
                    : min)
            .index;

        final firstIndex = first + 1;

        final activeVerse = verses[firstIndex];

        await showVersePicker(
            context: context, verses: verses, verse: activeVerse);
      }
    }

    return Align(
      alignment: Alignment.topCenter,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GestureDetector(
          onTap: () {
            openShowVersions();
          },
          child: Card(
            color: Theme.of(context).colorScheme.primaryContainer,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 12.0,
                vertical: 4.0,
              ),
              child: Text(
                "${verse.book} ${verse.chapter}",
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
