import 'package:blurrycontainer/blurrycontainer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';
import 'package:pet_world/resource/mycolor.dart';
import 'package:pet_world/screens/post_details_screen.dart';

class PostPreviewWidget extends StatefulWidget {
  DocumentSnapshot doc;
  int deletedMode;
  int userIdGlobal;

  PostPreviewWidget({this.doc, this.deletedMode,this.userIdGlobal});

  @override
  _PostPreviewWidgetState createState() => _PostPreviewWidgetState();
}

class _PostPreviewWidgetState extends State<PostPreviewWidget> {
  QuerySnapshot imageDoc;
  int check = 0;
  int imageCheck = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    FirebaseFirestore.instance
        .collection('allImages')
        .where('postId', isEqualTo: widget.doc.data()['postId'])
        .get()
        .then((value) {
      print(value);
      setState(() {
        imageDoc = value;
        check = 1;
        print(imageDoc.docs.first.data()['urls']);
      });
    }).catchError((v) {
      print("Error ============================= " + v.toString());
      setState(() {
        imageCheck = 1;
        check = 1;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      width: double.infinity,
      child: GestureDetector(
        onTap: () {
          if (check == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => PostDetailsScreen(
                        doc: widget.doc,
                        imageDoc: imageDoc.size == 0 ? null : imageDoc,
                        userIdGlobal: widget.userIdGlobal,
                      )),
            );
          }
        },
        child: BlurryContainer(
          borderRadius: BorderRadius.circular(20),
          bgColor: Colors.green[100],
          height: 150,
          child: check == 1
              ? Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Container(
                        padding: EdgeInsets.all(5),
                        width: 100,
                        //height: 100,
                        child: Image.network(
                          imageDoc.size == 0
                              ? 'https://i0.wp.com/comicbookinvest.com/wp-content/uploads/2020/07/112815900-stock-vector-no-image-available-icon-flat-vector.jpg?resize=450%2C450&ssl=1'
                              : imageDoc.docs.first.data()['urls'][0],
                          fit: BoxFit.cover,
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                "Category : ",
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              widget.doc.data()['postCategory'].toString() ==
                                      'Pet Food And Accessories'
                                  ? Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Pet Food',
                                          style: TextStyle(fontSize: 18),
                                        ),
                                        Text(
                                          'And Accessories',
                                          style: TextStyle(fontSize: 18),
                                        ),
                                      ],
                                    )
                                  : Text(
                                      widget.doc.data()['postCategory'],
                                      style: TextStyle(fontSize: 18),
                                    ),
                            ],
                          ),
                          Row(
                            children: [
                              Text(
                                "Sub Category : ",
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                widget.doc.data()['postSubCategory'],
                                style: TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Text(
                                "Pet Type : ",
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                widget.doc.data()['petType'],
                                style: TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                          widget.doc.data()['postSubCategory'].toString() ==
                                      'Sell' ||
                                  widget.doc
                                          .data()['postSubCategory']
                                          .toString() ==
                                      'Provider' ||
                                  widget.doc
                                          .data()['postSubCategory']
                                          .toString() ==
                                      'Owner'
                              ? Row(
                                  children: [
                                    Text(
                                      "Price : ",
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      widget.doc.data()['price'],
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  ],
                                )
                              : Container(),
                          widget.doc.data()['postCategory'].toString() ==
                                  'Pet Food And Accessories'
                              ? Row(
                                  children: [
                                    Text(
                                      "Name : ",
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      widget.doc.data()['name'],
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  ],
                                )
                              : Container(),
                        ],
                      ),
                    ],
                  ),
                )
              : LiquidLinearProgressIndicator(
                  value: 0.25, // Defaults to 0.5.
                  valueColor: AlwaysStoppedAnimation(Colors
                      .green), // Defaults to the current Theme's accentColor.
                  backgroundColor: Colors
                      .white, // Defaults to the current Theme's backgroundColor.
                  borderColor: Colors.green,
                  borderWidth: 5.0,
                  borderRadius: 12.0,
                  direction: Axis
                      .horizontal, // The direction the liquid moves (Axis.vertical = bottom to top, Axis.horizontal = left to right). Defaults to Axis.horizontal.
                  center: Text("Loading..."),
                ),
        ),
      ),
    );
  }
}
