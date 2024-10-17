import 'package:bible_app/src/models/bookmark_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BookmarkNotifier extends StateNotifier<AsyncValue<List<Bookmark>>> {
  BookmarkNotifier() : super(AsyncValue.loading());

  void add(Bookmark newBookmark) {}

  void remove(Bookmark newBookmark) {}
}
