import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:rally_rate/components/comment_item.dart';
import 'package:rally_rate/components/comments_widget.dart';
import 'package:rally_rate/firebase_authentication/auth_firebase.dart';
import 'package:rally_rate/firebase_cloud_firestore/firestore.dart';
import 'package:rally_rate/models/comment.dart';
import 'package:rally_rate/models/post.dart';
import 'package:rally_rate/models/user.dart';

class PostItem extends StatefulWidget {
  final Post post;
  final List<String> ratedPosts;
  final bool self;

  const PostItem(
      {Key? key,
      required this.post,
      required this.ratedPosts,
      required this.self})
      : super(key: key);

  @override
  State<PostItem> createState() => _PostItemState();
}

class _PostItemState extends State<PostItem> with TickerProviderStateMixin {
  late final AnimationController _controller;
  final TextEditingController _commentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller = BottomSheet.createAnimationController(this);

    // Animation duration for displaying the BottomSheet
    _controller.duration = const Duration(milliseconds: 500);

    // Animation duration for retracting the BottomSheet
    _controller.reverseDuration = const Duration(milliseconds: 300);
    // Set animation curve duration for the BottomSheet
    _controller.drive(CurveTween(curve: Curves.bounceInOut));
  }

  @override
  Widget build(BuildContext context) {
    final post = widget.post;
    final ratedPosts = widget.ratedPosts;
    int currentRating = 0;
    final self = widget.self;
    final email = AuthService().currentUserEmail;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          getTimeDifference(post.uploadTime),
          style: TextStyle(color: Colors.grey[400], fontSize: 12),
        ),
        const SizedBox(
          height: 10,
        ),
        Row(
          children: [
            CircleAvatar(
              backgroundImage: (post.userImage == null)
                  ? const AssetImage('assets/avatar.png')
                  : NetworkImage(post.userImage!) as ImageProvider,
            ),
            const SizedBox(
              width: 10,
            ),
            Text(
              post.authorName,
              style: const TextStyle(
                  fontWeight: FontWeight.bold, color: Colors.black),
            ),
            const Spacer(),
            TextButton.icon(
                onPressed: () {
                  final ratings = post.ratings!;
                  final ratingKeys = ratings.keys.toList();
                  showDialog(
                      context: context,
                      builder: (context) => Center(
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Container(
                                color: Colors.white,
                                child: Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: ListView.builder(
                                      shrinkWrap: true,
                                      itemCount: ratingKeys.length,
                                      itemBuilder: (context, index) {
                                        return Row(
                                          children: [
                                            Text(
                                              ratingKeys[index],
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            const Spacer(),
                                            const Icon(Icons.star,
                                                color: Colors.amber),
                                            Text(
                                              ratings[ratingKeys[index]]
                                                  .toString(),
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            )
                                          ],
                                        );
                                      }),
                                ),
                              ),
                            ),
                          ));
                },
                icon: Icon(
                  Icons.star,
                  color: Colors.amber,
                ),
                label: Text(
                  _getAvgRating(post.ratings!.values.toList()),
                  style: const TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                ))
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        Center(
          child: Container(
            color: Colors.black,
            child: Image.network(
              post.imageURL,
              scale: 1.5,
            ),
          ),
        ),
        Row(
          children: [
            IconButton(
                onPressed: (self)
                    ? null
                    : (ratedPosts.contains(post.id))
                        ? () async {
                            final map = post.ratings!;
                            map.remove(post.author);
                            final data = {'ratings': map};
                            await FirestoreOperations(email: email)
                                .removePostRating(
                                    data: data,
                                    id: post.id!,
                                    email: post.author);
                          }
                        : () {
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
                                          currentRating = rating.round();
                                          debugPrint(
                                              'Current Rating: $currentRating');
                                          final map = post.ratings!;
                                          map[email] = rating;
                                          final data = {'ratings': map};
                                          debugPrint(
                                              'RATINGS MAP: ${map.toString()}');
                                          debugPrint('POST ID: ${post.id}');
                                          await FirestoreOperations(
                                                  email: email)
                                              .addPostRating(
                                                  data: data,
                                                  id: post.id!,
                                                  email: post.author);
                                          Navigator.of(context).pop();
                                        }),
                                  ),
                                ),
                              ),
                            );
                          },
                iconSize: 32,
                icon: (self)
                    ? Icon(
                        Icons.star,
                        color: Colors.grey,
                      )
                    : (ratedPosts.contains(post.id))
                        ? Icon(Icons.star, color: Colors.amber)
                        : Icon(
                            Icons.star_border_outlined,
                          )),
            IconButton(
                onPressed: () {
                  _showComments(post);
                },
                icon: Icon(Icons.mode_comment_outlined)),
            IconButton(
                onPressed: () {
                  //TODO: add share code
                },
                icon: Icon(Icons.ios_share)),
          ],
        ),
        const Padding(
          padding: const EdgeInsets.only(left: 10),
          child: Text(
            //'${post.views} views',
            '1 view', //TODO: count the number of views
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  void _showComments(Post post) {
    showModalBottomSheet(
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        backgroundColor: Colors.white,
        context: context,
        transitionAnimationController: _controller,
        builder: (context) {
          return CommentWidget(postId: post.id!, postAuthorEmail: post.author,);
        });
  }


  String getTimeDifference(DateTime uploadTime) {
    final now = DateTime.now();
    final difference = now.difference(uploadTime);
    if (difference.inSeconds < 60) {
      return '${difference.inSeconds} seconds ago';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} minutes ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} hours ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      final months = [
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'May',
        'Jun',
        'Jul',
        'Aug',
        'Sept',
        'Oct',
        'Nov',
        'Dec'
      ];
      return '${months[uploadTime.month - 1]} ${uploadTime.day}';
    }
  }

  String _getAvgRating(List<double> ratings) {
    if (ratings.isEmpty) {
      return '0';
    }
    final double avgRating =
        ratings.reduce((value, element) => value + element) / ratings.length;
    return avgRating.toStringAsFixed(1);
  }
}
