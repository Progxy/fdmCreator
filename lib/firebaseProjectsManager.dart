import 'package:firebase_core/firebase_core.dart';

class FirebaseProjectsManager {
  static FirebaseApp secondaryApp;

  connectFirebaseSecondary() async {
    try {
      secondaryApp = await Firebase.initializeApp(
        name: 'fdmApp',
        options: const FirebaseOptions(
          apiKey: 'AIzaSyCmiAVLF7dIR9U90riDHxbLalq80dBUlfk',
          appId: '1:1096652698814:android:76ca6de6dbc5f891e0daef',
          messagingSenderId: '1096652698814',
          projectId: 'fdmapp-2dad1',
        ),
      );
      return;
    } catch (e) {
      print("error : $e");
      secondaryApp = Firebase.app("fdmApp");
      return;
    }
  }

  getSecondary() {
    return secondaryApp;
  }
}
