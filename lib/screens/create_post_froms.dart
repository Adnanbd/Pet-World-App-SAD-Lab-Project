import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_dropdown/flutter_dropdown.dart';
import 'package:flutter_xlider/flutter_xlider.dart';

import 'package:intl/intl.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

import 'package:uuid/uuid.dart';

class CreatePostBuySell extends StatefulWidget {
  int categoryMain;
  int userIdGlobal;
  CreatePostBuySell(this.categoryMain, this.userIdGlobal);
  @override
  _CreatePostBuySellState createState() => _CreatePostBuySellState();
}

final homeScaffoldKey = GlobalKey<ScaffoldState>();
final searchScaffoldKey = GlobalKey<ScaffoldState>();

class _CreatePostBuySellState extends State<CreatePostBuySell> {
  //int category = widget.categoryMain;
  final db = FirebaseFirestore.instance;

  final _formKey = GlobalKey<FormState>();
  //TextEditingController petTypeC = TextEditingController();
  String petTypeDropDown;
  TextEditingController contactC = TextEditingController();
  TextEditingController locationC = TextEditingController();
  TextEditingController detailC = TextEditingController();
  TextEditingController priceC = TextEditingController();
  int y = 0;
  int m = 0;
  int d = 0;

  // Buy Sell //============
  TextEditingController breedTypeC = TextEditingController();
  TextEditingController lastVaccineNameC = TextEditingController();
  TextEditingController alergyInfoC = TextEditingController();
  //TextEditingController detailC = TextEditingController();
  //TextEditingController priceC = TextEditingController();

  //Pet for look after and mating
  TextEditingController durationC = TextEditingController();
  int foodProvidedValue = -1;

  //Food Accessories

  TextEditingController quantityC = TextEditingController();
  TextEditingController foodAccessoriesNameC = TextEditingController();
  TextEditingController weightC = TextEditingController();
  List<Asset> images = List<Asset>();
  List<String> imageUrls = <String>[];

  int subCategoryValue = -1;

  int pottyTrainedValue = -1;
  int genderValue = -1;
  int vaccineValue = -1;
  int usedProductValue = -1;

  double ageValue = 100;
  String ageText;

  DateTime lastVaccinationDate;
  DateTime expireDate;

  @override
  void initState() {
    super.initState();
  }

  Widget buildGridView() {
    return GridView.count(
      crossAxisCount: 3,
      children: List.generate(images.length, (index) {
        Asset asset = images[index];
        return AssetThumb(
          asset: asset,
          width: 300,
          height: 300,
        );
      }),
    );
  }

  Widget thumbShow() {
    if (images.length > 0) print("See Inside = " + images[0].toString());
    return Container(
      child: images.length == 1
          ? Padding(
              padding: const EdgeInsets.all(10.0),
              child: AssetThumb(
                asset: images[0],
                width: 100,
                height: 100,
              ),
            )
          : images.length == 2
              ? Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: AssetThumb(
                        asset: images[0],
                        width: 100,
                        height: 100,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: AssetThumb(
                        asset: images[1],
                        width: 100,
                        height: 100,
                      ),
                    )
                  ],
                )
              : images.length > 2
                  ? Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: AssetThumb(
                            asset: images[0],
                            width: 100,
                            height: 100,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: AssetThumb(
                            asset: images[1],
                            width: 100,
                            height: 100,
                          ),
                        ),
                        Text(
                          "${images.length - 2}\nmore\nimage(s)",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    )
                  : Container(),
    );
  }

  Future<void> loadAssets() async {
    List<Asset> resultList = List<Asset>();
    String error = 'No Error Dectected';

    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 5,
        enableCamera: true,
        selectedAssets: images,
        cupertinoOptions: CupertinoOptions(takePhotoIcon: "chat"),
        materialOptions: MaterialOptions(
          actionBarColor: "#00a819",
          actionBarTitle: "Pet World",
          allViewTitle: "All Photos",
          useDetailsView: false,
          selectCircleStrokeColor: "#00a819",
        ),
      );
    } on Exception catch (e) {
      error = e.toString();
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      images = resultList;
    });
  }

