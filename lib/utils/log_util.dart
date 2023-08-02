import 'package:logger/logger.dart';

class LogUtil {
  static final _logger = Logger();

  static void verbose(String? message) {
    _logger.v(message);
  }

  static void debug(String? message) {
    _logger.d(message);
  }

  static void info(String? message) {
    _logger.i(message);
  }

  static void warning(String? message) {
    _logger.w(message);
  }

  static void error(String? message, {dynamic error, StackTrace? stackTrace}) {
    _logger.e(message, error, stackTrace);
  }
}
