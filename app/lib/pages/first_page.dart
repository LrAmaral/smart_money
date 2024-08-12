import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_money/widgets/custom_button.dart';

class FirstPage extends StatefulWidget {
  const FirstPage({super.key});

  @override
  _FirstPageState createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.75,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Image(
                width: 250, image: AssetImage('assets/images/logo.png')),
            const SizedBox(height: 96),
            const Text(
              'Seu controle financeiro  na palma da mão',
              style: TextStyle(fontSize: 24),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 96),
            CustomButton(
              text: 'Acessar',
              onPressed: () {
                context.go('/login');
              },
            ),
            const SizedBox(height: 60),
          ],
        ),
      )),
    );
  }
}
