
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rally_rate/models/comment.dart';

class FirestoreOperations{
  final _instance = FirebaseFirestore.instance;
  String? email;
  FirestoreOperations({this.email});

  Future setUserData({required Map<String, dynamic> map}) async {
    try{
      await _instance.collection('users').doc(email).set(map);
    }catch(e){
      debugPrint('FIRESTORE USER ADD ERROR> ${e.toString()}');
    }
  }

  Future<DocumentSnapshot?> getUserData() async {
    try{
      final snapshot = await _instance.collection('users').doc(email).get();
      return snapshot;
    }catch(e){
      debugPrint('FIRESTORE USER GET ERROR> ${e.toString()}');
      return null;
    }
  }

  Stream<QuerySnapshot> get getUserPosts{
    return _instance.collection('users').doc(email).collection('posts').snapshots();
  }

  Stream<DocumentSnapshot> get userData{
    return _instance.collection('users').doc(email).snapshots();
  }

  Future addToUserPosts({required Map<String,dynamic> map}) async{
    try{
      final postRef = _instance.collection('users').doc(email).collection('posts').doc();
      await postRef.set(map);
    } catch(e){
      debugPrint('FIRESTORE POST ADD ERROR> ${e.toString()}');
    }
  }

  // Future setPostData({required Map<String, dynamic> map}) async{
  //   try{
  //     final postRef = _instance.collection('posts').doc();
  //     await postRef.set(map);
  //     await _instance.collection('users').doc(email).update({
  //       'posts' : FieldValue.arrayUnion([postRef.id])
  //     });
  //   } catch(e){
  //     debugPrint('FIRESTORE POST ADD ERROR> ${e.toString()}');
  //   }
  // }
  
  // Stream<QuerySnapshot<Map<String,dynamic>>> getUserPosts({required List<String> postIds}) {
  //   return _instance.collection('posts').where(FieldPath.documentId,whereIn: postIds).snapshots();
  // }


  Stream<QuerySnapshot> getFollowingPosts({required List<String> following}){
      return _instance.collectionGroup('posts').where(
          'author', whereIn: following).snapshots();
  }

  Future addPostRating({required Map<String, Object?> data, required String id, required String email}) async{
    await _instance.collection('users').doc(email).collection('posts').doc(id).update(data);
    await _instance.collection('users').doc(this.email).update({
      'ratedPosts':FieldValue.arrayUnion([id])
    });
  }

  Future removePostRating({required Map<String,Object?> data, required String id, required String email}) async{
    await _instance.collection('users').doc(email).collection('posts').doc(id).update(data);
    await _instance.collection('users').doc(this.email).update({
      'ratedPosts':FieldValue.arrayRemove([id])
    });
  }

  Future addCommentToPost({required Map<String,Object?> data, required String id, required String email}) async{
    await _instance.collection('users').doc(email).collection('posts').doc(id).collection('comments').doc().set(data);
  }

  Stream<DocumentSnapshot> userPostStream({required String email, required String id}){
    return _instance.collection('users').doc(email).collection('posts').doc(id).snapshots();
  }

  Stream<QuerySnapshot> commentsStream({required String email, required String postId}){
    return _instance.collection('users').doc(email).collection('posts').doc(postId).collection('comments').snapshots();
  }

  Future updateComment ({required Map<String, Object?> data, required String email, required String postId, required String commentId}) async{
    await _instance.collection('users').doc(email).collection('posts').doc(postId).collection('comments').doc(commentId).update(data);
  }
}