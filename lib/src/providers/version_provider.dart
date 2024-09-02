import 'package:bible_app/src/databases/bible_database.dart';
import 'package:bible_app/src/models/bible_version_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final versionProvider = StateProvider<BibleVersion>((ref) {
  return BibleDatabase.bibleVersions.first;
});
