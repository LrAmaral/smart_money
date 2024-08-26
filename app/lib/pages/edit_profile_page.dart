import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_money/controller/auth_controller.dart';
import 'package:smart_money/model/edit_user.dart';
import 'package:smart_money/services/logger_service.dart';
import 'package:smart_money/services/user_service.dart';
import 'package:smart_money/widgets/custom_input.dart';
import 'package:smart_money/widgets/custom_button.dart';
import 'package:validators/validators.dart' as validators;

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  EditProfilePageState createState() => EditProfilePageState();
}

class EditProfilePageState extends State<EditProfilePage> {
  final AuthController authController = Get.find<AuthController>();
  final UserService userService = UserService();
  final logger = LoggerService();

  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController newPasswordController;
  late TextEditingController confirmPasswordController;

  late String id;

  @override
  void initState() {
    super.initState();
    id = authController.getUserId();

    final userProfile = authController.userProfile;
    nameController = TextEditingController(text: userProfile['name']);
    emailController = TextEditingController(text: userProfile['email']);
    newPasswordController = TextEditingController();
    confirmPasswordController = TextEditingController();
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  void handleEditProfile(BuildContext context) async {
    final name = nameController.text;
    final email = emailController.text.trim().toLowerCase();
    final password = newPasswordController.text.trim();
    final confirmPassword = confirmPasswordController.text.trim();

    if (!validators.isEmail(email)) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Erro'),
          content: const Text('O email fornecido não é válido.'),
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
      return;
    }

    if (password.isEmpty || password == confirmPassword) {
      try {
        final user = EditUser(
          email: email,
          name: name,
          password: password.isNotEmpty ? password : null,
        );

        final userMap = user.toEditJson();

        print(userMap);

        if (context.mounted) {
          await userService.editProfile(userMap);
          authController.setUserProfile(userMap);
          context.pop();
        } else {
          logger.error('Nenhuma informação foi alterada.');
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Aviso'),
              content: const Text('Nenhuma informação foi alterada.'),
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
        if (context.mounted) {
          logger.error('Erro ao salvar alterações', error: e);
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Erro'),
              content: Text(e.toString()),
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
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Erro'),
          content: const Text('Senhas não correspondem.'),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 52.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const SizedBox(height: 100),
              const Image(
                width: 200,
                image: AssetImage('assets/images/logo.png'),
              ),
              const SizedBox(height: 80),
              CustomInput(
                labelText: 'Email',
                controller: emailController,
                enable: true,
              ),
              const SizedBox(height: 20),
              CustomInput(
                labelText: 'Nome',
                controller: nameController,
                enable: true,
              ),
              const SizedBox(height: 20),
              CustomInput(
                labelText: 'Nova Senha',
                controller: newPasswordController,
                obscureText: true,
              ),
              const SizedBox(height: 20),
              CustomInput(
                labelText: 'Confirme a Nova Senha',
                controller: confirmPasswordController,
                obscureText: true,
              ),
              const SizedBox(height: 80),
              CustomButton(
                text: 'Salvar Alterações',
                onPressed: () => handleEditProfile(context),
                size: const Size(100, 52),
              ),
              const SizedBox(height: 24),
              CustomButton(
                text: 'Cancelar',
                onPressed: () => context.pop(),
                buttonColor: Theme.of(context).colorScheme.error,
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
