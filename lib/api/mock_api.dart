import 'dart:async';

var mockResponseApi = {
  "user": {
    "name": "Dourado",
    "email": "douraro@gmail.com",
  },
  "dashboard": {
    "balance": 4130.00,
    "transactions": 30,
    "goals": 4,
  }
};

Future<Map<String, dynamic>> fetchDashboardData() async {
  return Future.delayed(const Duration(seconds: 2), () => mockResponseApi);
}
