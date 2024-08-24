import 'package:bible_app/src/databases/bible_database.dart';
import 'package:bible_app/src/enums/bible_version_enum.dart';
import 'package:bible_app/src/models/chapter_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChaptersNotifier extends StateNotifier<AsyncValue<List<Chapter>>> {
  ChaptersNotifier() : super(const AsyncValue.loading());

  Future<void> loadChapters(BibleVersion version) async {
    state = const AsyncValue.loading();

    final getChaptersResult =
        await BibleDatabase(version: version).getChapters();

    state = getChaptersResult.fold(
      (error) => AsyncValue.error(error, StackTrace.current),
      (chapters) => AsyncValue.data(chapters),
    );
  }
}

final chaptersProvider =
    StateNotifierProvider<ChaptersNotifier, AsyncValue<List<Chapter>>>((ref) {
  return ChaptersNotifier();
});
