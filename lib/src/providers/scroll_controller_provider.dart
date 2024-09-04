import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class ScrollControllerProvider {
  static final itemScrollControllerProvider =
      Provider<ItemScrollController>((ref) {
    return ItemScrollController();
  });

  static final scrollOffsetControllerProvider =
      Provider<ScrollOffsetController>((ref) {
    return ScrollOffsetController();
  });

  static final itemPositionsListenerProvider =
      Provider<ItemPositionsListener>((ref) {
    return ItemPositionsListener.create();
  });

  static final scrollOffsetListenerProvider =
      Provider<ScrollOffsetListener>((ref) {
    return ScrollOffsetListener.create();
  });

  static void jumpTo({
    required WidgetRef ref,
    required int index,
  }) {
    ref
        .read(itemScrollControllerProvider)
        .jumpTo(index: index, alignment: 0.1);
  }
}
