import 'dart:collection';

import 'package:firebase_database/firebase_database.dart';

class AccountInfo {
  static String name = "Login";
  static String email = "me@example.com";
  static bool isManager = false;
  static var userId;

  setIsManager(bool isAccountManager) {
    isManager = isAccountManager;
  }

  setter(String username, String mail, bool isAccountManager) {
    name = username;
    email = mail;
    isManager = isAccountManager;
  }

  setUser(id, bool manager) {
    userId = id;
    isManager = manager;
  }

  setFromUserId(database, isAManager) async {
    if (isAManager) {
      await database
          .reference()
          .child(userId + "/User")
          .once()
          .then((DataSnapshot snapshot) {
        final Map map = snapshot.value.map((a, b) => MapEntry(a, b));
        final username = map.keys.first;
        final email = map.values.first;
        AccountInfo().setter(username, email, true);
      });
    } else {
      await database
          .reference()
          .child(userId)
          .child("User")
          .orderByValue()
          .once()
          .then((DataSnapshot snapshot) {
        LinkedHashMap<dynamic, dynamic> values = snapshot.value;
        String username;
        String email;
        Map<String, String> map =
            values.map((a, b) => MapEntry(a as String, b as String));
        map.forEach((k, value) => {username = k});
        map.forEach((k, value) => {email = value});
        AccountInfo().setter(username, email, false);
      });
    }
  }

  resetCredentials() {
    name = "Login";
    email = "me@example.com";
    isManager = false;
  }
}
