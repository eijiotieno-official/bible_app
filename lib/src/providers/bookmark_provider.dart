import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/bookmark_model.dart';

class BookmarkNotifier extends StateNotifier<AsyncValue<List<Bookmark>>> {
  BookmarkNotifier() : super(AsyncValue.loading());

  void add(Bookmark newBookmark) {}

  void remove(Bookmark newBookmark) {}
}
