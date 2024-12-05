import 'package:bible_app/src/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await MobileAds.instance.initialize();
  runApp(const ProviderScope(child: MainApp()));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(
      builder: (ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
        // Helper function to ensure the primary color is not null, white, or black
        Color getPrimaryColor(Color? color) {
          if (color == null || color == Colors.white || color == Colors.black) {
            return Colors.orange;
          }
          return color;
        }

        return MaterialApp(
          debugShowCheckedModeBanner: false,
          themeMode: ThemeMode.system,
          darkTheme: ThemeData(
            useMaterial3: true,
            colorSchemeSeed: getPrimaryColor(darkDynamic?.primary),
            brightness: Brightness.dark,
          ),
          theme: ThemeData(
            useMaterial3: true,
            colorSchemeSeed: getPrimaryColor(lightDynamic?.primary),
            brightness: Brightness.light,
          ),
          home: const HomeScreen(),
        );
      },
    );
  }
}
