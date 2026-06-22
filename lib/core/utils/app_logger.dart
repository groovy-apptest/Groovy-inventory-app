import 'package:logger/logger.dart';

final log = AppLogger._instance;

class AppLogger {
  static final AppLogger _instance = AppLogger._();

  late final Logger _logger;

  AppLogger._() {
    _logger = Logger(
      printer: PrettyPrinter(
        methodCount: 0,
        errorMethodCount: 5,
        lineLength: 80,
        noBoxingByDefault: true,
      ),
      level: Level.debug,
    );
  }

  void d(String message) => _logger.d(message);
  void i(String message) => _logger.i(message);
  void w(String message) => _logger.w(message);
  void e(String message, [Object? error, StackTrace? stackTrace]) =>
      _logger.e(message, error: error, stackTrace: stackTrace);
}