//=======================================================================================================================================================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: homeScaffoldKey,
      appBar: AppBar(
        title: Text(
          widget.categoryMain == 1
              ? "Buy Sell Post"
              : widget.categoryMain == 2
                  ? "Pet Look After"
                  : widget.categoryMain == 3
                      ? "Pet for Mating"
                      : widget.categoryMain == 4
                          ? "Pet Food & Accessories"
                          : 'No Label',
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                widget.categoryMain == 1 || widget.categoryMain == 4
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Buy :"),
                          Radio(
                              value: 0,
                              groupValue: subCategoryValue,
                              onChanged: (x) {
                                setState(() {
                                  subCategoryValue = x;
                                });
                              }),
                          Text("Sell :"),
                          Radio(
                              value: 1,
                              groupValue: subCategoryValue,
                              onChanged: (x) {
                                setState(() {
                                  subCategoryValue = x;
                                });
                              }),
                        ],
                      )
                    : Container(),
                widget.categoryMain == 2
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Owner :"),
                          Radio(
                              value: 0,
                              groupValue: subCategoryValue,
                              onChanged: (x) {
                                setState(() {
                                  subCategoryValue = x;
                                });
                              }),
                          Text("Nanny :"),
                          Radio(
                              value: 1,
                              groupValue: subCategoryValue,
                              onChanged: (x) {
                                setState(() {
                                  subCategoryValue = x;
                                });
                              }),
                        ],
                      )
                    : Container(),
                widget.categoryMain == 3
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Provider :"),
                          Radio(
                              value: 0,
                              groupValue: subCategoryValue,
                              onChanged: (x) {
                                setState(() {
                                  subCategoryValue = x;
                                });
                              }),
                          Text("Taker :"),
                          Radio(
                              value: 1,
                              groupValue: subCategoryValue,
                              onChanged: (x) {
                                setState(() {
                                  subCategoryValue = x;
                                });
                              }),
                        ],
                      )
                    : Container(),
                //customTextF(label: "Pet Type", con: petTypeC),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    "Pet Type :  ",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: DropDown(
                    items: ["Dog", "Cat", "Fish", "Bird", "Others"],
                    onChanged: (s) {
                      print("Clicked " + s);
                      setState(() {
                        petTypeDropDown = s;
                      });
                    },
                    hint: Text("Select Pet Type"),
                    isExpanded: true,
                    dropDownType: DropDownType.Button,
                    //initialValue: filteredCategory,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: FlatButton(
                    onPressed: loadAssets,
                    child: Text(
                      "Add Images",
                      style: TextStyle(color: Colors.white),
                    ),
                    color: Colors.green,
                  ),
                ),
                Center(
                  child: thumbShow(),
                ),
                widget.categoryMain == 1 ? ifBuySellPost() : Container(),
                widget.categoryMain == 2 || widget.categoryMain == 3
                    ? Column(
                        children: [
                          ifLookAfterPost(),
                          ifBuySellPost(),
                        ],
                      )
                    : Container(),
                widget.categoryMain == 4 ? ifFoodAccPost() : Container(),
                customTextF(
                    label: "Price (in Taka)",
                    con: priceC,
                    tType: TextInputType.numberWithOptions()),
                customTextF(label: "Location", con: locationC),

                customTextF(
                    label: "Contact No",
                    con: contactC,
                    tType: TextInputType.numberWithOptions()),
                customTextF(label: "Details", con: detailC, line: 5),
                Container(
                  padding: EdgeInsets.only(bottom: 20),
                  alignment: Alignment.center,
                  child: ElevatedButton(
                    onPressed: () {
                      // Validate returns true if the form is valid, or false
                      // otherwise.
                      if (_formKey.currentState.validate()) {
                        // If the form is valid, display a Snackbar.

                        if ((widget.categoryMain == 1 ||
                                widget.categoryMain == 4) &&
                            subCategoryValue == 1 &&
                            images.length <= 0) {
                          AwesomeDialog(
                            context: context,
                            dialogType: DialogType.ERROR,
                            animType: AnimType.BOTTOMSLIDE,
                            title: 'No Image!',
                            desc: 'Select At Least 1 Image',
                            btnCancelOnPress: () {},
                            btnOkOnPress: () {},
                          ).show();
                        } else if ((widget.categoryMain == 2 ||
                                widget.categoryMain == 3) &&
                            subCategoryValue == 0 &&
                            images.length <= 0) {
                          AwesomeDialog(
                            context: context,
                            dialogType: DialogType.ERROR,
                            animType: AnimType.BOTTOMSLIDE,
                            title: 'No Image!',
                            desc: 'Select At Least 1 Image',
                            btnCancelOnPress: () {},
                            btnOkOnPress: () {},
                          ).show();
                        } else {
                          var x = Uuid().v1();
                          print("Processing............");

                          if (widget.categoryMain == 1) {
                            createBuySellPostToFirebase(
                              age: ageText,
                              userId: widget.userIdGlobal,
                              postId: x,
                              petType: petTypeDropDown,
                              alergyInfo: alergyInfoC.text,
                              breedType: breedTypeC.text,
                              contact: contactC.text,
                              description: detailC.text,
                              gender: genderValue == 0 ? "Male" : "Female",
                              loc: locationC.text,
                              postCat: "Buy Sell Post",
                              postSubCat:
                                  subCategoryValue == 0 ? "Buy" : "Sell",
                              pottyT: pottyTrainedValue == 0 ? "Yes" : "No",
                              price: priceC.text,
                              vaccined: vaccineValue == 0 ? "Yes" : "No",
                              lVaccineName: vaccineValue != 0
                                  ? ""
                                  : lastVaccineNameC.text,
                              lVaccineDate: lastVaccinationDate == null
                                  ? ""
                                  : DateFormat.yMMMMd('en_US')
                                      .format(lastVaccinationDate)
                                      .toString(),
                            );
                          }

                          if (widget.categoryMain == 2) {
                            createPetLookafterAndForMatingPostToFirebase(
                              age: ageText,
                              duration: durationC.text,
                              foodProvided:
                                  foodProvidedValue == 0 ? "Yes" : "No",
                              userId: widget.userIdGlobal,
                              postId: x,
                              petType: petTypeDropDown,
                              alergyInfo: alergyInfoC.text,
                              breedType: breedTypeC.text,
                              contact: contactC.text,
                              description: detailC.text,
                              gender: genderValue == 0 ? "Male" : "Female",
                              loc: locationC.text,
                              postCat: "Pet Look After",
                              postSubCat:
                                  subCategoryValue == 0 ? "Owner" : "Nanny",
                              pottyT: pottyTrainedValue == 0 ? "Yes" : "No",
                              price: priceC.text,
                              vaccined: vaccineValue == 0 ? "Yes" : "No",
                              lVaccineName: vaccineValue != 0
                                  ? ""
                                  : lastVaccineNameC.text,
                              lVaccineDate: lastVaccinationDate == null
                                  ? ""
                                  : DateFormat.yMMMMd('en_US')
                                      .format(lastVaccinationDate)
                                      .toString(),
                            );
                          }

                          if (widget.categoryMain == 3) {
                            createPetLookafterAndForMatingPostToFirebase(
                              age: ageText,
                              duration: durationC.text,
                              foodProvided:
                                  foodProvidedValue == 0 ? "Yes" : "No",
                              userId: widget.userIdGlobal,
                              postId: x,
                              petType: petTypeDropDown,
                              alergyInfo: alergyInfoC.text,
                              breedType: breedTypeC.text,
                              contact: contactC.text,
                              description: detailC.text,
                              gender: genderValue == 0 ? "Male" : "Female",
                              loc: locationC.text,
                              postCat: "Pet for Mating",
                              postSubCat:
                                  subCategoryValue == 0 ? "Provider" : "Taker",
                              pottyT: pottyTrainedValue == 0 ? "Yes" : "No",
                              price: priceC.text,
                              vaccined: vaccineValue == 0 ? "Yes" : "No",
                              lVaccineName: vaccineValue != 0
                                  ? ""
                                  : lastVaccineNameC.text,
                              lVaccineDate: lastVaccinationDate == null
                                  ? ""
                                  : DateFormat.yMMMMd('en_US')
                                      .format(lastVaccinationDate)
                                      .toString(),
                            );
                          }
                          if (widget.categoryMain == 4) {
                            createFoodAndAccessToFirebase(
                              userId: widget.userIdGlobal,
                              postId: x,
                              petType: petTypeDropDown,
                              contact: contactC.text,
                              description: detailC.text,
                              loc: locationC.text,
                              postCat: "Pet Food And Accessories",
                              postSubCat:
                                  subCategoryValue == 0 ? "Buy" : "Sell",
                              price: priceC.text,
                              expireDateX: expireDate == null
                                  ? ""
                                  : DateFormat.yMMMMd('en_US')
                                      .format(expireDate)
                                      .toString(),
                              quantity: quantityC.text,
                              usedOrNot: usedProductValue == 0 ? "New" : "Used",
                              weight: weightC.text,
                              name: foodAccessoriesNameC.text,
                            );
                          }

                          uploadImages(x);
                        }
                      } else {
                        print("Error In Form");
                      }
                    },
                    child: Text('Submit'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

//====================================================================================================================================================
  Widget customTextF(
      {String label,
      TextEditingController con,
      int line = 1,
      TextInputType tType = TextInputType.multiline,
      int v = 0}) {
    return Padding(
      padding: EdgeInsets.all(10),
      child: TextFormField(
        enabled: v == 0 ? true : false,
        keyboardType: tType,
        maxLines: line,
        controller: con,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
                //color: config.getPrimaryDark(),
                ),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
                //color: loginCheck ? config.getPrimaryDark() : Colors.red,
                ),
          ),
          labelText: label,
          labelStyle: TextStyle(
              //color: config.getPrimaryDark(),
              ),
        ),
        validator: (value) {
          if (v != 0) {
            return null;
          }
          if (value.isEmpty) {
            return 'Please enter some text';
          }
          return null;
        },
      ),
    );
  }

  Widget ifBuySellPost() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 20),
          child: Text(
            y.toString() == "0"
                ? "Age :  " + m.toString() + " Month(s)"
                : "Age :  " + ageText,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        FlutterSlider(
          values: [ageValue],
          max: 10000,
          min: 30,
          step: FlutterSliderStep(
            step: 20,
          ),
          tooltip: FlutterSliderTooltip(custom: (value) {
            return Text(
              y.toStringAsFixed(0) + "." + m.toStringAsFixed(0),
              style: TextStyle(fontSize: 30),
            );
          }),
          onDragging: (handlerIndex, lowerValue, upperValue) {
            ageValue = lowerValue;

            setState(() {
              ageValue = lowerValue;
              int temp = lowerValue.toInt();
              y = (temp ~/ 365);

              int xageValue = temp - (365 * y);

              m = xageValue ~/ 30;

              d = xageValue - (m * 30);

              ageText = y.toString() + " Year(s) " + m.toString() + " Month(s)";
            });
          },
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                "Gender :  ",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text("Male :"),
              Radio(
                  value: 0,
                  groupValue: genderValue,
                  onChanged: (x) {
                    setState(() {
                      genderValue = x;
                    });
                  }),
              Text("Female :"),
              Radio(
                  value: 1,
                  groupValue: genderValue,
                  onChanged: (x) {
                    setState(() {
                      genderValue = x;
                    });
                  }),
            ],
          ),
        ),
        customTextF(label: "Breed Type", con: breedTypeC),
        Padding(
          padding: const EdgeInsets.only(left: 20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                "Potty Trained :  ",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text("Yes :"),
              Radio(
                  value: 0,
                  groupValue: pottyTrainedValue,
                  onChanged: (x) {
                    setState(() {
                      pottyTrainedValue = x;
                    });
                  }),
              Text("No :"),
              Radio(
                  value: 1,
                  groupValue: pottyTrainedValue,
                  onChanged: (x) {
                    setState(() {
                      pottyTrainedValue = x;
                    });
                  }),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                "Vaccinated :  ",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text("Yes :"),
              Radio(
                  value: 0,
                  groupValue: vaccineValue,
                  onChanged: (x) {
                    setState(() {
                      vaccineValue = x;
                    });
                  }),
              Text("No :"),
              Radio(
                  value: 1,
                  groupValue: vaccineValue,
                  onChanged: (x) {
                    setState(() {
                      vaccineValue = x;
                    });
                  }),
            ],
          ),
        ),
        (((widget.categoryMain == 1 || widget.categoryMain == 4) &&
                    subCategoryValue == 1) ||
                ((widget.categoryMain == 2 || widget.categoryMain == 3) &&
                    subCategoryValue == 0))
            ? Column(
                children: [
                  customTextF(
                      label: "Last Vaccine Name (Optional)",
                      con: lastVaccineNameC,
                      v: vaccineValue),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: FlatButton(
                        color: Colors.green,
                        disabledColor: Colors.black38,
                        onPressed: vaccineValue == 0
                            ? () {
                                DatePicker.showDatePicker(context,
                                    showTitleActions: true,
                                    minTime: DateTime(2000, 3, 5),
                                    maxTime: DateTime.now(),
                                    theme: DatePickerTheme(
                                        headerColor: Colors.white,
                                        backgroundColor: Colors.white,
                                        itemStyle: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18),
                                        doneStyle: TextStyle(
                                            color: Colors.black,
                                            fontSize: 16)), onChanged: (date) {
                                  print('change $date in time zone ' +
                                      date.timeZoneOffset.inHours.toString());
                                }, onConfirm: (date) {
                                  print('confirm $date');
                                  setState(() {
                                    lastVaccinationDate = date;
                                  });
                                  print(lastVaccinationDate);
                                },
                                    currentTime: lastVaccinationDate == null
                                        ? DateTime.now()
                                        : lastVaccinationDate,
                                    locale: LocaleType.en);
                              }
                            : null,
                        child: Text(
                          lastVaccinationDate == null
                              ? 'Last Vaccination Date (Optional)'
                              : DateFormat.yMMMMd('en_US')
                                  .format(lastVaccinationDate)
                                  .toString(),
                          style: TextStyle(color: Colors.white),
                        )),
                  ),
                ],
              )
            : Container(),
        customTextF(label: "Alergy Related Note", con: alergyInfoC, line: 2),
      ],
    );
  }

  Widget ifLookAfterPost() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        customTextF(
            label: "Duration (in Days)",
            con: durationC,
            tType: TextInputType.numberWithOptions()),
        Padding(
          padding: const EdgeInsets.only(left: 20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                "Food Provided ?   ",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text("Yes :"),
              Radio(
                  value: 0,
                  groupValue: foodProvidedValue,
                  onChanged: (x) {
                    setState(() {
                      foodProvidedValue = x;
                    });
                  }),
              Text("No :"),
              Radio(
                  value: 1,
                  groupValue: foodProvidedValue,
                  onChanged: (x) {
                    setState(() {
                      foodProvidedValue = x;
                    });
                  }),
            ],
          ),
        ),
      ],
    );
  }

  Widget ifFoodAccPost() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        customTextF(
          label: "Food/Accessories Name",
          con: foodAccessoriesNameC,
        ),
        customTextF(
            label: "Quantity",
            con: quantityC,
            tType: TextInputType.numberWithOptions()),
        Padding(
          padding: const EdgeInsets.only(left: 20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text("New :"),
              Radio(
                  value: 0,
                  groupValue: usedProductValue,
                  onChanged: (x) {
                    setState(() {
                      usedProductValue = x;
                    });
                  }),
              Text("Used :"),
              Radio(
                  value: 1,
                  groupValue: usedProductValue,
                  onChanged: (x) {
                    setState(() {
                      usedProductValue = x;
                    });
                  }),
            ],
          ),
        ),
        customTextF(
            label: "Weight (in Gram)",
            con: weightC,
            tType: TextInputType.numberWithOptions()),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: FlatButton(
              color: Colors.green,
              disabledColor: Colors.black38,
              onPressed: () {
                DatePicker.showDatePicker(context,
                    showTitleActions: true,
                    minTime: DateTime.now(),
                    maxTime: DateTime(2030, 0, 0),
                    theme: DatePickerTheme(
                        headerColor: Colors.white,
                        backgroundColor: Colors.white,
                        itemStyle: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 18),
                        doneStyle:
                            TextStyle(color: Colors.black, fontSize: 16)),
                    onChanged: (date) {
                  print('change $date in time zone ' +
                      date.timeZoneOffset.inHours.toString());
                }, onConfirm: (date) {
                  print('confirm $date');
                  setState(() {
                    expireDate = date;
                  });
                  print(expireDate);
                },
                    currentTime:
                        expireDate == null ? DateTime.now() : expireDate,
                    locale: LocaleType.en);
              },
              child: Text(
                expireDate == null
                    ? 'Expire Date of Food/Accessories (Optional)'
                    : DateFormat.yMMMMd('en_US').format(expireDate).toString(),
                style: TextStyle(color: Colors.white),
              )),
        ),
      ],
    );
  }

  createBuySellPostToFirebase({
    int userId,
    String postId,
    String postCat,
    String postSubCat,
    String petType,
    String price,
    String loc,
    String contact,
    String description,
    String breedType,
    String pottyT,
    String gender,
    String vaccined,
    String lVaccineName,
    String lVaccineDate,
    String alergyInfo,
    String age
  }) async {
    DocumentReference ref = await db.collection('UserPostAll').add({
      'userId': '$userId',
      'postId': '$postId',
      'postCategory': '$postCat',
      'postSubCategory': '$postSubCat',
      'petType': '$petType',
      'price': '$price',
      'location': '$loc',
      'contactNo': '$contact',
      'description': '$description',
      'breedType': '$breedType',
      'pottyTrained': '$pottyT',
      'gender': '$gender',
      'lastVaccineName': '$lVaccineName',
      'vaccined': '$vaccined',
      'lastVaccineDate': '$lVaccineDate',
      'alergyInfo': '$alergyInfo',
      "timestamp": DateTime.now().millisecondsSinceEpoch,
      'age':'$age',

    }).whenComplete(() {
      if (images.length <= 0) {
        AwesomeDialog(
          context: context,
          dialogType: DialogType.SUCCES,
          animType: AnimType.BOTTOMSLIDE,
          title: 'Posted!',
          desc: 'Your post has been posted successfully!',
          btnOkOnPress: () {
            Navigator.of(context).pop();
          },
        ).show();
      }
    });
    //setState(() => id = ref.documentID);
    print("Ref Id ---------------" + ref.id);
  }

  createPetLookafterAndForMatingPostToFirebase({
    int userId,
    String postId,
    String postCat,
    String postSubCat,
    String petType,
    String price,
    String loc,
    String contact,
    String description,
    String breedType,
    String pottyT,
    String gender,
    String vaccined,
    String lVaccineName,
    String lVaccineDate,
    String alergyInfo,
    String duration,
    String foodProvided,
    String age
  }) async {
    DocumentReference ref = await db.collection('UserPostAll').add({
      'userId': '$userId',
      'postId': '$postId',
      'postCategory': '$postCat',
      'postSubCategory': '$postSubCat',
      'petType': '$petType',
      'price': '$price',
      'location': '$loc',
      'contactNo': '$contact',
      'description': '$description',
      'breedType': '$breedType',
      'pottyTrained': '$pottyT',
      'gender': '$gender',
      'lastVaccineName': '$lVaccineName',
      'vaccined': '$vaccined',
      'lastVaccineDate': '$lVaccineDate',
      'alergyInfo': '$alergyInfo',
      'duration': '$duration',
      'foodProvided': '$foodProvided',
      "timestamp": DateTime.now().millisecondsSinceEpoch,
      'age':'$age',

    }).whenComplete(() {
      if (images.length <= 0) {
        AwesomeDialog(
          context: context,
          dialogType: DialogType.SUCCES,
          animType: AnimType.BOTTOMSLIDE,
          title: 'Posted!',
          desc: 'Your post has been posted successfully!',
          btnOkOnPress: () {
            Navigator.of(context).pop();
          },
        ).show();
      }
    });
    //setState(() => id = ref.documentID);
    print("Ref Id ---------------" + ref.id);
  }

  createFoodAndAccessToFirebase({
    int userId,
    String postId,
    String postCat,
    String postSubCat,
    String petType,
    String price,
    String loc,
    String contact,
    String description,
    String quantity,
    String usedOrNot,
    String weight,
    String expireDateX,
    String name,
  }) async {
    DocumentReference ref = await db.collection('UserPostAll').add({
      'userId': '$userId',
      'postId': '$postId',
      'postCategory': '$postCat',
      'postSubCategory': '$postSubCat',
      'petType': '$petType',
      'price': '$price',
      'location': '$loc',
      'contactNo': '$contact',
      'description': '$description',
      'quantity': '$quantity',
      'usedOrNew': '$usedOrNot',
      'weight': '$weight',
      'expiredDate': '$expireDateX',
      'name': '$name',
      "timestamp": DateTime.now().millisecondsSinceEpoch

    }).whenComplete(() {
      if (images.length <= 0) {
        AwesomeDialog(
          context: context,
          dialogType: DialogType.SUCCES,
          animType: AnimType.BOTTOMSLIDE,
          title: 'Posted!',
          desc: 'Your post has been posted successfully!',
          btnOkOnPress: () {
            Navigator.of(context).pop();
          },
        ).show();
      }
    });
    //setState(() => id = ref.documentID);
    print("Ref Id ---------------" + ref.id);
  }

  void uploadImages(var x) {
    for (var imageFile in images) {
      postImage(imageFile, x).then((downloadUrl) {
        print("Done...................................................");
        imageUrls.add(downloadUrl.toString());
        if (imageUrls.length == images.length) {
          //String documnetID = DateTime.now().millisecondsSinceEpoch.toString();
          FirebaseFirestore.instance
              .collection('allImages')
              .add({'urls': imageUrls, 'postId': x}).then((_) {
            print(
                'Uploaded Successfully.................................................');

            AwesomeDialog(
              context: context,
              dialogType: DialogType.SUCCES,
              animType: AnimType.BOTTOMSLIDE,
              title: 'Posted!',
              desc: 'Your post has been posted successfully!',
              btnOkOnPress: () {
                Navigator.of(context).pop();
              },
            ).show();

            setState(() {
              images = [];
              imageUrls = [];
            });
          });
        }
      }).catchError((err) {
        print("error........................................");
      });
    }
  }

  Future<dynamic> postImage(Asset imageFile, var x) async {
    //print("Pic name === " + imageFile.name);
    String fileName = Uuid().v1();
    //print("File Name ===== " + fileName);
    String downloadUrl = "abclinkkk";
    ByteData byteData = await imageFile.getByteData();
    List<int> imageData = byteData.buffer.asUint8List();
    final reference =
        FirebaseStorage.instance.ref().child("$x/" + fileName + ".jpg");
    UploadTask uploadTask = reference.putData(imageData);
    //print("Single Pic Uploaded");
    downloadUrl = await (await uploadTask).ref.getDownloadURL();
    //print("D -------------------------------------- " + downloadUrl);
    return downloadUrl;
  }
}
