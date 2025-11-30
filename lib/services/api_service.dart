import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:device_info_plus/device_info_plus.dart';

class ApiService {
  // Default paths for emulator and a typical local network IP.
  static const String _emulatorBase = 'http://10.0.2.2/jasakuapp';
  // NOTE: replace this with your PC IP on the local network if different.
  static const String _physicalBase = 'http://10.245.185.221/jasakuapp';

  // cache determined base URL to avoid repeated device info calls
  static String? _cachedBaseUrl;

  static Future<String> _getBaseUrl() async {
    if (_cachedBaseUrl != null) return _cachedBaseUrl!;

    try {
      final deviceInfo = DeviceInfoPlugin();
      final androidInfo = await deviceInfo.androidInfo;
      final isPhysical = androidInfo.isPhysicalDevice ?? true;

      _cachedBaseUrl = isPhysical ? _physicalBase : _emulatorBase;
    } catch (e) {
      // If detection fails, default to emulator host which works in emulator.
      _cachedBaseUrl = _emulatorBase;
    }

    return _cachedBaseUrl!;
  }

  static Future<dynamic> post(String endpoint, dynamic data) async {
    const int maxAttempts = 3;
    const Duration attemptTimeout = Duration(seconds: 10);

    final baseUrl = await _getBaseUrl();
    final uri = Uri.parse('$baseUrl/$endpoint');

    for (int attempt = 1; attempt <= maxAttempts; attempt++) {
      try {
        final response = await http
            .post(uri, headers: {'Content-Type': 'application/json'}, body: jsonEncode(data))
            .timeout(attemptTimeout);

        if (response.statusCode < 200 || response.statusCode >= 300) {
          final snippet = (response.body ?? '').toString();
          return {
            'success': false,
            'message': 'Server error: HTTP ${response.statusCode}',
            'bodySnippet': snippet.length > 200 ? snippet.substring(0, 200) : snippet,
          };
        }

        final contentType = response.headers['content-type'] ?? '';
        if (!contentType.toLowerCase().contains('application/json')) {
          try {
            return jsonDecode(response.body);
          } on FormatException {
            final snippet = (response.body ?? '').toString();
            return {
              'success': false,
              'message': 'Invalid JSON response from server',
              'bodySnippet': snippet.length > 200 ? snippet.substring(0, 200) : snippet,
            };
          }
        }

        return jsonDecode(response.body);
      } on TimeoutException catch (e) {
        if (attempt == maxAttempts) {
          return {'success': false, 'message': 'Timeout: $e'};
        }
        await Future.delayed(Duration(milliseconds: 300 * attempt));
      } on SocketException catch (e) {
        // Network-level error: host unreachable, etc.
        if (attempt == maxAttempts) {
          return {'success': false, 'message': 'Network error: $e'};
        }
        await Future.delayed(Duration(milliseconds: 300 * attempt));
      } catch (e) {
        return {'success': false, 'message': 'Connection error: $e'};
      }
    }

    return {'success': false, 'message': 'Failed to connect'};
  }

  static Future<dynamic> get(String endpoint) async {
    const int maxAttempts = 3;
    const Duration attemptTimeout = Duration(seconds: 10);

    final baseUrl = await _getBaseUrl();
    final uri = Uri.parse('$baseUrl/$endpoint');

    for (int attempt = 1; attempt <= maxAttempts; attempt++) {
      try {
        final response = await http.get(uri, headers: {'Content-Type': 'application/json'}).timeout(attemptTimeout);

        if (response.statusCode < 200 || response.statusCode >= 300) {
          final snippet = (response.body ?? '').toString();
          return {
            'success': false,
            'message': 'Server error: HTTP ${response.statusCode}',
            'bodySnippet': snippet.length > 200 ? snippet.substring(0, 200) : snippet,
          };
        }

        final contentType = response.headers['content-type'] ?? '';
        if (!contentType.toLowerCase().contains('application/json')) {
          try {
            return jsonDecode(response.body);
          } on FormatException {
            final snippet = (response.body ?? '').toString();
            return {
              'success': false,
              'message': 'Invalid JSON response from server',
              'bodySnippet': snippet.length > 200 ? snippet.substring(0, 200) : snippet,
            };
          }
        }

        return jsonDecode(response.body);
      } on TimeoutException catch (e) {
        if (attempt == maxAttempts) {
          return {'success': false, 'message': 'Timeout: $e'};
        }
        await Future.delayed(Duration(milliseconds: 300 * attempt));
      } on SocketException catch (e) {
        if (attempt == maxAttempts) {
          return {'success': false, 'message': 'Network error: $e'};
        }
        await Future.delayed(Duration(milliseconds: 300 * attempt));
      } catch (e) {
        return {'success': false, 'message': 'Connection error: $e'};
      }
    }

    return {'success': false, 'message': 'Failed to connect'};
  }
}