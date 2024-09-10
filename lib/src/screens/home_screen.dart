import 'package:bible_app/src/models/bible_version_model.dart';
import 'package:bible_app/src/models/verse_model.dart';
import 'package:bible_app/src/providers/last_index_provider.dart';
import 'package:bible_app/src/providers/scroll_controller_provider.dart';
import 'package:bible_app/src/providers/selected_verses_provider.dart';
import 'package:bible_app/src/providers/verse_provider.dart';
import 'package:bible_app/src/providers/version_provider.dart';
import 'package:bible_app/src/screens/help_screen.dart';
import 'package:bible_app/src/screens/search_screen.dart';
import 'package:bible_app/src/services/bible_list_cache_service.dart';
import 'package:bible_app/src/services/contact_us.dart';
import 'package:bible_app/src/services/fetch_bible_version_data.dart';
import 'package:bible_app/src/services/fetch_cached_data.dart';
import 'package:bible_app/src/services/invite_friend.dart';
import 'package:bible_app/src/services/privacy_policy.dart';
import 'package:bible_app/src/services/show_verse_picker.dart';
import 'package:bible_app/src/services/show_versions.dart';
import 'package:bible_app/src/widgets/bible_view.dart';
import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:share_plus/share_plus.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  Future<void> _initData() async {
    await fetchCachedData(ref: ref);

    final BibleVersion version = ref.read(versionProvider);

    await fetchBibleVersionData(ref: ref, version: version);
  }

  Verse? _activeVerse;

  @override
  void initState() {
    super.initState();
    _initData().then(
      (_) {
        ref
            .read(ScrollControllerProvider.itemPositionsListenerProvider)
            .itemPositions
            .addListener(
          () {
            final positions = ref
                .read(ScrollControllerProvider.itemPositionsListenerProvider)
                .itemPositions
                .value
                .toList();

            final first = positions
                .where((ItemPosition position) => position.itemTrailingEdge > 0)
                .reduce((ItemPosition min, ItemPosition position) =>
                    position.itemTrailingEdge < min.itemTrailingEdge
                        ? position
                        : min)
                .index;

            final firstIndex = first;

            LastIndexCacheService.save(firstIndex);

            final versesState = ref.read(versesProvider);

            final verses = versesState.asData?.value ?? [];

            final firstVerseInViewPort = verses[firstIndex];

            final previousActiveVerse = _activeVerse ?? verses.first;

            if (firstVerseInViewPort.book != previousActiveVerse.book ||
                firstVerseInViewPort.chapter != previousActiveVerse.chapter) {
              ref.read(lastIndexProvider.notifier).state = firstIndex;
              _activeVerse = firstVerseInViewPort;
            }
          },
        );
      },
    );
  }

  Future<void> _copy(List<Verse> verses) async {
    String cleaned = _cleanVerses(verses);

    await FlutterClipboard.copy(cleaned).then(
      (_) {
        ref.read(selectedVersesProvider.notifier).clear();
      },
    );
  }

  Future<void> _share(List<Verse> verses) async {
    String cleaned = _cleanVerses(verses);

    await Share.share(cleaned).then(
      (_) {
        ref.read(selectedVersesProvider.notifier).clear();
      },
    );
  }

  String _cleanVerses(List<Verse> verses) {
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

    final verses = versesState.asData?.value ?? [];

    bool versesLoaded = verses.isNotEmpty;

    final selected = ref.watch(selectedVersesProvider);

    final isVerseSelected = selected.isNotEmpty;

    final bibleVersion = ref.watch(versionProvider);

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
          title: versesLoaded == false
              ? null
              : Card(
                  margin: EdgeInsets.zero,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(16.0),
                    onTap: () async {
                      await showVersions(context: context, ref: ref);
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8.0,
                        vertical: 4.0,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            bibleVersion.title,
                            style: const TextStyle(
                              fontSize: 16,
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.only(left: 4.0),
                            child: Icon(Icons.arrow_drop_down_rounded),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
          actions: [
            if (isVerseSelected && versesLoaded)
              IconButton(
                onPressed: () {
                  _copy(selected);
                },
                icon: const Icon(
                  Icons.copy_rounded,
                ),
              ),
            if (isVerseSelected && versesLoaded)
              IconButton(
                onPressed: () {
                  _share(selected);
                },
                icon: const Icon(
                  Icons.share_rounded,
                ),
              ),
            if (!isVerseSelected && versesLoaded)
              IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return SearchScreen(verses);
                      },
                    ),
                  );
                },
                icon: const Icon(
                  Icons.search_rounded,
                ),
              ),
            if (!isVerseSelected && versesLoaded)
              IconButton(
                onPressed: () {
                  openShowVersions(context: context, verses: verses, ref: ref);
                },
                icon: const Icon(
                  Icons.book_rounded,
                ),
              ),
            if (!isVerseSelected && versesLoaded)
              PopupMenuButton(
                menuPadding: EdgeInsets.zero,
                padding: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                itemBuilder: (context) {
                  return [
                    PopupMenuItem(
                      padding: EdgeInsets.zero,
                      onTap: () {
                        inviteFriend();
                      },
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16.0),
                            child: Icon(Icons.share_rounded),
                          ),
                          Padding(
                            padding: EdgeInsets.only(right: 16.0),
                            child: Text("Invite a friend"),
                          ),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      padding: EdgeInsets.zero,
                      onTap: () {
                        contactUs();
                      },
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16.0),
                            child: Icon(Icons.mail_rounded),
                          ),
                          Padding(
                            padding: EdgeInsets.only(right: 16.0),
                            child: Text("Contact us"),
                          ),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      padding: EdgeInsets.zero,
                      onTap: () {
                        privacyPolicy();
                      },
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16.0),
                            child: Icon(Icons.privacy_tip_rounded),
                          ),
                          Padding(
                            padding: EdgeInsets.only(right: 16.0),
                            child: Text("Privacy policy"),
                          ),
                        ],
                      ),
                    ),
                  ];
                },
              ),
          ],
        ),
        body: versesState.when(
          data: (data) => BibleView(data),
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
