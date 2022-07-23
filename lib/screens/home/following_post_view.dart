import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rally_rate/components/post_item_view.dart';
import 'package:rally_rate/firebase_authentication/auth_firebase.dart';
import 'package:rally_rate/firebase_cloud_firestore/firestore.dart';
import 'package:rally_rate/models/post.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class Following extends StatefulWidget {
  final List<String> following;
  final List<String> ratedPosts;
  const Following({Key? key, required this.following, required this.ratedPosts}) : super(key: key);

  @override
  State<Following> createState() => _FollowingState();
}

class _FollowingState extends State<Following> {
  int currentRating = 0;
  @override
  Widget build(BuildContext context) {
    final following = widget.following;
    final email = AuthService().currentUserEmail;
    final ratedPosts = widget.ratedPosts;
    return StreamBuilder<QuerySnapshot>(
      stream: FirestoreOperations(email: email).getFollowingPosts(following: following),
      builder: (context, snapshot) {
        if(!snapshot.hasData){
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        final postList = snapshot.data!.docs;
        final idList = postList.map((e) => e.id).toList();
        debugPrint('Post id list: $idList');
        return Padding(
          padding: const EdgeInsets.all(10.0),
          child: ListView.builder(
            itemCount: postList.length,
              shrinkWrap: true,
              itemBuilder: (context, index){
                final post = Post.fromQueryDocumentSnapshot(postList[index]);
                return PostItem(post: post, ratedPosts: ratedPosts, self: false,);
              }
          ),
        );
      }
    );
  }

}
