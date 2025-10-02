import 'dart:convert';

import 'package:dev_once_app/core/services/connectivity/connectivity_service.dart';
import 'package:dev_once_app/core/types/types.dart';
import 'package:http/http.dart';

import 'api_response.dart';

class ApiResponseProvider<T> {
  final String endpoint;
  final RequestMap? request;
  final ModelFromJson? fromJson;
  final Future<Response> Function() onRequest;

  ApiResponseProvider({
    required this.endpoint,
    this.request,
    this.fromJson,
    required this.onRequest,
  });

  Future<ApiResponse<T>> call() async {
    final isConnected = await ConnectivityService().checkConnectivity();

    if (!isConnected) {
      return ApiResponse(
        success: false,
        message: 'You are not connected to internet',
        endpoint: endpoint,
        request: request,
      );
    } else {
      try {
        final response = await onRequest();
        final body = jsonDecode(response.body);

        if (response.statusCode >= 200 && response.statusCode <= 204) {
          final data = fromJson != null ? fromJson!(body) : body;

          return ApiResponse<T>(
            code: response.statusCode,
            data: data,
            response: response,
            endpoint: endpoint,
            request: request,
          );
        } else {
          return ApiResponse<T>(
            success: false,
            code: response.statusCode,
            message: _errorMessage(body['message']),
            response: response,
            endpoint: endpoint,
            request: request,
          );
        }
      } catch (e) {
        return ApiResponse<T>(
          success: false,
          message: e.toString(),
          endpoint: endpoint,
          request: request,
        );
      }
    }
  }

  String _errorMessage(error) {
    if (error is String) return error;
    if (error is List) {
      return error.first as String;
    }

    return '$error';
  }
}
