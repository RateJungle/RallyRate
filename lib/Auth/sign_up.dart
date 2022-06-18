import 'package:flutter/material.dart';



class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  bool _isHidden = true;
  bool _isConfirmPasswordHidden = true;
  String _selectedGender = "Female";



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.grey[50],
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
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 10.0, right: 10.0,top:10.0),
                child: TextFormField(
                  //focusNode: emailFocusNode,
                  controller: _nameController,
                  decoration: InputDecoration(
                      labelText: "Full Name",
                      labelStyle: TextStyle(
                          //color: emailFocusNode.hasFocus? Colors.red : Colors.grey,
                          ),
                      border: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red))),
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
                  decoration: InputDecoration(
                      labelText: "Email",
                      labelStyle: TextStyle(
                          //color: emailFocusNode.hasFocus? Colors.red : Colors.grey,
                          ),
                      border: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red))),
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
                  decoration: InputDecoration(
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
                        icon: Icon(
                            _isConfirmPasswordHidden ? Icons.visibility : Icons.visibility_off)),
                    labelText: "Confirm Password",
                    labelStyle: const TextStyle(
                      //color: emailFocusNode.hasFocus? Colors.red : Colors.grey,
                    ),
                    border: const OutlineInputBorder(),
                    focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red)),
                  ),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Padding(
                padding: const EdgeInsets.only(left:10,right:10),
                child: DropdownButtonFormField(
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                    labelText: 'Select your gender'
                  ),
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
                  decoration: InputDecoration(
                      labelText: "Phone number",
                      labelStyle: TextStyle(
                        //color: emailFocusNode.hasFocus? Colors.red : Colors.grey,
                      ),
                      border: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red))),
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
                      onPressed: () {
                        if(_isInputEmpty(_nameController.value.text) ||
                            _isInputEmpty(_passwordController.value.text) ||
                            _isInputEmpty(_confirmPasswordController.value.text) ||
                            _isInputEmpty(_phoneController.value.text)){
                          _showSnackBar('Input fields cannot be left empty');
                          return;
                        }
                        if(!_isValidEmail(_emailController.value.text)){
                          _showSnackBar('Please enter a valid email address');
                          return;
                        }
                        if(_passwordController.value.text != _confirmPasswordController.value.text){
                          _showSnackBar('Password mismatch');
                          return;
                        }

                      },
                      style: ElevatedButton.styleFrom(
                        primary: Colors.red,
                      ),
                      icon: const Icon(
                        Icons.chevron_right,
                        color: Colors.white,
                      ),
                      label: const Text('Continue',
                          style: TextStyle(
                              color: Colors.white,
                          ))),
                ),
              )
            ],
          ),
        ),
      ),
    );
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

  void _showSnackBar(String text){
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(text),
      backgroundColor: Colors.red,
    )
    );
  }

  bool _isInputEmpty(String input){
    debugPrint('inside _isInputEmpty');
    if(input.isEmpty){
      return true;
    }
    return false;
  }
  bool _isValidEmail(String? email) {
    debugPrint('inside _isInputEmpty');
    if(email == null || email.isEmpty){
      return false;
    }
    if(RegExp(
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(email)){
      return true;
    }
    return false;
  }
}
