import 'package:dev_once_app/core/models/request_config.dart';
import 'package:dev_once_app/core/services/api/repositories/client_repository.dart';
import 'package:dev_once_app/core/models/api_response.dart';

class Delete {
  final ClientRepository _repository;

  const Delete(this._repository);

  Future<ApiResponse<T>> call<T>(RequestConfig config) async {
    return await _repository.delete(config);
  }
}
