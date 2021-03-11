import 'package:fdmCreator/screens/access.dart';
import 'package:fdmCreator/screens/accessIscritti.dart';
import 'package:fdmCreator/screens/badConnection.dart';
import 'package:fdmCreator/screens/contentWorkBench.dart';
import 'package:fdmCreator/screens/errorpage.dart';
import 'package:fdmCreator/screens/feedback.dart';
import 'package:fdmCreator/screens/home.dart';
import 'package:fdmCreator/screens/utilizzo.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'authentication_service.dart';
import 'firebaseProjectsManager.dart';

class MyApp extends StatelessWidget {
  initializeFirebase() async {
    await FirebaseProjectsManager().connectFirebaseSecondary();
    await FirebaseProjectsManager().connectFirebaseDefault();
    await Firebase.initializeApp();
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AuthenticationService>(
          create: (_) => AuthenticationService(FirebaseAuth.instance),
        ),
        StreamProvider(
          create: (context) =>
              context.read<AuthenticationService>().authStateChanges,
          initialData: null,
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'FdmCreator',
        theme: ThemeData(
          fontFamily: "Avenir",
          primaryColor: Color.fromARGB(255, 24, 37, 102),
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: FutureBuilder(
          future: initializeFirebase(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return ErrorPage();
            }
            if (snapshot.hasData) {
              print("resultfirst : ${snapshot.data}");
              return Access();
            }
            return CircularProgressIndicator();
          },
        ),
        routes: {
          Access.routeName: (context) => Access(),
          AccessIscritti.routeName: (context) => AccessIscritti(),
          BadConnection.routeName: (context) => BadConnection(),
          Utilizzo.routeName: (context) => Utilizzo(),
          FeedBack.routeName: (context) => FeedBack(),
          Home.routeName: (context) => Home(),
          ErrorPage.routeName: (context) => ErrorPage(),
          CreateContent.routeName: (context) => CreateContent(),
        },
      ),
    );
  }
}
