import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'app.dart';
import 'firebaseProjectsManager.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp();
  } catch (e) {
    print("-\nError : $e\n-");
    await FirebaseProjectsManager().connectFirebaseDefault();
  }
  await FirebaseProjectsManager().connectFirebaseSecondary();
  runApp(MyApp());
}
