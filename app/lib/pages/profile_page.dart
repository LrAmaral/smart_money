import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_money/widgets/custom_button.dart';
import 'package:smart_money/widgets/custom_input.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 52.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const SizedBox(height: 60),
              const Image(
                  width: 200, image: AssetImage('assets/images/logo.png')),
              const SizedBox(height: 64),
              CustomInput(
                labelText: 'antonio.dourado@gmail.com',
                controller: emailController,
              ),
              const SizedBox(height: 16),
              CustomInput(
                labelText: 'Antonio Dourado',
                controller: passwordController,
                obscureText: true,
              ),
              const SizedBox(height: 260),
              CustomButton(
                text: 'Alterar Dados',
                onPressed: () {
                  context.go('/edit_profile');
                },
                size: const Size(100, 52),
              ),
              const SizedBox(height: 24),
              CustomButton(
                text: "Sair do Aplicativo",
                onPressed: () {},
                buttonColor: colorScheme.error,
                size: const Size(100, 52),
              ),
              const SizedBox(height: 60),
            ],
          ),
        ),
      ),
    );
  }
}
