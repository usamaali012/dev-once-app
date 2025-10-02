import 'package:http/http.dart';

class ClientConfig {
  final Client client;
  final String baseUrl;
  final Map<String, String> headers;

  const ClientConfig({required this.client, required this.baseUrl, required this.headers});

  ClientConfig copyWith({Client? client, String? baseUrl, Map<String, String>? headers}) {
    return ClientConfig(
      client: client ?? this.client,
      baseUrl: baseUrl ?? this.baseUrl,
      headers: headers ?? this.headers,
    );
  }
}
