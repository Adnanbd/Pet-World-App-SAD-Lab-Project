import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pet_world/screens/home_screen.dart';

class Login extends StatelessWidget {
  TextEditingController loginC = TextEditingController();
  TextEditingController passC = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
        body: SingleChildScrollView(
                  child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 120,),
                  Image.network("https://images.ctfassets.net/y5z23yb0t4f0/13ivYcFz04vy24IEMN3UNn/24cb7bd7ad4609d768a0c138f5938528/pets31.jpg"),
                  Text("Pet World - Login",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.green,fontSize: 30),),
                  SizedBox(height: 20,),
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: TextFormField(
                      controller: loginC,
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
                        labelText: "Email",
                        labelStyle: TextStyle(
                            //color: config.getPrimaryDark(),
                            ),
                      ),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Don\'t leave this field empty';
                        }
                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: TextFormField(
                      controller: passC,
                      obscureText: true,
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
                        labelText: "Password",
                        labelStyle: TextStyle(
                            //color: config.getPrimaryDark(),
                            ),
                      ),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Don\'t leave this field empty';
                        }
                        return null;
                      },
                    ),
                  ),
                  FlatButton(
                      onPressed: () {
                        if (_formKey.currentState.validate()) {
                          FirebaseFirestore.instance
                              .collection('UserDetails')
                              .where('login', isEqualTo: loginC.text.trim())
                              .get()
                              .then((value) {
                            print(value);
                            value.docs.first.data()['password'] == passC.text
                                ? AwesomeDialog(
                                    context: context,
                                    dialogType: DialogType.SUCCES,
                                    animType: AnimType.BOTTOMSLIDE,
                                    title: 'Matched!',
                                    desc: 'Successfully Login.',
                                    //btnCancelOnPress: () {},
                                    btnOkOnPress: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                HomeScreen(int.parse(value.docs.first.data()['userId']))),
                                      );
                                    },
                                  ).show()
                                : AwesomeDialog(
                                    context: context,
                                    dialogType: DialogType.ERROR,
                                    animType: AnimType.BOTTOMSLIDE,
                                    title: 'Wrong Password!',
                                    desc: 'Your given password not matched.',
                                    btnCancelOnPress: () {},
                                    btnOkOnPress: () {},
                                  ).show();
                          }).catchError((v) {
                            print("Error =========== User ================== " +
                                v.toString());
                            AwesomeDialog(
                              context: context,
                              dialogType: DialogType.ERROR,
                              animType: AnimType.BOTTOMSLIDE,
                              title: 'Re-Enter!',
                              desc:
                                  'Your given Email not existed in our database',
                              btnCancelOnPress: () {},
                              btnOkOnPress: () {},
                            ).show();
                          });
                        }
                      },
                      child: Text("Login",style: TextStyle(color: Colors.white),),
                      color: Colors.green,
                      )
                ],
              )),
        ));
  }
}
