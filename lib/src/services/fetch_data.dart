import 'package:bible_app/src/providers/book_provider.dart';
import 'package:bible_app/src/providers/chapters_provider.dart';
import 'package:bible_app/src/providers/verse_provider.dart';
import 'package:bible_app/src/providers/version_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Future<void> fetchData(WidgetRef ref) async => await Future.delayed(
      const Duration(milliseconds: 100),
      () async {
        await ref
            .read(versesProvider.notifier)
            .loadVerses(ref.watch(versionProvider));
        await ref
            .read(chaptersProvider.notifier)
            .loadChapters(ref.watch(versionProvider));
        await ref
            .read(booksProvider.notifier)
            .loadBooks(ref.watch(versionProvider));
      },
    );
