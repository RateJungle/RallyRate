import 'package:firebase_auth/firebase_auth.dart';
import 'package:rally_rate/components/string_codes.dart';
import 'package:flutter/material.dart';

class AuthService{
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Stream<User?> get user{
    return _auth.authStateChanges();
  }



  String get currentUserEmail{
    return _auth.currentUser!.email!;
  }

  Future<String> registerWithEmailAndPassword({required String email,required String password}) async {
    try{
      final userCredentials = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      return Codes.SUCCESS;
    } on FirebaseAuthException catch(e){
      return e.code;
    }
  }

  Future<String> signInWithEmailAndPassword({required String email,required String password}) async {
    try{
      final userCredentials = await _auth.signInWithEmailAndPassword(email: email, password: password);
      return Codes.SUCCESS;
    } on FirebaseAuthException catch(e){
      return e.code;
    }
  }

  Future sendVerificationEmail() async {
    try {
      final user = FirebaseAuth.instance.currentUser!;
      debugPrint('EMAIL>>>> ${user.email}');
      await user.sendEmailVerification();
    } catch (e) {
      debugPrint('ERROR:::'+e.toString());
    }
  }

  Future sendPasswordResetEmail(String email) async{
    try{
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
    } catch(e){
      debugPrint('Password Error:: ${e.toString()}');
    }
  }

  Future signOut() async{
    await _auth.signOut();
  }

}