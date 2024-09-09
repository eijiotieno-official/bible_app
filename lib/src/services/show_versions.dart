import 'package:bible_app/src/databases/bible_database.dart';
import 'package:bible_app/src/models/bible_version_model.dart';
import 'package:bible_app/src/providers/last_index_provider.dart';
import 'package:bible_app/src/providers/scroll_controller_provider.dart';
import 'package:bible_app/src/providers/version_provider.dart';
import 'package:bible_app/src/services/bible_list_cache_service.dart';
import 'package:bible_app/src/services/bible_version_cache_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import 'fetch_bible_version_data.dart';

Future<void> showVersions({
  required WidgetRef ref,
  required BuildContext context,
}) async {
  final positions = ref
      .read(ScrollControllerProvider.itemPositionsListenerProvider)
      .itemPositions
      .value
      .toList();

  final first = positions
      .where((ItemPosition position) => position.itemTrailingEdge > 0)
      .reduce((ItemPosition min, ItemPosition position) =>
          position.itemTrailingEdge < min.itemTrailingEdge ? position : min)
      .index;

  final firstIndex = first;

  ref.read(lastIndexProvider.notifier).state = firstIndex;

  LastIndexCacheService.save(firstIndex);

  final result = await showModalBottomSheet(
    useSafeArea: true,
    isScrollControlled: true,
    backgroundColor: Theme.of(context).colorScheme.surface,
    showDragHandle: true,
    context: context,
    builder: (context) {
      return const _VersionsView();
    },
  );

  if (result != null) {
    final version = ref.watch(versionProvider);

    await fetchBibleVersionData(ref: ref, version: version);
  }
}

class _VersionsView extends ConsumerStatefulWidget {
  const _VersionsView();

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => __VersionsViewState();
}

class __VersionsViewState extends ConsumerState<_VersionsView> {
  BibleVersion? _currentVersion;

  @override
  void initState() {
    _currentVersion = ref.read(versionProvider);
    super.initState();
  }

  void _confirm() {
    final version = _currentVersion ?? BibleDatabase.bibleVersions.first;

    BibleVersionCacheService.save(version);

    ref.read(versionProvider.notifier).state = version;

    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.5,
            child: ListView.builder(
              itemCount: BibleDatabase.bibleVersions.length,
              itemBuilder: (context, index) {
                final thisVersion = BibleDatabase.bibleVersions[index];
                bool isSelected =
                    _currentVersion.toString() == thisVersion.toString();
                return CheckboxListTile(
                  value: isSelected,
                  onChanged: (b) {
                    setState(() {
                      _currentVersion = thisVersion;
                    });
                  },
                  title: Text(thisVersion.title),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: ref.read(versionProvider).toString() !=
                        _currentVersion.toString()
                    ? () {
                        _confirm();
                      }
                    : null,
                child: const Text("Confirm"),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
