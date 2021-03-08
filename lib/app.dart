import 'package:fdmCreator/screens/access.dart';
import 'package:fdmCreator/screens/accessIscritti.dart';
import 'package:fdmCreator/screens/badConnection.dart';
import 'package:fdmCreator/screens/errorpage.dart';
import 'package:fdmCreator/screens/feedback.dart';
import 'package:fdmCreator/screens/home.dart';
import 'package:fdmCreator/screens/utilizzo.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'authentication_service.dart';

class MyApp extends StatelessWidget {
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
        home: Access(),
        routes: {
          Access.routeName: (context) => Access(),
          AccessIscritti.routeName: (context) => AccessIscritti(),
          BadConnection.routeName: (context) => BadConnection(),
          Utilizzo.routeName: (context) => Utilizzo(),
          FeedBack.routeName: (context) => FeedBack(),
          Home.routeName: (context) => Home(),
          ErrorPage.routeName: (context) => ErrorPage(),
        },
      ),
    );
  }
}
