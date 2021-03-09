import 'package:connectivity/connectivity.dart';
import 'package:fdmCreator/screens/mainDrawer.dart';
import 'package:fdmCreator/screens/utilizzo.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'badConnection.dart';
import 'feedback.dart';

class CreateContent extends StatefulWidget {
  static const String routeName = "/createContent";

  @override
  _CreateContentState createState() => _CreateContentState();
}

class _CreateContentState extends State<CreateContent> {
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
          "Area Creazione Contenuti",
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
          children: <Widget>[
            SizedBox(
              height: 15,
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: 10,
                right: 10,
              ),
              child: Text(
                "Selezionare gli elementi presenti nella colonna a scomparsa di destra e trascinarli a piacimento nella pagina.",
                style: TextStyle(
                  fontSize: 25,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            //colonna a scomparsa con elementi dragable, usa la card come dragableArea
            SizedBox(
              height: 15,
            ),
            Card(
              //aggiungi sfumatura per dare contrasto e renderla visibile
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
            SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}
