import 'package:jasaku_app/services/api_service.dart';
import 'package:jasaku_app/models/user_model.dart';
import 'package:jasaku_app/exceptions/auth_exception.dart';

class UserService {
  /// Panggilan login ke backend. Endpoint diasumsikan `login.php`.
  /// Response backend harus mengembalikan JSON dengan format:
  /// { "success": true, "data": { ...user fields... } }
  static Future<User> login(String email, String password) async {
    final payload = {
      'email': email,
      'password': password,
    };

    final res = await ApiService.post('api/user/login.php', payload);

    if (res == null) {
      throw AuthException('Tidak ada respons dari server');
    }

    if (res is Map) {
      // Preferred: explicit success boolean and data object
      if (res['success'] == true) {
        final data = res['data'];
        if (data is Map<String, dynamic>) {
          return User.fromJson(data);
        } else if (data is Map) {
          return User.fromJson(Map<String, dynamic>.from(data));
          } else {
          throw AuthException('Format data user tidak valid');
        }
      }

      // Fallback: some backends return a message like "Login successful" but omit
      // the `success` boolean. If message indicates success, try to use `data` if
      // present, otherwise build a minimal User so the app can proceed.
      final msg = (res['message'] ?? '').toString().toLowerCase();

      // Detect common server-side error codes/messages that indicate invalid password
      final errorCode = (res['errorCode'] ?? '').toString().toLowerCase();
      if (errorCode.contains('invalid_password') || errorCode.contains('invalidcredentials') ||
          errorCode.contains('wrong_password') || errorCode.contains('wrong_credentials')) {
        throw AuthException('Password salah. Periksa kembali kata sandi Anda.');
      }

      // Also check human-readable message text for password-related failure
      if (msg.contains('password') && (msg.contains('wrong') || msg.contains('invalid') || msg.contains('salah') || msg.contains('incorrect') || msg.contains('not match'))) {
        throw AuthException('Password salah. Periksa kembali kata sandi Anda.');
      }

      if (msg.contains('success')) {
        final data = res['data'];
        if (data is Map<String, dynamic>) {
          return User.fromJson(data);
        } else if (data is Map) {
          return User.fromJson(Map<String, dynamic>.from(data));
        } else {
          // Try to fetch full user profile from server (some backends expose a profile endpoint)
          try {
            final profileRes = await ApiService.post('api/user/profile.php', {'email': email});
            if (profileRes is Map && profileRes['success'] == true && profileRes['data'] is Map) {
              return User.fromJson(Map<String, dynamic>.from(profileRes['data']));
            }
          } catch (_) {
            // ignore and fallback
          }

          // Fallback: create a minimal User using the email local-part as display name
          final displayName = email.split('@').first;
          return User(
            id: 0,
            nrp: '',
            nama: displayName,
            email: email,
            phone: null,
            role: 'customer',
          );
        }
      }
    }

    String message = 'Login gagal: kredensial salah atau server error';
    if (res is Map) {
      if (res['message'] != null) message = res['message'].toString();
      if (res['bodySnippet'] != null) {
        message = '$message\n\nResponse snippet:\n${res['bodySnippet'].toString()}';
      }
    }

    throw AuthException(message);
  }

  /// Register user ke backend. Endpoint diasumsikan `register.php`.
  /// Mengembalikan `User` jika backend mengembalikan data user.
  static Future<User> register({
    required String nrp,
    required String nama,
    required String email,
    String? phone,
    required String password,
  }) async {
    final payload = {
      'nrp': nrp,
      'nama': nama,
      'email': email,
      'phone': phone ?? '',
      'password': password,
    };

    final res = await ApiService.post('api/user/register.php', payload);

    if (res == null) {
      throw AuthException('Tidak ada respons dari server');
    }

    if (res is Map && res['success'] == true) {
      final data = res['data'];
      if (data is Map<String, dynamic>) {
        return User.fromJson(data);
      } else if (data is Map) {
        return User.fromJson(Map<String, dynamic>.from(data));
      } else {
        // Jika backend hanya mengembalikan success tanpa data, buat User minimal
        // menggunakan field yang tersedia di response
        // Coba ambil created user's info dari message jika ada
        throw AuthException('Registrasi berhasil tapi data user tidak tersedia');
      }
    }

    String message = 'Registrasi gagal: server error';
    if (res is Map) {
      if (res['message'] != null) message = res['message'].toString();
      if (res['bodySnippet'] != null) {
        message = '$message\n\nResponse snippet:\n${res['bodySnippet'].toString()}';
      }
    }

    throw AuthException(message);
  }
}
