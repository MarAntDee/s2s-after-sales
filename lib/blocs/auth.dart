import 'package:flutter/material.dart';
import 'package:s2s_after_sales/blocs/base.dart';
import 'package:s2s_after_sales/utils/api.dart';
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
      bool success =
          await ProdApi().verifyAccount(code, pendingReferenceNumber!);
      if (!success) throw "OTP Verification failed please try again";
      await getAccountInfo();
      referenceNumber = pendingReferenceNumber;
    } catch (e) {
      print("AUTHBLOC VERIFY ACCOUNT ERROR: ${e.toString()}");
      rethrow;
    }
  }

  //ACCOUNT INFO
  static const String _refCacheKey = "referenceNumber";
  String? get referenceNumber => cache.getString(_refCacheKey);
  set referenceNumber(String? newValue) {
    print("SETTING REFERENCE NUMBER TO $newValue");
    if (newValue == null) {
      cache.remove(_refCacheKey);
    } else {
      cache.setString(_refCacheKey, newValue);
    }
  }

  Future getAccountInfo() async {
    try {
      String? refNumber = referenceNumber ?? pendingReferenceNumber;
      if (refNumber == null) throw "Unknown Reference Number";
      await ProdApi().getAccount(refNumber);
    } catch (e) {
      print("AUTHBLOC GET ACCOUNT INFO ERROR: ${e.toString()}");
      rethrow;
    }
  }

  //OTP
  List<String> expiredOtps = [];

  AuthBloc._(this.cache);

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
