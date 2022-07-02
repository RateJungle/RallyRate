import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rally_rate/screens/app_auth/reset_password.dart';
import 'package:rally_rate/screens/app_auth/sign_up.dart';
import 'package:rally_rate/screens/app_auth/verify_email.dart';
import 'package:rally_rate/firebase_authentication/auth_firebase.dart';
import 'package:rally_rate/components/string_codes.dart';
import 'package:rally_rate/screens/home/home.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isHidden = true;
  bool _hasErrors = true;
  final AuthService _auth = AuthService();

  void _togglePasswordView() {
    setState(() {
      _isHidden = !_isHidden;
    });
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final bHeight = mediaQuery.size.height - mediaQuery.padding.top;
    final FocusNode emailFocusNode = FocusNode();
    return Scaffold(
        body: SafeArea(
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(

            children: [
              const SizedBox(height: 50,),
              Image.asset(
                "assets/logo/6.png",
                scale: 2.0,
              ),
              const SizedBox(height: 50,),
              Padding(
                padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                child: TextFormField(
                  //focusNode: emailFocusNode,
                  validator: (value) => _isValidEmail(value?.trim())
                      ? null
                      : 'Please enter a valid email',
                  controller: _emailController,
                  decoration: const InputDecoration(
                      labelText: "Email",
                      border: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey))),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                child: TextFormField(
                  //focusNode: emailFocusNode,
                  controller: _passwordController,
                  enableSuggestions: false,
                  autocorrect: false,
                  obscureText: _isHidden,
                  validator: (value) => _isInputEmpty(value)
                      ? 'This field cannot be empty'
                      : null,
                  decoration: InputDecoration(
                    suffixIcon: IconButton(
                        onPressed: _togglePasswordView,
                        icon: Icon(_isHidden
                            ? Icons.visibility
                            : Icons.visibility_off)),
                    labelText: "Password",
                    labelStyle: const TextStyle(
                        //color: emailFocusNode.hasFocus? Colors.red : Colors.grey,
                        ),
                    border: const OutlineInputBorder(),
                    focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey)),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 10),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                      onPressed: () {
                        Navigator.of(context).push(
                            _createPageRoute(const ResetPasswordScreen()));
                      },
                      child: const Text(
                        'Forgot your password?',
                        style: TextStyle(color: Colors.green),
                      )),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                      onPressed: () async {
                        final FormState form = _formKey.currentState!;
                        if (form.validate()) {
                          showProgressDialog();
                          String result =
                              await _auth.signInWithEmailAndPassword(
                                  email: _emailController.value.text.trim(),
                                  password: _passwordController.value.text);
                          Navigator.of(context, rootNavigator: true).pop();
                          if (result == Codes.SUCCESS) {

                            if (_isEmailVerified()) {
                              Navigator.of(context).pushAndRemoveUntil(
                                  _createPageRoute(const Home()),
                                  (route) => false);
                              debugPrint('Signed In');
                            } else {
                              Navigator.of(context).pushAndRemoveUntil(
                                  _createPageRoute(const VerifyEmailScreen()),
                                  (route) => false);
                            }
                          } else if (result == Codes.USER_NOT_FOUND) {
                            _showSnackBar(
                                'User does not exist with this email');
                          } else if (result == Codes.WRONG_PASSWORD) {
                            _showSnackBar('Password does not match');
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Colors.green,
                      ),
                      icon: const Icon(
                        Icons.vpn_key,
                        color: Colors.white,
                      ),
                      label: const Text('Sign In',
                          style: TextStyle(color: Colors.white))),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const Divider(
                    height: 20,
                    thickness: 1,
                    color: Colors.grey,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('New to Rally Rate?'),
                      TextButton(
                          onPressed: () {
                            Navigator.of(context)
                                .push(_createPageRoute(const SignUp()));
                          },
                          child: Text(
                            'Get yourself registered!',
                            style: TextStyle(color: Colors.green),
                          ))
                    ],
                  )
                ],
              )
            ],
          ),
        ),
      ),
    ));
  }

  void showProgressDialog() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: CircularProgressIndicator(),
        ));
  }

  bool _isEmailVerified() {
    final user = FirebaseAuth.instance.currentUser!;
    if (user.emailVerified) {
      return true;
    }
    return false;
  }

  void _showSnackBar(String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(text),
      backgroundColor: Colors.red,
    ));
  }

  bool _isInputEmpty(String? input) {
    if (input == null) {
      return true;
    } else if (input.isEmpty) {
      return true;
    }
    return false;
  }

  bool _isValidEmail(String? email) {
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
