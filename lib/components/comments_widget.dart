import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rally_rate/models/comment.dart';
import 'package:rally_rate/models/post.dart';
import 'package:rally_rate/models/user.dart';

import 'package:rally_rate/firebase_authentication/auth_firebase.dart';
import 'package:rally_rate/firebase_cloud_firestore/firestore.dart';
import 'comment_item.dart';

class CommentWidget extends StatefulWidget {
  final String postId;
  final String postAuthorEmail;
  const CommentWidget({Key? key, required this.postId, required this.postAuthorEmail}) : super(key: key);

  @override
  State<CommentWidget> createState() => _CommentWidgetState();
}

class _CommentWidgetState extends State<CommentWidget> {
  final TextEditingController _commentController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final postId = widget.postId;
    final postAuthorEmail = widget.postAuthorEmail;
    final mediaQuery = MediaQuery.of(context);
    final height = mediaQuery.size.height - mediaQuery.padding.top;
    return Padding(
      padding: EdgeInsets.fromLTRB(
          10, 10, 10, MediaQuery.of(context).viewInsets.bottom),
      child: StreamBuilder<QuerySnapshot>(
        stream: FirestoreOperations().commentsStream(email: postAuthorEmail, postId: postId),
        builder: (context, snapshot) {
          if(!snapshot.hasData){
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          final commentDocs = snapshot.data!.docs;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 40,
                child: TextButton.icon(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  style: ButtonStyle(
                    overlayColor:
                    MaterialStateProperty.all(Colors.transparent),
                  ),
                  label: Text(
                    'Comments',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                  icon: Icon(
                    Icons.keyboard_arrow_down,
                    size: 32,
                    color: Colors.black,
                  ),
                ),
              ),
              SizedBox(
                height: (height - 50 - 40) * 0.5,
                child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: commentDocs.length,
                    itemBuilder: (context, index) {
                      final comment = Comment.fromQueryDocumentSnapshot(snapshot: commentDocs[index]);
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: CommentItem(comment: comment),
                      );
                    }),
              ),
              const Divider(),
              SizedBox(
                height: 50,
                child: ListTile(
                  title: TextField(
                    controller: _commentController,
                    textAlign: TextAlign.start,
                    textCapitalization: TextCapitalization.sentences,
                    autofocus: true,
                    decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Write a comment...'),
                  ),
                  trailing: IconButton(
                    onPressed: () async {
                      _showProgressDialog();
                      final email = AuthService().currentUserEmail;
                      final db = FirestoreOperations(email: email);

                      final userData = await db.getUserData();
                      if (userData == null) {
                        Navigator.of(context, rootNavigator: true).pop();
                        return;
                      }
                      final user = UserModel.fromDocumentSnapshot(userData);
                      final comment = Comment(
                          author: user.name,
                          comment: _commentController.value.text,
                          commentTime: DateTime.now(),
                          authorEmail: email,
                          authorImageURL: user.imageUrl,
                        postId: postId,
                        postAuthorEmail: postAuthorEmail
                      );
                      final map = comment.toMap();
                      await db.addCommentToPost(data: map, id: postId, email: postAuthorEmail);
                      Navigator.of(context, rootNavigator: true).pop();
                      _commentController.clear();
                    },
                    icon: const Icon(
                      Icons.send,
                      color: Colors.black,
                    ),
                  ),
                ),
              )
            ],
          );
        }
      ),
    );
  }
  void _showProgressDialog() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: CircularProgressIndicator(),
        ));
  }
}
