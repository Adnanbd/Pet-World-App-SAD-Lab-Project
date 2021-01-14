import 'package:flutter/material.dart';

class PostDetailModel {

  int postId;
  String postCategory;
  String subPostCategory;
  String petType;
  List<String> imageLinks;
  double price;
  String location;
  String contactNo;
  String postDescription;

  PostDetailModel(
    {
      this.postId,
      this.postCategory,
      this.subPostCategory,
      this.petType,
      this.imageLinks,
      this.price,
      this.location,
      this.contactNo,
      this.postDescription
    }
  );
  
}
