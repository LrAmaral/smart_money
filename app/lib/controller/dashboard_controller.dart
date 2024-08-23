import 'package:get/get.dart';
import 'package:smart_money/services/dashboard_service.dart';

class DashboardController extends GetxController {
  var dashboardData = {}.obs;
  var isLoading = true.obs;
  var hasError = false.obs;

  final DashboardService dashboardService = DashboardService();

  @override
  void onInit() {
    super.onInit();
    fetchDashboardData();
  }

  Future<void> fetchDashboardData() async {
    try {
      isLoading.value = true;
      hasError.value = false;

      final data = await dashboardService.getData();
      if (data.isNotEmpty) {
        dashboardData.value = data;
      } else {
        hasError.value = true;
      }
    } catch (e) {
      hasError.value = true;
    } finally {
      isLoading.value = false;
    }
  }

  void refreshData() {
    fetchDashboardData();
  }
}
