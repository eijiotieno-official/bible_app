import 'package:bible_app/src/widgets/toc_view.dart';
import 'package:flutter/material.dart';

Future<void> showTOC({
  required BuildContext context,
  String? book,
  int? chapter,
  int? verse,
}) async =>
    await showModalBottomSheet(
      useSafeArea: true,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      showDragHandle: true,
      context: context,
      builder: (context) {
        return TocView(chapter: chapter, book: book, verse: verse);
      },
    );
