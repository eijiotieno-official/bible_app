import 'package:bible_app/src/models/verse_model.dart';
import 'package:bible_app/src/providers/selected_verses_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class VerseItem extends ConsumerWidget {
  final Verse verse;
  const VerseItem({super.key, required this.verse});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    bool isSelected =
        ref.watch(selectedVersesProvider.notifier).isSelected(verse);

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 8.0,
        vertical: 4.0,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (verse.chapter == 1 && verse.verse == 1)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Text(
                verse.book,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: Theme.of(context).textTheme.displayLarge?.fontSize!,
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: DefaultTextStyle.of(context).style,
              children: <TextSpan>[
                TextSpan(
                  text: "${verse.verse.toString()} ",
                  style: TextStyle(
                    fontSize: Theme.of(context).textTheme.labelSmall?.fontSize!,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                // TextSpan for the verse text
                TextSpan(
                  text: verse.text.trim(),
                  style: TextStyle(
                    fontSize: Theme.of(context).textTheme.bodyMedium?.fontSize!,
                    color: isSelected
                        ? Theme.of(context).colorScheme.primary
                        : null,
                    decorationColor: Theme.of(context).colorScheme.primary,
                    decorationStyle: TextDecorationStyle.wavy,
                    decoration: isSelected ? TextDecoration.underline : null,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
