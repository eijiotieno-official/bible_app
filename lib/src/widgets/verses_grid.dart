import '../models/verse_model.dart';
import 'package:flutter/material.dart';

class VersesGrid extends StatelessWidget {
  final List<Verse> verses;
  final Verse? selectedVerse;
  final Function(Verse) onVerseTapped;
  const VersesGrid({
    super.key,
    required this.verses,
    required this.selectedVerse,
    required this.onVerseTapped,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: Wrap(
        spacing: 8.0,
        runSpacing: 8.0,
        children: List.generate(
          verses.length,
          (index) {
            final verse = verses[index];
            return GestureDetector(
              onTap: () {
                onVerseTapped(verse);
              },
              child: SizedBox(
                width: 40,
                height: 40,
                child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0)),
                  margin: EdgeInsets.zero,
                  color: verse.book == selectedVerse?.book &&
                          verse.chapter == selectedVerse?.chapter &&
                          verse.verse == selectedVerse?.verse
                      ? Theme.of(context).colorScheme.primaryContainer
                      : null,
                  child: Center(child: Text(verse.verse.toString())),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
