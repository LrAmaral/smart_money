import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_money/controller/dashboard_controller.dart';
import '../widgets/info_card.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final DashboardController dashboardController =
        Get.put(DashboardController());

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Obx(() {
            if (dashboardController.isLoading.value) {
              return const Center(child: CircularProgressIndicator());
            } else if (dashboardController.hasError.value) {
              return const Center(child: Text('Error loading data'));
            } else if (dashboardController.dashboardData.isEmpty) {
              return const Center(child: Text('No data available'));
            } else {
              var data = dashboardController.dashboardData;
              var user = data['user'] ?? {'name': 'Usuário'};
              double balance = data['dashboard']['balance']?.toDouble() ?? 0.0;
              int transactionsTotal =
                  data['dashboard']['transactionsTotal'] ?? 0;
              int goalsTotal = data['dashboard']['goalsTotal'] ?? 0;

              return Column(
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
              );
            }
          }),
        ),
      ),
    );
  }
}
