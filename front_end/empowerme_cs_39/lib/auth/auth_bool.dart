class AuthBool {
  bool _loginAsGuest = true;

  bool get loginAsGuest => _loginAsGuest;

  set loginAsGuest(bool value) {
    _loginAsGuest = value;
  }
}
