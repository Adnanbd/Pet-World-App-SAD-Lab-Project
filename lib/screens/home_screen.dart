import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:flutter_dropdown/flutter_dropdown.dart';
import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';
import 'package:pet_world/screens/create_post_screen.dart';
import 'package:pet_world/screens/user_posts_screen.dart';
import 'package:pet_world/screens/user_profile_screen.dart';
import 'package:pet_world/widgets/post_preview_widget.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:tabbar/tabbar.dart';

class HomeScreen extends StatefulWidget {
  int userIdGlobal;
  HomeScreen(this.userIdGlobal);
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final db = FirebaseFirestore.instance;
  final controller = PageController();
  String filteredCategory = "Buy Sell";
  String filteredSubCategory = "";

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  Stream<QuerySnapshot> streamX;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      streamX =
          FirebaseFirestore.instance.collection('UserPostAll').snapshots();
    });
  }

  void _onRefresh() async {
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    setState(() {
      streamX =
          FirebaseFirestore.instance.collection('UserPostAll').snapshots();
    });
    // if failed,use refreshFailed()
    _refreshController.refreshCompleted();
  }

  void _onLoading() async {
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use loadFailed(),if no data return,use LoadNodata()
    //items.add((items.length+1).toString());
    if (mounted) setState(() {});
    _refreshController.loadComplete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Pet World"),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(kToolbarHeight),
          child: TabbarHeader(
            controller: controller,
            tabs: [
              Tab(
                child: Text(
                  "Home",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ),
              Tab(
                child: Text(
                  "My Posts",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ),
            ],
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.person,
            color: Colors.white,
            size: 25,
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => UserProfileScreen(widget.userIdGlobal)),
            );
          },
        ),
        actions: [
          IconButton(
              icon: Icon(
                Icons.add,
                color: Colors.white,
                size: 25,
              ),
              onPressed: () => createPost(context))
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showAnimatedDialog(
            context: context,
            barrierDismissible: true,
            builder: (BuildContext context) {
              return StatefulBuilder(builder: (context, setState) {
                return SingleChildScrollView(
                    child: AlertDialog(
                  //actionsOverflowDirection: VerticalDirection.down,
                  content: Column(
                    //crossAxisAlignment: CrossAxisAlignment.start,
                    //mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        child: Text(
                          "Filter by Category :",
                          style: TextStyle(
                              color: Colors.green, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Container(
                        alignment: Alignment.center,
                        width: MediaQuery.of(context).size.width * 0.8,
                        child: DropDown(
                          items: [
                            "Buy Sell",
                            "Pet for Mating",
                            "Pet Look After",
                            "Food & Accessories"
                          ],
                          onChanged: (s) {
                            print("Clicked " + s);
                            setState(() {
                              filteredCategory = s;
                              filteredSubCategory = "";
                            });
                          },
                          hint: Text("Filter By Category"),
                          isExpanded: true,
                          dropDownType: DropDownType.Button,
                          initialValue: filteredCategory,
                        ),
                      ),
                      Container(
                        child: Text(
                          "Select Sub-Category :",
                          style: TextStyle(
                              color: Colors.green, fontWeight: FontWeight.bold),
                        ),
                      ),
                      filteredCategory == "Buy Sell" ||
                              filteredCategory == "Food & Accessories"
                          ? Container(
                              alignment: Alignment.center,
                              width: MediaQuery.of(context).size.width * 0.8,
                              child: DropDown(
                                items: [
                                  "Buy",
                                  "Sell",
                                ],
                                onChanged: (s) {
                                  setState(() {
                                    filteredSubCategory = s;
                                  });
                                },
                                hint: filteredSubCategory == ""
                                    ? Text("Select")
                                    : Text(filteredSubCategory),
                                isExpanded: true,
                                dropDownType: DropDownType.Button,
                                //initialValue: filteredCategory,
                              ),
                            )
                          : filteredCategory == "Pet for Mating"
                              ? Container(
                                  alignment: Alignment.center,
                                  width:
                                      MediaQuery.of(context).size.width * 0.8,
                                  child: DropDown(
                                    items: [
                                      "Provider",
                                      "Taker",
                                    ],
                                    onChanged: (s) {
                                      setState(() {
                                        filteredSubCategory = s;
                                      });
                                    },
                                    hint: filteredSubCategory == ""
                                        ? Text("Select")
                                        : Text(filteredSubCategory),
                                    isExpanded: true,
                                    dropDownType: DropDownType.Button,
                                    //initialValue: filteredCategory,
                                  ),
                                )
                              : Container(
                                  alignment: Alignment.center,
                                  width:
                                      MediaQuery.of(context).size.width * 0.8,
                                  child: DropDown(
                                    items: [
                                      "Owner",
                                      "Nanny",
                                    ],
                                    onChanged: (s) {
                                      setState(() {
                                        filteredSubCategory = s;
                                      });
                                    },
                                    hint: filteredSubCategory == ""
                                        ? Text("Select")
                                        : Text(filteredSubCategory),
                                    isExpanded: true,
                                    dropDownType: DropDownType.Button,
                                    //initialValue: filteredCategory,
                                  ),
                                ),
                    ],
                  ),
                  actions: [
                    FlatButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        "Cancel",
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                    FlatButton(
                      color: Colors.green,
                      onPressed: () {
                        setState(() {
                          streamX = filteredSubCategory == ""
                              ? FirebaseFirestore.instance
                                  .collection('UserPostAll')
                                  .where(
                                    "postCategory",
                                    isEqualTo: filteredCategory == "Buy Sell"
                                        ? "Buy Sell Post"
                                        : filteredCategory ==
                                                "Food & Accessories"
                                            ? "Pet Food And Accessories"
                                            : filteredCategory,
                                  )
                                  .snapshots()
                              : FirebaseFirestore.instance
                                  .collection('UserPostAll')
                                  .where(
                                    "postCategory",
                                    isEqualTo: filteredCategory == "Buy Sell"
                                        ? "Buy Sell Post"
                                        : filteredCategory ==
                                                "Food & Accessories"
                                            ? "Pet Food And Accessories"
                                            : filteredCategory,
                                  )
                                  .where("postSubCategory",
                                      isEqualTo: filteredSubCategory)
                                  .snapshots();
                          //_onRefresh();
                        });
                        //Navigator.of(context).pop();
                        Navigator.pop(context, streamX);
                      },
                      child: Text(
                        "Filter",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ));
              });
            },
            animationType: DialogTransitionType.size,
            curve: Curves.fastOutSlowIn,
            duration: Duration(seconds: 1),
          ).then((value) {
            setState(() {
              streamX = value;
            });
          });
        },
        child: Icon(Icons.equalizer),
      ),
      body: TabbarContent(
        controller: controller,
        children: <Widget>[
          Container(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
              ),
              child: StreamBuilder<QuerySnapshot>(
                stream: streamX,
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return Text('Something went wrong');
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return LiquidCircularProgressIndicator(
                      value: 0.25, // Defaults to 0.5.
                      valueColor: AlwaysStoppedAnimation(Colors
                          .green), // Defaults to the current Theme's accentColor.
                      backgroundColor: Colors
                          .white, // Defaults to the current Theme's backgroundColor.
                      borderColor: Colors.green,
                      borderWidth: 5.0,
                      direction: Axis
                          .horizontal, // The direction the liquid moves (Axis.vertical = bottom to top, Axis.horizontal = left to right). Defaults to Axis.vertical.
                      center: Text("Loading..."),
                    );
                  }

                  return SmartRefresher(
                    enablePullDown: true,
                    enablePullUp: true,
                    header: WaterDropHeader(),
                    controller: _refreshController,
                    onRefresh: _onRefresh,
                    onLoading: _onLoading,
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: snapshot.data.size,
                      itemBuilder: (context, index) {
                        return PostPreviewWidget(
                          doc: snapshot.data.docs[index],
                          deletedMode: 0,
                          userIdGlobal: widget.userIdGlobal,
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ),
          UserPostScreen(widget.userIdGlobal)
        ],
      ),
    );
  }

  createPost(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => CreatePostScreen(widget.userIdGlobal)),
    );
  }

  void readData() async {
    //DocumentSnapshot snapshot = await db.collection('UserPostAll').doc().get();
    //CollectionReference A = FirebaseFirestore.instance.collection('users');
    //print(snapshot.data['name']);
    Stream collectionStream =
        FirebaseFirestore.instance.collection('UserPostAll').snapshots();
  }

  void updateData(DocumentSnapshot doc) async {
    await db
        .collection('CRUD')
        .document(doc.id)
        .updateData({'todo': 'please 🤫'});
  }
}
