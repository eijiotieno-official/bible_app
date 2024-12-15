import '../databases/bible_database.dart';
import '../models/verse_model.dart';
import '../providers/scroll_controller_provider.dart';
import '../utils/text_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:collection/collection.dart';

class SearchScreen extends ConsumerStatefulWidget {
  final List<Verse> verses;
  const SearchScreen(this.verses, {super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  final List<Verse> _results = [];

  // Method to perform the search
  Future<void> search() async {
    setState(() {
      _results.clear();
    });

    for (var verse in widget.verses) {
      // Matching verses based on the trimmed and lowercase text
      bool matchVerse = verse.text
          .trim()
          .replaceAll(" ", "")
          .toLowerCase()
          .contains(
              _searchController.text.trim().replaceAll(" ", "").toLowerCase());
      if (matchVerse) {
        bool contains = _results.any((element) => element == verse);
        if (!contains) {
          setState(() {
            _results.add(verse);
          });
        }
      }
    }
  }

  String _selectedBook = "All";

  void _onTap(String book) {
    setState(() {
      _selectedBook = book;
    });
  }

  @override
  Widget build(BuildContext context) {
    final resultBooks =
        _results.map((toElement) => toElement.book).toSet().toList();

    resultBooks.sortByCompare(
      (keyOf) => keyOf,
      (a, b) {
        final books = BibleDatabase.books;
        int indexA = books.indexOf(a);
        int indexB = books.indexOf(b);

        return indexA.compareTo(indexB);
      },
    );

    final filteredResult = _selectedBook == "All"
        ? _results
        : _results.where((test) => test.book == _selectedBook).toList();

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0.0,
        title: TextField(
          autofocus: true,
          controller: _searchController,
          decoration: const InputDecoration(
            border: InputBorder.none,
            hintText: "Search",
          ),
          onChanged: (o) => setState(() {}),
          onSubmitted: (s) async =>
              await search().then((_) => _scrollController.jumpTo(0.0)),
          textInputAction: TextInputAction.search,
        ),
        actions: [
          // Clear search button when there's input
          if (_searchController.text.isNotEmpty)
            IconButton(
              onPressed: () async {
                await search().then((_) => _scrollController.jumpTo(0.0));
              },
              icon: const Icon(Icons.search_rounded),
            ),
        ],
      ),
      body: Column(
        children: [
          ListTile(
            contentPadding: EdgeInsets.zero,
            // title: _results.isEmpty
            //     ? null
            //     : Padding(
            //         padding: const EdgeInsets.symmetric(horizontal: 16.0),
            //         child: Text("Results: ${_results.length}"),
            //       ),
            title: SizedBox(
              height: 45,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: resultBooks.length,
                physics: const BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  final book = resultBooks[index];

                  final resultCount = _results
                      .where((test) => test.book == book)
                      .toList()
                      .length;

                  return index == 0
                      ? Row(
                          children: [
                            Center(
                              child: GestureDetector(
                                onTap: () {
                                  _onTap("All");
                                },
                                child: Card(
                                  color: "All" == _selectedBook
                                      ? Theme.of(context)
                                          .colorScheme
                                          .primaryContainer
                                      : null,
                                  margin: EdgeInsets.only(
                                      left: 14.0,
                                      right: index == (resultBooks.length - 1)
                                          ? 14.0
                                          : 0.0),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0, vertical: 4.0),
                                    child: Text("All ${_results.length}"),
                                  ),
                                ),
                              ),
                            ),
                            Center(
                              child: GestureDetector(
                                onTap: () {
                                  _onTap(book);
                                },
                                child: Card(
                                  color: book == _selectedBook
                                      ? Theme.of(context)
                                          .colorScheme
                                          .primaryContainer
                                      : null,
                                  margin: EdgeInsets.only(
                                      left: 14.0,
                                      right: index == (resultBooks.length - 1)
                                          ? 14.0
                                          : 0.0),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0, vertical: 4.0),
                                    child: Text("$book $resultCount"),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
                      : Center(
                          child: GestureDetector(
                            onTap: () {
                              _onTap(book);
                            },
                            child: Card(
                              color: book == _selectedBook
                                  ? Theme.of(context)
                                      .colorScheme
                                      .primaryContainer
                                  : null,
                              margin: EdgeInsets.only(
                                  left: 14.0,
                                  right: index == (resultBooks.length - 1)
                                      ? 14.0
                                      : 0.0),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8.0, vertical: 4.0),
                                child: Text("$book $resultCount"),
                              ),
                            ),
                          ),
                        );
                },
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              physics: const BouncingScrollPhysics(),
              itemCount: filteredResult.length,
              itemBuilder: (context, index) {
                Verse verse = filteredResult[index];
                return DecoratedBox(
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: Theme.of(context).hoverColor),
                    ),
                  ),
                  child: ListTile(
                    onTap: () {
                      int idx = widget.verses.indexWhere(
                        (element) =>
                            element.chapter == verse.chapter &&
                            element.book == verse.book &&
                            element.verse == verse.verse,
                      );
                      ScrollControllerProvider.jumpTo(ref: ref, index: idx);
                      Navigator.pop(context);
                    },
                    title: TextUtils.search(
                        input: verse.text.trim(),
                        text: _searchController.text.trim(),
                        context: context),
                    subtitle:
                        Text("${verse.book} ${verse.chapter}:${verse.verse}"),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
