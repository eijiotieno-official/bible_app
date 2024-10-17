import 'package:clipboard/clipboard.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';

import 'package:bible_app/src/models/verse_model.dart';
import 'package:bible_app/src/providers/selected_verses_provider.dart';
import 'package:bible_app/src/providers/version_provider.dart';

class VerseServices {
  final WidgetRef _ref;
  VerseServices(this._ref);

  Future<void> copy(List<Verse> verses) async {
    String cleaned = _cleanVerses(verses);

    await FlutterClipboard.copy(cleaned).then(
      (_) {
        _ref.read(selectedVersesProvider.notifier).clear();
      },
    );
  }

  Future<void> share(List<Verse> verses) async {
    String cleaned = _cleanVerses(verses);

    await Share.share(cleaned).then(
      (_) {
        _ref.read(selectedVersesProvider.notifier).clear();
      },
    );
  }

  String _cleanVerses(List<Verse> verses) {
    String result = verses
        .map((e) => " [${e.book} ${e.chapter}:${e.verse}] ${e.text.trim()}")
        .join();

    final currentVersion = _ref.watch(versionProvider);

    final cleaned = "$result [${currentVersion.title}]";
    return cleaned;
  }
}
