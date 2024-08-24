import 'package:bible_app/src/models/verse_model.dart';
import 'package:bible_app/src/providers/verse_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

final scrollControllerProvider = Provider<AutoScrollController>((ref) {
  return AutoScrollController();
});

void scrollTo({required Verse verse, required WidgetRef ref}) {
  final versesState = ref.read(versesProvider);

  final verses = versesState.asData?.value ?? [];

  final index =
      verses.indexWhere((test) => test.toString() == verse.toString());

  ref.read(scrollControllerProvider).scrollToIndex(index);

  ref.read(scrollControllerProvider).highlight(index);

  Future.delayed(
    const Duration(seconds: 3),
    () {
      ref.read(scrollControllerProvider).cancelAllHighlights();
    },
  );
}
