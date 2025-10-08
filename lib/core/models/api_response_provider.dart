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
            message: _errorMessage(body),
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

  String _errorMessage(dynamic body) {
    if (body is String) return body;
    if (body is List && body.isNotEmpty) {
      final first = body.first;
      return first is String ? first : '$first';
    }
    if (body is Map<String, dynamic>) {
      final msg = body['message'];
      if (msg is String && msg.isNotEmpty) return msg;

      final detail = body['detail'];
      if (detail is Map<String, dynamic>) {
        final field = detail['field'];
        final message = detail['message'];
        if (field != null && message != null) {
          return '$message';
        }
        return '$detail';
      }
      // Handle FastAPI-style validation errors: { detail: [ {loc: [..., field], msg: 'Field required', type: 'missing'} ] }
      if (detail is List && detail.isNotEmpty) {
        final first = detail.first;
        if (first is Map<String, dynamic>) {
          final loc = first['loc'];
          final msg2 = first['msg'];
          final type = first['type'];
          String? fieldName;
          if (loc is List && loc.isNotEmpty) {
            fieldName = loc.last?.toString();
          }
          if (fieldName != null && fieldName.isNotEmpty) {
            final isMissing = (type == 'missing') ||
                (msg2 is String && msg2.toLowerCase().contains('required'));
            return isMissing
                ? '$fieldName is missing'
                : msg2 is String && msg2.isNotEmpty
                    ? '$fieldName: $msg2'
                    : '$fieldName is invalid';
          }
          if (msg2 is String && msg2.isNotEmpty) return msg2;
        }
      }
      if (detail is String) return detail;
    }
    return '$body';
  }
}
