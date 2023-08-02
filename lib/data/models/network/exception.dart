abstract class CVNException implements Exception {
  final int code;
  final String message;

  CVNException(this.code, this.message);
}

class RemoteException extends CVNException {
  static const other = -1;
  static const receiveTimeout = 0;
  static const connectTimeout = 1;
  static const sendTimeout = 2;
  static const responseError = 3;
  static const cancelRequest = 4;
  static const socketError = 5;
  static const noInternet = 6;
  static const downloadError = 7;
  static const badCertification = 8;

  final int errorCode;
  final int? httpStatusCode;
  final String errorMessage;

  RemoteException(this.errorCode, this.errorMessage, {this.httpStatusCode})
      : super(errorCode, errorMessage);
}

class LocalException extends CVNException {
  static const other = -1;
  static const emptyUser = 0;
  static const unableSaveUser = 1;
  static const unableSaveDictionary = 2;

  final int errorCode;
  final String errorMessage;

  LocalException(this.errorCode, this.errorMessage)
      : super(errorCode, errorMessage);
}
