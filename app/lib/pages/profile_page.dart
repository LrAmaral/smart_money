import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_money/controller/auth_controller.dart';
import 'package:smart_money/widgets/custom_input.dart';
import 'package:smart_money/widgets/custom_button.dart';

class ProfilePage extends StatelessWidget {
  final AuthController authController = Get.find<AuthController>();

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
                const SizedBox(height: 140),
                CustomButton(
                  text: 'Alterar Dados',
                  onPressed: () {
                    context.push('/edit_profile');
                  },
                  size: const Size(100, 52),
                ),
                const SizedBox(height: 24),
                CustomButton(
                  text: "Sair do Aplicativo",
                  onPressed: () {
                    authController.clearAuthData();
                    context.go('/login');
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
