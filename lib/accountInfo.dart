import 'dart:collection';

import 'package:firebase_database/firebase_database.dart';

class AccountInfo {
  static String name = "Login";
  static String email = "me@example.com";
  static bool isManager = false;
  static var userId;

  setter(String username, String mail, bool isAccountManager) {
    name = username;
    email = mail;
    isManager = isAccountManager;
  }

  setUser(id, bool manager) {
    userId = id;
    isManager = manager;
  }

  setFromUserId(database) async {
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
      AccountInfo().setter(username, email, isManager ?? false);
    });
  }

  resetCredentials() {
    name = "Login";
    email = "me@example.com";
    isManager = false;
  }
}
