class VerseGroup {
  final String book;
  final int chapter;

  VerseGroup({
    required this.book,
    required this.chapter,
  });
}

class ItemComparator {
  final int chapter;
  final int verse;
  ItemComparator({
    required this.chapter,
    required this.verse,
  });
}

class GroupBy {
  final String book;
  final int chapter;
  final int verse;
  GroupBy({
    required this.book,
    required this.chapter,
    required this.verse,
  });
}
