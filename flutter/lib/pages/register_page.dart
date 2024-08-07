import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_money/widgets/custom_button.dart';
import 'package:smart_money/widgets/custom_input.dart';
import 'package:smart_money/services/user_register_service.dart';
import 'package:smart_money/api/register_user.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  final UserService userService = UserService();

  void handleUserRegister() async {
    final name = nameController.text;
    final email = emailController.text;
    final password = passwordController.text;
    final confirmPassword = confirmPasswordController.text;

    if (password == confirmPassword) {
      try {
        final user = UserRegister(email: email, name: name, password: password);
        await userService.registerUser(user);
        context.go('/login');
      } catch (e) {
        print(e);
      }
    } else {
      print('Senhas não correspondem');
    }
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

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
              Text(
                'Cadastrar',
                style: TextStyle(fontSize: 28, color: colorScheme.primary),
              ),
              const SizedBox(height: 50),
              CustomInput(
                labelText: 'Nome',
                controller: nameController,
              ),
              const SizedBox(height: 16),
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
              const SizedBox(height: 16),
              CustomInput(
                labelText: 'Confirmar Senha',
                controller: confirmPasswordController,
                obscureText: true,
              ),
              const SizedBox(height: 56),
              CustomButton(
                text: 'Cadastrar',
                onPressed: handleUserRegister,
              ),
              const SizedBox(height: 16),
              InkWell(
                onTap: () {
                  context.go('/login');
                },
                child: RichText(
                  text: TextSpan(
                    text: 'Já possui uma conta? ',
                    style:
                        TextStyle(fontSize: 14, color: colorScheme.onPrimary),
                    children: <TextSpan>[
                      TextSpan(
                        text: 'Acesse',
                        style:
                            TextStyle(color: colorScheme.primary, fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }
}
