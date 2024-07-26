import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            context.go('/home');
          },
          child: const Text('Login'),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF1CA477),
          ),
        ),
      ),
    );
  }
}
