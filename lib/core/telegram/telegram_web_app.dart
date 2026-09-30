import 'dart:convert';
import 'dart:js_interop';

@JS('window.Telegram.WebApp')
external JSObject? get _telegramWebApp;

@JS('window.Telegram.WebView')
external JSObject? get _telegramWebView;

@JS('window.sessionStorage')
external JSObject? get _sessionStorage;

class TelegramUser {
  final int? id;
  final String? firstName;
  final String? lastName;
  final String? username;
  final String? languageCode;

  const TelegramUser({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.username,
    required this.languageCode,
  });

  String get displayName {
    if (firstName != null && firstName!.trim().isNotEmpty) {
      return firstName!;
    }

    if (username != null && username!.trim().isNotEmpty) {
      return '@$username';
    }

    return 'Admin';
  }
}

class TelegramWebApp {
  TelegramWebApp._();

  static final TelegramWebApp instance = TelegramWebApp._();

  JSObject? _webApp;
  String? _launchInitData;
  TelegramUser? _launchUser;

  bool get isAvailable => _webApp != null;

  String? get version {
    try {
      if (_webApp == null) return null;
      return _getString(_webApp!, 'version');
    } catch (_) {
      return null;
    }
  }

  bool get hasInitDataUnsafe {
    try {
      if (_webApp == null) return _launchInitData != null;
      final unsafe = _getProperty(_webApp!, 'initDataUnsafe');
      return unsafe != null || _launchInitData != null;
    } catch (_) {
      return _launchInitData != null;
    }
  }

  bool get hasUnsafeUser {
    try {
      if (_webApp == null) return _launchUser != null;
      final unsafe = _getProperty(_webApp!, 'initDataUnsafe');
      if (unsafe == null) return _launchUser != null;

      final rawUser = _getProperty(unsafe as JSObject, 'user');
      return rawUser != null || _launchUser != null;
    } catch (_) {
      return _launchUser != null;
    }
  }

  void init() {
    try {
      _webApp = _telegramWebApp;
      _captureLaunchData();

      if (_webApp == null) return;

      _call('ready');
      _call('expand');
      _call('disableClosingConfirmation');
    } catch (_) {
      _webApp = null;
    }
  }

  Future<void> waitForLaunchData() async {
    if (initData.isNotEmpty || user != null) return;

    await Future<void>.delayed(Duration.zero);
    init();
  }

  String get colorScheme {
    try {
      if (_webApp == null) return 'light';
      final value = _getProperty(_webApp!, 'colorScheme');
      return value?.toString() ?? 'light';
    } catch (_) {
      return 'light';
    }
  }

  bool get isDarkMode => colorScheme.toLowerCase() == 'dark';

  String get initData {
    try {
      if (_webApp == null) return _launchInitData ?? '';
      final value = _getProperty(_webApp!, 'initData');
      final webAppInitData = value?.toString() ?? '';
      if (webAppInitData.isNotEmpty) return webAppInitData;

      return _launchInitData ?? '';
    } catch (_) {
      return _launchInitData ?? '';
    }
  }

  TelegramUser? get user {
    try {
      if (_webApp == null) return _launchUser;

      final unsafe = _getProperty(_webApp!, 'initDataUnsafe');
      if (unsafe == null) return _launchUser;

      final rawUser = _getProperty(unsafe as JSObject, 'user');
      if (rawUser == null) return _launchUser;

      final userObject = rawUser as JSObject;

      return TelegramUser(
        id: _getInt(userObject, 'id'),
        firstName: _getString(userObject, 'first_name'),
        lastName: _getString(userObject, 'last_name'),
        username: _getString(userObject, 'username'),
        languageCode: _getString(userObject, 'language_code'),
      );
    } catch (_) {
      return _launchUser;
    }
  }

  void hapticImpact() {
    try {
      if (_webApp == null) return;

      final haptic = _getProperty(_webApp!, 'HapticFeedback');
      if (haptic == null) return;

      _callMethod(haptic as JSObject, 'impactOccurred', ['medium']);
    } catch (_) {}
  }

  void hapticSuccess() {
    try {
      if (_webApp == null) return;

      final haptic = _getProperty(_webApp!, 'HapticFeedback');
      if (haptic == null) return;

      _callMethod(haptic as JSObject, 'notificationOccurred', ['success']);
    } catch (_) {}
  }

  void hapticError() {
    try {
      if (_webApp == null) return;

      final haptic = _getProperty(_webApp!, 'HapticFeedback');
      if (haptic == null) return;

      _callMethod(haptic as JSObject, 'notificationOccurred', ['error']);
    } catch (_) {}
  }

  void close() {
    _call('close');
  }

  void _call(String method) {
    try {
      if (_webApp == null) return;
      _callMethod(_webApp!, method, []);
    } catch (_) {}
  }

  String? _getString(JSObject object, String key) {
    try {
      final value = _getProperty(object, key);
      return value?.toString();
    } catch (_) {
      return null;
    }
  }

