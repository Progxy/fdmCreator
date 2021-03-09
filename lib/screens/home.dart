import 'package:fdmCreator/screens/access.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../accountInfo.dart';
import '../authentication_service.dart';
import '../firebaseProjectsManager.dart';
import 'mainDrawer.dart';

class Home extends StatelessWidget {
  static const String routeName = "/home";
  final String name = AccountInfo.name;
  final FirebaseApp app = FirebaseProjectsManager().getSecondary();

  @override
  Widget build(BuildContext context) {
    final FirebaseAuth _auth = FirebaseAuth.instanceFor(app: app);
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
              context.read<AuthenticationService>().signOut();
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
      body: Center(
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
      ),
    );
  }
}
