// import 'dart:convert';

// import 'package:foodgram/core/models/api_response.dart';
// import 'package:http/http.dart' as http;

// class ApiClient {
//   // final _baseUrl = dotenv.get('BASE_URL');
//   final _baseUrl = 'https://6415ff4691cf.ngrok-free.app';

//   String? _authToken;

//   Map<String, String> get _headers => {
//     'Content-Type': 'application/json',
//     'Accept': 'application/json',
//     'Authorization': 'Bearer $_authToken',
//   };

//   void setAuthToken(String? token) {
//     _authToken = token;
//   }

//   Future<ApiResponse<T>> post<T>({
//     required String endpoint,
//     ReqObj? request,
//     FromJson? fromJson,
//   }) async {
//     final url = Uri.parse('$_baseUrl$endpoint');
//     try {
//       final response = await http.post(url, headers: _headers, body: jsonEncode(request));
//       final body = jsonDecode(response.body);

//       if (response.statusCode == 200 || response.statusCode == 201) {
//         final data = fromJson != null ? fromJson(body) : body;

//         return ApiResponse<T>(
//           code: response.statusCode,
//           data: data,
//           response: response,
//           endpoint: endpoint,
//           request: request,
//         );
//       } else {
//         return ApiResponse<T>(
//           success: false,
//           code: response.statusCode,
//           message: _errorMessage(body['message']),
//           response: response,
//           endpoint: endpoint,
//           request: request,
//         );
//       }
//     } catch (e) {
//       return ApiResponse<T>(
//         success: false,
//         message: e.toString(),
//         endpoint: endpoint,
//         request: request,
//       );
//     }
//   }

//   Future<ApiResponse<T>> get<T>({
//     required String endpoint,
//     ReqObj? request,
//     FromJson? fromJson,
//   }) async {
//     final url = Uri.parse('$_baseUrl$endpoint').replace(queryParameters: request);
//     try {
//       final response = await http.get(url.replace(queryParameters: request), headers: _headers);
//       final body = jsonDecode(response.body);

//       if (response.statusCode == 200) {
//         final data = fromJson != null ? fromJson(body) : body;

//         return ApiResponse<T>(
//           code: response.statusCode,
//           data: data,
//           response: response,
//           endpoint: endpoint,
//           request: request,
//         );
//       } else {
//         return ApiResponse<T>(
//           success: false,
//           code: response.statusCode,
//           message: _errorMessage(body['message']),
//           response: response,
//           endpoint: endpoint,
//           request: request,
//         );
//       }
//     } catch (e) {
//       return ApiResponse<T>(
//         success: false,
//         message: e.toString(),
//         endpoint: endpoint,
//         request: request,
//       );
//     }
//   }

//   Future<ApiResponse<T>> patch<T>({
//     required String endpoint,
//     ReqObj? request,
//     FromJson? fromJson,
//   }) async {
//     final url = Uri.parse('$_baseUrl$endpoint');
//     try {
//       final response = await http.patch(url, headers: _headers, body: jsonEncode(request));
//       final body = jsonDecode(response.body);

//       if (response.statusCode == 200 || response.statusCode == 204) {
//         final data = fromJson != null ? fromJson(body) : body;

//         return ApiResponse<T>(
//           code: response.statusCode,
//           data: data,
//           response: response,
//           endpoint: endpoint,
//           request: request,
//         );
//       } else {
//         return ApiResponse<T>(
//           success: false,
//           code: response.statusCode,
//           message: body['message'],
//           response: response,
//           endpoint: endpoint,
//           request: request,
//         );
//       }
//     } catch (e) {
//       return ApiResponse<T>(
//         success: false,
//         message: e.toString(),
//         endpoint: endpoint,
//         request: request,
//       );
//     }
//   }

//   Future<ApiResponse<T>> delete<T>({
//     required String endpoint,
//     ReqObj? request,
//     FromJson? fromJson,
//   }) async {
//     final url = Uri.parse('$_baseUrl$endpoint');
//     try {
//       final response = await http.delete(url, headers: _headers, body: jsonEncode(request));
//       final body = jsonDecode(response.body);

//       if (response.statusCode == 200 || response.statusCode == 204) {
//         return ApiResponse<T>(
//           code: response.statusCode,
//           response: response,
//           endpoint: endpoint,
//           request: request,
//         );
//       } else {
//         return ApiResponse<T>(
//           success: false,
//           code: response.statusCode,
//           message: _errorMessage(body['message']),
//           response: response,
//           endpoint: endpoint,
//           request: request,
//         );
//       }
//     } catch (e) {
//       return ApiResponse<T>(
//         success: false,
//         message: e.toString(),
//         endpoint: endpoint,
//         request: request,
//       );
//     }
//   }
// }

// String _errorMessage(error) {
//   if (error is String) return error;
//   if (error is List) {
//     return error.first as String;
//   }

//   return '$error';
// }

// typedef ReqObj = Map<String, dynamic>;
// typedef FromJson<T> = T Function(ReqObj);

import 'package:dev_once_app/core/models/api_response.dart';
import 'package:dev_once_app/core/models/client_config.dart';
import 'package:dev_once_app/core/models/request_config.dart';
import 'package:dev_once_app/core/services/api/datasources/client_remote_datasource.dart';
import 'package:dev_once_app/core/services/api/repositories/client_repository_impl.dart';
import 'package:dev_once_app/core/services/api/usecases/delete.dart';
import 'package:dev_once_app/core/services/api/usecases/get.dart';
import 'package:dev_once_app/core/services/api/usecases/patch.dart';
import 'package:dev_once_app/core/services/api/usecases/post.dart';
import 'package:http/http.dart';

class ApiClient {
  static final _instance = ApiClient._singleton();

  factory ApiClient() => _instance;

  ApiClient._singleton() {
    _initialize();
  }

  String? _authToken;

  late ClientConfig _config;
  late ClientRemoteDatasource _datasource;
  late ClientRepositoryImpl _repository;
  late Get _get;
  late Post _post;
  late Patch _patch;
  late Delete _delete;

  void _initialize() {
    _configInitialization();
    _datasourceInitialization();
    _repositoryInitialization();
    _get = Get(_repository);
    _post = Post(_repository);
    _patch = Patch(_repository);
    _delete = Delete(_repository);
  }

  ClientConfig _configInitialization() {
    _config = ClientConfig(
      client: Client(),
      baseUrl: 'https://backend.tawakalsolutions.com/api',
      headers: _headers,
    );

    return _config;
  }

  ClientRemoteDatasource _datasourceInitialization() {
    _datasource = ClientRemoteDatasource(_config);
    return _datasource;
  }

  ClientRepositoryImpl _repositoryInitialization() {
    _repository = ClientRepositoryImpl(_datasource);
    return _repository;
  }

  void setAuthToken(String? token) {
    _authToken = token;
    _initialize();
  }

  Map<String, String> get _headers => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    'Authorization': 'Bearer $_authToken',
  };

  Future<ApiResponse<T>> get<T>(RequestConfig<T> config) async {
    return await _get(config);
  }

  Future<ApiResponse<T>> post<T>(RequestConfig<T> config) async {
    return await _post(config);
  }

  Future<ApiResponse<T>> patch<T>(RequestConfig<T> config) async {
    return await _patch(config);
  }

  Future<ApiResponse<T>> delete<T>(RequestConfig<T> config) async {
    return await _delete(config);
  }
}
