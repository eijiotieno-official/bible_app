import '../models/verse_model.dart';
import '../providers/last_index_provider.dart';
import '../services/show_picker.dart';
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
            showPicker(context: context, verses: verses, ref: ref);
          },
          child: Card(
            color: Theme.of(context).colorScheme.primaryContainer,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24.0),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 4.0,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 12.0),
                    child: Text(
                      "${verse.book} ${verse.chapter}",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(
                      left: 4.0,
                      right: 8.0,
                    ),
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
