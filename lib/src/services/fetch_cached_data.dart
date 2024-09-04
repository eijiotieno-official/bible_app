import 'package:bible_app/src/databases/bible_database.dart';
import 'package:bible_app/src/models/bible_version_model.dart';
import 'package:bible_app/src/providers/last_index_provider.dart';

import 'package:bible_app/src/providers/version_provider.dart';
import 'package:bible_app/src/services/bible_list_cache_service.dart';
import 'package:bible_app/src/services/bible_version_cache_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Future<void> fetchCachedData({required WidgetRef ref}) async {
  final BibleVersion? versionReadResult = await BibleVersionCacheService.read();

  final int? indexResult = await LastIndexCacheService.read();

  final int index = indexResult ?? 0;

  final BibleVersion version =
      versionReadResult ?? BibleDatabase.bibleVersions.first;

  ref.read(versionProvider.notifier).state = version;

  ref.read(lastIndexProvider.notifier).state = index;
}
