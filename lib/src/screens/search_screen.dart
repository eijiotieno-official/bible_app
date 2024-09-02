import 'package:bible_app/src/models/verse_model.dart';
import 'package:bible_app/src/providers/scroll_controller_provider.dart';
import 'package:bible_app/src/providers/verse_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _textEditingController = TextEditingController();
  final List<Verse> _results = [];

  void _search(List<Verse> verses) {
    setState(() {
      _results.clear();
    });

    for (var verse in verses) {
      bool matchVerse = verse.text
          .trim()
          .replaceAll(" ", "")
          .toLowerCase()
          .contains(_textEditingController.text
              .trim()
              .replaceAll(" ", "")
              .toLowerCase());
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

  String? _selectedBook;

  @override
  void initState() {
    _selectedBook = "All";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final versesState = ref.watch(versesProvider);
    final verses = versesState.asData?.value ?? [];

    final resultBooks =
        _results.map((toElement) => toElement.book).toList().toSet().toList();

    final resultVerses = _selectedBook == "All"
        ? _results
        : _results.where((test) => test.book == _selectedBook).toList();

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0.0,
        title: TextField(
          autofocus: true,
          controller: _textEditingController,
          decoration: const InputDecoration(
            border: InputBorder.none,
            hintText: "Search",
          ),
          onChanged: (o) => setState(() {}),
          onSubmitted: (s) {
            _search(verses);
            _scrollController.jumpTo(0.0);
          },
          textInputAction: TextInputAction.search,
        ),
        actions: [
          if (_textEditingController.text.isNotEmpty)
            IconButton(
              onPressed: () {
                _search(verses);
                _scrollController.jumpTo(0.0);
              },
              icon: const Icon(Icons.search_rounded),
            ),
        ],
      ),
      body: Column(
        children: [
          if (resultBooks.isNotEmpty)
            ListTile(
              title: Wrap(
                children: List.generate(
                  resultBooks.length,
                  (index) {
                    final book = resultBooks[index];
                    final count = _results
                        .where((test) => test.book == book)
                        .toList()
                        .length;
                    return index == 0
                        ? Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _selectedBook = "All";
                                  });
                                },
                                child: Card(
                                  color: _selectedBook == "All"
                                      ? Theme.of(context)
                                          .colorScheme
                                          .primaryContainer
                                      : null,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0,
                                      vertical: 4.0,
                                    ),
                                    child: Text("All ${_results.length}"),
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _selectedBook = book;
                                  });
                                },
                                child: Card(
                                  color: _selectedBook == book
                                      ? Theme.of(context)
                                          .colorScheme
                                          .primaryContainer
                                      : null,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0,
                                      vertical: 4.0,
                                    ),
                                    child: Text("$book $count"),
                                  ),
                                ),
                              )
                            ],
                          )
                        : GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedBook = book;
                              });
                            },
                            child: Card(
                              color: _selectedBook == book
                                  ? Theme.of(context)
                                      .colorScheme
                                      .primaryContainer
                                  : null,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8.0,
                                  vertical: 4.0,
                                ),
                                child: Text("$book $count"),
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
              itemCount: resultVerses.length,
              itemBuilder: (context, index) {
                Verse verse = resultVerses[index];
                return DecoratedBox(
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: Theme.of(context).hoverColor),
                    ),
                  ),
                  child: ListTile(
                    onTap: () {
                      int idx = verses.indexWhere((element) =>
                          element.chapter == verse.chapter &&
                          element.book == verse.book &&
                          element.verse == verse.verse);
                      ref
                          .read(itemScrollControllerProvider)
                          .jumpTo(index: idx, alignment: 0.075);
                      Navigator.pop(context);
                    },
                    title: TextUtils._search(
                        input: verse.text.trim(),
                        text: _textEditingController.text.trim(),
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

class TextUtils {
  static RichText verse({
    required bool isSelected,
    required Verse verse,
    required BuildContext context,
  }) {
    return RichText(
      text: TextSpan(
        style: DefaultTextStyle.of(context).style,
        children: <TextSpan>[
          TextSpan(
            text: verse.verse == 1
                ? "${verse.chapter}. "
                : "${verse.verse.toString()}. ",
            style: TextStyle(
              fontSize: verse.verse == 1
                  ? Theme.of(context).textTheme.displayMedium?.fontSize!
                  : null,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          TextSpan(
            text: verse.text.trim(),
            style: TextStyle(
              color: isSelected ? Theme.of(context).colorScheme.primary : null,
              decorationColor: Theme.of(context).colorScheme.primary,
              decorationStyle: TextDecorationStyle.wavy,
              decoration: isSelected ? TextDecoration.underline : null,
            ),
          ),
        ],
      ),
    );
  }

  static Text _search({
    required String input,
    required String text,
    required BuildContext context,
  }) {
    if (input.isEmpty || text.isEmpty) {
      return Text(input);
    }

    List<TextSpan> textSpans = [];

    RegExp regExp = RegExp(text, caseSensitive: false);

    Iterable<Match> matches = regExp.allMatches(input);

    int currentIndex = 0;

    for (Match match in matches) {
      textSpans.add(TextSpan(text: input.substring(currentIndex, match.start)));

      textSpans.add(
        TextSpan(
          text: input.substring(match.start, match.end),
          style: TextStyle(
            color: Theme.of(context).colorScheme.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
      );

      currentIndex = match.end;
    }

    textSpans.add(TextSpan(text: input.substring(currentIndex)));

    return Text.rich(TextSpan(children: textSpans));
  }
}
