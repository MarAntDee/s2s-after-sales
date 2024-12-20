import 'dart:html' as html;
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:surf2sawa/blocs/base.dart';
import 'package:surf2sawa/main.dart';
import 'package:surf2sawa/models/account.dart';
import 'package:surf2sawa/utils/api.dart';
import 'package:surf2sawa/utils/dev-tools.dart';
import 'package:surf2sawa/utils/navigator.dart';

import '../models/outage.dart';

class AuthBloc implements BlocBase {
  final SharedPreferences cache;
  //CHECK ACCOUNT VALUES
  String? pendingReferenceNumber, maskedMobileNumber, pincode;
  String pendingAccountNumber = "";
  bool? autolink;

  //USER ID / NAME
  String? get userId => cache.getString("userId");
  set userId(String? newValue) {
    if (newValue == null) {
      cache.remove("userId");
    } else {
      cache.setString("userId", newValue);
    }
  }
  String? get username => cache.getString("username");
  set username(String? newValue) {
    if (newValue == null) {
      cache.remove("username");
    } else {
      cache.setString("username", newValue);
    }
  }

  //PAGE
  final BehaviorSubject<int> _pageController = BehaviorSubject<int>();
  set selectedIndex(int newValue) => _pageController.add(newValue);
  Stream<int> get pageStream => _pageController.stream;
  pushToShop() => selectedIndex = 1;
  pushToJournal() => selectedIndex = 3;

  void _parseBaseParameter() {
    print("PARSING BASE PARAMETER...");
    try {
      if (kDebugMode) {
        userId = "639285018871";
        username = "nap";
        return;
      }
      String url = html.window.location.href;
      if (!url.contains("?")) return;
      List<String> chunk = url.split("?");
      if (chunk.length != 2) return;
      String rawParam = url.split("?")[1];
      if (rawParam.isEmpty) return;
      List<String> queryChunks = rawParam.split("&");
      Map<String, String> queryParameter = {};
      for (String query in queryChunks) {
        if (!query.contains("=")) throw "Improper format";
        List<String> entry = query.split("=");
        if (entry.length != 2) throw "Improper format";
        queryParameter[entry[0].toString()] = entry[1].toString();
      }
      if (queryParameter.containsKey("userId")) userId = queryParameter["userId"];
      if (queryParameter.containsKey("username")) username = queryParameter["username"];
    } catch (e) {
      return;
    }
  }

  Future<String?> checkAccount() async {
    try {
      Map<String, dynamic> payload = await ProdApi().checkAccount(
        pendingAccountNumber,
        userId: userId,
        username: username,
      );
      maskedMobileNumber = payload["mobileNumber"];
      autolink = !payload.putIfAbsent(
        "requireOTP",
        () => payload["status"] == "NOT_VERIFIED",
      );
      if (autolink ?? false) referenceNumber = payload["referenceNumber"];
      pendingReferenceNumber = payload["referenceNumber"];
      pincode = payload['pincode'];
      return pincode;
    } catch (e) {
      print("AUTHBLOC CHECK ACCOUNT ERROR: ${e.toString()}");
      rethrow;
    }
  }

  Future verifyAccount(String code) async {
    try {
      bool success = await ProdApi().verifyAccount(code);
      if (!success) throw "OTP Verification failed please try again";
      await getAccountInfo();
      referenceNumber = pendingReferenceNumber;
    } catch (e) {
      print("AUTHBLOC VERIFY ACCOUNT ERROR: ${e.toString()}");
      rethrow;
    }
  }

  //DEVICE ID
  static const String _uuidCacheKey = "uuid";
  String? get uuid => cache.getString(_uuidCacheKey);
  set uuid(String? newValue) {
    if (newValue == null) {
      print("DELETING UNIQUE ID FROM CACHE");
      cache.remove(_uuidCacheKey);
    } else {
      print("SETTING UNIQUE ID TO $newValue");
      cache.setString(_uuidCacheKey, newValue);
    }
  }

  static const _chars =
      'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  static String _generateUuid(int length) =>
      String.fromCharCodes(Iterable.generate(
          length, (_) => _chars.codeUnitAt(Random().nextInt(_chars.length))));

  //ACCOUNT INFO
  static const String _refCacheKey = "referenceNumber";
  String? get referenceNumber => cache.getString(_refCacheKey);
  set referenceNumber(String? newValue) {
    if (newValue == null) {
      print("DELETING REFERENCE NUMBER FROM CACHE");
      cache.remove(_refCacheKey);
    } else {
      print("SETTING REFERENCE NUMBER TO $newValue");
      cache.setString(_refCacheKey, newValue);
    }
  }

  //WELCOME PAGE
  static const String _showWelcomeKey = "showWelcomeKey";
  bool get showWelcomeKey => cache.getBool(_showWelcomeKey) ?? true;
  set showWelcomeKey(bool newValue) {
    cache.setBool(_showWelcomeKey, newValue);
  }

  final BehaviorSubject<Account?> _currentAccountController =
      BehaviorSubject<Account?>();
  Stream<Account?> get accountStream => _currentAccountController.stream;

  bool get isLoggedIn => cache.containsKey(_refCacheKey);

  //ACCOUNT INFO
  Account? _account;
  set currentAccount(Account? newValue) {
    if (newValue != null) {
      DevTools.printModel<Account>(newValue, withNew: true);
    } else {
      print("DELETING ACCOUNT");
    }
    _currentAccountController.add(newValue);
    _account = newValue;
  }

  void logout({bool? autologout}) {
    String? error = (autologout ?? false)
        ? "Your account is logged in on another device, please log in again."
        : null;
    currentAccount = null;
    referenceNumber = null;
    pendingAccountNumber = "";
    pendingReferenceNumber = null;
    maskedMobileNumber = null;
    pincode = null;
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      Navigator.of(navigatorKey.currentContext!).popUntilLogin(
        error: error,
      );
    });
  }

  Account? get currentAccount =>
      _currentAccountController.valueOrNull ?? _account;
  Future getAccountInfo() async {
    try {
      String? refNumber = referenceNumber ?? pendingReferenceNumber;
      if (refNumber == null) throw "Unknown Reference Number";
      currentAccount = await ProdApi().getAccount();
    } catch (e) {
      print("AUTHBLOC GET ACCOUNT INFO ERROR: ${e.toString()}");
      rethrow;
    }
  }

  //OUTAGE
  Future<Outage?> getOutage() async {
    Outage? outage = await ProdApi().getOutage();
    print("GET OUTAGE MAP: ${outage?.toMap()}");
    return outage;
  }

  //OTP
  List<String> expiredOtps = [];

  AuthBloc._(this.cache) {
    _parseBaseParameter();
    uuid ??= _generateUuid(64);
  }

  @override
  void dispose() {}

  static Widget build(
          {required SharedPreferences cache, required Widget child}) =>
      BlocProvider<AuthBloc>(
        bloc: AuthBloc._(cache),
        child: child,
      );

  static AuthBloc? instance(BuildContext context) =>
      BlocProvider.of<AuthBloc>(context);
}
