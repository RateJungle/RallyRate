import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rally_rate/firebase_authentication/auth_firebase.dart';
import 'package:rally_rate/firebase_cloud_firestore/firestore.dart';
import 'package:rally_rate/models/post.dart';
import 'package:rally_rate/screens/app_navigation/post_view.dart';

class ProfileGridView extends StatefulWidget {
  const ProfileGridView({Key? key}) : super(key: key);

  @override
  State<ProfileGridView> createState() => _ProfileGridViewState();
}

class _ProfileGridViewState extends State<ProfileGridView> {

  @override
  Widget build(BuildContext context) {
    final String email = AuthService().currentUserEmail;
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: StreamBuilder<QuerySnapshot>(
        stream: FirestoreOperations(email: email).getUserPosts,
        builder: (context, snapshot) {
          if(!snapshot.hasData){
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          final docs = snapshot.data!.docs;
          return GridView.builder(
                shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 5,
                    mainAxisSpacing: 5
                  ),
                itemCount: docs.length,
                itemBuilder: (BuildContext context, int index) {
                  final item = docs[index];
                  final post = Post.fromQueryDocumentSnapshot(item);
                    return InkWell(
                      onTap: (){
                        Navigator.of(context).push(_createPageRoute(post));
                      },
                      child: Container(
                        color: Colors.grey[200],
                        child: Image.network(post.imageURL,fit: BoxFit.cover,),
                      ),
                    );
                },
              );
        }
      )
    );
  }
  Route _createPageRoute(Post post) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => PostView(post: post),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 1.0);
        const end = Offset.zero;
        final tween = Tween(begin: begin, end: end);
        final offsetAnimation = animation.drive(tween);

        return SlideTransition(
          position: offsetAnimation,
          child: child,
        );
      },
    );
  }
}
