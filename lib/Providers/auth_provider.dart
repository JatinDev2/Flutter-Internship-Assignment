import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quantmhill_assignment/Local%20Memory/LoginData.dart';
import 'package:quantmhill_assignment/Providers/profile_provider.dart';

class FirebaseAuthProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isLoading = false;
  String _errorMessage = '';

  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  void setLoading(bool isLoading) {
    _isLoading = isLoading;
    notifyListeners();
  }

  void _clearErrorMessage() {
    _errorMessage = '';
    notifyListeners();
  }

  void _setErrorMessage(String message) {
    _errorMessage = message;
    notifyListeners();
  }

  Future<bool> signIn(String email, String password,BuildContext context) async {
    try {
      setLoading(true);
      _clearErrorMessage();

      await _auth.signInWithEmailAndPassword(email: email, password: password);
    final provider=  Provider.of<FirestoreUserProvider>(context, listen: false);
    provider.fetchUserProfile(_auth.currentUser!.uid).then((value) {
      LoginData().writeUserEmail(email);
      LoginData().writeUserName(provider.currentUserProfile!.username);
      LoginData().writeUserId(_auth.currentUser!.uid);
      LoginData().writeIsLoggedIn(true);
    });

      setLoading(false);
      return true;
    } on FirebaseAuthException catch (e) {
      setLoading(false);
      _setErrorMessage(e.message ?? "An unknown error occurred");
      return false;
    } catch (e) {
      setLoading(false);
      _setErrorMessage("An unexpected error occurred");
      return false;
    }
  }

  Future<bool> signUp(String email, String password) async {
    try {
      setLoading(true);
      _clearErrorMessage();

      await _auth.createUserWithEmailAndPassword(email: email, password: password);

      // setLoading(false);
      return true;
    } on FirebaseAuthException catch (e) {
      setLoading(false);
      _setErrorMessage(e.message ?? "An unknown error occurred");
      return false;
    } catch (e) {
      setLoading(false);
      _setErrorMessage("An unexpected error occurred");
      return false;
    }
  }
}
