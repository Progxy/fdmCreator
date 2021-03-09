import 'package:fdmCreator/screens/access.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../authentication_service.dart';

class ErrorPage extends StatefulWidget {
  static const String routeName = "/errorPage";
  @override
  _ErrorPageState createState() => _ErrorPageState();
}

class _ErrorPageState extends State<ErrorPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Color.fromARGB(255, 192, 192, 192),
        ),
        title: Text(
          "Errore",
          style: TextStyle(
            color: Color.fromARGB(255, 192, 192, 192),
            fontWeight: FontWeight.w700,
          ),
        ),
        backgroundColor: Color.fromARGB(255, 24, 37, 102),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Padding(
                padding: const EdgeInsets.only(
                  top: 20.0,
                ),
                child: Icon(
                  Icons.error,
                  size: 75.0,
                  color: Colors.red,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                "Email o Password invalida!",
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w800,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Center(
              child: FloatingActionButton(
                onPressed: () {
                  context.read<AuthenticationService>().signOut();
                  Navigator.pushReplacementNamed(context, Access.routeName);
                },
                child: Icon(
                  Icons.arrow_back_rounded,
                  size: 50.0,
                ),
                backgroundColor: Color.fromARGB(255, 24, 37, 102),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
