import 'package:dio/dio.dart';

import '../models/network/api_service_request.dart';
import '../models/network/exception.dart';

class APIService {
  late final Dio _dio;

  APIService._internal() {
    final options = BaseOptions(
      receiveDataWhenStatusError: true,
      connectTimeout: const Duration(milliseconds: 15000),
      receiveTimeout: const Duration(milliseconds: 15000),
    );
    _dio = Dio(options);
  }

  static final APIService _instance = APIService._internal();

  factory APIService.instance() => _instance;

  /// HTTP GET
  Future<T> get<T>(APIServiceRequest<T> request) async {
    try {
      final headerOption = Options(headers: request.header);
      final response = await _dio.get(
        request.path,
        options: headerOption,
        queryParameters: request.queryParams,
      );

      return request.parseResponse(response.data);
    } on DioException catch (e) {
      // print(e.type);
      switch (e.type) {
        case DioExceptionType.connectionError:
          throw RemoteException(
              RemoteException.badCertification, "Connection error");
        case DioExceptionType.badCertificate:
          throw RemoteException(
              RemoteException.badCertification, "Bad Certification error");
        case DioExceptionType.connectionTimeout:
          throw RemoteException(
              RemoteException.connectTimeout, 'Connection timeout');
        case DioExceptionType.sendTimeout:
          throw RemoteException(RemoteException.sendTimeout, 'Send timeout');
        case DioExceptionType.receiveTimeout:
          throw RemoteException(
              RemoteException.receiveTimeout, 'Receive timeout');
        case DioExceptionType.badResponse:
          throw RemoteException(
            RemoteException.responseError,
            '${e.response?.data?['error'] ?? ''}',
            httpStatusCode: e.response?.statusCode,
          );
        case DioExceptionType.cancel:
          throw RemoteException(
              RemoteException.cancelRequest, 'Request cancel');
        case DioExceptionType.unknown:
          throw RemoteException(
              RemoteException.other, 'Dio error unknown: ${e.error}');
      }
    } catch (e) {
      print(e);
      // print("eee");
      throw RemoteException(RemoteException.other, e.toString());
    }
  }

  /// HTTP POST
  Future<T> post<T>(
    APIServiceRequest<T> request, {
    bool isDelete = false,
  }) async {
    try {
      final headerOption = Options(headers: request.header);
      final response = await _dio.post(
        request.path,
        options: headerOption,
        data: request.dataBody,
        queryParameters: request.queryParams,
      );
      return request.parseResponse(response);
    } on DioException catch (e) {
      switch (e.type) {
        case DioExceptionType.connectionError:
          throw RemoteException(
              RemoteException.badCertification, "Connection error");
        case DioExceptionType.badCertificate:
          throw RemoteException(
              RemoteException.badCertification, "Bad Certification error");
        case DioExceptionType.connectionTimeout:
          throw RemoteException(
              RemoteException.connectTimeout, 'Connection timeout');
        case DioExceptionType.sendTimeout:
          throw RemoteException(RemoteException.sendTimeout, 'Send timeout');
        case DioExceptionType.receiveTimeout:
          throw RemoteException(
              RemoteException.receiveTimeout, 'Receive timeout');
        case DioExceptionType.badResponse:
          throw RemoteException(
            RemoteException.responseError,
            '${e.response?.data?['error'] ?? ''}',
            httpStatusCode: e.response?.statusCode,
          );
        case DioExceptionType.cancel:
          throw RemoteException(
              RemoteException.cancelRequest, 'Request cancel');
        case DioExceptionType.unknown:
          throw RemoteException(
              RemoteException.other, 'Dio error unknown: ${e.error}');
      }
    } catch (e) {
      // throw RemoteException(RemoteException.other, e.toString());
      throw Exception(e.toString());
    }
  }
}
