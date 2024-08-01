import 'package:flutter/material.dart';
import '../api/mock_api.dart';
import '../widgets/info_card.dart';
import '../utils/bottom_navbar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<Map<String, dynamic>> _dashboardData;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _dashboardData = fetchDashboardData();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: FutureBuilder<Map<String, dynamic>>(
            future: _dashboardData,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return const Center(child: Text('Error loading data'));
              } else if (!snapshot.hasData) {
                return const Center(child: Text('No data available'));
              } else {
                var data = snapshot.data!;
                var user = data['user'];
                var dashboard = data['dashboard'];
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
                      value: 'R\$ ${dashboard['balance'].toStringAsFixed(2)}',
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: InfoCard(
                            title: 'Transações',
                            subtitle: 'Últimos 30 dias',
                            value: '${dashboard['transactions']}',
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: InfoCard(
                            title: 'Metas',
                            subtitle: 'Total',
                            value: '${dashboard['goals']}',
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              }
            },
          ),
        ),
      ),
      bottomNavigationBar: BottomNavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}
