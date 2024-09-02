import 'package:bible_app/src/models/bible_version_model.dart';
import 'package:bible_app/src/providers/book_provider.dart';
import 'package:bible_app/src/providers/chapters_provider.dart';
import 'package:bible_app/src/providers/verse_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Future<void> fetchData({
  required WidgetRef ref,
  required BibleVersion version,
}) async {
  await ref.read(versesProvider.notifier).loadVerses(version);
  await ref.read(chaptersProvider.notifier).loadChapters(version);
  await ref.read(booksProvider.notifier).loadBooks(version);
}
