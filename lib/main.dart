import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_money/pages/first_page.dart';
import 'pages/login_page.dart';
import 'pages/home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final GoRouter _router = GoRouter(
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const LoginPage(),
        ),
        GoRoute(
          path: '/home',
          builder: (context, state) => const HomePage(),
        ),
        GoRoute(
          path: '/extract',
          builder: (context, state) => const HomePage(),
        ),
        GoRoute(
          path: '/goals',
          builder: (context, state) => const HomePage(),
        ),
        GoRoute(
          path: '/profile',
          builder: (context, state) => const HomePage(),
        ),
      ],
    );

    final ColorScheme colorScheme = ColorScheme(
      primary: const Color(0xFF1CA477),
      primaryContainer: const Color(0xFF1CA477).withOpacity(0.1),
      secondary: const Color(0xFF202024),
      secondaryContainer: const Color(0xFF202024).withOpacity(0.1),
      surface: const Color(0xFF121214),
      background: const Color(0xFF121214),
      error: Colors.red,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: Colors.white,
      onBackground: Colors.white,
      onError: Colors.white,
      brightness: Brightness.dark,
    );

    return MaterialApp.router(
      routerConfig: _router,
      title: 'Smart Money',
      theme: ThemeData(
        colorScheme: colorScheme,
        useMaterial3: true,
        scaffoldBackgroundColor: colorScheme.background,
        appBarTheme: AppBarTheme(
          backgroundColor: colorScheme.surface,
          iconTheme: IconThemeData(color: colorScheme.onSurface),
          titleTextStyle: TextStyle(color: colorScheme.onSurface),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: colorScheme.primary,
            foregroundColor: colorScheme.onPrimary,
          ),
        ),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: colorScheme.surface,
          selectedItemColor: colorScheme.primary,
          unselectedItemColor: Colors.grey,
        ),
        textTheme: TextTheme(
          bodyLarge: TextStyle(color: colorScheme.onBackground),
          bodyMedium: TextStyle(color: colorScheme.onBackground),
          headlineLarge: TextStyle(color: colorScheme.onBackground),
          headlineMedium: TextStyle(color: colorScheme.onBackground),
          headlineSmall: TextStyle(color: colorScheme.onBackground),
        ),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
