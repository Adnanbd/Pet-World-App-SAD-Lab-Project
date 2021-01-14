import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';
import 'package:pet_world/resource/userInfo.dart';
import 'package:pet_world/widgets/image_slider.dart';

class PostDetailsScreen extends StatefulWidget {
  DocumentSnapshot doc;
  QuerySnapshot imageDoc;
  int userIdGlobal;

  PostDetailsScreen({this.doc, this.imageDoc, this.userIdGlobal});
  @override
  _PostDetailsScreenState createState() => _PostDetailsScreenState();
}

class _PostDetailsScreenState extends State<PostDetailsScreen> {
  final db = FirebaseFirestore.instance;
  int deleteWait = 0;

  @override
  Widget build(BuildContext context) {
   

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.doc.data()['postCategory']),
        actions: [
          widget.userIdGlobal.toString() == widget.doc.data()['userId']
              ? Container(
                  margin: EdgeInsets.all(10),
                  child: FlatButton(
                      color: Colors.red,
                      onPressed: () {
                        AwesomeDialog(
                          context: context,
                          dialogType: DialogType.WARNING,
                          animType: AnimType.BOTTOMSLIDE,
                          title: 'Confirm?',
                          desc: 'Do you want to delete this post?',
                          btnOkOnPress: () {
                            setState(() {
                              deleteWait = 1;
                            });

                            deleteData(widget.doc);
                          },
                          btnCancelOnPress: () {},
                          btnCancelText: "No",
                          btnOkText: "Yes",
                        ).show();
                        if (deleteWait == 1) {
                          return LiquidLinearProgressIndicator(
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
                            center: Text("Deleting..."),
                          );
                        }
                      },
                      child: Text(
                        "Delete",
                        style: TextStyle(color: Colors.white),
                      )),
                )
              : Container(),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ImageSlider(
                imageUrls: widget.imageDoc == null
                    ? null
                    : widget.imageDoc.docs.first.data()['urls'],
              ),
              widget.doc.data()['timestamp'] == null
                  ? Container()
                  : Text(DateFormat.yMMMMd('en_US')
                      .format(DateTime.fromMicrosecondsSinceEpoch(
                          widget.doc.data()['timestamp'] * 1000))
                      .toString()),
              Container(
                padding: EdgeInsets.all(20),
                child: Column(
                  children: [
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
                    Row(
                      children: [
                        Text(
                          "Price : ",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          widget.doc.data()['price'],
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          "Location : ",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          widget.doc.data()['location'],
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          "Contact No : ",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          widget.doc.data()['contactNo'],
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                    widget.doc.data()['postCategory'] == "Buy Sell Post"
                        ? ifBuySell()
                        : widget.doc.data()['postCategory'] ==
                                "Pet Food And Accessories"
                            ? ifFoodAndAccessories()
                            : Column(
                                children: [
                                  ifMatingOrLookafter(),
                                  ifBuySell(),
                                ],
                              ),
                    Text(
                      "Details : ",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      widget.doc.data()['description'],
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget ifBuySell() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              "Gender : ",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Text(
              widget.doc.data()['gender'],
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
        Row(
          children: [
            Text(
              "Breed Type : ",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Text(
              widget.doc.data()['breedType'],
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
        Row(
          children: [
            Text(
              "Potty Trained : ",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Text(
              widget.doc.data()['pottyTrained'],
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
        Row(
          children: [
            Text(
              "Vaccinated : ",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Text(
              widget.doc.data()['vaccined'],
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
        widget.doc.data()['lastVaccineName'] != ""
            ? Row(
                children: [
                  Text(
                    "Last Vaccine Name : ",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    widget.doc.data()['lastVaccineName'],
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              )
            : Container(),
        widget.doc.data()['lastVaccineDate'] != ""
            ? Row(
                children: [
                  Text(
                    "Last Vaccine Date : ",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    widget.doc.data()['lastVaccineDate'],
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              )
            : Container(),
        Text(
          "Allergy Related Information : ",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        Text(
          widget.doc.data()['alergyInfo'],
          style: TextStyle(fontSize: 16),
        ),
      ],
    );
  }

  Widget ifMatingOrLookafter() {
    return Column(
      children: [
        widget.doc.data()['duration'] != null
            ? Row(
                children: [
                  Text(
                    "Duration : ",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    widget.doc.data()['duration'],
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              )
            : Container(),
        widget.doc.data()['foodProvided'] != null
            ? Row(
                children: [
                  Text(
                    "Pood Provided : ",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    widget.doc.data()['foodProvided'],
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              )
            : Container(),
      ],
    );
  }

  Widget ifFoodAndAccessories() {
    return Column(
      children: [
        Row(
          children: [
            Text(
              "Name : ",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Text(
              widget.doc.data()['name'],
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
        Row(
          children: [
            Text(
              "Quantity : ",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Text(
              widget.doc.data()['quantity'],
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
        Row(
          children: [
            Text(
              "Condition : ",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Text(
              widget.doc.data()['usedOrNew'],
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
        widget.doc.data()['weight'] != ""
            ? Row(
                children: [
                  Text(
                    "Weight : ",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    widget.doc.data()['weight'],
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              )
            : Container(),
        widget.doc.data()['expiredDate'] != ""
            ? Row(
                children: [
                  Text(
                    "Expired Date : ",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    widget.doc.data()['expiredDate'],
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              )
            : Container(),
      ],
    );
  }

  void deleteData(DocumentSnapshot doc) async {
    await db.collection('UserPostAll').doc(doc.id).delete().then((value1) {
      print("Post deleted === ");
      int x = 1;
      FirebaseFirestore.instance
          .collection("allImages")
          .where("postId", isEqualTo: doc.data()["postId"])
          .get()
          .then((value2) {
        print("Image fetched === ");

        value2.docs.forEach((element) {
          List<dynamic> imgUrls = element.data()["urls"];
          print("URL ==============" + imgUrls[0].toString());
          imgUrls.forEach((element1) {
            FirebaseStorage.instance
                .refFromURL(element1.toString())
                .delete()
                .then((value) {
              setState(() {
                print("Image deleted === ");
                x = 1;
              });
            });
          });
        });

        print('Second Step Done................!' + x.toString());

        x == 1
            ? value2.docs.forEach((element) {
                FirebaseFirestore.instance
                    .collection("allImages")
                    .doc(element.id)
                    .delete()
                    .then((value) {
                  print("Success!");
                  setState(() {
                    deleteWait = 0;
                  });
                });
              })
            : print("Jhamelaa=====================================");
      });
    }).whenComplete(() {
      AwesomeDialog(
        context: context,
        dialogType: DialogType.SUCCES,
        animType: AnimType.BOTTOMSLIDE,
        title: 'Deleted!',
        desc: 'Your post is successfully deleted',
        btnOkOnPress: () {
          Navigator.of(context).pop();
        },
      ).show();
    });
  }
}
