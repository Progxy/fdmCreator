class AccountInfo {
  static String name = "Login";
  static String email = "me@example.com";
  static bool isManager;

  setter(String username, String mail, bool isAccountManager) {
    name = username;
    email = mail;
    isManager = isAccountManager;
  }

  resetCredentials() {
    name = "Login";
    email = "me@example.com";
    isManager = false;
  }
}
