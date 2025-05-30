import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/verse_model.dart';

class SelectedVersesNotifier extends StateNotifier<List<Verse>> {
  SelectedVersesNotifier() : super([]);

  void add(Verse newVerse) {
    state = [...state, newVerse];
  }

  void remove(Verse newVerse) {
    state = [
      for (final verse in state)
        if (verse.toString() != newVerse.toString()) verse,
    ];
  }

  void clear() {
    state = [];
  }
}

final selectedVersesProvider =
    StateNotifierProvider<SelectedVersesNotifier, List<Verse>>((ref) {
  return SelectedVersesNotifier();
});
