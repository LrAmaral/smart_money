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
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: <Widget>[
            Image.asset(
              'assets/images/logo.png',
              height: 48,
            ),
            const SizedBox(width: 16),
            CustomButton(text: 'Adicionar meta', onPressed: () {})
          ],
        ),
      ),
      body: const Center(
        child: SizedBox(
          child: Column(
            children: <Widget>[
              Text(
                'Metas',
                style: TextStyle(fontSize: 24),
              )
            ],
          ),
        ),
      ),
    );
  }
}
