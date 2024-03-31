import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:quantmhill_assignment/Local%20Memory/LoginData.dart';
import 'package:quantmhill_assignment/Models/user_profile.dart';

class FirestoreUserProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isLoading = false;
  String? _userProfilePicUrl;
  UserProfile? currentUserProfile;

  bool get isLoading => _isLoading;
  String? get userProfilePicUrl => _userProfilePicUrl;

  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  Future<void> createUserProfile(String username, String email, String profilePicPath) async {
    setLoading(true);
    try {
      String userId = _auth.currentUser!.uid;

      await _firestore.collection('Users').doc(userId).set({
        'username': username,
        'email': email,
        'profilePicUrl': profilePicPath,
      }, SetOptions(merge: true));

      LoginData().writeUserEmail(email);
      LoginData().writeUserName(username);
      LoginData().writeUserId(userId);
      LoginData().writeIsLoggedIn(true);

      _userProfilePicUrl = profilePicPath;
    } catch (e) {
      setLoading(false);
      return Future.error('An error occurred while creating the user profile: ${e.toString()}');
    }
    setLoading(false);
  }

  Future<void> updateUserProfile(String userId, String? username, String? email, String? profilePicPath) async {
    setLoading(true);
    try {
      Map<String, dynamic> updates = {};
      if (username != null) {
        updates['username'] = username;
      }
      if (email != null) {
        updates['email'] = email;
      }
      if (profilePicPath != null) {
        String filePath = 'Users/$userId';
        UploadTask uploadTask = _storage.ref().child(filePath).putFile(File(profilePicPath));
        String downloadUrl = await (await uploadTask).ref.getDownloadURL();
        updates['profilePicUrl'] = downloadUrl;
        _userProfilePicUrl = downloadUrl;
      }
      if (updates.isNotEmpty) {
        await _firestore.collection('Users').doc(userId).update(updates);
      }
    } catch (e) {
      setLoading(false);
      // Handle errors
      return Future.error('Failed to update profile.');
    }
    setLoading(false);
  }

  Future<void> deleteUserProfile(String userId) async {
    setLoading(true);
    try {
      await _storage.ref('Users/$userId').delete();

      await _firestore.collection('Users').doc(userId).delete();

      await _auth.currentUser!.delete();
    } catch (e) {
      setLoading(false);
      return Future.error('Failed to delete profile.');
    }
    setLoading(false);
  }

  Future<String> uploadProfilePicture(File image) async {
    setLoading(true);
    String userId = _auth.currentUser!.uid;
    String filePath = 'Users/$userId';
    try {
      TaskSnapshot snapshot = await _storage.ref().child(filePath).putFile(image);
      String downloadUrl = await snapshot.ref.getDownloadURL();
      _userProfilePicUrl = downloadUrl;


      setLoading(false);
      return downloadUrl;
    } catch (e) {
      setLoading(false);
      rethrow;
    }
  }

  Future<void> fetchUserProfile(String userId) async {
    setLoading(true);
    try {
      DocumentSnapshot snapshot = await _firestore.collection('Users').doc(userId).get();
      if (snapshot.exists && snapshot.data() != null) {
        UserProfile userProfile = UserProfile.fromMap(snapshot.data()! as Map<String, dynamic>, snapshot.id);
        currentUserProfile=userProfile;
        setLoading(false);
      } else {
        setLoading(false);
        throw Exception('User profile not found.');
      }
    } catch (e) {
      setLoading(false);
      throw Exception('Failed to fetch user profile: ${e.toString()}');
    }
  }

}
