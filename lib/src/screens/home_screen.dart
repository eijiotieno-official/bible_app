import 'package:bible_app/src/models/bible_version_model.dart';
import 'package:bible_app/src/models/verse_model.dart';
import 'package:bible_app/src/providers/last_index_provider.dart';
import 'package:bible_app/src/providers/scroll_controller_provider.dart';
import 'package:bible_app/src/providers/selected_verses_provider.dart';
import 'package:bible_app/src/providers/verse_provider.dart';
import 'package:bible_app/src/providers/version_provider.dart';
import 'package:bible_app/src/screens/bookmark_screen.dart';
import 'package:bible_app/src/screens/search_screen.dart';
import 'package:bible_app/src/services/cache_services.dart';
import 'package:bible_app/src/services/fetch_bible_version_data.dart';
import 'package:bible_app/src/services/fetch_cached_data.dart';
import 'package:bible_app/src/services/show_versions.dart';
import 'package:bible_app/src/services/user_action_services.dart';
import 'package:bible_app/src/services/verse_services.dart';
import 'package:bible_app/src/widgets/bible_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  Future<void> _init() async {
    await fetchCachedData(ref: ref);

    final BibleVersion version = ref.read(versionProvider);

    await fetchBibleVersionData(ref: ref, version: version).then(
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

            CacheServices.saveVerseIndex(firstIndex);

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

  Verse? _activeVerse;

  @override
  void initState() {
    super.initState();
    _init();
  }

  @override
  Widget build(BuildContext context) {
    VerseServices verseServices = VerseServices(ref);

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
                  verseServices.copy(selected);
                },
                icon: const Icon(
                  Icons.copy_rounded,
                ),
              ),
            if (isVerseSelected && versesLoaded)
              IconButton(
                onPressed: () {
                  verseServices.share(selected);
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
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return BookmarkScreen();
                      },
                    ),
                  );
                },
                icon: const Icon(
                  Icons.bookmark_outline_rounded,
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
                        UserActionServices.inviteFriend();
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
                        UserActionServices.contactUs();
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
                        UserActionServices.privacyPolicy();
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
