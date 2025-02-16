
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import '../models/bible_version_model.dart';
import '../models/verse_model.dart';
import '../providers/last_index_provider.dart';
import '../providers/scroll_controller_provider.dart';
import '../providers/selected_verses_provider.dart';
import '../providers/verse_provider.dart';
import '../providers/version_provider.dart';
import '../services/cache_services.dart';
import '../services/fetch_bible_version_data.dart';
import '../services/fetch_cached_data.dart';
import '../services/notification_service.dart';
import '../services/show_versions.dart';
import '../services/user_action_services.dart';
import '../services/verse_services.dart';
import '../widgets/ad_banner_view.dart';
import '../widgets/bible_view.dart';
import 'search_screen.dart';

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

    NotificationService.scheduleDailyNotifications(version);
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
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24.0),
                  ),
                  margin: EdgeInsets.zero,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(24.0),
                    onTap: () async {
                      await showVersions(context: context, ref: ref);
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 12.0),
                            child: Text(
                              bibleVersion.title,
                              style: const TextStyle(
                                fontSize: 16,
                              ),
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.only(
                              left: 4.0,
                              right: 8.0,
                            ),
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
              PopupMenuButton(
                menuPadding: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                itemBuilder: (context) {
                  return [
                    PopupMenuItem(
                      onTap: () {
                        UserActionServices.inviteFriend();
                      },
                      child: Text("Invite a friend"),
                    ),
                    PopupMenuItem(
                      onTap: () {
                        UserActionServices.contactUs();
                      },
                      child: Text("Contact us"),
                    ),
                    PopupMenuItem(
                      onTap: () {
                        UserActionServices.privacyPolicy();
                      },
                      child: Text("Privacy policy"),
                    ),
                  ];
                },
              ),
          ],
        ),
        body: Column(
          children: [
            // const AdBannerView(),
            Expanded(
              child: versesState.when(
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
          ],
        ),
      ),
    );
  }
}
