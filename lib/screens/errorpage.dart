import 'package:fdmCreator/accountInfo.dart';
import 'package:fdmCreator/firebaseProjectsManager.dart';
import 'package:fdmCreator/screens/access.dart';
import 'package:fdmCreator/screens/accessIscritti.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import '../authentication_service.dart';

class ErrorPage extends StatefulWidget {
  static const String routeName = "/errorPage";
  final FirebaseApp app = Firebase.app();
  final FirebaseApp appIscritti = FirebaseProjectsManager().getSecondary();

  @override
  _ErrorPageState createState() => _ErrorPageState();
}

class _ErrorPageState extends State<ErrorPage> {
  @override
  Widget build(BuildContext context) {
    final String email = ModalRoute.of(context).settings.arguments as String;
    final bool isManager = AccountInfo.isManager;
    final FirebaseAuth _auth = isManager
        ? FirebaseAuth.instanceFor(app: widget.app)
        : FirebaseAuth.instanceFor(app: widget.appIscritti);
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
            SizedBox(
              height: 20,
            ),
            Center(
              child: FloatingActionButton(
                onPressed: () async {
                  await AuthenticationService(_auth).signOut();
                  Navigator.pushReplacementNamed(context,
                      isManager ? Access.routeName : AccessIscritti.routeName);
                },
                child: Icon(
                  Icons.arrow_back_rounded,
                  size: 50.0,
                ),
                backgroundColor: Color.fromARGB(255, 24, 37, 102),
              ),
            ),
            SizedBox(
              height: 65,
            ),
            Center(
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                    Color.fromARGB(255, 24, 37, 102),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(7),
                  child: Text(
                    "Reimposta Password",
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.w600),
                  ),
                ),
                onPressed: () async {
                  final String res =
                      await AuthenticationService(_auth).resetPassword(email);
                  final snackBar = SnackBar(
                    content: Text(res),
                    duration: Duration(seconds: 2),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
