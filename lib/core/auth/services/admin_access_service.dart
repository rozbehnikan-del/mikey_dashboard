import 'package:dio/dio.dart';

import '../../config/project_config.dart';
import '../models/admin_access_model.dart';
import '../telegram/telegram_context.dart';

class AdminAccessService {
  final Dio _dio;
  final ApiEndpoints _apiEndpoints;
  final TelegramContext _telegramContext;

  AdminAccessService(
    this._dio,
    ProjectConfig project, {
    required TelegramContext telegramContext,
  }) : _apiEndpoints = project.apiEndpoints,
       _telegramContext = telegramContext;

  Future<AdminAccessModel> checkAccess() async {
    final user = _telegramContext.user;

    final response = await _dio.post(
      _apiEndpoints.adminMe,
      data: {
        'telegram_user_id': user?.id,
        'telegram_username': user?.username,
        'init_data': _telegramContext.initData,
      },
    );

    final data = response.data;

    if (data is! Map<String, dynamic>) {
      throw Exception('Invalid admin access response');
    }

    return AdminAccessModel.fromJson(data).withFallback(
      telegramUserId: user?.id,
      telegramUsername: user?.username,
    );
  }
}
