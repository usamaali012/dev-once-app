import 'package:dev_once_app/core/types/types.dart';

class RequestConfig<T> {
  final String endpoint;
  final RequestMap? request;
  final ModelFromJson<T>? fromJson;

  const RequestConfig({required this.endpoint, this.request, this.fromJson});
}