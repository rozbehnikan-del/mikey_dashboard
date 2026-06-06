import 'package:dio/dio.dart';

import '../../core/telegram/telegram_web_app.dart';
import 'admin_access_model.dart';

class AdminAccessService {
  final Dio _dio;

  AdminAccessService(this._dio);

  Future<AdminAccessModel> checkAccess() async {
    final telegram = TelegramWebApp.instance;
    final user = telegram.user;

    final response = await _dio.post(
      'https://n8nmicky.launchman.xyz/webhook/mikey-admin-me',
      data: {
        'telegram_user_id': user?.id,
        // Development fallback. Remove this fallback before production.
        //'telegram_username': user?.username,
        'telegram_username': user?.username ?? 'RadicalaAI',
        'init_data': telegram.initData,
      },
      options: Options(
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      ),
    );

    if (response.data is! Map<String, dynamic>) {
      throw Exception('Invalid admin access response');
    }

    return AdminAccessModel.fromJson(response.data as Map<String, dynamic>);
  }
}