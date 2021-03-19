import 'dart:io';
import 'package:connectivity/connectivity.dart';
import 'package:fdmCreator/firebaseProjectsManager.dart';
import 'package:fdmCreator/screens/utilizzo.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'badConnection.dart';
import 'feedback.dart';
import 'mainDrawer.dart';

class NotificationsCreator extends StatefulWidget {
  static const String routeName = "/creaNotifica";
  final FirebaseDatabase database =
      FirebaseDatabase(app: FirebaseProjectsManager().getSecondary());
  @override
  _NotificationsCreatorState createState() => _NotificationsCreatorState();
}

class _NotificationsCreatorState extends State<NotificationsCreator> {
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
  final _textController = TextEditingController();
  final _titleController = TextEditingController();

  pushNotification(String title, String text) {
    try {
      var databaseReference = widget.database.reference().child("Info");
      databaseReference.set({title: text});
      return true;
    } catch (e) {
      print("An error occurred while posting on database : $e");
      return false;
    }
  }

  verifyTitleExist(String title) async {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Color.fromARGB(255, 192, 192, 192),
        ),
        title: Text(
          "Crea una Notifica",
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
                      controller: _titleController,
                      decoration: const InputDecoration(
                        hintText: "Inserire il titolo",
                        hintStyle: TextStyle(
                          fontSize: 23.0,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                        border: OutlineInputBorder(),
                        labelText: "Titolo Notifica",
                        labelStyle: TextStyle(
                          fontSize: 23.0,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
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
                    height: 30,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 15, right: 15),
                    child: TextFormField(
                      controller: _textController,
                      maxLines: 5,
                      decoration: const InputDecoration(
                        hintText: "Inserire il testo",
                        hintStyle: TextStyle(
                          fontSize: 23.0,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                        border: OutlineInputBorder(),
                        labelText: "Testo Notifica",
                        labelStyle: TextStyle(
                          fontSize: 23.0,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
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
                    height: 25,
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
                          "CREA NOTIFICA",
                          style: TextStyle(
                            fontSize: 23,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    onPressed: () {
                      if (_formKey.currentState.validate()) {
                        final title = _titleController.text.trim();
                        final text = _textController.text.trim();
                        final result = pushNotification(title, text);
                        if (result.runtimeType == String) {
                          print("error : $result");
                          return;
                        }
                        if (!result) {
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
                                          "Esito Creazione Notifica",
                                          style: TextStyle(
                                            fontSize: 28,
                                          ),
                                        ),
                                        content: Text(
                                          "Ops... Si è verificato un'errore durante il salvataggio !",
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
                                          "Esito Creazione Notifica",
                                          style: TextStyle(
                                            fontSize: 28,
                                          ),
                                        ),
                                        content: Text(
                                          "Ops... Si è verificato un'errore durante il salvataggio !",
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
                        } else {
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
                                          "Esito Creazione Notifica",
                                          style: TextStyle(
                                            fontSize: 28,
                                          ),
                                        ),
                                        content: Text(
                                          "Notifica creata con successo !",
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
                                          "Esito Creazione Notifica",
                                          style: TextStyle(
                                            fontSize: 28,
                                          ),
                                        ),
                                        content: Text(
                                          "Notifica creata con successo !",
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
                          _titleController.clear();
                          _textController.clear();
                        }
                        return;
                      }
                    },
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 35,
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
