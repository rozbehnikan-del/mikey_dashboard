import 'package:dio/dio.dart';

import 'dashboard_models.dart';

class DashboardService {
  final Dio _dio;

  DashboardService(this._dio);

  Future<DashboardData> fetchDashboard() async {
    final response = await _dio
        .get(
          'https://n8nmicky.launchman.xyz/webhook/mikey-dashboard-summary',
          options: Options(
            headers: {
              'Accept': 'application/json',
            },
          ),
        )
        .timeout(const Duration(seconds: 8));

    if (response.data is! Map<String, dynamic>) {
      throw Exception('Invalid dashboard summary response');
    }

    return DashboardData.fromJson(response.data as Map<String, dynamic>);
  }
}
