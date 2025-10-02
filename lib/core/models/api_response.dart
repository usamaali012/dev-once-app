import 'package:flutter/material.dart';
import 'package:http/http.dart';

/// Base class for the represntation of the fetched information from the server.
class ApiResponse<T> {
  /// Endpoint to call the Api.
  final String endpoint;

  /// True/False based on the Status of the response.
  final bool success;

  /// Error message of the response in case of api failed.
  final String? message;

  /// Status code of the response.
  final int? code;

  /// Data of the response.
  /// It will return the data of type `T` if fromJson is provided otherwise it will return the data of type `dynamic`.
  final T? data;

  /// Response receieved from [http].
  final Response? response;

  /// Request or Query parameters for api request.
  final Map<String, dynamic>? request;

  /// Generic model [ApiResponse] for the response conversion reveived from the server.
  ApiResponse({
    required this.endpoint,
    this.request = const {},
    this.success = true,
    this.message,
    this.code,
    this.data,
    this.response,
  }) {
    debugPrint('$this');
  }

  @override
  String toString() {
    String str = '';
    str += '${'*' * 30}\n';
    str += 'API LOGS INTERCEPTORS\n';
    str += '${'*' * 30}\n';
    str += 'ENDPOINT: $endpoint\n';
    str += 'INTERNAL HEADERS: ${response?.headers}\n';
    str += 'REQUEST: $request\n';
    str += 'SUCCESS: $success\n';
    str += 'CODE: $code\n';
    str += 'MESSAGE: $message\n';
    str += 'DATA: $data\n';
    str += 'STATUS CODE: ${response?.statusCode}\n';
    str += 'RESPONSE BODY: ${response?.body}\n';
    str += '*' * 30;
    return str;
  }
}
