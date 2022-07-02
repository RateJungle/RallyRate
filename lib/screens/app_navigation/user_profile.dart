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
          if (!snapshot.hasData) {
            return Container(
              color: Colors.white,
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
          final UserModel user = UserModel.fromDocumentSnapshot(snapshot.data!);
          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
                backgroundColor: Colors.white,
                elevation: 0,
                centerTitle: false,
                title: Text(
                  user.username,
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.grey[800]),
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
                                      fontSize: 20),
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
                                backgroundImage:
                                    AssetImage('assets/avatar.png'),
                                radius: 50,
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Text(
                                user.name,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20),
                              ),
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
                                      fontSize: 20),
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
                      const SizedBox(
                        height: 25,
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 5),
                        child: SizedBox(
                          width: double.infinity,
                          child: Text(
                            user.bio!,
                            softWrap: true,
                            style: TextStyle(color: Colors.grey[700]),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10,),
                      Row(
                        children: [
                          Row(
                            children: [
                              Icon(Icons.location_on_outlined,
                                  color: Colors.grey[500]),
                              Text('Your location',
                                  style: TextStyle(color: Colors.grey[500]))
                            ],
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Row(
                            children: [
                              Icon(Icons.link, color: Colors.grey[500]),
                              Text('https://cash.app/',
                                  style: TextStyle(
                                      color: Colors.blue,
                                      decoration: TextDecoration.underline))
                            ],
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Row(
                            children: [
                              Icon(Icons.calendar_month, color: Colors.grey[500]),
                              Text('28-02-2000',
                                  style: TextStyle(
                                    color: Colors.grey[500],
                                  )
                              )
                            ],
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Row(
                            children: [
                              Icon(Icons.calendar_month, color: Colors.grey[500]),
                              Text('Date joined',
                                  style: TextStyle(
                                    color: Colors.grey[500],
                                  )
                              )
                            ],
                          )
                        ],
                      ),
                      OutlinedButton(
                          onPressed: () {},
                          style: OutlinedButton.styleFrom(
                              minimumSize: Size.fromHeight(30)),
                          child: Text(
                            'Edit Profile',
                            style: TextStyle(color: Colors.black),
                          )),
                      DefaultTabController(
                          length: 4,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              TabBar(
                                labelColor: Colors.green,
                                unselectedLabelColor: Colors.black,
                                tabs: [
                                  Icon(Icons.grid_view_outlined),
                                  Icon(Icons.view_day_outlined),
                                  Icon(Icons.person_pin_outlined),
                                  Icon(Icons.stars_outlined)
                                ],
                              ),
                              Container(
                                height: 400,
                                child: TabBarView(children: [
                                  Center(child: Text('Grid view')),
                                  Center(child: Text('Timeline view')),
                                  Center(child: Text('Stories')),
                                  Center(child: Text('Rated posts'))
                                ]),
                              )
                            ],
                          )),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }
}
