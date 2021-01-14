import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';

class BuySellPostForm extends StatefulWidget {

  @override
  _BuySellPostFormState createState() => _BuySellPostFormState();
}

class _BuySellPostFormState extends State<BuySellPostForm> {

  TextEditingController breedTypeC = TextEditingController();
  TextEditingController lastVaccineNameC = TextEditingController();
  TextEditingController alergyInfoC = TextEditingController();
  int subCategoryValue = -1;
  int pottyTrainedValue = -1;
  int genderValue = -1;
  int vaccineValue = -1;


  DateTime lastVaccinationDate;
  DateTime expireDate;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
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
                "Potty Trained ?   ",
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
                "Vaccined ?   ",
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
                              doneStyle:
                                  TextStyle(color: Colors.black, fontSize: 16)),
                          onChanged: (date) {
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
        customTextF(label: "Alergy Related Note", con: alergyInfoC, line: 2),
      ],
    );
  }

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
          if (value.isEmpty) {
            return 'Please enter some text';
          }
          return null;
        },
      ),
    );
  }

}
