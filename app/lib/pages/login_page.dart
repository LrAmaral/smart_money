import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_money/widgets/custom_button.dart';
import 'package:smart_money/widgets/custom_input.dart';
import 'package:smart_money/services/user_service.dart';
import 'package:smart_money/api/login_user.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();
    final UserService userService = UserService();
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    void handleLogin() async {
      final email = emailController.text;
      final password = passwordController.text;

      try {
        final user = LoginUser(email: email, password: password);
        await userService.login(user);

        if (userService.authController.accessToken.isNotEmpty) {
          context.go('/home');
        } else {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Erro'),
              content: const Text(
                  'Falha ao fazer login. Verifique suas credenciais.'),
              actions: <Widget>[
                TextButton(
                  child: const Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          );
        }
      } catch (e) {
        print('Erro durante o login: $e');
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Erro'),
            content:
                const Text('Falha ao fazer login. Verifique suas credenciais.'),
            actions: <Widget>[
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      }
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: colorScheme.primary),
          onPressed: () {
            context.go('/');
          },
        ),
      ),
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
                labelText: 'Email',
                controller: emailController,
              ),
              const SizedBox(height: 16),
              CustomInput(
                labelText: 'Senha',
                controller: passwordController,
                obscureText: true,
              ),
              const SizedBox(height: 8),
              InkWell(
                onTap: () {
                  context.go('/forgot_password');
                },
                child: const Align(
                  alignment: Alignment.bottomLeft,
                  child: Padding(
                    padding: EdgeInsets.only(left: 0),
                    child: Text(
                      'Esqueceu a senha?',
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 48),
              CustomButton(
                text: 'Login',
                onPressed: handleLogin,
              ),
              const SizedBox(height: 16),
              InkWell(
                onTap: () {
                  context.go('/register');
                },
                child: RichText(
                  text: TextSpan(
                    text: 'Não possui uma conta? ',
                    style:
                        TextStyle(fontSize: 14, color: colorScheme.onPrimary),
                    children: <TextSpan>[
                      TextSpan(
                        text: 'Registre-se',
                        style:
                            TextStyle(color: colorScheme.primary, fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 60),
            ],
          ),
        ),
      ),
    );
  }
}
