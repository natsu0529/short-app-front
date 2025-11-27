import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/foundation.dart';
import '../models/models.dart';
import 'api_client.dart';

class AuthService {
  final GoogleSignIn _googleSignIn;
  final ApiClient _apiClient;

  User? _currentUser;

  AuthService({
    GoogleSignIn? googleSignIn,
    required ApiClient apiClient,
  })  : _googleSignIn = googleSignIn ?? GoogleSignIn(
          scopes: ['email', 'profile'],
        ),
        _apiClient = apiClient;

  User? get currentUser => _currentUser;
  bool get isLoggedIn => _currentUser != null && _apiClient.isAuthenticated;

  Future<User?> signInWithGoogle() async {
    try {
      final googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return null;

      final googleAuth = await googleUser.authentication;
      final idToken = googleAuth.idToken;
      if (idToken == null) return null;

      // Send Google ID token to backend for verification
      final apiUser = await _authenticateWithBackend(
        idToken: idToken,
        email: googleUser.email,
        displayName: googleUser.displayName ?? '',
      );

      _currentUser = apiUser;
      return apiUser;
    } catch (e) {
      if (kDebugMode) {
        print('Error signing in with Google: $e');
      }
      rethrow;
    }
  }

  Future<User?> signInWithEmailPassword(String email, String password) async {
    try {
      final response = await _apiClient.post<Map<String, dynamic>>(
        '/api/auth/login/',
        data: {
          'email': email,
          'password': password,
        },
      );

      final token = response.data!['token'] as String;
      _apiClient.setAuthToken(token);

      final userResponse = await _apiClient.get<Map<String, dynamic>>(
        '/api/users/me/',
      );
      _currentUser = User.fromJson(userResponse.data!);
      return _currentUser;
    } catch (e) {
      if (kDebugMode) {
        print('Error signing in with email/password: $e');
      }
      rethrow;
    }
  }

  Future<User?> register({
    required String username,
    required String displayName,
    required String email,
    required String password,
  }) async {
    try {
      final response = await _apiClient.post<Map<String, dynamic>>(
        '/api/users/',
        data: {
          'username': username,
          'user_name': displayName,
          'user_mail': email,
          'password': password,
        },
      );

      final user = User.fromJson(response.data!);
      await signInWithEmailPassword(email, password);
      return user;
    } catch (e) {
      if (kDebugMode) {
        print('Error registering: $e');
      }
      rethrow;
    }
  }

  Future<User?> _authenticateWithBackend({
    required String idToken,
    required String email,
    required String displayName,
  }) async {
    try {
      // Send Google ID token to backend
      final response = await _apiClient.post<Map<String, dynamic>>(
        '/api/auth/google/',
        data: {
          'id_token': idToken,
          'email': email,
          'display_name': displayName,
        },
      );

      final token = response.data!['token'] as String;
      _apiClient.setAuthToken(token);

      final userResponse = await _apiClient.get<Map<String, dynamic>>(
        '/api/users/me/',
      );
      return User.fromJson(userResponse.data!);
    } catch (e) {
      if (kDebugMode) {
        print('Error authenticating with backend: $e');
      }
      rethrow;
    }
  }

  Future<void> signOut() async {
    await _googleSignIn.signOut();
    _apiClient.setAuthToken(null);
    _currentUser = null;
  }

  Future<User?> refreshCurrentUser() async {
    if (!_apiClient.isAuthenticated) return null;
    try {
      final response = await _apiClient.get<Map<String, dynamic>>(
        '/api/users/me/',
      );
      _currentUser = User.fromJson(response.data!);
      return _currentUser;
    } catch (e) {
      if (kDebugMode) {
        print('Error refreshing current user: $e');
      }
      return null;
    }
  }

  void setCurrentUser(User? user) {
    _currentUser = user;
  }

  void setAuthToken(String? token) {
    _apiClient.setAuthToken(token);
  }
}
