import 'package:dashboard_core/dashboard_core.dart';

import 'telegram_web_app.dart';

class MikeyTelegramContext implements TelegramContext {
  const MikeyTelegramContext(this._telegramWebApp);

  final TelegramWebApp _telegramWebApp;

  @override
  String get initData => _telegramWebApp.initData;

  @override
  bool get isDarkMode => _telegramWebApp.isDarkMode;

  @override
  TelegramUserData? get user {
    final user = _telegramWebApp.user;
    final id = user?.id;

    if (user == null || id == null) {
      return null;
    }

    return TelegramUserData(
      id: id,
      username: user.username,
      firstName: user.firstName,
      lastName: user.lastName,
    );
  }
}
