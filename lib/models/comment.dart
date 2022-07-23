import 'package:cloud_firestore/cloud_firestore.dart';

class Comment {
  String? id;
  String postId;
  String author;
  String? authorImageURL;
  String authorEmail;
  String comment;
  Map<String, double>? ratings;
  DateTime commentTime;
  String postAuthorEmail;


  Comment({required this.author,
    required this.comment,
    this.ratings,
    this.id,
    required this.postAuthorEmail,
    required this.postId,
    required this.commentTime,
    required this.authorEmail,
    this.authorImageURL});

  Map<String, dynamic> toMap() =>
      {
        'author': author,
        'comment': comment,
        'ratings': ratings,
        'commentTime': commentTime,
        'authorImageURL': authorImageURL,
        'authorEmail': authorEmail,
        'postId' : postId,
        'postAuthorEmail' :postAuthorEmail
      };


  static Comment fromDocumentSnapshot({required DocumentSnapshot snapshot}) =>
      Comment(
        id: snapshot.id,
          author: snapshot.get('author'),
          comment: snapshot.get('comment'),
          commentTime: (snapshot.get('commentTime') as Timestamp).toDate(),
          authorEmail: snapshot.get('authorEmail'),
        authorImageURL: snapshot.get('authorImageURL'),
        ratings: Map<String,double>.from(snapshot.get('ratings') ?? {}),
        postId: snapshot.get('postId'),
        postAuthorEmail: snapshot.get('postAuthorEmail')
      );

  static Comment fromQueryDocumentSnapshot({required QueryDocumentSnapshot snapshot}) =>
      Comment(
          id: snapshot.id,
          author: snapshot.get('author'),
          comment: snapshot.get('comment'),
          commentTime: (snapshot.get('commentTime') as Timestamp).toDate(),
          authorEmail: snapshot.get('authorEmail'),
          authorImageURL: snapshot.get('authorImageURL'),
          ratings: Map<String,double>.from(snapshot.get('ratings') ?? {}),
          postId: snapshot.get('postId'),
        postAuthorEmail: snapshot.get('postAuthorEmail')
      );

  // static List<Map> commentListToMapList(List<Comment>? commentList) {
  //   commentList ??= [];
  //   return commentList!.map((e) => e.toMap()).toList();
  // }
  //
  // static List<Comment> mapListToCommentList(List<dynamic>? mapList) {
  //   if (mapList == null) {
  //     return [];
  //   }
  //   return mapList
  //       .map((map) =>
  //       Comment(
  //           author: map['author'],
  //           comment: map['comment'],
  //           ratings: map['ratings'],
  //           authorEmail: map['authorEmail'],
  //           authorImageURL: map['authorImageURL'],
  //           commentTime: (map['commentTime'] as Timestamp).toDate(),
  //       ))
  //       .toList();
  // }
}
