class SessionService {
  bool _isLogged = false;
  static final SessionService _instance = SessionService._();

  SessionService._();

  factory SessionService() {
    return _instance;
  }

  login() {
    _isLogged = true;
  }

  logOut() {
    _isLogged = false;
  }

  bool isLogedIn() {
    return _isLogged;
  }
}
