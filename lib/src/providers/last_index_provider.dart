import 'package:flutter_riverpod/flutter_riverpod.dart';

final lastIndexProvider = StateProvider<int>((ref) {
  return 0;
});
