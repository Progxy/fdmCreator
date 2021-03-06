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
          // fontFamily: "PlayfairDisplay", change font family
          primaryColor: Color.fromARGB(255, 24, 37, 102),
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        // home: Access(),
        // routes: {
        //   Access.routeName: (context) => Access(),
        // },
      ),
    );
  }
}