import 'package:flutter/material.dart';
import 'package:rally_rate/app_auth/verify_email.dart';
import 'package:rally_rate/firebase_authentication/auth_firebase.dart';
import 'package:rally_rate/components/string_codes.dart';
import 'package:rally_rate/firebase_cloud_firestore/firestore.dart';
import 'package:rally_rate/models/user.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isHidden = true;
  bool _isConfirmPasswordHidden = true;
  String _selectedGender = "Female";
  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          backgroundColor: Colors.white,
          toolbarHeight: 100,
          elevation: 0,
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'New User?',
                style: TextStyle(
                    color: Colors.grey[800], fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 6,
              ),
              Text(
                'Create a new account now!',
                style: TextStyle(color: Colors.grey[800], fontSize: 13),
              )
            ],
          ),
          leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: Icon(
              Icons.chevron_left,
              color: Colors.grey[800],
            ),
          )),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0),
                  child: TextFormField(
                    //focusNode: emailFocusNode,
                    controller: _nameController,
                    validator: (input) => _isInputEmpty(input)
                        ? 'This field cannot be left empty'
                        : null,
                    decoration: InputDecoration(
                        labelText: "Full Name",
                        labelStyle: TextStyle(
                            //color: emailFocusNode.hasFocus? Colors.red : Colors.grey,
                            ),
                        border: OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey))),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0),
                  child: TextFormField(
                    //focusNode: emailFocusNode,
                    controller: _usernameController,
                    validator: (input) => _isUsernameValid(input)
                        ? null
                        : 'Username should contain letters, numbers and symbols',
                    decoration: InputDecoration(
                        labelText: "Username",
                        labelStyle: TextStyle(
                            //color: emailFocusNode.hasFocus? Colors.red : Colors.grey,
                            ),
                        border: OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey))),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                  child: TextFormField(
                    //focusNode: emailFocusNode,
                    controller: _emailController,
                    validator: (input) => _isValidEmail(input?.trim())
                        ? null
                        : 'Please enter a valid email address',
                    decoration: InputDecoration(
                        labelText: "Email",
                        labelStyle: TextStyle(
                            //color: emailFocusNode.hasFocus? Colors.red : Colors.grey,
                            ),
                        border: OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey))),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                  child: TextFormField(
                    //focusNode: emailFocusNode,
                    controller: _passwordController,
                    enableSuggestions: false,
                    autocorrect: false,
                    obscureText: _isHidden,
                    validator: (input) => _isPasswordValid(input)
                        ? null
                        : 'Password should contain 8 characters minimum with numbers, letters and symbols',
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
                const SizedBox(
                  height: 15,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                  child: TextFormField(
                    //focusNode: emailFocusNode,
                    controller: _confirmPasswordController,
                    enableSuggestions: false,
                    autocorrect: false,
                    obscureText: _isConfirmPasswordHidden,
                    decoration: InputDecoration(
                      suffixIcon: IconButton(
                          onPressed: _toggleConfirmPasswordView,
                          icon: Icon(_isConfirmPasswordHidden
                              ? Icons.visibility
                              : Icons.visibility_off)),
                      labelText: "Confirm Password",
                      labelStyle: const TextStyle(
                          //color: emailFocusNode.hasFocus? Colors.red : Colors.grey,
                          ),
                      border: const OutlineInputBorder(),
                      focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey)),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  child: DropdownButtonFormField(
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Select your gender'),
                    isExpanded: true,
                    value: _selectedGender,
                    hint: const Text('Gender'),
                    items: ["Male", "Female"]
                        .map((label) => DropdownMenuItem(
                              child: Text(label),
                              value: label,
                            ))
                        .toList(),
                    onChanged: (val) {
                      setState(() {
                        _selectedGender = val.toString();
                      });
                    },
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                  child: TextFormField(
                    //focusNode: emailFocusNode,
                    controller: _phoneController,
                    keyboardType: TextInputType.number,
                    validator: (input) => _isInputEmpty(input)
                        ? 'This field cannot be left empty'
                        : null,
                    decoration: InputDecoration(
                        labelText: "Phone number",
                        labelStyle: TextStyle(
                            //color: emailFocusNode.hasFocus? Colors.red : Colors.grey,
                            ),
                        border: OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey))),
                  ),
                ),
                const SizedBox(
                  height: 25,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        if (_passwordController.value.text !=
                            _confirmPasswordController.value.text) {
                          _showSnackBar('Password mismatch');
                          return;
                        }
                        if (_formKey.currentState!.validate()) {
                          showProgressDialog();
                          String result =
                              await _auth.registerWithEmailAndPassword(
                                  email: _emailController.value.text.trim(),
                                  password: _passwordController.value.text);
                          final user = UserModel(
                              name: _nameController.value.text.trim(),
                              email: _emailController.value.text.trim(),
                              phone: _phoneController.value.text.trim(),
                              username: _usernameController.value.text.trim(),
                              gender: _selectedGender);
                          await FirestoreOperations(
                                  email: _emailController.value.text.trim())
                              .setUserData(map: user.toMap());
                          Navigator.of(context, rootNavigator: true)
                              .pop();
                          debugPrint(result);
                          if (result == Codes.SUCCESS) {
                            debugPrint('Registered!');
                            Navigator.of(context).push(_createPageRoute());
                          } else if (result == Codes.EMAIL_ALREADY_IN_USE) {
                            _showSnackBar('Email already in use');
                          } else if (result == Codes.WEAK_PASSWORD) {
                            _showSnackBar('Weak Password');
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Colors.green,
                      ),
                      icon: const Icon(
                        Icons.chevron_right,
                        color: Colors.white,
                      ),
                      label: const Text('Continue',
                          style: TextStyle(
                            color: Colors.white,
                          )),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
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

  bool _isPasswordValid(String? input) {
    if (input == null) {
      return false;
    } else if (input.length < 8) {
      return false;
    } else if (RegExp(r'^[a-zA-Z0-9_]*$').hasMatch(input)) {
      return true;
    }
    return false;
  }

  bool _isUsernameValid(String? input) {
    if (input == null) {
      return false;
    } else if (input.isEmpty) {
      return false;
    } else if (RegExp(r'^[a-zA-Z0-9_]*$').hasMatch(input)) {
      return true;
    }
    return false;
  }

  bool _isUsernameTaken(String username) {
    //TODO: check username availability
    return false;
  }

  void _togglePasswordView() {
    setState(() {
      _isHidden = !_isHidden;
    });
  }

  void _toggleConfirmPasswordView() {
    setState(() {
      _isConfirmPasswordHidden = !_isConfirmPasswordHidden;
    });
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
    }
    if (input.isEmpty) {
      return true;
    }
    return false;
  }

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

  Route _createPageRoute() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
          const VerifyEmailScreen(),
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
