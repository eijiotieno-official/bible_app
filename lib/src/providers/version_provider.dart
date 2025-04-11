import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../databases/bible_database.dart';
import '../models/bible_version_model.dart';

final versionProvider = StateProvider<BibleVersion>((ref) {
  return BibleDatabase.bibleVersions.first;
});

final versionChangedProvider = StateProvider<bool>((ref) {
    return false;
});