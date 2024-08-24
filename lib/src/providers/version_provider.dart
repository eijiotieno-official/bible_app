import 'package:bible_app/src/enums/bible_version_enum.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final versionProvider = StateProvider<BibleVersion>((ref) {
  return BibleVersion.kjv;
});
