import 'package:bible_app/src/models/verse_model.dart';
import 'package:bible_app/src/widgets/search_view.dart';
import 'package:flutter/material.dart';

Future<void> showSearchScreen({
  required BuildContext context,
  required List<Verse> verses,
}) async =>
    await showModalBottomSheet(
      useSafeArea: true,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      showDragHandle: true,
      context: context,
      builder: (context) {
        return SearchView(verses);
      },
    );
