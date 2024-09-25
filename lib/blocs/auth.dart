import 'package:flutter/material.dart';
import 'package:s2s_after_sales/blocs/base.dart';
import 'package:s2s_after_sales/utils/api.dart';

class AuthBloc implements BlocBase {
  //CHECK ACCOUNT VALUES
  String? pendingReferenceNumber, maskedMobileNumber, pincode;
  String pendingAccountNumber = "";
  bool? autolink;

  Future checkAccount() async {
    try {
      Map<String, dynamic> payload =
          await ProdApi().checkAccount(pendingAccountNumber);
      maskedMobileNumber = payload["mobileNumber"];
      autolink = payload.putIfAbsent(
        "autolink",
        () => payload["status"] != "NOT_VERIFIED",
      );
      pincode = payload['pincode'];
    } catch (e) {
      print("AUTHBLOC CHECK ACCOUNT ERROR: ${e.toString()}");
      rethrow;
    }
  }

  //OTP
  List<String> expiredOtps = [];

  @override
  void dispose() {}

  static Widget build({required Widget child}) => BlocProvider<AuthBloc>(
        bloc: AuthBloc(),
        child: child,
      );

  static AuthBloc? instance(BuildContext context) =>
      BlocProvider.of<AuthBloc>(context);
}
