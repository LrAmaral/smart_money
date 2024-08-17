import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_money/widgets/custom_input.dart';
import 'package:smart_money/widgets/custom_button.dart';
import 'package:smart_money/services/profile_service.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final ProfileService profileService = ProfileService();
    final userData = profileService.getUserDataFromToken();

    final TextEditingController nameController =
        TextEditingController(text: userData['name']);
    final TextEditingController emailController =
        TextEditingController(text: userData['email']);
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 52.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const SizedBox(height: 60),
              const Image(
                width: 200,
                image: AssetImage('assets/images/logo.png'),
              ),
              const SizedBox(height: 64),
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
              const SizedBox(height: 260),
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
                onPressed: () {},
                buttonColor: colorScheme.error,
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
