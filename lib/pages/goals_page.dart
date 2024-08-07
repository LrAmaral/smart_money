import 'package:flutter/material.dart';
import 'package:smart_money/widgets/custom_button.dart';
import 'package:smart_money/widgets/custom_input.dart';

class GoalsPage extends StatefulWidget {
  const GoalsPage({super.key});

  @override
  GoalsPageState createState() => GoalsPageState();
}

class GoalsPageState extends State<GoalsPage> {
  final List<Map<String, dynamic>> _goals = [
    {
      'name': 'Pagar Agiota',
      'current': 100.0,
      'goal': 10000.0,
    },
    {
      'name': 'PC Gamer',
      'current': 600.0,
      'goal': 5000.0,
    },
    {
      'name': 'Minha Casa, Minha Vida',
      'current': 1000.0,
      'goal': 100000.0,
    },
    {
      'name': 'Curso de Inglês',
      'current': 250.0,
      'goal': 1500.0,
    },
    {
      'name': 'Viagem para Europa',
      'current': 2000.0,
      'goal': 12000.0,
    },
    {
      'name': 'Novo Carro',
      'current': 5000.0,
      'goal': 30000.0,
    },
    {
      'name': 'Fundo de Emergência',
      'current': 800.0,
      'goal': 5000.0,
    },
    {
      'name': 'Empreendimento Próprio',
      'current': 1500.0,
      'goal': 20000.0,
    },
    {
      'name': 'Compra de Smartphone',
      'current': 200.0,
      'goal': 1000.0,
    },
    {
      'name': 'Economias para Aposentadoria',
      'current': 3000.0,
      'goal': 50000.0,
    }
  ];

  List<Map<String, dynamic>> _filteredGoals = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _filteredGoals = _goals;
  }

  void _filterGoals(String query) {
    setState(() {
      _filteredGoals = _goals
          .where((goal) =>
              goal['name'].toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  void _onSearchButtonPressed() {
    final query = _searchController.text;
    _filterGoals(query);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: colorScheme.background,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Image.asset(
              'assets/images/logo.png',
              height: 40,
            ),
            CustomButton(
              text: 'Adicionar meta',
              size: const Size(100, 36),
              showArrowIcon: false,
              textSize: 12,
              onPressed: () {},
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SizedBox(height: 16),
            Text(
              'Metas',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: colorScheme.onBackground,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: CustomInput(
                    labelText: 'Busque uma meta',
                    controller: _searchController,
                    obscureText: true,
                  ),
                ),
                const SizedBox(width: 16),
                OutlinedButton(
                  onPressed: _onSearchButtonPressed,
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: colorScheme.primary, width: 1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                    padding: const EdgeInsets.all(12),
                  ),
                  child: Icon(
                    Icons.search,
                    color: colorScheme.primary,
                    size: 24,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: _filteredGoals.isEmpty
                  ? Center(
                      child: Text(
                        'Nenhuma meta encontrada',
                        style: TextStyle(
                          fontSize: 18,
                          color: colorScheme.onBackground,
                        ),
                      ),
                    )
                  : ListView.builder(
                      itemCount: _filteredGoals.length,
                      itemBuilder: (context, index) {
                        final goal = _filteredGoals[index];
                        final progress = (goal['current'] / goal['goal']) * 100;

                        return Card(
                          color: colorScheme.secondary,
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text(
                                      goal['name'],
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Icon(
                                      Icons.add,
                                      color: colorScheme.primary,
                                      size: 28,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: <Widget>[
                                    Expanded(
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: LinearProgressIndicator(
                                          minHeight: 10,
                                          value: progress / 100,
                                          backgroundColor: colorScheme.primary
                                              .withOpacity(0.3),
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                  colorScheme.primary),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 8.0),
                                    Text(
                                      '${progress.toStringAsFixed(0)}%',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: colorScheme.onPrimary,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'R\$${goal['current']} - R\$${goal['goal']}',
                                  style: const TextStyle(fontSize: 14),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
