import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/foundation.dart';
import '../models/models.dart';
import 'api_client.dart';

class AuthService {
  final firebase_auth.FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;
  final ApiClient _apiClient;

  User? _currentUser;

  AuthService({
    firebase_auth.FirebaseAuth? firebaseAuth,
    GoogleSignIn? googleSignIn,
    required ApiClient apiClient,
  })  : _firebaseAuth = firebaseAuth ?? firebase_auth.FirebaseAuth.instance,
        _googleSignIn = googleSignIn ?? GoogleSignIn(),
        _apiClient = apiClient;

  User? get currentUser => _currentUser;
  bool get isLoggedIn => _currentUser != null && _apiClient.isAuthenticated;

  Stream<firebase_auth.User?> get authStateChanges =>
      _firebaseAuth.authStateChanges();

  Future<User?> signInWithGoogle() async {
    try {
      final googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return null;

      final googleAuth = await googleUser.authentication;
      final credential = firebase_auth.GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential =
          await _firebaseAuth.signInWithCredential(credential);
      final firebaseUser = userCredential.user;
      if (firebaseUser == null) return null;

      // Get Firebase ID token to authenticate with backend
      final idToken = await firebaseUser.getIdToken();
      if (idToken == null) return null;

      // Authenticate with backend and get API token
      final apiUser = await _authenticateWithBackend(
        idToken: idToken,
        email: firebaseUser.email ?? '',
        displayName: firebaseUser.displayName ?? '',
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
      // Try to sign in with backend directly
      final response = await _apiClient.post<Map<String, dynamic>>(
        '/api/auth/login/',
        data: {
          'email': email,
          'password': password,
        },
      );

      final token = response.data!['token'] as String;
      _apiClient.setAuthToken(token);

      // Get current user
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
      // Create user on backend
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

      // Login after registration
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
      // Try to authenticate with Firebase token
      final response = await _apiClient.post<Map<String, dynamic>>(
        '/api/auth/firebase/',
        data: {
          'id_token': idToken,
          'email': email,
          'display_name': displayName,
        },
      );

      final token = response.data!['token'] as String;
      _apiClient.setAuthToken(token);

      // Get current user from backend
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
    await _firebaseAuth.signOut();
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
