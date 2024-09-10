import 'package:bible_app/src/models/verse_model.dart';
import 'package:bible_app/src/providers/last_index_provider.dart';
import 'package:bible_app/src/services/show_verse_picker.dart';
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
            openShowVersions(context: context, verses: verses, ref: ref);
          },
          child: Card(
            color: Theme.of(context).colorScheme.primaryContainer,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 12.0,
                vertical: 4.0,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "${verse.book} ${verse.chapter}",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 4.0),
                    child: Icon(Icons.arrow_drop_down_rounded),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
