import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rally_rate/firebase_authentication/auth_firebase.dart';
import 'package:rally_rate/firebase_cloud_firestore/firestore.dart';
import 'package:rally_rate/models/user.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({Key? key}) : super(key: key);

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  @override
  Widget build(BuildContext context) {
    final String email = AuthService().currentUserEmail;
    return StreamBuilder<DocumentSnapshot>(
      stream: FirestoreOperations(email: email).userData,
      builder: (context, snapshot) {
        if(!snapshot.hasData){
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        final UserModel user = UserModel.fromDocumentSnapshot(snapshot.data!);
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              centerTitle: false,
              title: Text(user.username, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey[800]),),
              leading: IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: Icon(
                  Icons.chevron_left,
                  color: Colors.grey[800],
                ),
              )
          ),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(left: 10, right: 10, top: 25),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: Column(
                            children: [
                              Text(
                                user.followers!.length.toString(),
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20
                                ),
                              ),
                              Text(
                                'Followers',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.grey[700],
                                ),
                              )
                            ],
                          ),
                        ),
                        Column(
                          children: [
                            CircleAvatar(
                              backgroundImage: AssetImage('assets/avatar.png'),
                              radius: 50,
                            ),
                            const SizedBox(height: 10,),
                            Text(
                              user.name,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20
                              ),
                            ),
                            const SizedBox(height: 10,),
                            SizedBox(
                              width: 200,
                              child: Text(
                                user.bio!,
                                softWrap: true,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.grey[700]
                                ),
                              ),
                            )
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: Column(
                            children: [
                              Text(
                                user.following!.length.toString(),
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20
                                ),
                              ),
                              Text(
                                'Following',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.grey[700],
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 15,),
                    OutlinedButton(
                        onPressed: (){},
                        style: OutlinedButton.styleFrom(
                          minimumSize: Size.fromHeight(30)
                        ),
                        child: Text(
                          'Edit Profile',
                          style: TextStyle(
                            color: Colors.black
                          ),
                        ))
                  ],
                ),
              ),
            ),
          ),
        );
      }
    );
  }

}
