import 'package:flutter/material.dart';
import 'app.dart';
import 'firebaseProjectsManager.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FirebaseProjectsManager().connectFirebaseDefault();
  await FirebaseProjectsManager().connectFirebaseSecondary();
  runApp(MyApp());
}
