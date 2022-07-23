import 'package:animation_wrappers/animation_wrappers.dart';
import 'package:flutter/material.dart';
import 'dart:io';

import 'package:rally_rate/firebase_authentication/auth_firebase.dart';
import 'package:rally_rate/firebase_cloud_firestore/firestore.dart';
import 'package:rally_rate/firebase_storage_operations/storage.dart';
import 'package:rally_rate/models/post.dart';
import 'package:rally_rate/models/user.dart';

class GalleryImageScreen extends StatefulWidget {
  final File imagePath;
  const GalleryImageScreen({Key? key, required this.imagePath}) : super(key: key);

  @override
  State<GalleryImageScreen> createState() => _GalleryImageScreenState();
}

class _GalleryImageScreenState extends State<GalleryImageScreen> with TickerProviderStateMixin{
  final Storage storage = Storage();

  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = BottomSheet.createAnimationController(this);

    // Animation duration for displaying the BottomSheet
    _controller.duration = const Duration(milliseconds: 500);

    // Animation duration for retracting the BottomSheet
    _controller.reverseDuration = const Duration(milliseconds: 500);
    // Set animation curve duration for the BottomSheet
    _controller.drive(CurveTween(curve: Curves.bounceInOut));
  }
  @override
  Widget build(BuildContext context) {
    final imagePath = widget.imagePath;
    return SafeArea(
      child: Scaffold(
        body: Container(
          color: Colors.grey[300],
          child: Image.file(imagePath,),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            _showPostingOptions(imagePath);
          },
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          splashColor: Colors.transparent,
          label: Text('Send to'),
          icon: Icon(Icons.chevron_right),
        ),
      ),
    );
  }
  void _showPostingOptions(File imagePath) {
    showModalBottomSheet(
        context: context,
        transitionAnimationController: _controller,
        builder: (builder) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: FadedSlideAnimation(
              beginOffset: Offset(0, 0.3),
              endOffset: Offset(0, 0),
              slideCurve: Curves.linearToEaseOut,
              child: Wrap(
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: TextButton(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Coming soon')));
                          },
                          child: Text(
                            'Create story',
                            textAlign: TextAlign.start,
                            style: TextStyle(color: Colors.black, fontSize: 16),
                          )),
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: TextButton(
                          onPressed: () async {
                            Navigator.of(context).pop();
                            _showProgressDialog();
                            await _createPost(imagePath);
                            Navigator.of(context, rootNavigator: true).pop();
                            Navigator.of(context)
                                .popUntil((route) => route.isFirst);
                          },
                          child: Text(
                            'Create post',
                            style: TextStyle(color: Colors.black, fontSize: 16),
                          )),
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }

  Future _createPost(File imagePath) async {
    final _auth = AuthService();
    final email = _auth.currentUserEmail;
    final db = FirestoreOperations(email: email);
    final documentSnapshot = await db.getUserData();
    final user = UserModel.fromDocumentSnapshot(documentSnapshot!);
    String downloadURL = await storage.storeImage(imagePath, email) ?? 'N/A';
    final post = Post(
        author: email,
        uploadTime: DateTime.now(),
        imageURL: downloadURL,
        username: user.username,
        userImage: user.imageUrl,
        authorName: user.name
    );
    await FirestoreOperations(email: email).addToUserPosts(map: post.toMap());
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
