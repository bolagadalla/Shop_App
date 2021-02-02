import 'dart:convert';
import 'dart:async';

import '../models/http_exceptions.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Auth with ChangeNotifier {
  String _token;
  DateTime _expiryDate;
  String _userID;
  Timer _authTimer;

  bool get isAuth {
    return token != null;
  }

  String get token {
    if (_expiryDate != null &&
        _expiryDate.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    }
    return null;
  }

  String get userID {
    return _userID;
  }

  Future<void> _authenticate(
    String email,
    String password,
    String urlSegment,
  ) async {
    try {
      final url =
          "https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=AIzaSyAMNhRaYXhlHlL-20WZ52_n8nLSiHmnBpA";

      final responde = await http.post(
        url,
        body: json.encode(
          {
            "email": email,
            "password": password,
            "returnSecureToken": true,
          },
        ),
      );
      // Since Firebase does not return an error status code
      // They return a json with the error in it. So we look at that error
      final responseData = json.decode(responde.body);
      if (responseData["error"] != null) {
        throw HttpException(responseData["error"]["message"]);
      }
      _token = responseData["idToken"];
      _userID = responseData["localId"];
      _expiryDate = DateTime.now().add(
        Duration(
          seconds: int.parse(responseData["expiresIn"]),
        ),
      );
      _autoLogout();
      notifyListeners();
      final prefs = await SharedPreferences.getInstance();
      // Json object with user information of log ins
      final userData = json.encode(
        {
          "token": _token,
          "userID": _userID,
          "expiryDate": _expiryDate.toIso8601String(),
        },
      );
      // saves the json as a string
      prefs.setString("USER_DATA", userData);
    } catch (error) {
      throw error;
    }
  }

  // Returning a method that would run in the Future which takes time to execute
  Future<void> signUp(String email, String password) async {
    return _authenticate(email, password, "signUp");
  }

  // Returning a method that would run in the Future which takes time to execute
  Future<void> signIn(String email, String password) async {
    return _authenticate(email, password, "signInWithPassword");
  }

  Future<bool> tryAutoLogin() async {
    // Get the instance of the "SharedPreference" to use its methods
    final prefs = await SharedPreferences.getInstance();

    // If the prefs doesnt have an object key with "USER_DATA" that means we didnt save user data before
    if (!prefs.containsKey("USER_DATA")) return false;

    // Get the json folder
    final extractedUserData =
        json.decode(prefs.getString("USER_DATA")) as Map<String, dynamic>;

    // Get the expiration date on the token
    final expiryDate = DateTime.parse(extractedUserData["expiryDate"]);
    // if the expiry date is in the past then we return false because that means the token has expired
    if (expiryDate.isBefore(DateTime.now())) return false;

    _token = extractedUserData["token"];
    _userID = extractedUserData["userID"];
    _expiryDate = expiryDate;
    notifyListeners();
    // Have auto log out activate
    _autoLogout();
    return true; // we found user token that did not expire yet
  }

  Future<void> logout() async {
    _token = null;
    _userID = null;
    _expiryDate = null;
    if (_authTimer != null) {
      _authTimer.cancel();
      _authTimer = null;
    }
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    prefs.remove("USER_DATA");
  }

  void _autoLogout() {
    if (_authTimer != null) {
      _authTimer.cancel();
    }
    final timeTilExpiry = _expiryDate.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(Duration(seconds: timeTilExpiry), logout);
  }
}
