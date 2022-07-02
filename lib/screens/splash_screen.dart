import 'dart:async';

import 'package:animation_wrappers/animation_wrappers.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rally_rate/firebase_authentication/auth_firebase.dart';
import 'package:rally_rate/screens/app_auth/sign_in.dart';
import 'package:rally_rate/screens/home/home.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}


class _SplashScreenState extends State<SplashScreen> {

  late Timer _timer;
  final AuthService _auth = AuthService();
  
  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {

    return StreamBuilder<User?>(
      stream: _auth.user,
      builder: (context, snapshot) {
        debugPrint('CONNECTION STATE: ${snapshot.connectionState.toString()}');
        if(snapshot.connectionState == ConnectionState.active && !snapshot.hasData){
          _timer = Timer(Duration(seconds: 3),
                  ()=>Navigator.of(context).pushAndRemoveUntil(_createPageRoute(const SignIn()), (route) => false)
          );
          debugPrint('No user found');
        } else if(snapshot.connectionState == ConnectionState.active && snapshot.hasData){
          _timer = Timer(Duration(seconds: 3),
                  ()=>Navigator.of(context).pushAndRemoveUntil(_createPageRoute(const Home()), (route) => false)
          );
          debugPrint('CURRENT USER EMAIL: ${snapshot.data!.email}');
        }
        return Container(
          color: Colors.white,
          child: FadedSlideAnimation(
            child: Center(
              child: Image.asset('assets/logo/1.png',scale: 3,),
            ),
            beginOffset: const Offset(0, 0.3),
            endOffset: const Offset(0, 0),
            slideCurve: Curves.linearToEaseOut,
          ),
        );
      }
    );
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
