import 'package:dev_once_app/core/models/base_provider.dart';
import 'package:dev_once_app/core/services/api/api_client.dart';

extension ApiClientExtension on BaseProvider {
  ApiClient get client => ApiClient();
}