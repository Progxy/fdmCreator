import 'package:firebase_core/firebase_core.dart';

class FirebaseProjectsManager {
  static FirebaseApp secondaryApp;
  static FirebaseApp managerApp;

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

  connectFirebaseManager() async {
    try {
      managerApp = await Firebase.initializeApp(
        name: 'fdmManager',
        options: const FirebaseOptions(
          apiKey: 'AIzaSyAChLxG1f4Ns6eFa7xMUZT977ZptW6Sjno',
          appId: '1:572166541054:android:95f8cda1f3ba43e3da1faf',
          messagingSenderId: '572166541054',
          projectId: 'fdmmanager-2fef4',
        ),
      );
      return;
    } catch (e) {
      managerApp = Firebase.app("fdmManager");
      return;
    }
  }

  getManager() {
    return managerApp;
  }
}