  int? _getInt(JSObject object, String key) {
    try {
      final value = _getProperty(object, key);
      if (value == null) return null;

      return int.tryParse(value.toString());
    } catch (_) {
      return null;
    }
  }

  void _captureLaunchData() {
    try {
      final launchInitData = _readLaunchInitData();
      if (launchInitData == null || launchInitData.isEmpty) return;

      _launchInitData = launchInitData;
      _launchUser = _parseLaunchUser(launchInitData);
    } catch (_) {}
  }

  String? _readLaunchInitData() {
    final webAppData = _readWebAppData();
    if (webAppData != null && webAppData.isNotEmpty) {
      return webAppData;
    }

    final webViewData = _readWebViewInitData();
    if (webViewData != null && webViewData.isNotEmpty) {
      return webViewData;
    }

    final storedData = _readStoredInitData();
    if (storedData != null && storedData.isNotEmpty) {
      return storedData;
    }

    final fragmentData = _readLaunchValue(Uri.base.fragment);
    if (fragmentData != null && fragmentData.isNotEmpty) {
      return fragmentData;
    }

    final queryData = Uri.base.queryParameters['tgWebAppData'];
    if (queryData != null && queryData.isNotEmpty) {
      return queryData;
    }

    return null;
  }

  String? _readWebAppData() {
    try {
      if (_webApp == null) return null;
      final value = _getProperty(_webApp!, 'initData');
      final initData = value?.toString() ?? '';
      if (initData.isNotEmpty) return initData;
    } catch (_) {}

    return null;
  }

  String? _readWebViewInitData() {
    try {
      final webView = _telegramWebView;
      if (webView == null) return null;

      final initParams = _getProperty(webView, 'initParams');
      if (initParams == null) return null;

      final value = _getProperty(initParams as JSObject, 'tgWebAppData');
      final initData = value?.toString() ?? '';
      if (initData.isNotEmpty) return initData;
    } catch (_) {}

    return null;
  }

  String? _readStoredInitData() {
    try {
      final storage = _sessionStorage;
      if (storage == null) return null;

      final raw = _callReturningMethod(storage, 'getItem', [
        '__telegram__initParams',
      ])?.toString();
      if (raw == null || raw.isEmpty || raw == 'null') return null;

      final params = jsonDecode(raw);
      if (params is! Map<String, dynamic>) return null;

      return params['tgWebAppData']?.toString();
    } catch (_) {}

    return null;
  }

  String? _readLaunchValue(String fragment) {
    if (fragment.isEmpty) return null;

    final queryIndex = fragment.indexOf('?');
    final fragmentQuery = queryIndex == -1
        ? fragment
        : fragment.substring(queryIndex + 1);
    final queryStart = fragmentQuery.startsWith('?') ? 1 : 0;
    final values = Uri.splitQueryString(fragmentQuery.substring(queryStart));
    return values['tgWebAppData'];
  }

  TelegramUser? _parseLaunchUser(String launchInitData) {
    final values = Uri.splitQueryString(launchInitData);
    final rawUser = values['user'];
    if (rawUser == null || rawUser.isEmpty) return null;

    final userJson = jsonDecode(rawUser);
    if (userJson is! Map<String, dynamic>) return null;

    return TelegramUser(
      id: _toInt(userJson['id']),
      firstName: userJson['first_name']?.toString(),
      lastName: userJson['last_name']?.toString(),
      username: userJson['username']?.toString(),
      languageCode: userJson['language_code']?.toString(),
    );
  }

  int? _toInt(Object? value) {
    if (value == null) return null;
    if (value is int) return value;
    return int.tryParse(value.toString());
  }
}

extension _JSObjectHelpers on JSObject {
  external JSAny? operator [](String key);
}

JSAny? _getProperty(JSObject object, String key) {
  return object[key];
}

void _callMethod(JSObject object, String method, List<Object?> args) {
  final function = object[method];

  if (function == null) return;

  if (args.isEmpty) {
    (function as JSFunction).callAsFunction(object);
    return;
  }

  if (args.length == 1) {
    (function as JSFunction).callAsFunction(object, args[0].jsify());
    return;
  }

  if (args.length == 2) {
    (function as JSFunction).callAsFunction(
      object,
      args[0].jsify(),
      args[1].jsify(),
    );
    return;
  }

  throw UnsupportedError('Only up to 2 JS arguments are supported.');
}

JSAny? _callReturningMethod(
  JSObject object,
  String method,
  List<Object?> args,
) {
  final function = object[method];

  if (function == null) return null;

  if (args.isEmpty) {
    return (function as JSFunction).callAsFunction(object);
  }

  if (args.length == 1) {
    return (function as JSFunction).callAsFunction(object, args[0].jsify());
  }

  if (args.length == 2) {
    return (function as JSFunction).callAsFunction(
      object,
      args[0].jsify(),
      args[1].jsify(),
    );
  }

  throw UnsupportedError('Only up to 2 JS arguments are supported.');
}
