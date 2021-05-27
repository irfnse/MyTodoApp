import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';

abstract class BaseAuth {
  // menjalankan method signIn dengan parameter
  Future<String> signIn(String email, String password);

  // menjalankan method singUp dengan parameter
  Future<String> signUp(String email, String password);

  // melakukan pengecekan user
  Future<FirebaseUser> getCurrentUser();

  // mengirimkan email verification
  Future<void> sendEmailVerification();

  //melakukan method sign out
  Future<void> signOut();

  // melakukan pengecekan email
  Future<bool> isEmailVerified();
}

class Auth implements BaseAuth {
  // melakukan deklarasi firebase auth
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;


  Future<String> signIn(String email, String password) async {
    // melakukan sign in menggunakan _firebaseauth dengan email dan password
    AuthResult result = await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
    FirebaseUser user = result.user;
    return user.uid;
  }

  Future<String> signUp(String email, String password) async {
    // melakukan sign up dengan menggunakan _firebaseauth
    AuthResult result = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
    FirebaseUser user = result.user;
    return user.uid;
  }

  Future<FirebaseUser> getCurrentUser() async {
    // melakukan pengecekan user
    FirebaseUser user = await _firebaseAuth.currentUser();
    return user;
  }

  Future<void> signOut() async {
    // melakukan sign out dengan _firebaseauth
    return _firebaseAuth.signOut();
  }

  Future<void> sendEmailVerification() async {
    // mengirimkan email verfigikasi dengan _firebase auth
    FirebaseUser user = await _firebaseAuth.currentUser();
    user.sendEmailVerification();
  }

  Future<bool> isEmailVerified() async {
    // melakukan pengecekan verifikasi email
    FirebaseUser user = await _firebaseAuth.currentUser();
    return user.isEmailVerified;
  }
}