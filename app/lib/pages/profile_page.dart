import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_money/controller/auth_controller.dart';
import 'package:smart_money/services/user_service.dart';
import 'package:smart_money/widgets/custom_input.dart';
import 'package:smart_money/widgets/custom_button.dart';

class ProfilePage extends StatelessWidget {
  final AuthController authController = Get.find<AuthController>();
  final UserService userService = UserService();

  ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 52.0),
          child: Obx(() {
            if (authController.userProfile.isEmpty) {
              return const Center(child: CircularProgressIndicator());
            }

            final userProfile = authController.userProfile;
            final TextEditingController nameController =
                TextEditingController(text: userProfile['name']);
            final TextEditingController emailController =
                TextEditingController(text: userProfile['email']);

            return Column(
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
                  enable: false,
                ),
                const SizedBox(height: 20),
                CustomInput(
                  labelText: 'Nome',
                  controller: nameController,
                  enable: false,
                ),
                const SizedBox(height: 80),
                CustomButton(
                  text: 'Alterar Dados',
                  onPressed: () {
                    context.push('/edit_profile');
                  },
                  size: const Size(100, 52),
                ),
                const SizedBox(height: 20),
                CustomButton(
                  text: "Sair do Aplicativo",
                  onPressed: () {
                    authController.clearAuthData();
                    context.go('/login');
                  },
                  buttonColor: colorScheme.onErrorContainer,
                  size: const Size(100, 52),
                ),
                const SizedBox(height: 20),
                CustomButton(
                  text: "Excluir conta",
                  onPressed: () async {
                    final bool confirmed = await showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Confirmar Exclusão'),
                        content: const Text(
                            'Tem certeza que deseja excluir sua conta?'),
                        actions: <Widget>[
                          TextButton(
                            child: const Text('Cancelar'),
                            onPressed: () {
                              Navigator.of(context).pop(false);
                            },
                          ),
                          TextButton(
                            child: const Text('Confirmar'),
                            onPressed: () {
                              Navigator.of(context).pop(true);
                            },
                          ),
                        ],
                      ),
                    );

                    if (confirmed) {
                      try {
                        await userService.deleteProfile();
                        authController.clearAuthData();
                        context.go('/login');
                      } catch (e) {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Erro'),
                            content: const Text('Erro ao excluir perfil.'),
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
                  },
                  buttonColor: colorScheme.error,
                  size: const Size(100, 52),
                ),
                const SizedBox(height: 60),
              ],
            );
          }),
        ),
      ),
    );
  }
}
