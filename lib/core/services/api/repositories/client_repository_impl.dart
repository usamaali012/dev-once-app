import 'package:dev_once_app/core/models/request_config.dart';
import 'package:dev_once_app/core/services/api/datasources/client_remote_datasource.dart';
import 'package:dev_once_app/core/services/api/repositories/client_repository.dart';
import 'package:dev_once_app/core/models/api_response.dart';

class ClientRepositoryImpl implements ClientRepository {
  final ClientRemoteDatasource _datasource;

  ClientRepositoryImpl(this._datasource);

  @override
  Future<ApiResponse<T>> get<T>(RequestConfig config) async {
    return await _datasource.get(config);
  }

  @override
  Future<ApiResponse<T>> post<T>(RequestConfig config) async {
    return await _datasource.post(config);
  }

  @override
  Future<ApiResponse<T>> patch<T>(RequestConfig config) async {
    return await _datasource.patch(config);
  }

  @override
  Future<ApiResponse<T>> delete<T>(RequestConfig config) async {
    return await _datasource.delete(config);
  }
}
