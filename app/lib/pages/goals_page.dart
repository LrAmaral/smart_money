import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_money/controller/auth_controller.dart';
import 'package:smart_money/widgets/modal.dart';
import 'package:smart_money/widgets/custom_input.dart';
import 'package:smart_money/widgets/custom_button.dart';
import 'package:smart_money/services/goal_service.dart';
import 'package:smart_money/services/logger_service.dart';

class GoalsPage extends StatefulWidget {
  const GoalsPage({super.key});

  @override
  GoalsPageState createState() => GoalsPageState();
}

class GoalsPageState extends State<GoalsPage> {
  List<Map<String, dynamic>> _goals = [];
  List<Map<String, dynamic>> _filteredGoals = [];
  final logger = LoggerService();
  final GoalService _goalService = GoalService();
  final TextEditingController _searchController = TextEditingController();
  final AuthController authController = Get.put(AuthController());
  String? userId;

  @override
  void initState() {
    super.initState();
    _loadGoals();
    userId = authController.getUserId();
  }

  Future<void> _loadGoals() async {
    try {
      final goals = await _goalService.getGoals();
      logger.info('Metas carregadas: $goals');
      setState(() {
        _goals = goals;
        _filteredGoals = _goals;
      });
    } catch (e) {
      logger.error('Erro ao carregar metas: $e');
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
            double initialValue = double.tryParse(data['Valor Inicial']) ?? 0.0;
            double goalValue = double.tryParse(data['Valor da Meta']) ?? 0.0;

            if (goalValue <= 0) {
              _showErrorDialog('O valor da meta deve ser maior que zero.');
              return;
            }

            if (initialValue > goalValue) {
              _showErrorDialog(
                  'O valor inicial não pode ser maior que o valor da meta.');
              return;
            }

            if (userId != null) {
              final newGoal = {
                'title': data['Nome'],
                'balance': initialValue,
                'amount': goalValue,
                'user_id': userId!.toString(),
              };

              logger.info('Nova Meta: $newGoal');

              try {
                await _goalService.registerGoal(newGoal);
                await _loadGoals();
              } catch (e) {
                logger.error('Erro ao adicionar meta: $e');
                _showErrorDialog('Erro ao adicionar meta. Tente novamente.');
              }
            } else {
              logger
                  .error('User ID é nulo. Não foi possível adicionar a meta.');
              _showErrorDialog(
                  'Erro ao adicionar meta. ID do usuário não encontrado.');
            }
          },
        );
      },
    );
  }

  void _showErrorDialog(String message) {
    Future.delayed(Duration(milliseconds: 100), () {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Erro"),
            content: Text(message),
            actions: [
              TextButton(
                child: const Text("OK"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    });
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
            double initialValue = double.tryParse(data['Valor Inicial']) ?? 0.0;
            double goalValue = double.tryParse(data['Valor da Meta']) ?? 0.0;

            if (goalValue <= 0) {
              _showErrorDialog('O valor da meta deve ser maior que zero.');
              return;
            }

            if (initialValue < 0) {
              _showErrorDialog('O valor inicial não pode ser negativo.');
              return;
            }

            if (initialValue > goalValue) {
              _showErrorDialog(
                  'O valor inicial não pode ser maior que o valor da meta.');
              return;
            }

            final updatedGoal = {
              'title': data['Nome'],
              'balance': initialValue,
              'amount': goalValue,
              'user_id': userId!.toString(),
            };

            try {
              await _goalService.editGoal(goal['id'], updatedGoal);
              await _loadGoals();
            } catch (e) {
              logger.error('Erro ao atualizar meta: $e');
              _showErrorDialog('Erro ao atualizar meta. Tente novamente.');
            }
          },
          onDelete: () async {
            try {
              await _goalService.deleteGoal(goal['id']);
              await _loadGoals();
            } catch (e) {
              logger.error('Erro ao excluir meta: $e');
              _showErrorDialog('Erro ao excluir meta. Tente novamente.');
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
            double amountToAdd = double.tryParse(data['Valor']) ?? 0.0;

            if (amountToAdd <= 0) {
              _showErrorDialog('O valor a ser adicionado deve ser positivo.');
              return;
            }

            final updatedGoal = {
              'title': goal['title'],
              'balance': goal['balance'] + amountToAdd,
              'amount': goal['amount'],
              'user_id': userId!.toString(),
            };

            try {
              await _goalService.editGoal(goal['id'], updatedGoal);
              await _loadGoals();
            } catch (e) {
              logger.error('Erro ao adicionar saldo: $e');
              _showErrorDialog('Erro ao adicionar saldo. Tente novamente.');
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
                        final progressLimit = progress > 100 ? 100 : progress;
                        // if (progressLimit >= 100) {
                        //   Future.delayed(Duration.zero, () {
                        //     showDialog(
                        //       context: context,
                        //       builder: (BuildContext context) {
                        //         return AlertDialog(
                        //           title: const Text('Parabéns!'),
                        //           content: Text(
                        //               'Você atingiu 100% da sua meta "${goal['title']}"!'),
                        //           actions: <Widget>[
                        //             TextButton(
                        //               child: const Text('OK'),
                        //               onPressed: () {
                        //                 Navigator.of(context).pop();
                        //               },
                        //             ),
                        //           ],
                        //         );
                        //       },
                        //     );
                        //   });
                        // }
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
                                            value: progressLimit / 100,
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
                                        '${progressLimit.toStringAsFixed(0)}%',
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
