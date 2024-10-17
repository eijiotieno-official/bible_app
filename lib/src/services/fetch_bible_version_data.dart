import 'package:bible_app/src/models/bible_version_model.dart';
import 'package:bible_app/src/providers/verse_provider.dart';
import 'package:bible_app/src/providers/version_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Future<void> fetchBibleVersionData({
  required WidgetRef ref,
  required BibleVersion version,
}) async {
  ref.read(versionProvider.notifier).state = version;

  await ref.read(versesProvider.notifier).loadVerses(version);
}
