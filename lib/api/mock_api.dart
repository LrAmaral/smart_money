import 'dart:async';

var mockResponseApi = {
  "user": {
    "name": "Dourado",
    "email": "dourado@gmail.com",
  },
  "dashboard": {
    "balance": 1412.00,
    "transactions": 30,
    "goals": 4,
  }
};

Future<Map<String, dynamic>> fetchDashboardData() async {
  return Future.delayed(const Duration(seconds: 1), () => mockResponseApi);
}
