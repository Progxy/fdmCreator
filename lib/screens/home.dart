import 'package:fdmCreator/screens/access.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../accountInfo.dart';
import '../authentication_service.dart';

class Home extends StatelessWidget {
  static const String routeName = "/home";
  final String name = AccountInfo.name;
  @override
  Widget build(BuildContext context) {
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
              AccountInfo().resetCredentials();
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
      // drawer: MainDrawer(),
      body: Center(
        child: Text(
          "Benvenuto $name nella tua area personale!",
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.w800,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
