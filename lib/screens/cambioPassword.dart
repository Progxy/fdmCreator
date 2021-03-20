import 'dart:io';

import 'package:connectivity/connectivity.dart';
import 'package:fdmCreator/authentication_service.dart';
import 'package:fdmCreator/screens/utilizzo.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'badConnection.dart';
import 'feedback.dart';
import 'mainDrawer.dart';

class CambioPassword extends StatefulWidget {
  static const String routeName = "/cambioPassword";
  final FirebaseApp app = Firebase.app();

  @override
  _CambioPasswordState createState() => _CambioPasswordState();
}

class _CambioPasswordState extends State<CambioPassword> {
  final List<String> choices = <String>[
    "FeedBack",
    "Aiuto",
  ];

  void choiceAction(String choice) async {
    if (choice == "Aiuto") {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => Utilizzo()));
    } else {
      var connectivityResult = await (Connectivity().checkConnectivity());
      if (connectivityResult == ConnectivityResult.none) {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => BadConnection()));
      } else {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => FeedBack()));
      }
    }
  }

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final FirebaseAuth _auth = FirebaseAuth.instanceFor(app: widget.app);
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Color.fromARGB(255, 192, 192, 192),
        ),
        title: Text(
          "Cambio Password",
          style: TextStyle(
            color: Color.fromARGB(255, 192, 192, 192),
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          PopupMenuButton<String>(
            onSelected: choiceAction,
            itemBuilder: (BuildContext context) {
              return choices.map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(
                    choice,
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                );
              }).toList();
            },
          )
        ],
        backgroundColor: Color.fromARGB(255, 24, 37, 102),
        centerTitle: true,
      ),
      drawer: MainDrawer(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 25,
            ),
            Form(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              key: _formKey,
              child: Column(
                children: [
                  SizedBox(
                    height: 25,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 15, right: 15),
                    child: TextFormField(
                      controller: _emailController,
                      decoration: const InputDecoration(
                        hintText: "Inserire l'email",
                        hintStyle: TextStyle(
                          fontSize: 23.0,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                        border: OutlineInputBorder(),
                        labelText: "Email",
                        labelStyle: TextStyle(
                          fontSize: 23.0,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                        icon: Icon(
                          Icons.email,
                          size: 35,
                        ),
                      ),
                      validator: (value) {
                        if (value.isEmpty) {
                          return "Dati Mancanti";
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  TextButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                        const Color.fromARGB(255, 24, 37, 102),
                      ),
                    ),
                    child: Container(
                      height: 40,
                      width: 200,
                      child: FittedBox(
                        fit: BoxFit.fitWidth,
                        child: Text(
                          "CAMBIA PASSWORD",
                          style: TextStyle(
                            fontSize: 23,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    onPressed: () async {
                      if (_formKey.currentState.validate()) {
                        final email = _emailController.text.trim();
                        final result = await AuthenticationService(_auth)
                            .resetPassword(email);
                        if (Platform.isIOS) {
                          showCupertinoDialog(
                            barrierDismissible: false,
                            context: context,
                            builder: (context) {
                              return StatefulBuilder(
                                builder: (context, setState) {
                                  return WillPopScope(
                                    onWillPop: () async => false,
                                    child: CupertinoAlertDialog(
                                      title: Text(
                                        "Esito Cambio Password",
                                        style: TextStyle(
                                          fontSize: 28,
                                        ),
                                      ),
                                      content: Text(
                                        result,
                                        style: TextStyle(
                                          fontSize: 21,
                                        ),
                                      ),
                                      actions: [
                                        CupertinoDialogAction(
                                          child: Text(
                                            "OK",
                                            style: TextStyle(
                                              fontSize: 20,
                                            ),
                                          ),
                                          onPressed: () {
                                            Navigator.of(context,
                                                    rootNavigator: true)
                                                .pop('dialog');
                                          },
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              );
                            },
                          );
                        } else {
                          showDialog(
                            barrierDismissible: false,
                            context: context,
                            builder: (context) {
                              return StatefulBuilder(
                                builder: (context, setState) {
                                  return WillPopScope(
                                    onWillPop: () async => false,
                                    child: AlertDialog(
                                      title: Text(
                                        "Esito Cambio Password",
                                        style: TextStyle(
                                          fontSize: 28,
                                        ),
                                      ),
                                      content: Text(
                                        result,
                                        style: TextStyle(
                                          fontSize: 21,
                                        ),
                                      ),
                                      actions: [
                                        TextButton(
                                          child: Text(
                                            "OK",
                                            style: TextStyle(
                                              fontSize: 20,
                                            ),
                                          ),
                                          onPressed: () {
                                            Navigator.of(context,
                                                    rootNavigator: true)
                                                .pop('dialog');
                                          },
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              );
                            },
                          );
                        }
                        _emailController.clear();
                        return;
                      }
                    },
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 135,
            ),
            Image.asset(
              "assets/images/don_milani.png",
              fit: BoxFit.fill,
            ),
          ],
        ),
      ),
    );
  }
}
