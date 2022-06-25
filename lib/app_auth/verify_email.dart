

import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rally_rate/firebase_authentication/auth_firebase.dart';
import 'package:rally_rate/home/home.dart';

class VerifyEmailScreen extends StatefulWidget {
  const VerifyEmailScreen({Key? key}) : super(key: key);

  @override
  State<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends State<VerifyEmailScreen> {
  bool _isEmailVerified = false;
  Timer? _timer;
  Timer? _countDown;
  int _currentTime = 30;
  bool _canResendEmail = false;
  final AuthService _auth = AuthService();

  @override
  void initState() {
    super.initState();

    _isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    debugPrint('EMAILLL>> ${FirebaseAuth.instance.currentUser!.email}');
    if (!_isEmailVerified) {
      _auth.sendVerificationEmail();

      _timer = Timer.periodic(
          Duration(seconds: 3), (_) => checkEmailVerified());
      startCountDown();
  }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _countDown?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          title: Text(
            'Verify Email',
            style: TextStyle(
                color: Colors.grey[800], fontWeight: FontWeight.bold),
          ),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Verification email has been sent to your email address. Please login to your email client and click the link provided in the sent email to complete email verification',
                ),
                const SizedBox(height: 15,),
                SizedBox(
                  width: double.infinity,
                  height: 24,
                  child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size.fromHeight(50),
                        primary: Colors.green,
                      ),
                      onPressed: _canResendEmail
                          ? () async {
                        _canResendEmail=false;
                        _currentTime=30;
                        startCountDown();
                        await _auth.sendVerificationEmail();

                      }
                      : null,
                      icon: _canResendEmail? const Icon(Icons.email_outlined,size: 32,) : Text('$_currentTime'),
                      label: const Text(
                        'Resend email', style: TextStyle(fontSize: 24),)
                  ),
                ),

              ],
            ),
          ),
        ),
      );

  void startCountDown() {
    _countDown = Timer.periodic(
        const Duration(seconds: 1),
            (timer) {
          if(_currentTime==0){
            setState((){
              timer.cancel();
              _canResendEmail=true;
            });
          }
          else{
            setState((){
              _currentTime--;
            });
          }
            });
  }



  Future checkEmailVerified() async {
    await FirebaseAuth.instance.currentUser!.reload();
    setState(() {
      _isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    });
    if (_isEmailVerified) {
      Navigator.of(context).pushAndRemoveUntil(_createPageRoute(const Home()),(route) => false);
      _timer?.cancel();
    }
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
