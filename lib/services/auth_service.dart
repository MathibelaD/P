import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final _client = Supabase.instance.client;

  Future<AuthResponse> signUp({required String email, required String password}) async {
    return await _client.auth.signUp(
      email: email,
      password: password,
    );
  }

  Future<AuthResponse> signIn({required String email, required String password}) async {
    return await _client.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  Future<void> signOut() async {
    await _client.auth.signOut();
  }

  Future<void> signUpWithRole(String email, String password, String fullName, String role) async {
  final response = await signUp(email: email, password: password);
  if (response.user != null) {
    await Supabase.instance.client.from('profiles').insert({
      'id': response.user!.id,
      'full_name': fullName,
      'role': role,
    });
  }

  final user = Supabase.instance.client.auth.currentUser;
print('Current user: $user');

}


  User? get currentUser => _client.auth.currentUser;

  Stream<AuthState> get onAuthStateChange => _client.auth.onAuthStateChange;
}
