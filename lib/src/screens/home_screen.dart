import 'package:bible_app/src/databases/bible_database.dart';
import 'package:bible_app/src/models/bible_version_model.dart';
import 'package:bible_app/src/models/verse_model.dart';
import 'package:bible_app/src/providers/scroll_controller_provider.dart';
import 'package:bible_app/src/providers/selected_verses_provider.dart';
import 'package:bible_app/src/providers/verse_provider.dart';
import 'package:bible_app/src/providers/version_provider.dart';
import 'package:bible_app/src/screens/bookmark_screen.dart';
import 'package:bible_app/src/services/fetch_data.dart';
import 'package:bible_app/src/utils/font_size_util.dart';
import 'package:bible_app/src/widgets/bible_view.dart';
import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  void initState() {
    super.initState();
    fetchData(ref);
  }

  Future<void> _copy(List<Verse> verses) async {
    String cleaned = cleanVerses(verses);

    await FlutterClipboard.copy(cleaned).then(
      (_) {
        ref.read(selectedVersesProvider.notifier).clear();
      },
    );
  }

  Future<void> _share(List<Verse> verses) async {
    String cleaned = cleanVerses(verses);

    await Share.share(cleaned).then(
      (_) {
        ref.read(selectedVersesProvider.notifier).clear();
      },
    );
  }

  String cleanVerses(List<Verse> verses) {
    String result = verses
        .map((e) => " [${e.book} ${e.chapter}:${e.verse}] ${e.text.trim()}")
        .join();

    final currentVersion = ref.watch(versionProvider);

    final cleaned = "$result [${currentVersion.title}]";
    return cleaned;
  }

  @override
  Widget build(BuildContext context) {
    final versesState = ref.watch(versesProvider);

    final selected = ref.watch(selectedVersesProvider);

    final isVerseSelected = selected.isNotEmpty;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        systemNavigationBarColor: Theme.of(context).colorScheme.surface,
        systemNavigationBarIconBrightness:
            Theme.of(context).brightness == Brightness.dark
                ? Brightness.light
                : Brightness.dark,
      ),
      child: Scaffold(
        appBar: AppBar(
          title: isVerseSelected
              ? null
              : DropdownButton<BibleVersion>(
                  underline: const SizedBox.shrink(),
                  borderRadius: BorderRadius.circular(16.0),
                  value: ref.watch(versionProvider),
                  items: BibleDatabase.bibleVersions
                      .map(
                        (e) => DropdownMenuItem<BibleVersion>(
                          value: e,
                          child: Text(
                            e.title,
                            style: TextStyle(
                                fontSize: FontSizeUtil.font3(context)),
                          ),
                        ),
                      )
                      .toList(),
                  onChanged: (BibleVersion? value) {
                    final currentVersion = ref.watch(versesProvider);

                    ref.read(versionProvider.notifier).state =
                        value ?? BibleDatabase.bibleVersions.first;

                    if (currentVersion.toString() != value.toString()) {
                      fetchData(ref);
                      ref
                          .read(itemScrollControllerProvider)
                          .jumpTo(index: 0, alignment: 0.05);
                    }
                  },
                ),
          actions: [
            if (isVerseSelected)
              IconButton(
                onPressed: () {
                  _copy(selected);
                },
                icon: const Icon(
                  Icons.copy_rounded,
                ),
              ),
            if (isVerseSelected)
              IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.notes_rounded,
                ),
              ),
            if (isVerseSelected)
              IconButton(
                onPressed: () {
                  _share(selected);
                },
                icon: const Icon(
                  Icons.share_rounded,
                ),
              ),
            if (!isVerseSelected)
              IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.search_rounded,
                ),
              ),
            if (!isVerseSelected)
              IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return const BookmarkScreen();
                      },
                    ),
                  );
                },
                icon: const Icon(
                  Icons.bookmark_outline_rounded,
                ),
              ),
          ],
        ),
        body: versesState.when(
          data: (data) => const BibleView(),
          error: (error, stackTrace) => Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(error.toString()),
            ),
          ),
          loading: () => const Center(
            child: CircularProgressIndicator(
              strokeCap: StrokeCap.round,
            ),
          ),
        ),
      ),
    );
  }
}
