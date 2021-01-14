import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';
import 'package:pie_chart/pie_chart.dart';

class AdminPanel extends StatefulWidget {
  @override
  _AdminPanelState createState() => _AdminPanelState();
}

class _AdminPanelState extends State<AdminPanel> {
  AsyncSnapshot<QuerySnapshot> streamX;

  int todayAllPost = 0;
  int todayBuySellPost = 0;
  int todayPetForMating = 0;
  int todayPetLookAfter = 0;
  int todayFoodandAcc = 0;

  int totalAllPost = 0;
  int totalBuySellPost = 0;
  int totalPetForMating = 0;
  int totalPetLookAfter = 0;
  int totalFoodandAcc = 0;

  int isLoading = 1;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final waitList = <Future<void>>[];

    waitList.add(FirebaseFirestore.instance
        .collection('UserPostAll')
        .snapshots()
        .forEach((element) {
      element.docs.forEach((element) {
        String todayDate =
            DateFormat.yMMMMd('en_US').format(DateTime.now()).toString();
        String postDate = element.data()['timestamp'] == null
            ? "No Date"
            : DateFormat.yMMMMd('en_US')
                .format(DateTime.fromMicrosecondsSinceEpoch(
                    element.data()['timestamp'] * 1000))
                .toString();
        print("Today = " + todayDate);
        print("Post Date = " + postDate);

        setState(() {
          todayAllPost =
              todayAllPost + (todayDate.trim() == postDate.trim() ? 1 : 0);
          todayBuySellPost = todayBuySellPost +
              (todayDate.trim() == postDate.trim() &&
                      element.data()['postCategory'].toString() ==
                          "Buy Sell Post"
                  ? 1
                  : 0);
          todayPetForMating = todayPetForMating +
              (todayDate.trim() == postDate.trim() &&
                      element.data()['postCategory'].toString() ==
                          "Pet for Mating"
                  ? 1
                  : 0);
          todayPetLookAfter = todayPetLookAfter +
              (todayDate.trim() == postDate.trim() &&
                      element.data()['postCategory'].toString() ==
                          "Pet Look After"
                  ? 1
                  : 0);
          todayFoodandAcc = todayFoodandAcc +
              (todayDate.trim() == postDate.trim() &&
                      element.data()['postCategory'].toString() ==
                          "Pet Food And Accessories"
                  ? 1
                  : 0);
          totalBuySellPost = totalBuySellPost +
              (element.data()['postCategory'].toString() == "Buy Sell Post"
                  ? 1
                  : 0);
          totalPetForMating = totalPetForMating +
              (element.data()['postCategory'].toString() == "Pet for Mating"
                  ? 1
                  : 0);
          totalPetLookAfter = totalPetLookAfter +
              (element.data()['postCategory'].toString() == "Pet Look After"
                  ? 1
                  : 0);
          totalFoodandAcc = totalFoodandAcc +
              (element.data()['postCategory'].toString() ==
                      "Pet Food And Accessories"
                  ? 1
                  : 0);
        });
      });
    }));

    Future.wait(waitList);
    setState(() {
      todayAllPost = todayBuySellPost +
          todayFoodandAcc +
          todayPetForMating +
          todayPetLookAfter;
      totalAllPost = (totalBuySellPost +
          totalFoodandAcc +
          totalPetForMating +
          totalPetLookAfter);
      isLoading = 0;
      print('Done.........Admin');
    });

    
  }

  postCount(Stream<QuerySnapshot> stream) {}

  @override
  Widget build(BuildContext context) {
    Map<String, double> dataMap = {
      "Today's Buy Sell Posts": todayBuySellPost.roundToDouble(),
      "Today's Pet Look After Posts": todayPetLookAfter.roundToDouble(),
      "Today's Pet for Mating Posts": todayPetForMating.roundToDouble(),
      "Today's Food & Acc. Posts": todayFoodandAcc.roundToDouble(),
    };
    Map<String, double> dataMap_total = {
      "Total's Buy Sell Posts": totalBuySellPost.roundToDouble(),
      "Total's Pet Look After Posts": totalPetLookAfter.roundToDouble(),
      "Total's Pet for Mating Posts": totalPetForMating.roundToDouble(),
      "Total's Food & Acc. Posts": totalFoodandAcc.roundToDouble(),
    };
    return Scaffold(
      appBar: AppBar(
        title: Text("Admin Panel"),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: isLoading == 0
              ? Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 40),
                      child: PieChart(
                        dataMap: dataMap,
                        animationDuration: Duration(milliseconds: 800),
                        chartLegendSpacing: 30,
                        chartRadius: MediaQuery.of(context).size.width / 2.4,
                        //colorList: colorList,
                        initialAngleInDegree: 0,
                        chartType: ChartType.ring,
                        ringStrokeWidth: 32,
                        centerText:
                            "TODAY TOTAL POST = " + todayAllPost.toString(),

                        legendOptions: LegendOptions(
                          showLegendsInRow: false,
                          legendPosition: LegendPosition.bottom,
                          showLegends: true,
                          legendShape: BoxShape.circle,
                          legendTextStyle: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        chartValuesOptions: ChartValuesOptions(
                            showChartValueBackground: true,
                            showChartValues: true,
                            showChartValuesInPercentage: false,
                            showChartValuesOutside: true,
                            chartValueBackgroundColor: Colors.grey[900],
                            chartValueStyle: TextStyle(color: Colors.white)),
                      ),
                    ),
                    Divider(
                      thickness: 1,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 40),
                      child: PieChart(
                        dataMap: dataMap_total,
                        animationDuration: Duration(milliseconds: 800),
                        chartLegendSpacing: 30,
                        chartRadius: MediaQuery.of(context).size.width / 2.4,
                        //colorList: colorList,
                        initialAngleInDegree: 0,
                        chartType: ChartType.ring,
                        ringStrokeWidth: 32,
                        centerText: "TOTAL POST = " + (totalBuySellPost +
          totalFoodandAcc +
          totalPetForMating +
          totalPetLookAfter).toString(),

                        legendOptions: LegendOptions(
                          showLegendsInRow: false,
                          legendPosition: LegendPosition.bottom,
                          showLegends: true,
                          legendShape: BoxShape.circle,
                          legendTextStyle: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        chartValuesOptions: ChartValuesOptions(
                            showChartValueBackground: true,
                            showChartValues: true,
                            showChartValuesInPercentage: false,
                            showChartValuesOutside: true,
                            chartValueBackgroundColor: Colors.grey[900],
                            chartValueStyle: TextStyle(color: Colors.white)),
                      ),
                    ),
                  ],
                )
              : LiquidCircularProgressIndicator(
                  value: 0.25, // Defaults to 0.5.
                  valueColor: AlwaysStoppedAnimation(Colors
                      .green), // Defaults to the current Theme's accentColor.
                  backgroundColor: Colors
                      .white, // Defaults to the current Theme's backgroundColor.
                  borderColor: Colors.green,
                  borderWidth: 5.0,
                  direction: Axis
                      .vertical, // The direction the liquid moves (Axis.vertical = bottom to top, Axis.horizontal = left to right). Defaults to Axis.vertical.
                  center: Text("Loading..."),
                ),
        ),
      ),
    );
  }
}
