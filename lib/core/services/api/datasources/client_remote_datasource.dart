import 'dart:convert';

import 'package:dev_once_app/core/models/client_config.dart';
import 'package:dev_once_app/core/models/request_config.dart';
import 'package:dev_once_app/core/models/api_response.dart';
import 'package:dev_once_app/core/models/api_response_provider.dart';

class ClientRemoteDatasource {
  final ClientConfig _config;

  const ClientRemoteDatasource(this._config);

  Future<ApiResponse<T>> get<T>(RequestConfig config) async {
    final url = Uri.parse(
      '${_config.baseUrl}${config.endpoint}',
    ).replace(queryParameters: config.request);

    final response = ApiResponseProvider<T>(
      endpoint: config.endpoint,
      request: config.request,
      onRequest: () async {
        return await _config.client.get(url, headers: _config.headers);
      },
      fromJson: config.fromJson,
    );

    return await response();
  }

  Future<ApiResponse<T>> post<T>(RequestConfig config) async {
    final url = Uri.parse('${_config.baseUrl}${config.endpoint}');
    dynamic body = jsonEncode(config.request);
    var headers = _config.headers;

    if (config.isFormData) {
      body = config.request;
      headers['Content-Type'] = 'application/x-www-form-urlencoded';
    }

    final response = ApiResponseProvider<T>(
      endpoint: config.endpoint,
      request: config.request,
      onRequest: () async {
        return await _config.client.post(
          url,
          headers: headers,
          body: body,
        );
      },
      fromJson: config.fromJson,
    );

    return await response();
  }

  Future<ApiResponse<T>> patch<T>(RequestConfig config) async {
    final url = Uri.parse('${_config.baseUrl}${config.endpoint}');
    dynamic body = jsonEncode(config.request);
    var headers = _config.headers;

    if (config.isFormData) {
      body = config.request;
      headers['Content-Type'] = 'application/x-www-form-urlencoded';
    }

    final response = ApiResponseProvider<T>(
      endpoint: config.endpoint,
      request: config.request,
      onRequest: () async {
        return await _config.client.patch(
          url,
          headers: headers,
          body: body,
        );
      },
      fromJson: config.fromJson,
    );

    return await response();
  }

  Future<ApiResponse<T>> delete<T>(RequestConfig config) async {
    final url = Uri.parse('${_config.baseUrl}${config.endpoint}');

    final response = ApiResponseProvider<T>(
      endpoint: config.endpoint,
      request: config.request,
      onRequest: () async {
        return await _config.client.delete(
          url,
          headers: _config.headers,
          body: jsonEncode(config.request),
        );
      },
      fromJson: config.fromJson,
    );

    return await response();
  }
}
