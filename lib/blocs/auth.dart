import 'package:flutter/material.dart';
import 'package:s2s_after_sales/blocs/base.dart';
import 'package:s2s_after_sales/utils/api.dart';

class AuthBloc implements BlocBase {
  //CHECK ACCOUNT VALUES
  String? pendingReferenceNumber, maskedMobileNumber;
  bool? autolink;

  Future checkAccount(String accountNumber) async {
    try {
      Map<String, dynamic> _payload =
          await ProdApi().checkAccount(accountNumber);
      this.maskedMobileNumber = _payload["mobileNumber"];
      this.autolink = _payload.putIfAbsent(
        "autolink",
        () => _payload["status"] != "NOT_VERIFIED",
      );
      this.pendingReferenceNumber = _payload["referenceNumber"];
    } catch (e) {
      print("AUTHBLOC CHECK ACCOUNT ERROR: ${e.toString()}");
      throw e;
    }
  }

  @override
  void dispose() {}

  static Widget build({required Widget child}) => BlocProvider<AuthBloc>(
        bloc: AuthBloc(),
        child: child,
      );

  static AuthBloc? instance(BuildContext context) =>
      BlocProvider.of<AuthBloc>(context);
}
