import 'package:logger/logger.dart';

class LoggerService {
  final Logger _logger = Logger(
    printer: PrettyPrinter(
      methodCount: 2,
      errorMethodCount: 5,
      lineLength: 120,
      colors: true,
      printEmojis: true,
    ),
  );

  void debug(Object? message) {
    _logger.d(message);
  }

  void info(Object? message) {
    _logger.i(message);
  }

  void warning(Object? message) {
    _logger.w(message);
  }

  void error(Object? message, {Object? error, StackTrace? stackTrace}) {
    _logger.e(message, error: error, stackTrace: stackTrace);
  }

  void verbose(Object? message) {
    _logger.t(message);
  }
}
