import 'package:fdmCreator/screens/access.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import '../accountInfo.dart';
import '../authentication_service.dart';
import '../firebaseProjectsManager.dart';
import 'mainDrawer.dart';

class Home extends StatefulWidget {
  static const String routeName = "/home";
  Home({this.defaultApp});
  final FirebaseApp secondaryApp = FirebaseProjectsManager().getSecondary();
  final FirebaseApp defaultApp;

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String name = AccountInfo.name;
  final bool isManager = AccountInfo.isManager;

  @override
  Widget build(BuildContext context) {
    final FirebaseDatabase database = isManager
        ? FirebaseDatabase(app: widget.defaultApp)
        : FirebaseDatabase(app: widget.secondaryApp);
    final FirebaseAuth _auth = isManager
        ? FirebaseAuth.instanceFor(app: widget.secondaryApp)
        : FirebaseAuth.instanceFor(app: widget.defaultApp);

    getAccount() async {
      if (name == "Login") {
        setState(() async {
          await AccountInfo().setFromUserId(database);
          name = AccountInfo.name;
        });
        return name;
      }
    }

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Color.fromARGB(255, 192, 192, 192),
        ),
        title: Text(
          "Home di $name",
          style: TextStyle(
            color: Color.fromARGB(255, 192, 192, 192),
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              AuthenticationService(_auth).signOut();
              Navigator.pushReplacementNamed(context, Access.routeName);
            },
            icon: Icon(
              Icons.logout,
              size: 40.0,
              color: Color.fromARGB(255, 192, 192, 192),
            ),
          )
        ],
        backgroundColor: Color.fromARGB(255, 24, 37, 102),
        centerTitle: true,
      ),
      drawer: MainDrawer(),
      body: FutureBuilder(
          future: getAccount(),
          builder: (context, AsyncSnapshot<dynamic> snapshot) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.only(
                  right: 15.0,
                  left: 15.0,
                ),
                child: Text(
                  "Benvenuto $name nella tua area di Creator, qui potrai creare articoli e altri contenuti per le risorse digitali della Fondazione Don Milani!",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w800,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }),
    );
  }
}
