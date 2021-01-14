import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';
import 'package:pet_world/screens/admin_panel.dart';
import 'package:pet_world/screens/login_screen.dart';
import 'package:pet_world/screens/user_post_fromProfile.dart';
import 'package:pet_world/screens/user_posts_screen.dart';

class UserProfileScreen extends StatefulWidget {
  int userIdGlobal;
  UserProfileScreen(this.userIdGlobal);
  @override
  _UserProfileScreenState createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  QuerySnapshot userData;
  int dataCheck = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    FirebaseFirestore.instance
        .collection('UserDetails')
        .where('userId', isEqualTo: widget.userIdGlobal.toString())
        .get()
        .then((value) {
      print(value);
      setState(() {
        userData = value;
        dataCheck = 1;
      });
    }).catchError((v) {
      print("Error =========== User ================== " + v.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Profile'),
        actions: [
          Container(
            margin: EdgeInsets.all(10),
            child: FlatButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => Login()),
                );
              },
              child: Text(
                "Log Out",
                style: TextStyle(color: Colors.white),
              ),
              color: Colors.red,
            ),
          )
        ],
      ),
      body: dataCheck == 0
          ? LiquidLinearProgressIndicator(
              value: 0.25, // Defaults to 0.5.
              valueColor: AlwaysStoppedAnimation(
                  Colors.green), // Defaults to the current Theme's accentColor.
              backgroundColor: Colors
                  .white, // Defaults to the current Theme's backgroundColor.
              borderColor: Colors.green,
              borderWidth: 5.0,
              borderRadius: 12.0,
              direction: Axis
                  .horizontal, // The direction the liquid moves (Axis.vertical = bottom to top, Axis.horizontal = left to right). Defaults to Axis.horizontal.
              center: Text("Loading..."),
            )
          : Container(
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.all(20),
                    alignment: Alignment.topCenter,
                    width: 200,
                    child: Image.network(
                      userData.docs.first.data()['profilePicUrl'],
                      fit: BoxFit.cover,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 35),
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.green[50],
                      border: Border.all(width: 4, color: Colors.green),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.all(10),
                          child: Row(
                            children: [
                              Text(
                                "Name : ",
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                userData.docs.first.data()['name'],
                                style: TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(10),
                          child: Row(
                            children: [
                              Text(
                                "Contact No : ",
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                userData.docs.first.data()['phone'],
                                style: TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(10),
                          child: Row(
                            children: [
                              Text(
                                "Address : ",
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                userData.docs.first.data()['address'],
                                style: TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: FlatButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  UserPostFromProfile(widget.userIdGlobal)),
                        );
                      },
                      child: Text(
                        'See My Posts',
                        style: TextStyle(color: Colors.white),
                      ),
                      color: Colors.green,
                    ),
                  ),

                  userData.docs.first.data()['userId'].toString() == "2145" ? Padding(
                    padding: EdgeInsets.all(10),
                    child: FlatButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  AdminPanel()),
                        );
                      },
                      child: Text(
                        'Admin Panel',
                        style: TextStyle(color: Colors.white),
                      ),
                      color: Colors.green,
                    ),
                  ):Container(),
                ],
              ),
            ),
    );
  }
}
