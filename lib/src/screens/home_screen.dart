import 'package:bible_app/src/providers/verse_provider.dart';
import 'package:bible_app/src/services/fetch_data.dart';
import 'package:bible_app/src/widgets/bible_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  void initState() {
    super.initState();
    fetchData(ref);
  }

  @override
  Widget build(BuildContext context) {
    final versesState = ref.watch(versesProvider);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        systemNavigationBarColor: Theme.of(context).colorScheme.surface,
        systemNavigationBarIconBrightness:
            Theme.of(context).brightness == Brightness.dark
                ? Brightness.light
                : Brightness.dark,
      ),
      child: Material(
        child: versesState.when(
          data: (data) => Scaffold(
            appBar: AppBar(),
            body: const BibleView(),
          ),
          error: (error, stackTrace) => Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(error.toString()),
            ),
          ),
          loading: () => const Center(
            child: CircularProgressIndicator(
              strokeCap: StrokeCap.round,
            ),
          ),
        ),
      ),
    );
  }
}
