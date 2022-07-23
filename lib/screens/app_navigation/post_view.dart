import 'package:flutter/material.dart';
import 'package:rally_rate/components/post_item_view.dart';
import 'package:rally_rate/models/post.dart';

class PostView extends StatefulWidget {
  final Post post;

  const PostView({Key? key, required this.post}) : super(key: key);

  @override
  State<PostView> createState() => _PostViewState();
}

class _PostViewState extends State<PostView> {
  @override
  Widget build(BuildContext context) {
    final post = widget.post;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(
              Icons.chevron_left,
              color: Colors.black,
            ),
          ),
          title: Text(
            '${post.username}\'s post',
            style: TextStyle(
              color: Colors.black,
            ),
          ),
          centerTitle: false,
        ),
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: PostItem(post: post, ratedPosts: [], self: true),
        ),
        // body: SingleChildScrollView(
        //   child: Padding(
        //     padding: const EdgeInsets.all(10.0),
        //     child: Column(
        //       crossAxisAlignment: CrossAxisAlignment.start,
        //       children: [
        //         Text(
        //           getTimeDifference(post.uploadTime),
        //           style: TextStyle(
        //               color: Colors.grey[400],
        //               fontSize: 12
        //           ),
        //         ),
        //         const SizedBox(
        //           height: 10,
        //         ),
        //         Row(
        //           children: [
        //             CircleAvatar(
        //               backgroundImage: AssetImage(post.userImage ?? 'assets/avatar.png'),
        //             ),
        //             const SizedBox(
        //               width: 10,
        //             ),
        //             Text(
        //               post.authorName,
        //               style: const TextStyle(
        //                   fontWeight: FontWeight.bold, color: Colors.black),
        //             ),
        //             const Spacer(),
        //             TextButton.icon(
        //                 onPressed: () {},
        //                 icon: Icon(Icons.star, color: Colors.amber,),
        //                 label: Text(
        //                   _getAvgRating(post.ratings!.values.toList()),
        //                   style: const TextStyle(
        //                     color: Colors.black,
        //                     fontWeight: FontWeight.bold
        //                   ),
        //                 )
        //             )
        //           ],
        //         ),
        //
        //
        //         const SizedBox(
        //           height: 10,
        //         ),
        //         Center(
        //           child: Container(
        //             color: Colors.black,
        //             child: Image.network(post.imageURL, scale: 1.5,),
        //           ),
        //         ),
        //
        //         Row(
        //           children: [
        //             IconButton(
        //                 onPressed: () {
        //                   //TODO: add rate code
        //                 },
        //                 iconSize: 32,
        //                 icon: Icon(Icons.star_border_outlined,)),
        //             IconButton(
        //                 onPressed: () {
        //                   //TODO: add comment code
        //                 },
        //
        //                 icon: Icon(Icons.mode_comment_outlined)),
        //             IconButton(
        //                 onPressed: () {
        //                   //TODO: add share code
        //                 },
        //                 icon: Icon(Icons.ios_share)
        //             ),
        //             const Spacer(),
        //             Text(
        //               '${post.views} views',
        //               style: TextStyle(
        //                   color: Colors.black,
        //                   fontWeight: FontWeight.bold
        //               ),
        //             ),
        //           ],
        //         ),
        //
        //       ],
        //     ),
        //   ),
        // ),
      ),
    );
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

  String _getAvgRating(List<double> ratings){
    if(ratings.isEmpty){
      return '0';
    }
    final double avgRating = ratings.reduce((value, element) => value+element)/ratings.length;
    return avgRating.toStringAsFixed(1);
  }
}
