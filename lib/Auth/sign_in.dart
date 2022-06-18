import 'package:flutter/material.dart';
import 'package:rally_rate/Auth/sign_up.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  bool _isHidden = true;
  bool _hasErrors = true;

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
        child: Column(
          children: [
            Image.asset(
              "assets/logo.png",
              scale: 1.0,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10.0, right: 10.0),
              child: TextFormField(
                //focusNode: emailFocusNode,
                controller: _emailController,
                decoration: InputDecoration(
                  errorText: _isValidEmail(_emailController.value.text) ? null : 'Please enter a valid email',
                    labelText: "Email",
                    labelStyle: const TextStyle(
                        //color: emailFocusNode.hasFocus? Colors.red : Colors.grey,
                        ),
                    border: const OutlineInputBorder(),
                    focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red))),
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
                decoration: InputDecoration(
                  errorText: _isInputEmpty(_passwordController.value.text) ? 'This field cannot be empty':null,
                  suffixIcon: IconButton(
                      onPressed: _togglePasswordView,
                      icon: Icon(
                          _isHidden ? Icons.visibility : Icons.visibility_off)),
                  labelText: "Password",
                  labelStyle: const TextStyle(
                      //color: emailFocusNode.hasFocus? Colors.red : Colors.grey,
                      ),
                  border: const OutlineInputBorder(),
                  focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.red)),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                    onPressed: () {},
                    child: const Text(
                      'Forgot your password?',
                      style: TextStyle(color: Colors.red),
                    )),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                    onPressed: _hasErrors ? null:(){},
                    style: ElevatedButton.styleFrom(
                      primary: Colors.red,
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
                          Navigator.of(context).push(_createPageRoute());
                        },
                        child: Text(
                          'Get yourself registered!',
                          style: TextStyle(color: Colors.red),
                        ))
                  ],
                )
              ],
            )
          ],
        ),
      ),
    ));
  }

  bool _isInputEmpty(String input){
    if(input.isEmpty){
      _hasErrors = true;
      return true;
    }
    _hasErrors = false;
    return false;
  }
  bool _isValidEmail(String? email) {
    if(email == null || email.isEmpty){
      _hasErrors=true;
      return false;
    }
    if(RegExp(
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(email)){
      _hasErrors = false;
      return true;
    }
    return false;
  }

  Route _createPageRoute() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => const SignUp(),
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
