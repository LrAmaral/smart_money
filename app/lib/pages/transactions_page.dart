import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_money/controller/auth_controller.dart';
import 'package:smart_money/controller/form_controller.dart';
import 'package:smart_money/services/logger_service.dart';
import 'package:smart_money/utils/number_format.dart';
import 'package:smart_money/widgets/custom_button.dart';
import 'package:smart_money/widgets/custom_input.dart';
import 'package:smart_money/widgets/modal.dart';
import 'package:smart_money/services/transaction_service.dart';
import 'package:smart_money/enums/input_type.dart';

class TransactionsPage extends StatefulWidget {
  const TransactionsPage({super.key});

  @override
  TransactionsPageState createState() => TransactionsPageState();
}

class TransactionsPageState extends State<TransactionsPage> {
  final logger = LoggerService();
  final TransactionService _transactionService = TransactionService();
  final AuthController authController = Get.put(AuthController());
  final FormController formController = Get.put(FormController());

  String? userId;
  bool _isLoading = false;
  List<Map<String, dynamic>> _filteredTransactions = [];
  List<Map<String, dynamic>> _transactions = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadTransactions();
    userId = authController.getUserId();
  }

  Future<void> _loadTransactions() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final transactions = await _transactionService.getTransactions();
      setState(() {
        _transactions = transactions;
        _filteredTransactions = _transactions;
      });
    } catch (e) {
      logger.error('Erro ao carregar transações: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _filterTransactions(String query) {
    setState(() {
      _filteredTransactions = _transactions
          .where((transaction) =>
              transaction['title'].toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  void _onSearchButtonPressed() {
    final query = _searchController.text;
    _filterTransactions(query);
  }

  Future<void> _addTransaction(Map<String, dynamic> data) async {
    formController.clearErrorMessage();
    if (data['Título'].toString().trim().isEmpty) {
      formController.setErrorMessage('O título não pode ser vazio.');
      return;
    }

    double amount;
    try {
      amount = double.parse(data['Valor']);
    } catch (e) {
      formController.setErrorMessage('O valor deve ser um número válido.');
      return;
    }

    if (amount <= 0) {
      formController.setErrorMessage('O valor deve ser maior que zero.');
      return;
    }

    if (data['Categoria'].toString().trim().isEmpty) {
      formController.setErrorMessage('A categoria não pode ser vazio.');
      return;
    }

    final newTransaction = {
      'user_id': userId.toString(),
      'title': data['Título'],
      'amount': amount,
      'category': data['Categoria'],
      'type': data['Tipo'],
    };

    try {
      await _transactionService.registerTransaction(newTransaction);
      await _loadTransactions();
    } catch (e) {
      logger.error('Erro ao adicionar transação: $e');
      formController
          .setErrorMessage('Erro ao adicionar transação. Tente novamente.');
    }
  }

  Future<void> _editTransaction(String id, Map<String, dynamic> data) async {
    formController.clearErrorMessage();
    if (data['Título'].toString().trim().isEmpty) {
      formController.setErrorMessage('O título não pode ser vazio.');
      return;
    }

    double amount;
    try {
      amount = double.parse(data['Valor']);
    } catch (e) {
      formController.setErrorMessage('O valor deve ser um número válido.');
      return;
    }

    if (amount <= 0) {
      formController.setErrorMessage('O valor deve ser maior que zero.');
      return;
    }

    if (data['Categoria'].toString().trim().isEmpty) {
      formController.setErrorMessage('A categoria não pode ser vazio.');
      return;
    }

    final updatedTransaction = {
      'user_id': userId.toString(),
      'title': data['Título'],
      'amount': amount,
      'category': data['Categoria'],
      'type': data['Tipo'],
    };

    try {
      await _transactionService.editTransaction(id, updatedTransaction);
      await _loadTransactions();
    } catch (e) {
      logger.error('Erro ao editar transação: $e');
      formController
          .setErrorMessage('Erro ao editar transação. Tente novamente.');
    }
  }

  Future<void> _deleteTransaction(String id) async {
    try {
      await _transactionService.deleteTransaction(id);
      await _loadTransactions();
    } catch (e) {
      logger.error('Erro ao excluir transação: $e');
      formController
          .setErrorMessage('Erro ao excluir transação. Tente novamente.');
    }
  }

  void _showAddTransactionModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Modal(
          textButton: 'Adicionar',
          title: 'Nova Transação',
          fields: [
            {'label': 'Título', 'type': ModalInputType.text.type},
            {'label': 'Valor', 'type': ModalInputType.number.type},
            {'label': 'Categoria', 'type': ModalInputType.text.type},
          ],
          onConfirm: (data) async {
            await _addTransaction(data);
          },
          showTransactionTypeButtons: true,
        );
      },
    );
  }

  void _showEditTransactionModal(Map<String, dynamic> transaction) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Modal(
          textButton: "Atualizar",
          title: "Editar Transação",
          fields: [
            {
              'label': 'Título',
              'value': transaction['title'],
              'type': ModalInputType.text.type,
            },
            {
              'label': 'Valor',
              'value': transaction['amount'].toString(),
              'type': ModalInputType.number.type,
            },
            {
              'label': 'Categoria',
              'value': transaction['category'],
              'type': ModalInputType.text.type,
            },
          ],
          onConfirm: (data) async {
            await _editTransaction(transaction['id'], data);
          },
          onDelete: () async {
            await _deleteTransaction(transaction['id']);
          },
          showTransactionTypeButtons: true,
          transactionTypeButtons: transaction['type'],
        );
      },
    );
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
            Column(
              children: [
                const SizedBox(height: 20),
                CustomButton(
                  text: 'Adicionar transação',
                  size: const Size(100, 36),
                  showArrowIcon: false,
                  textSize: 12,
                  onPressed: _showAddTransactionModal,
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
              'Transações',
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
                    labelText: 'Busque uma transação',
                    controller: _searchController,
                    obscureText: false,
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
              child: _isLoading
                  ? Center(
                      child: CircularProgressIndicator(
                        color: colorScheme.primary,
                      ),
                    )
                  : _filteredTransactions.isEmpty
                      ? Center(
                          child: Text(
                            'Nenhuma transação encontrada',
                            style: TextStyle(
                              fontSize: 18,
                              color: colorScheme.onBackground,
                            ),
                          ),
                        )
                      : ListView.builder(
                          itemCount: _filteredTransactions.length,
                          itemBuilder: (context, index) {
                            final transaction = _filteredTransactions[index];
                            final amountColor = transaction['type'] == 'saida'
                                ? colorScheme.error
                                : colorScheme.primary;

                            return GestureDetector(
                              onTap: () {
                                _showEditTransactionModal(transaction);
                              },
                              child: Card(
                                color: colorScheme.secondary,
                                margin: const EdgeInsets.symmetric(vertical: 8),
                                child: Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        transaction['title'],
                                        style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(height: 10),
                                      Row(
                                        children: <Widget>[
                                          Expanded(
                                            child: Text(
                                              currencyFormatter.format(
                                                  transaction['amount']),
                                              style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                                color: amountColor,
                                              ),
                                              softWrap:
                                                  true, // Permite a quebra de linha
                                              overflow: TextOverflow
                                                  .visible, // Garante que o texto não será cortado com reticências
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 10),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Row(
                                            children: [
                                              Icon(
                                                Icons.turned_in_not,
                                                size: 16,
                                                color: colorScheme.onSurface
                                                    .withOpacity(0.6),
                                              ),
                                              const SizedBox(width: 4),
                                              Text(
                                                transaction['category'],
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  color: colorScheme.onSurface
                                                      .withOpacity(0.6),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
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
