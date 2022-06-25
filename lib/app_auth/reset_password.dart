import 'dart:async';

import 'package:flutter/material.dart';
import 'package:rally_rate/firebase_authentication/auth_firebase.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final AuthService _auth = AuthService();
  final TextEditingController _emailController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isEmailSent = false;



  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) =>
      Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: false,
          leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: Icon(
              Icons.chevron_left,
              color: Colors.grey[800],
            ),
          ),
          title: Text(
            'Reset Password',
            style: TextStyle(
                color: Colors.grey[800], fontWeight: FontWeight.bold),
          ),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Receive an email to reset your password',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold

                    ),
                  ),
                  const SizedBox(height: 25,),
                  TextFormField(
                    //focusNode: emailFocusNode,
                    controller: _emailController,
                    validator: (input) => _isValidEmail(input?.trim())
                        ? null
                        : 'Please enter a valid email address',
                    decoration: const InputDecoration(
                        labelText: "Email",
                        labelStyle: TextStyle(
                          //color: emailFocusNode.hasFocus? Colors.red : Colors.grey,
                        ),
                        border: OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey))),
                  ),
                  const SizedBox(height: 15,),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          primary: Colors.green,
                        ),
                        onPressed: _isEmailSent? null : () async {
                          setState((){
                            _isEmailSent=true;
                          });
                          await _auth.sendPasswordResetEmail(_emailController.value.text.trim());
                          ScaffoldMessenger.of(context).showSnackBar(
                             const  SnackBar(
                                  content: Text('Password reset link sent to your email'),
                                backgroundColor: Colors.blue,
                              ));
                          Navigator.of(context).pop();
                        },
                        icon: Icon(Icons.email_outlined),
                        label: const Text(
                          'Reset Password',)
                    ),
                  ),

                ],
              ),
            ),
          ),
        ),
      );

  bool _isValidEmail(String? email) {
    debugPrint('inside _isInputEmpty');
    if (email == null || email.isEmpty) {
      return false;
    }
    if (RegExp(
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(email)) {
      return true;
    }
    return false;
  }


}
