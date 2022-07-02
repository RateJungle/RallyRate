import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:animation_wrappers/animation_wrappers.dart';
import 'package:rally_rate/firebase_cloud_firestore/firestore.dart';
import 'package:rally_rate/models/user.dart';
import 'package:rally_rate/screens/app_auth/sign_in.dart';
import 'package:rally_rate/screens/app_navigation/user_profile.dart';
import 'package:rally_rate/firebase_authentication/auth_firebase.dart';

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({Key? key}) : super(key: key);

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final String email = AuthService().currentUserEmail;
    return SafeArea(
      child: StreamBuilder<DocumentSnapshot>(
        stream: FirestoreOperations(email: email).userData,
        builder: (context, snapshot) {
          if(!snapshot.hasData){
            return Container(
              color: Colors.white,
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
          final UserModel user = UserModel.fromDocumentSnapshot(snapshot.data!);
          return Container(
            width: 225,
            color: Colors.white,
            height: mediaQuery.size.height,
            child: Drawer(
              child: FadedSlideAnimation(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 30),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Align(
                            alignment: Alignment.topRight,
                            child: GestureDetector(
                              onTap: (){
                                Navigator.of(context).pop();
                              },
                              child: const Icon(
                                Icons.close,
                                color: Colors.red,
                              ),
                            ),
                          ),
                          const SizedBox(height: 40,),
                          FadedScaleAnimation(
                              child: const CircleAvatar(
                                radius: 35,
                                backgroundColor: Colors.white,
                                backgroundImage: AssetImage('assets/avatar.png'),   //TODO: change when integrate cloud firestore
                              )
                          ),
                          const SizedBox(height: 20,),
                          Text(
                            user.name,
                            style: TextStyle(
                              color: Colors.grey[800],
                              fontSize: 15
                            ),
                          ),
                          const SizedBox(height: 50,),
                          GestureDetector(
                            onTap: (){
                              Navigator.of(context).push(_createPageRoute(const UserProfile()));
                            },
                            child: const Text(
                              'View Profile',
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 17
                              ),
                            ),
                          ),
                          const SizedBox(height: 25,),
                          GestureDetector(
                            onTap: (){
                              //TODO: open settings screen
                            },
                            child: const Text(
                              'Settings',
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                  fontSize: 17
                              ),
                            ),
                          ),
                          const SizedBox(height: 25,),
                          GestureDetector(
                            onTap: () async {
                              showProgressDialog();
                              await AuthService().signOut();
                              Navigator.of(context, rootNavigator: true)
                                  .pop();
                              Navigator.of(context).pushAndRemoveUntil(
                                  _createPageRoute(const SignIn()),
                                      (route) => false);
                            },
                            child: const Text(
                              'Logout',
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                  fontSize: 17
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  beginOffset: Offset(0, 0.3),
                  endOffset: Offset(0, 0),
                  slideCurve: Curves.linearToEaseOut,
              )
            )
          );
        }
      ),
    );
  }
  Route _createPageRoute(Widget screen) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => screen,
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

  void showProgressDialog() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: CircularProgressIndicator(),
        ));
  }
}
