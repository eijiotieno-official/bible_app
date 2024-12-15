import '../models/verse_model.dart';
import '../providers/selected_verses_provider.dart';
import '../utils/font_size_util.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class VerseItem extends ConsumerWidget {
  final Verse verse;
  const VerseItem({super.key, required this.verse});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selected = ref.watch(selectedVersesProvider);

    bool isSelected =
        selected.any((test) => test.toString() == verse.toString());

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (verse.chapter == 1 && verse.verse == 1)
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 75),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Text(
                  verse.book,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize:
                        Theme.of(context).textTheme.displayLarge?.fontSize!,
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        DecoratedBox(
          decoration: BoxDecoration(
            color: isSelected
                ? Theme.of(context).colorScheme.primaryContainer
                : null,
          ),
          child: InkWell(
            onTap: () {
              if (isSelected) {
                ref.read(selectedVersesProvider.notifier).remove(verse);
              } else {
                ref.read(selectedVersesProvider.notifier).add(verse);
              }
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 8.0,
              ),
              child: RichText(
                textAlign: TextAlign.justify,
                text: TextSpan(
                  style: DefaultTextStyle.of(context).style,
                  children: <TextSpan>[
                    TextSpan(
                      text: verse.verse == 1
                          ? "${verse.chapter.toString()}  "
                          : "${verse.verse.toString()}  ",
                      style: TextStyle(
                        fontSize: verse.verse == 1
                            ? FontSizeUtil.font1(context)
                            : FontSizeUtil.font5(context),
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: verse.verse == 1 ? FontWeight.bold : null,
                      ),
                    ),
                    TextSpan(
                      recognizer: TapGestureRecognizer(),
                      text: verse.text.trim(),
                      style: TextStyle(
                        fontSize: FontSizeUtil.font4(context),
                        color: isSelected
                            ? Theme.of(context).colorScheme.primary
                            : null,
                        decorationColor: Theme.of(context).colorScheme.primary,
                        decorationStyle: TextDecorationStyle.wavy,
                        decoration:
                            isSelected ? TextDecoration.underline : null,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
