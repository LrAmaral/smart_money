import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_money/controller/auth_controller.dart';
import 'package:smart_money/services/user_service.dart';
import 'package:smart_money/widgets/custom_button.dart';
import 'package:smart_money/widgets/custom_input.dart';

class EditPasswordPage extends StatefulWidget {
  const EditPasswordPage({super.key});

  @override
  EditPasswordPageState createState() => EditPasswordPageState();
}

class EditPasswordPageState extends State<EditPasswordPage> {
  final AuthController authController = Get.find<AuthController>();
  final UserService userService = UserService();

  late TextEditingController emailController;
  late TextEditingController newPasswordController;
  late TextEditingController confirmPasswordController;

  @override
  void initState() {
    super.initState();

    emailController =
        TextEditingController(text: authController.userProfile['email']);
    newPasswordController = TextEditingController();
    confirmPasswordController = TextEditingController();
  }

  @override
  void dispose() {
    emailController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  void showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Erro'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void showSuccessDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Sucesso'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
                context.go('/login');
              },
            ),
          ],
        );
      },
    );
  }

  void handleChangePassword() async {
    final email = emailController.text;
    final newPassword = newPasswordController.text;
    final confirmPassword = confirmPasswordController.text;

    if (newPassword.isEmpty || confirmPassword.isEmpty) {
      showErrorDialog('Os campos de senha não podem estar vazios.');
      return;
    }

    if (newPassword != confirmPassword) {
      showErrorDialog('As senhas não correspondem.');
      return;
    }

    try {
      await userService.editProfileByEmail(email, newPassword);
      if (mounted) {
        showSuccessDialog('Senha alterada com sucesso!');
      }
    } catch (e) {
      if (e.toString().contains('Email não encontrado')) {
        showErrorDialog('O email informado não foi encontrado.');
      } else {
        showErrorDialog('Erro ao alterar a senha.');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF1CA477)),
          onPressed: () {
            context.pop();
          },
        ),
        title: const Text('Alterar Senha',
            style: TextStyle(color: Color(0xFF1CA477))),
      ),
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 52.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const SizedBox(height: 52),
              CustomInput(
                labelText: 'Email',
                controller: emailController,
                enable: true,
              ),
              const SizedBox(height: 16),
              CustomInput(
                labelText: 'Nova Senha',
                controller: newPasswordController,
                obscureText: true,
              ),
              const SizedBox(height: 16),
              CustomInput(
                labelText: 'Confirmar Nova Senha',
                controller: confirmPasswordController,
                obscureText: true,
              ),
              const SizedBox(height: 56),
              CustomButton(
                text: 'Alterar Senha',
                onPressed: handleChangePassword,
              ),
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }
}
