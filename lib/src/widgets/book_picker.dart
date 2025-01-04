import 'package:flutter/material.dart';

class BookPicker {
  static Future<String?> pick({
    required BuildContext context,
    required String initialBook,
    required List<String> books,
  }) async {
    return await showModalBottomSheet(
      context: context,
      useSafeArea: true,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (sheetContext) {
        return _BookPickerView(
          initialBook: initialBook,
          books: books,
        );
      },
    );
  }
}

class _BookPickerView extends StatefulWidget {
  final String initialBook;
  final List<String> books;
  const _BookPickerView({required this.initialBook, required this.books});

  @override
  State<_BookPickerView> createState() => __BookPickerViewState();
}

class __BookPickerViewState extends State<_BookPickerView> {
  List<String> _searchResult = [];

  final TextEditingController _searchController = TextEditingController();

  void _search() {
    setState(() {
      _searchResult = [];
    });

    final query = _searchController.text.trim();

    final result = widget.books.where((book) {
      return book.toLowerCase().contains(query.toLowerCase());
    }).toList();

    setState(() {
      _searchResult = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    final books = _searchResult.isEmpty ? widget.books : _searchResult;

    return SafeArea(
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 8.0,
                horizontal: 16.0,
              ),
              child: TextField(
                controller: _searchController,
                autofocus: true,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.search_rounded),
                  hintText: "Search book",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                ),
                onChanged: (_) {
                  _search();
                },
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.4,
              child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: books.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    selected: widget.initialBook == books[index],
                    title: Text(books[index]),
                    onTap: () {
                      Navigator.of(context).pop(books[index]);
                    },
                    trailing: Icon(Icons.arrow_right_rounded),
                  );
                },
              ),
            ),
            SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
          ],
        ),
      ),
    );
  }
}
