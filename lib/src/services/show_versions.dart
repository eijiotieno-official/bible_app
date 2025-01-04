import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import '../databases/bible_database.dart';
import '../models/bible_version_model.dart';
import '../providers/last_index_provider.dart';
import '../providers/scroll_controller_provider.dart';
import '../providers/version_provider.dart';
import 'cache_services.dart';
import 'fetch_bible_version_data.dart';
import 'notification_service.dart';

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

  CacheServices.saveVerseIndex(firstIndex);

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

  Future<void> _confirm() async {
    final version = _currentVersion ?? BibleDatabase.bibleVersions.first;

    CacheServices.saveVersion(version);

    await NotificationService.scheduleDailyNotifications(version);

    ref.read(versionProvider.notifier).state = version;

    final index = ref.read(lastIndexProvider);

    ScrollControllerProvider.jumpTo(ref: ref, index: index);

    if (mounted) {
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListView.builder(
            shrinkWrap: true,
            itemCount: BibleDatabase.bibleVersions.length,
            itemBuilder: (context, index) {
              final thisVersion = BibleDatabase.bibleVersions[index];
              bool isSelected =
                  _currentVersion.toString() == thisVersion.toString();
              return RadioListTile(
                value: thisVersion,
                onChanged: (b) {
                  setState(() {
                    _currentVersion = thisVersion;
                  });
                },
                title: Text(thisVersion.title),
                groupValue: _currentVersion,
                selected: isSelected,
              );
            },
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: ref.read(versionProvider).toString() !=
                        _currentVersion.toString()
                    ? () async {
                        await _confirm();
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
