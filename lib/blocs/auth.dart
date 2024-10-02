import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:rxdart/rxdart.dart';
import 'package:s2s_after_sales/blocs/base.dart';
import 'package:s2s_after_sales/main.dart';
import 'package:s2s_after_sales/models/account.dart';
import 'package:s2s_after_sales/utils/api.dart';
import 'package:s2s_after_sales/utils/dev-tools.dart';
import 'package:s2s_after_sales/utils/navigator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthBloc implements BlocBase {
  final SharedPreferences cache;
  //CHECK ACCOUNT VALUES
  String? pendingReferenceNumber, maskedMobileNumber, pincode;
  String pendingAccountNumber = "";
  bool? autolink;

  Future<String?> checkAccount() async {
    try {
      Map<String, dynamic> payload =
          await ProdApi().checkAccount(pendingAccountNumber);
      maskedMobileNumber = payload["mobileNumber"];
      autolink = payload.putIfAbsent(
        "autolink",
        () => payload["status"] != "NOT_VERIFIED",
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
    String? _error = (autologout ?? false)
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
        error: _error,
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

  //OTP
  List<String> expiredOtps = [];

  AuthBloc._(this.cache) {
    if (uuid == null) uuid = _generateUuid(64);
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
