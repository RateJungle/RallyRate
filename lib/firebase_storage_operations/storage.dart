
import 'dart:io';
import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
class Storage{
  final _instance = FirebaseStorage.instance;

  Future<String?> storeAsBytes(Uint8List data,String email) async {
    try{
      final ref = _instance.ref().child('$email${DateTime.now().toString().replaceAll(' ', '_')}');
      await ref.putData(data, SettableMetadata(
          contentType: 'image/jpeg'
      ));
      debugPrint("FIREBASE STORAGE IMAGE NAME: ${ref.name}");
      String downloadURL = await ref.getDownloadURL();
      debugPrint("DOWNLOAD URL : $downloadURL");

      return ref.getDownloadURL();
    }catch(e){
      debugPrint('FIREBASE STORAGE ERROR: ${e.toString()}');
      return null;
    }
  }
  Future<String?> storeImage(File image,String email) async {
    try{
      final ref = _instance.ref().child('$email${DateTime.now().toString().replaceAll(' ', '_')}');
      await ref.putFile(image,SettableMetadata(
        contentType: 'image/jpeg'
      ));
      debugPrint("FIREBASE STORAGE IMAGE NAME: ${ref.name}");
      String downloadURL = await ref.getDownloadURL();
      debugPrint("DOWNLOAD URL : $downloadURL");

      return ref.getDownloadURL();
    }catch(e){
      debugPrint('FIREBASE STORAGE ERROR: ${e.toString()}');
      return null;
    }
  }
}