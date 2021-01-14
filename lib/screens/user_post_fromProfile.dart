import 'package:flutter/material.dart';
import 'package:pet_world/screens/user_posts_screen.dart';

class UserPostFromProfile extends StatefulWidget {
  int userIdGlobal;
  UserPostFromProfile(this.userIdGlobal);

  @override
  _UserPostFromProfileState createState() => _UserPostFromProfileState();
}

class _UserPostFromProfileState extends State<UserPostFromProfile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Post"),
      ),
      body: UserPostScreen(widget.userIdGlobal),
    );
  }
}
