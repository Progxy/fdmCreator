import 'package:firebase_core/firebase_core.dart';

class FirebaseProjectsManager {
  FirebaseApp secondaryApp;

  connectFirebaseSecondary() async {
    final FirebaseApp app = await Firebase.initializeApp(
      name: 'fdmApp',
      options: const FirebaseOptions(
        apiKey: 'AIzaSyCmiAVLF7dIR9U90riDHxbLalq80dBUlfk',
        appId: '1:1096652698814:android:76ca6de6dbc5f891e0daef',
        messagingSenderId: '1096652698814',
        projectId: 'fdmapp-2dad1',
      ),
    );
    secondaryApp = app;
    print(secondaryApp);
    return app;
  }
}
