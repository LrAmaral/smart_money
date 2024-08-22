import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_money/controller/auth_controller.dart';
import 'package:smart_money/pages/edit_password_page.dart';
import 'package:smart_money/pages/edit_profile_page.dart';
import 'package:smart_money/pages/first_page.dart';
import 'package:smart_money/pages/profile_page.dart';
import 'package:smart_money/pages/register_page.dart';
import 'package:smart_money/pages/login_page.dart';
import 'package:smart_money/layouts/main_layout.dart';
import 'package:smart_money/enums/route_path.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthController authController = Get.put(AuthController());

    final GoRouter _router = GoRouter(
      initialLocation:
          authController.getAccessToken().isNotEmpty ? '/home' : '/login',
      routes: [
        GoRoute(
          path: RoutePath.firstPage.path,
          name: RoutePath.firstPage.name,
          builder: (context, state) => const FirstPage(),
        ),
        GoRoute(
          path: RoutePath.forgotPassword.path,
          name: RoutePath.forgotPassword.name,
          builder: (context, state) => const EditPasswordPage(),
        ),
        GoRoute(
          path: RoutePath.login.path,
          name: RoutePath.login.name,
          builder: (context, state) => const LoginPage(),
        ),
        GoRoute(
          path: RoutePath.register.path,
          name: RoutePath.register.name,
          builder: (context, state) => const RegisterPage(),
        ),
        GoRoute(
          path: RoutePath.home.path,
          name: RoutePath.home.name,
          builder: (context, state) => const MainLayout(),
        ),
        GoRoute(
          path: RoutePath.extract.path,
          name: RoutePath.extract.name,
          builder: (context, state) => const MainLayout(),
        ),
        GoRoute(
          path: RoutePath.goals.path,
          name: RoutePath.goals.name,
          builder: (context, state) => const MainLayout(),
        ),
        GoRoute(
          path: RoutePath.profile.path,
          name: RoutePath.profile.name,
          builder: (context, state) => ProfilePage(),
        ),
        GoRoute(
          path: RoutePath.editProfile.path,
          name: RoutePath.editProfile.name,
          builder: (context, state) => const EditProfilePage(),
        ),
        GoRoute(
          path: RoutePath.logout.path,
          name: RoutePath.logout.name,
          builder: (context, state) => const FirstPage(),
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
      onSurface: const Color.fromARGB(255, 216, 216, 216),
      onBackground: Colors.white,
      onError: Colors.white,
      surfaceTint: const Color(0xFF646464),
      brightness: Brightness.dark,
      surfaceVariant: const Color.fromARGB(255, 100, 100, 100),
    );

    return MaterialApp.router(
      routerConfig: _router,
      title: 'Smart Money',
      theme: ThemeData(
        fontFamily: 'DM Sans',
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
