class AuthBool {
  bool _loginAsGuest = false;

  bool get loginAsGuest => _loginAsGuest;

  set loginAsGuest(bool value) {
    _loginAsGuest = value;
    print("IIIIIIIIIIIII  setter method AuthBool $_loginAsGuest");
  }
}