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

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF1CA477)),
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
              const Text(
                'Cadastrar',
                style: TextStyle(fontSize: 28, color: Color(0xFF1CA477)),
              ),
              const SizedBox(height: 28),
              const SizedBox(height: 52),
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
                  text: const TextSpan(
                    text: 'Já possui uma conta? ',
                    style: TextStyle(fontSize: 14, color: Colors.white),
                    children: <TextSpan>[
                      TextSpan(
                        text: 'Acesse',
                        style: TextStyle(color: Colors.green, fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 100),
              const Text('Você está completamente seguro.'),
              const SizedBox(height: 4),
              const Text('Read our Terms & Conditions',
                  style: TextStyle(color: Color(0xFF1CA477))),
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }
}
