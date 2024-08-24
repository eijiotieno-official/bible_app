import 'package:bible_app/src/databases/bible_database.dart';
import 'package:bible_app/src/enums/bible_version_enum.dart';
import 'package:bible_app/src/models/book_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BookNotifier extends StateNotifier<AsyncValue<List<Book>>> {
  BookNotifier() : super(const AsyncValue.loading());

  Future<void> loadBooks(BibleVersion version) async {
    state = const AsyncValue.loading();

    final getBooksResult = await BibleDatabase(version: version).getBooks();

    state = getBooksResult.fold(
      (error) => AsyncValue.error(error, StackTrace.current),
      (books) => AsyncValue.data(books),
    );
  }
}

final booksProvider =
    StateNotifierProvider<BookNotifier, AsyncValue<List<Book>>>((ref) {
  return BookNotifier();
});
