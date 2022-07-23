import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  String? id;
  String author;
  DateTime uploadTime;
  Map<String, double>? ratings;
  int? views = 0;
  String imageURL;
  String? description;
  String username;
  String? userImage;
  String authorName;

  Post(
      {this.id,
      this.views,
      this.description,
        this.ratings,
      required this.username,
      required this.userImage,
      required this.authorName,
      required this.author,
      required this.uploadTime,
      required this.imageURL});

  Map<String, dynamic> toMap() => {
        'author': author,
        'uploadTime': uploadTime,
        'ratings': ratings,
        'views': views,
        'content': imageURL,
        'description': description,
    'username' : username,
    'userImage':userImage,
    'authorName': authorName,
      };

  static Post fromQueryDocumentSnapshot(QueryDocumentSnapshot snapshot) => Post(
      id: snapshot.id,
      author: snapshot.get('author'),
      imageURL: snapshot.get('content'),
      uploadTime: (snapshot.get('uploadTime') as Timestamp).toDate(),
      views: snapshot.get('views') ?? 0,
      description: snapshot.get('description'),
      username: snapshot.get('username'),
      userImage: snapshot.get('userImage'),
      authorName: snapshot.get('authorName'),
      ratings: Map<String,double>.from(snapshot.get('ratings') ?? {}),
      );

  static Post fromDocumentSnapshot(DocumentSnapshot snapshot) => Post(
      id: snapshot.id,
      author: snapshot.get('author'),
      imageURL: snapshot.get('content'),
      uploadTime: (snapshot.get('uploadTime') as Timestamp).toDate(),
      views: snapshot.get('views') ?? 0,
      description: snapshot.get('description'),
      username: snapshot.get('username'),
      userImage: snapshot.get('userImage'),
      authorName: snapshot.get('authorName'),
      ratings: Map<String,double>.from(snapshot.get('ratings') ?? {}),
      );
}
