import 'package:expanse_tracker/core/providers/main_provider.dart';
import 'package:expanse_tracker/features/root/screens/root_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static const ink = Color(0xFF1F211D);
  static const forest = Color(0xFF1E3C31);
  static const sage = Color(0xFF849074);
  static const sand = Color(0xFFCBB891);
  static const cream = Color(0xFFF5F0E6);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (context) => MainProvider())],

      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Stillwell — Expenses',
        theme: ThemeData(
          useMaterial3: true,
          scaffoldBackgroundColor: cream,
          colorScheme: ColorScheme.fromSeed(
            seedColor: forest,
            brightness: Brightness.light,
            primary: forest,
            secondary: sage,
            surface: cream,
          ),
          appBarTheme: const AppBarTheme(
            backgroundColor: cream,
            foregroundColor: ink,
            elevation: 0,
            centerTitle: false,
          ),
          floatingActionButtonTheme: const FloatingActionButtonThemeData(
            backgroundColor: forest,
            foregroundColor: cream,
            elevation: 4,
          ),
          bottomNavigationBarTheme: const BottomNavigationBarThemeData(
            backgroundColor: cream,
            selectedItemColor: forest,
            unselectedItemColor: sage,
            type: BottomNavigationBarType.fixed,
            elevation: 0,
          ),
          cardTheme: CardThemeData(
            color: Colors.white,
            surfaceTintColor: Colors.transparent,
            elevation: 0,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          ),
          inputDecorationTheme: InputDecorationTheme(
            filled: true,
            fillColor: cream,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        home: const RootScreen(),
      ),
    );
  }
}
