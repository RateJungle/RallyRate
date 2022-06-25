import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FirestoreOperations{
  final _instance = FirebaseFirestore.instance;
  String email;
  FirestoreOperations({required this.email});

  Future setUserData({required Map<String, dynamic> map}) async {
    try{
      await _instance.collection('users').doc(email).set(map);
    }catch(e){
      debugPrint('FIRESTORE ADD ERROR>> ${e.toString()}');
    }
  }

  Future<Map<String, dynamic>?> getUserData() async {
    try{
      final snapshot = await _instance.collection('users').doc(email).get();
      return snapshot.data();
    }catch(e){
      debugPrint('FIRESTORE GET ERROR>> ${e.toString()}');
      return null;
    }
  }
  Stream<DocumentSnapshot> get userData{
    return _instance.collection('users').doc(email).snapshots();
  }
}