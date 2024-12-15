import '../databases/bible_database.dart';
import '../models/bible_version_model.dart';
import '../providers/last_index_provider.dart';

import '../providers/version_provider.dart';
import 'cache_services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Future<void> fetchCachedData({required WidgetRef ref}) async {
  final BibleVersion? versionReadResult = await CacheServices.readVersion();

  final int? indexResult = await CacheServices.readVerseIndex();

  final int index = indexResult ?? 0;

  final BibleVersion version =
      versionReadResult ?? BibleDatabase.bibleVersions.first;

  ref.read(versionProvider.notifier).state = version;

  ref.read(lastIndexProvider.notifier).state = index;
}
