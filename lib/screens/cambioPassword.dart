import 'package:connectivity/connectivity.dart';
import 'package:fdmCreator/screens/utilizzo.dart';
import 'package:flutter/material.dart';

import 'badConnection.dart';
import 'feedback.dart';
import 'mainDrawer.dart';

class CambioPassword extends StatefulWidget {
  static const String routeName = "/cambioPassword";

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

  @override
  Widget build(BuildContext context) {
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
        body: Center(
          child: Padding(
            padding: const EdgeInsets.only(
              right: 15.0,
              left: 15.0,
            ),
            child: Text(
              "Cambio Password!",
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w800,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ));
  }
}
