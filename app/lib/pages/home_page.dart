import 'package:flutter/material.dart';
import 'package:smart_money/services/dashboard_service.dart';
import '../widgets/info_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  final DashboardService _dashboardService = DashboardService();
  Map<String, dynamic> _dashboardData = {};
  bool _isLoading = true;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _loadDashboardData();
  }

  void _loadDashboardData() async {
    try {
      final data = await _dashboardService.getData();
      setState(() {
        _dashboardData = data;
        _isLoading = false;
        _hasError = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _hasError = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_hasError) {
      return const Scaffold(
        body: Center(child: Text('Error loading data')),
      );
    }

    final user = _dashboardData['user'] ?? {'name': 'Usuário'};
    final double balance =
        _dashboardData['dashboard']['balance']?.toDouble() ?? 0.0;
    final int transactionsTotal =
        _dashboardData['dashboard']['transactionsTotal'] ?? 0;
    final int goalsTotal = _dashboardData['dashboard']['goalsTotal'] ?? 0;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const SizedBox(height: 40),
              Center(
                child: Column(
                  children: [
                    const Image(
                      width: 200,
                      image: AssetImage('assets/images/logo.png'),
                    ),
                    const SizedBox(height: 52),
                    Text(
                      'Seja bem vindo, ${user['name']}!',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 52),
              InfoCard(
                title: 'Saldo Geral',
                subtitle: 'Últimos 30 dias',
                value: 'R\$ ${balance.toStringAsFixed(2)}',
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: InfoCard(
                      title: 'Transações',
                      subtitle: 'Últimos 30 dias',
                      value: transactionsTotal.toString(),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: InfoCard(
                      title: 'Metas',
                      subtitle: 'Total',
                      value: goalsTotal.toString(),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
