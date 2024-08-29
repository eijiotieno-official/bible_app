import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

final itemScrollControllerProvider = Provider<ItemScrollController>((ref) {
  return ItemScrollController();
});

final scrollOffsetControllerProvider = Provider<ScrollOffsetController>((ref) {
  return ScrollOffsetController();
});

final itemPositionsListenerProvider = Provider<ItemPositionsListener>((ref) {
  return ItemPositionsListener.create();
});

final scrollOffsetListenerProvider = Provider<ScrollOffsetListener>((ref) {
  return ScrollOffsetListener.create();
});
