import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_money/controller/auth_controller.dart';
import 'package:smart_money/controller/form_controller.dart';
import 'package:smart_money/utils/number_format.dart';
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
  final logger = LoggerService();
  final GoalService _goalService = GoalService();
  final AuthController authController = Get.put(AuthController());
  final FormController formController = Get.put(FormController());

  String? userId;
  List<Map<String, dynamic>> _goals = [];
  List<Map<String, dynamic>> _filteredGoals = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadGoals();
    userId = authController.getUserId();
    formController.clearErrorMessage();
  }

  Future<void> _loadGoals() async {
    try {
      final goals = await _goalService.getGoals();
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
            formController.clearErrorMessage();
            if (userId != null) {
              if (data['Nome'].toString().trim().isEmpty) {
                formController
                    .setErrorMessage('O nome da meta não pode ser vazio.');
                return;
              }

              double initialValue;
              double goalValue;

              try {
                initialValue = double.parse(data['Valor Inicial']);
                goalValue = double.parse(data['Valor da Meta']);
              } catch (e) {
                formController
                    .setErrorMessage('Os valores devem ser números válidos.');
                return;
              }

              if (initialValue < 0 || goalValue <= 0) {
                formController
                    .setErrorMessage('Os valores devem ser maiores que zero.');
                return;
              }

              if (initialValue > goalValue) {
                formController.setErrorMessage(
                    'O valor inicial não pode ser maior que o valor da meta.');
                return;
              }

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
                formController.setErrorMessage(
                    'Erro ao adicionar meta. Tente novamente.');
              }
            } else {
              logger
                  .error('User ID é nulo. Não foi possível adicionar a meta.');
              formController.setErrorMessage(
                  'Erro de autenticação. Tente fazer login novamente.');
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
            formController.clearErrorMessage();
            if (data['Nome'].toString().trim().isEmpty) {
              formController
                  .setErrorMessage('O nome da meta não pode ser vazio.');
              return;
            }

            double initialValue;
            double goalValue;

            try {
              initialValue = double.parse(data['Valor Inicial']);
              goalValue = double.parse(data['Valor da Meta']);
            } catch (e) {
              formController
                  .setErrorMessage('Os valores devem ser números válidos.');
              return;
            }

            if (initialValue < 0 || goalValue <= 0) {
              formController
                  .setErrorMessage('Os valores devem ser maiores que zero.');
              return;
            }

            if (initialValue > goalValue) {
              formController.setErrorMessage(
                'O valor inicial não pode ser maior que o valor da meta.',
              );
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
              formController
                  .setErrorMessage('Erro ao atualizar meta. Tente novamente.');
            }
          },
          onDelete: () async {
            try {
              await _goalService.deleteGoal(goal['id']);
              await _loadGoals();
            } catch (e) {
              logger.error('Erro ao excluir meta: $e');
              formController
                  .setErrorMessage('Erro ao excluir meta. Tente novamente.');
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
            formController.clearErrorMessage();
            double amountToAdd;

            try {
              amountToAdd = double.parse(data['Valor']);
            } catch (e) {
              formController
                  .setErrorMessage('O valor deve ser um número válido.');
              return;
            }

            if (amountToAdd <= 0) {
              formController.setErrorMessage(
                  'O valor a ser adicionado deve ser positivo.');
              return;
            }

            if (goal['balance'] + amountToAdd > goal['amount']) {
              formController.setErrorMessage(
                  'O valor adicionado excede o valor da meta.');
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
              formController
                  .setErrorMessage('Erro ao adicionar saldo. Tente novamente.');
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
                                    'Saldo: ${currencyFormatter.format(goal['balance'])}',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: colorScheme.onBackground,
                                    ),
                                  ),
                                  Text(
                                    'Meta:  ${currencyFormatter.format(goal['amount'])}',
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
