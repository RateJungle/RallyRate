import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:rally_rate/firebase_authentication/auth_firebase.dart';
import 'package:rally_rate/firebase_cloud_firestore/firestore.dart';
import 'package:rally_rate/models/comment.dart';

class CommentItem extends StatefulWidget {
  final Comment comment;

  const CommentItem({Key? key, required this.comment}) : super(key: key);

  @override
  State<CommentItem> createState() => _CommentItemState();
}

class _CommentItemState extends State<CommentItem> {
  @override
  Widget build(BuildContext context) {
    final comment = widget.comment;
    final ratingsMap = comment.ratings ?? {};
    final ratings = ratingsMap.values.toList();
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: (comment.authorImageURL == null)
            ? const AssetImage('assets/avatar.png')
            : NetworkImage(comment.authorImageURL!) as ImageProvider,
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            comment.author,
            style: const TextStyle(
                color: Colors.black, fontWeight: FontWeight.bold),
          ),
          Text(
            comment.comment,
            softWrap: true,
          ),
          const SizedBox(
            height: 5,
          ),
          Row(
            children: [
              RatingBarIndicator(
                  itemSize: 15,
                  rating: double.parse(_getAvgRating(ratings)),
                  itemBuilder: (context, _) {
                    return const Icon(
                      Icons.star,
                      color: Colors.amber,
                    );
                  }),
              const SizedBox(
                width: 5,
              ),
              Text(
                _getAvgRating(ratings),
              ),
            ],
          )
        ],
      ),
      trailing: IconButton(
        onPressed: isRated(comment)
            ? () async {
                await _removeRating(comment);
              }
            : () {
                _showRatingsDialog(comment);
              },
        icon: isRated(comment)
            ? Icon(
                Icons.star,
                color: Colors.amber,
              )
            : Icon(Icons.star_border_outlined),
      ),
    );
  }

  Future _removeRating(Comment comment) async {
    final ratingsMap = comment.ratings ?? {};
    final email = AuthService().currentUserEmail;
    ratingsMap.remove(email);
    final data = {'ratings': ratingsMap};
    await FirestoreOperations().updateComment(
        data: data,
        email: comment.postAuthorEmail,
        postId: comment.postId,
        commentId: comment.id!);
  }

  String _getAvgRating(List<double> ratings) {
    if (ratings.isEmpty) {
      return '0';
    }
    final double avgRating =
        ratings.reduce((value, element) => value + element) / ratings.length;
    return avgRating.toStringAsFixed(1);
  }

  _showRatingsDialog(Comment comment) {
    showDialog(
      context: context,
      builder: (context) => Center(
        child: Container(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: RatingBar.builder(
                itemCount: 5,
                initialRating: 0,
                allowHalfRating: false,
                itemBuilder: (context, _) => const Icon(
                      Icons.star,
                      color: Colors.amber,
                    ),
                onRatingUpdate: (rating) async {
                  final ratingsMap = comment.ratings ?? {};
                  final email = AuthService().currentUserEmail;
                  ratingsMap[email] = rating;
                  final data = {'ratings': ratingsMap};
                  await FirestoreOperations().updateComment(
                      data: data,
                      email: comment.postAuthorEmail,
                      postId: comment.postId,
                      commentId: comment.id!);
                  Navigator.of(context).pop();
                }),
          ),
        ),
      ),
    );
  }

  bool isRated(Comment comment) {
    final ratings = comment.ratings ?? {};
    final peopleWhoRated = ratings.keys.toList();
    final email = AuthService().currentUserEmail;
    return peopleWhoRated.contains(email);
  }
}
