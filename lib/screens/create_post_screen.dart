import 'package:flutter/material.dart';
import 'package:pet_world/screens/create_post_froms.dart';
import 'package:pet_world/widgets/create_post_category_widget.dart';

class CreatePostScreen extends StatelessWidget {
  int userIdGLobal;
  CreatePostScreen(this.userIdGLobal);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Create Post"),
      ),
      body: Container(
        width: double.infinity,
        child: Container(
          child: GridView.count(
            crossAxisCount: 2,
            children: [
              CreatePostCategoryWidget(
                name: "Pet Buy Sell",
                nextPage: CreatePostBuySell(1,userIdGLobal),
              ),
              CreatePostCategoryWidget(
                name: "Pet Look After",
                nextPage: CreatePostBuySell(2,userIdGLobal),
              ),
              CreatePostCategoryWidget(
                name: "Pet For Mating",
                nextPage: CreatePostBuySell(3,userIdGLobal),
              ),
              CreatePostCategoryWidget(
                name: "Pet Food & \nAccessories",
                nextPage: CreatePostBuySell(4,userIdGLobal),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
