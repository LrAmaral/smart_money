import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_money/widgets/custom_button.dart';
import 'package:smart_money/widgets/custom_input.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({Key? key}) : super(key: key);

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 52.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const SizedBox(height: 40),
              Text(
                'Dados Cadastrais',
                style: TextStyle(
                    fontSize: 36,
                    color: colorScheme.primary,
                    fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 64),
              CustomInput(
                labelText: 'antonio.dourado@gmail.com',
                controller: emailController,
              ),
              const SizedBox(height: 16),
              CustomInput(
                labelText: 'Antonio Dourado',
                controller: emailController,
              ),
              const SizedBox(height: 16),
              CustomInput(
                labelText: 'Nova Senha',
                controller: emailController,
              ),
              const SizedBox(height: 16),
              CustomInput(
                labelText: 'Confirmar Nova Senha',
                controller: passwordController,
                obscureText: true,
              ),
              const SizedBox(height: 160),
              CustomButton(
                text: 'Salvar',
                onPressed: () {
                  context.go('/profile');
                },
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
