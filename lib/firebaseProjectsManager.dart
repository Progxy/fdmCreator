import 'package:firebase_core/firebase_core.dart';

class FirebaseProjectsManager {
  static FirebaseApp secondaryApp;
  static FirebaseApp defaultApp;

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
      secondaryApp = Firebase.app("fdmApp");
      return;
    }
  }

  getSecondary() {
    return secondaryApp;
  }

  connectFirebaseDefault() async {
    try {
      defaultApp = await Firebase.initializeApp(
        name: 'default',
        options: const FirebaseOptions(
          apiKey: 'AIzaSyB9UyS_Sz1TtMNs8_qAsZnmi4WaSeR5GAQ',
          appId: '1:1096652698814:android:76ca6de6dbc5f891e0daef',
          messagingSenderId: '1096652698814',
          projectId: 'fdmcreator',
        ),
      );
      return;
    } catch (e) {
      defaultApp = Firebase.app("default");
      return;
    }
  }

  getDefault() {
    return defaultApp;
  }
}
