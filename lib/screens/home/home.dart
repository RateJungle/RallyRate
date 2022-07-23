import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rally_rate/components/custom_drawer.dart';
import 'package:rally_rate/components/expandable_fab/action_button.dart';
import 'package:rally_rate/components/expandable_fab/expanded_fab.dart';
import 'package:rally_rate/firebase_authentication/auth_firebase.dart';
import 'package:rally_rate/firebase_cloud_firestore/firestore.dart';
import 'package:rally_rate/models/user.dart';
import 'package:rally_rate/screens/app_navigation/gallery_image_screen.dart';
import 'package:rally_rate/screens/app_navigation/write_screen.dart';
import 'package:rally_rate/screens/home/following_post_view.dart';
import 'dart:io';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final email = AuthService().currentUserEmail;
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.white,
        endDrawer: const CustomDrawer(),
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Image.asset('assets/logo/app_text.png', scale: 1.8,),
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: false,
          bottom:  TabBar(
            indicatorColor: Colors.green,
              tabs: [
                Icon(Icons.search,color: Colors.grey[800],),
                Text(
                  'Following',
                  style: TextStyle(
                    color: Colors.grey[800],
                  ),
                ),
                Text(
                  'Trending',
                  style: TextStyle(
                    color: Colors.grey[800],
                  ),
                )
              ]
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                onTap: (){
                  _openEndDrawer();
                },
                child: const CircleAvatar(
                  backgroundImage: AssetImage('assets/avatar.png',),
                  backgroundColor: Colors.white,
                ),
              ),
            )
          ],
        ),
        body: StreamBuilder<DocumentSnapshot>(
          stream: FirestoreOperations(email: email).userData,
          builder: (context, snapshot) {
            if(!snapshot.hasData){
              return Center(
                child: CircularProgressIndicator(),
              );
            }

            final user = UserModel.fromDocumentSnapshot(snapshot.data!);
            return TabBarView(
                children: [
                  Center(child: Text('Search')),
                  Following(following: user.following ?? [],ratedPosts: user.ratedPosts ?? [],),
                  Center(child: Text('Trending'))
                ]
            );
          }
        ),
        floatingActionButton: ExpandableFab(
          distance: 112.0,
          children: [
            ActionButton(
              onPressed: () {},
              icon: const Icon(Icons.videocam),
            ),
            ActionButton(
              onPressed: () {},
              icon: const Icon(Icons.camera_alt),
            ),
            ActionButton(
              onPressed: () async {
                final File? imagePath = await _pickImage();
                if(imagePath == null){
                  return;
                }
                debugPrint('imagePath: ${imagePath ?? 'no path'}');
                Navigator.of(context).push(_createPageRoute(GalleryImageScreen(imagePath: imagePath!)));
              },
              icon: const Icon(Icons.insert_photo),
            ),
            ActionButton(
              onPressed: () {
                Navigator.of(context).push(_createPageRoute(const WriteScreen()));
              },
              icon: const Icon(Icons.edit),
            ),
          ],
        ),
      ),
    );
  }

  Future<File?> _pickImage() async {
    try{
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if(image == null) return null;
      final imageFile = File(image.path);
      return imageFile;
    } on PlatformException catch(e){
      debugPrint('Platform exception: ${e.toString()}');
      return null;
    }
  }

  void _openEndDrawer() {
    _scaffoldKey.currentState!.openEndDrawer();
  }

  Route _createPageRoute(Widget widget) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => widget,
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
