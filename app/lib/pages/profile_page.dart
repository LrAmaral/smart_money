import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_money/widgets/custom_button.dart';
import 'package:smart_money/widgets/custom_input.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage ({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      // appBar: AppBar(
      //   leading: IconButton(
      //     icon: Icon(Icons.arrow_back, color: colorScheme.primary),
      //     onPressed: () {
      //       context.go('/');
      //     },
      //   ),
      // ),
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 52.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const SizedBox(height: 30),
              Text(
                'Login',
                style: TextStyle(fontSize: 24, color: colorScheme.primary),
              ),
              const SizedBox(height: 28),
              const Image(
                  width: 200, image: AssetImage('assets/images/logo.png')),
              const SizedBox(height: 64),
              CustomInput(
                labelText: 'Nome de usuário',
                controller: emailController,
              ),
              const SizedBox(height: 16),
              CustomInput(
                labelText: 'Senha',
                controller: passwordController,
                obscureText: true,
              ),
              const SizedBox(height: 48),
              CustomButton(
                text: 'Alterar Dados',
                onPressed: () {
                  context.go('');
                },
              ),
                  CustomButton(
                    text: "Sair do Aplicativo",
                    onPressed: () {},
                    buttonColor: colorScheme.error,
                  ),
              const SizedBox(height: 60),
            ],
          ),
        ),
      ),
    );
  }
}
