import 'package:bible_app/src/models/verse_model.dart';
import 'package:bible_app/src/providers/last_index_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Header extends ConsumerWidget {
  final List<Verse> verses;
  const Header(this.verses, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final index = ref.watch(lastIndexProvider);

    final verse = verses[index];

    return Align(
      alignment: Alignment.topCenter,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GestureDetector(
          onTap: () {
            // if (!isVerseSelected) {
            //   showTOC(
            //     context: context,
            //     book: _activeVerse?.book,
            //     chapter: _activeVerse?.chapter,
            //     verse: _activeVerse?.verse,
            //   );
            // }
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
