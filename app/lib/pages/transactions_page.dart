import 'package:flutter/material.dart';
import 'package:smart_money/widgets/custom_button.dart';
import 'package:smart_money/widgets/custom_input.dart';
import 'package:smart_money/widgets/modal.dart';

class TransactionsPage extends StatefulWidget {
  const TransactionsPage({super.key});

  @override
  TransactionsPageState createState() => TransactionsPageState();
}

class TransactionsPageState extends State<TransactionsPage> {
  final List<Map<String, dynamic>> _transactions = [
    {
      'title': 'Hamburger',
      'amount': -59.00,
      'category': 'Alimentação',
      'date': '10/04/2022',
    },
    {
      'title': 'Aluguel do apartamento',
      'amount': -1200.00,
      'category': 'Casa',
      'date': '27/03/2022',
    },
    {
      'title': 'Salário',
      'amount': 5400.00,
      'category': 'Salário',
      'date': '15/02/2022',
    },
    {
      'title': 'Desenvolvimento de site',
      'amount': 12000.00,
      'category': 'Venda',
      'date': '13/04/2022',
    },
  ];

  List<Map<String, dynamic>> _filteredTransactions = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _filteredTransactions = _transactions;
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

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _showAddTransactionModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Modal(
          textButton: 'Adicionar',
          title: 'Nova Transação',
          fields: const [
            {'label': 'Título', 'type': 'text'},
            {'label': 'Valor', 'type': 'number'},
            {'label': 'Categoria', 'type': 'text'},
            {'label': 'Data', 'type': 'date'},
          ],
          onConfirm: () {},
          onDelete: () {},
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
              'type': 'text',
            },
            {
              'label': 'Valor',
              'value': transaction['amount'].toString(),
              'type': 'number',
            },
            {
              'label': 'Categoria',
              'value': transaction['category'],
              'type': 'text',
            },
            {
              'label': 'Data',
              'value': transaction['date'],
              'type': 'date',
            },
          ],
          onConfirm: () {},
          onDelete: () {},
        );
      },
    );
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
              text: 'Adicionar transação',
              size: const Size(100, 36),
              showArrowIcon: false,
              textSize: 12,
              onPressed: _showAddTransactionModal,
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
              child: _filteredTransactions.isEmpty
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
                        final isNegative = transaction['amount'] < 0;
                        final amountColor = isNegative
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
                                crossAxisAlignment: CrossAxisAlignment.start,
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
                                      Text(
                                        'R\$ ${transaction['amount'].toStringAsFixed(2)}',
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: amountColor,
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
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.calendar_today,
                                            size: 16,
                                            color: colorScheme.onSurface
                                                .withOpacity(0.6),
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            transaction['date'],
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
