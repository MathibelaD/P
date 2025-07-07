import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/profile.dart';

class ProfileProvider with ChangeNotifier {
  UserProfile? _profile;
  bool _isLoading = false;

  UserProfile? get profile => _profile;
  bool get isLoading => _isLoading;

  final _client = Supabase.instance.client;

  Future<void> loadUserProfile() async {
    _isLoading = true;
    notifyListeners();
print(_client.auth.currentUser);
    final user = _client.auth.currentUser;
    if (user != null) {
      final data = await _client
          .from('profiles')
          .select()
          .eq('id', user.id)
          .maybeSingle();
print({user});
      if (data != null) {
        _profile = UserProfile.fromJson(data);
      }
    }

    _isLoading = false;
    notifyListeners();
  }

  void clear() {
    _profile = null;
    notifyListeners();
  }
}
