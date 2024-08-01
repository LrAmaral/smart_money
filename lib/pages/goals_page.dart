import 'package:flutter/material.dart';
import 'package:smart_money/widgets/custom_button.dart';

class GoalsPage extends StatefulWidget {
  const GoalsPage({Key? key}) : super(key: key);

  @override
  _GoalsPageState createState() => _GoalsPageState();
}

class _GoalsPageState extends State<GoalsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: <Widget>[
            Image.asset(
              'assets/images/logo.png',
              height: 40,
            ),
            const SizedBox(width: 16),
            CustomButton(text: 'Adicionar meta', onPressed:() {})
          ],
        ),
        backgroundColor: Colors.blue,
      ),
      body: const Center(
        child: SizedBox(
          child: Column(
            children: <Widget>[],
          ),
        ),
      ),
    );
  }
}
