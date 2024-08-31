import 'package:flutter/material.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class GroupedList extends StatelessWidget {
  final List<dynamic> items;
  final Widget Function(BuildContext, int) itemBuilder;
  final Widget? header;
  final ItemScrollController itemScrollController;
  final ScrollOffsetController scrollOffsetController;
  final ItemPositionsListener itemPositionsListener;
  final ScrollOffsetListener scrollOffsetListener;
  const GroupedList({
    super.key,
    required this.items,
    required this.itemScrollController,
    required this.scrollOffsetController,
    required this.itemPositionsListener,
    required this.scrollOffsetListener,
    required this.itemBuilder,
    required this.header,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        ScrollablePositionedList.builder(
          physics: const BouncingScrollPhysics(),
          shrinkWrap: true,
          itemCount: items.length,
          itemBuilder: itemBuilder,
          itemScrollController: itemScrollController,
          scrollOffsetController: scrollOffsetController,
          itemPositionsListener: itemPositionsListener,
          scrollOffsetListener: scrollOffsetListener,
        ),
        Align(
          alignment: Alignment.topCenter,
          child: header,
        ),
      ],
    );
  }
}
