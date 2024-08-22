import 'package:flutter/material.dart';
import 'package:smart_money/services/goal_service.dart';
import 'package:smart_money/widgets/custom_button.dart';
import 'package:smart_money/widgets/custom_input.dart';
import 'package:smart_money/widgets/modal.dart';

class GoalsPage extends StatefulWidget {
  const GoalsPage({super.key});

  @override
  GoalsPageState createState() => GoalsPageState();
}

class GoalsPageState extends State<GoalsPage> {
  List<Map<String, dynamic>> _goals = [];
  List<Map<String, dynamic>> _filteredGoals = [];
  final TextEditingController _searchController = TextEditingController();
  final GoalService _goalService = GoalService();
  String? _userId;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final userData = await _goalService.getData();
    print('Dados do usuário carregados: $userData');

    setState(() {
      _userId = userData['sub'];
      print('User ID carregado: $_userId');
    });

    if (_userId != null) {
      _loadGoals();
    } else {
      print('User ID é nulo. Não foi possível carregar metas.');
    }
  }

  Future<void> _loadGoals() async {
    if (_userId == null) return;

    try {
      final goals = await _goalService.getGoals();
      print('Metas carregadas: $goals');
      setState(() {
        _goals = goals;
        _filteredGoals = _goals;
      });
    } catch (e) {
      print('Erro ao carregar metas: $e');
    }
  }

  void _showAddGoalModal() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Modal(
          textButton: "Adicionar",
          title: "Adicionar Meta",
          fields: const [
            {'label': 'Nome', 'type': 'text'},
            {'label': 'Valor Inicial', 'type': 'number'},
            {'label': 'Valor da Meta', 'type': 'number'}
          ],
          onConfirm: (data) async {
            if (_userId != null) {
              final newGoal = {
                'title': data['Nome'],
                'balance': double.parse(data['Valor Inicial']),
                'amount': double.parse(data['Valor da Meta']),
                'user_id': _userId!.toString(),
              };

              print('Nova Meta: $newGoal');

              try {
                await _goalService.registerGoal(newGoal);
                await _loadGoals();
              } catch (e) {
                print('Erro ao adicionar meta: $e');
              }
            } else {
              print('User ID é nulo. Não foi possível adicionar a meta.');
            }
          },
        );
      },
    );
  }

  void _showEditGoalModal(Map<String, dynamic> goal) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Modal(
          textButton: "Atualizar",
          title: "Editar Meta",
          fields: [
            {
              'label': 'Nome',
              'value': goal['title'],
              'type': 'text',
            },
            {
              'label': 'Valor Inicial',
              'value': goal['balance'].toString(),
              'type': 'number',
            },
            {
              'label': 'Valor da Meta',
              'value': goal['amount'].toString(),
              'type': 'number',
            },
          ],
          onConfirm: (data) async {
            final updatedGoal = {
              'title': data['Nome'],
              'balance': double.parse(data['Valor Inicial']),
              'amount': double.parse(data['Valor da Meta']),
              'user_id': _userId!.toString(),
            };

            try {
              await _goalService.editGoal(goal['id'], updatedGoal);
              await _loadGoals();
            } catch (e) {
              print('Erro ao atualizar meta: $e');
            }
          },
          onDelete: () async {
            try {
              await _goalService.deleteGoal(goal['id']);
              await _loadGoals();
            } catch (e) {
              print('Erro ao excluir meta: $e');
            }
          },
        );
      },
    );
  }

  void _showAddBalanceModal(Map<String, dynamic> goal) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Modal(
          textButton: "Adicionar",
          title: "Adicionar Saldo",
          fields: const [
            {'label': 'Valor', 'type': 'number'}
          ],
          onConfirm: (data) async {
            final amountToAdd = double.parse(data['Valor']);

            if (amountToAdd <= 0) {
              print('O valor a ser adicionado deve ser positivo.');
              return;
            }

            final updatedGoal = {
              'title': goal['title'],
              'balance': goal['balance'] + amountToAdd,
              'amount': goal['amount'],
              'user_id': _userId!.toString(),
            };

            try {
              await _goalService.editGoal(goal['id'], updatedGoal);
              await _loadGoals();
            } catch (e) {
              print('Erro ao adicionar saldo: $e');
            }
          },
        );
      },
    );
  }

  void _onSearchButtonPressed() {
    final searchTerm = _searchController.text.toLowerCase();
    setState(() {
      _filteredGoals = _goals.where((goal) {
        final title = goal['title'].toLowerCase();
        return title.contains(searchTerm);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: colorScheme.background,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Image.asset(
              'assets/images/logo.png',
              height: 40,
            ),
            Column(
              children: [
                const SizedBox(height: 16),
                CustomButton(
                  text: 'Adicionar meta',
                  size: const Size(100, 36),
                  showArrowIcon: false,
                  textSize: 12,
                  onPressed: _showAddGoalModal,
                ),
              ],
            )
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
                        final progress =
                            (goal['balance'] / goal['amount']) * 100;

                        return GestureDetector(
                          onTap: () {
                            _showEditGoalModal(goal);
                          },
                          child: Card(
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
                                        goal['title'],
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          _showAddBalanceModal(goal);
                                        },
                                        child: Icon(
                                          Icons.add,
                                          color: colorScheme.primary,
                                          size: 28,
                                        ),
                                      )
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    children: <Widget>[
                                      Expanded(
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(8),
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
                                    'Saldo: ${goal['balance'].toStringAsFixed(2)}',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: colorScheme.onBackground,
                                    ),
                                  ),
                                  Text(
                                    'Meta: ${goal['amount'].toStringAsFixed(2)}',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: colorScheme.onBackground,
                                    ),
                                  ),
                                ],
                              ),
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
