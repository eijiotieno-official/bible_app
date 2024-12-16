import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/bible_version_model.dart';
import '../providers/verse_provider.dart';
import '../providers/version_provider.dart';

Future<void> fetchBibleVersionData({
  required WidgetRef ref,
  required BibleVersion version,
}) async {
  ref.read(versionProvider.notifier).state = version;

  await ref.read(versesProvider.notifier).loadVerses(version);
}
