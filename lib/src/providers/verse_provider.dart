import '../databases/bible_database.dart';
import '../models/bible_version_model.dart';
import '../models/verse_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class VerseNotifier extends StateNotifier<AsyncValue<List<Verse>>> {
  VerseNotifier() : super(const AsyncValue.loading());

  Future<void> loadVerses(BibleVersion version) async {
    state = const AsyncValue.loading();

    final getVersesResult = await BibleDatabase(version).getVerses();

    state = getVersesResult.fold(
      (error) => AsyncValue.error(error, StackTrace.current),
      (verses) => AsyncValue.data(verses),
    );
  }
}

final versesProvider =
    StateNotifierProvider<VerseNotifier, AsyncValue<List<Verse>>>((ref) {
  return VerseNotifier();
});
