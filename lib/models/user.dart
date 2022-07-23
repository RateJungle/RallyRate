import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String name;
  String email;
  String phone;
  String username;
  String gender;
  List<String>? followers;
  List<String>? following;
  List<String>? friends;
  List<String>? posts;
  String? bio;
  String? imageUrl;
  List<String>? ratedPosts;

  UserModel(
      {required this.name,
      required this.email,
      required this.phone,
      required this.username,
      required this.gender,
      this.followers,
      this.following,
      this.friends,
      this.posts,
      this.bio,
        this.ratedPosts,
      this.imageUrl});

  Map<String, dynamic> toMap() => {
        'name': name,
        'phone': phone,
        'username': username,
        'gender': gender,
        'followers': followers,
        'following': following,
        'friends': friends,
        'posts': posts,
    'bio': bio,
    'imageUrl': imageUrl,
    'ratedPosts':ratedPosts ?? []
      };

  static UserModel fromDocumentSnapshot(DocumentSnapshot documentSnapshot) {
    return UserModel(
        name: documentSnapshot.get('name').toString(),
        email: documentSnapshot.id,
        phone: documentSnapshot.get('phone').toString(),
        username: documentSnapshot.get('username').toString(),
        gender: documentSnapshot.get('gender').toString(),
        ratedPosts: List<String>.from(documentSnapshot.get('ratedPosts') ?? []),
        followers: (documentSnapshot.get('followers') == null)
            ? <String>[]
            : List<String>.from(documentSnapshot.get('followers')),
        following: (documentSnapshot.get('following') == null)
            ? <String>[]
            : List<String>.from(documentSnapshot.get('following')),
        friends: (documentSnapshot.get('friends') == null)
            ? <String>[]
            : List<String>.from(documentSnapshot.get('friends')),
        posts: (documentSnapshot.get('posts') == null)
            ? <String>[]
            : List<String>.from(documentSnapshot.get('posts')),
        bio: (documentSnapshot.get('bio') == null)
            ? 'No bio yet'
            : documentSnapshot.get('bio'),
        imageUrl: documentSnapshot.get('imageUrl'));
  }
}
