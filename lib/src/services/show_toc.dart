import 'package:bible_app/src/models/chapter_model.dart';
import 'package:bible_app/src/widgets/toc_view.dart';
import 'package:flutter/material.dart';

Future<void> showTOC({
  required BuildContext context,
  required Chapter chapter,
}) async =>
    await showModalBottomSheet(
      useSafeArea: true,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      showDragHandle: true,
      context: context,
      builder: (context) {
        return TocView(chapter: chapter);
      },
    );
