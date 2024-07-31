import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_money/widgets/custom_button.dart';
import 'package:smart_money/widgets/custom_input.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  @override
  Widget build(BuildContext context) {
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();
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
                controller: emailController,
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
                controller: passwordController,
                obscureText: true,
              ),
              const SizedBox(height: 56),
              CustomButton(
                text: 'Cadastrar',
                onPressed: () {
                  context.go('/home');
                },
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
