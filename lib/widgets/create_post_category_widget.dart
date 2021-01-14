import 'package:flutter/material.dart';

class CreatePostCategoryWidget extends StatelessWidget {
  String name;
  var nextPage;

  CreatePostCategoryWidget({this.name,this.nextPage});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => nextPage),
        );
      },
      child: Container(
        margin: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.green,
          borderRadius: BorderRadius.all(Radius.circular(20))
        ),
        height: double.infinity,
        width: double.infinity,
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(name,style: TextStyle(fontSize: 18,color: Colors.white,fontWeight: FontWeight.bold),),
          ],
        ),
      ),
    );
  }
}
