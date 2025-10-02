import 'package:dev_once_app/core/models/request_config.dart';
import 'package:dev_once_app/core/models/api_response.dart';

abstract interface class ClientRepository {
  Future<ApiResponse<T>> get<T>(RequestConfig config);
  Future<ApiResponse<T>> post<T>(RequestConfig config);
  Future<ApiResponse<T>> patch<T>(RequestConfig config);
  Future<ApiResponse<T>> delete<T>(RequestConfig config);
}
