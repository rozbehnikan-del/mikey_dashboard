abstract interface class TelegramContext {
  TelegramUserData? get user;
  String get initData;
  bool get isDarkMode;
}

class TelegramUserData {
  final int id;
  final String? username;
  final String? firstName;
  final String? lastName;

  const TelegramUserData({
    required this.id,
    required this.username,
    required this.firstName,
    required this.lastName,
  });
}
