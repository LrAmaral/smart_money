import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_money/api/edit_user.dart';
import 'package:smart_money/widgets/custom_input.dart';
import 'package:smart_money/services/user_service.dart';
import 'package:smart_money/widgets/custom_button.dart';
import 'package:smart_money/services/logger_service.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({Key? key}) : super(key: key);

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late TextEditingController emailController;
  late TextEditingController nameController;
  late TextEditingController newPasswordController;
  late TextEditingController confirmPasswordController;
  late String id;
  final UserService userService = UserService();
  final logger = LoggerService();
  bool _isDataLoaded = false;

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController();
    nameController = TextEditingController();
    newPasswordController = TextEditingController();
    confirmPasswordController = TextEditingController();
    loadUserData();
  }

  Future<void> loadUserData() async {
    try {
      final userData = await userService.getProfile();

      if (userData != null) {
        setState(() {
          id = userData['id'] ?? '';
          emailController.text = userData['email'] ?? '';
          nameController.text = userData['name'] ?? '';
          _isDataLoaded = true;
        });
      } else {
        logger.error('Os dados do usuário não puderam ser carregados.');
      }
    } catch (e) {
      logger.error('Erro ao carregar dados do usuário', error: e);
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    nameController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  void handleEditProfile() async {
    final name = nameController.text;
    final email = emailController.text;
    final password = newPasswordController.text;
    final confirmPassword = confirmPasswordController.text;
    final userId = id;

    if (password.isEmpty || password == confirmPassword) {
      try {
        final user = EditUser(
          email: email,
          name: name,
          password: password.isNotEmpty ? password : null,
        );

        final userMap = user.toEditJson();

        if (userMap.isNotEmpty) {
          await userService.editProfile(userMap, userId);
          context.pop();
        } else {
          logger.error('Nenhuma informação foi alterada.');
        }
      } catch (e) {
        logger.error(e);
      }
    } else {
      logger.error('Senhas não correspondem');
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
            context.pop();
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
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 64),
              if (_isDataLoaded) ...[
                CustomInput(
                  labelText: 'Email',
                  controller: emailController,
                ),
                const SizedBox(height: 16),
                CustomInput(
                  labelText: 'Nome',
                  controller: nameController,
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
                const SizedBox(height: 160),
                CustomButton(
                  text: 'Salvar',
                  onPressed: handleEditProfile,
                  size: const Size(100, 52),
                ),
              ] else ...[
                const Center(
                    child:
                        CircularProgressIndicator()), // Indicador de carregamento
              ],
              const SizedBox(height: 60),
            ],
          ),
        ),
      ),
    );
  }
}
