import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

import 'base.dart';

class OtpBloc implements BlocBase {
  final Future Function()? api;
  String? beOtp;

  final BehaviorSubject<String> _pincodeController = BehaviorSubject<String>();
  Stream<String> get pincodeStream => _pincodeController.stream;
  set pincode(String newValue) => _pincodeController.add(newValue);

  OtpBloc({this.api, String? initialData}) {
    beOtp = initialData;
  }

  @override
  void dispose() {
    _pincodeController.close();
  }

  static Widget build({
    Future Function()? api,
    String? initialData,
    Widget? child,
  }) =>
      BlocProvider<OtpBloc>(
        bloc: OtpBloc(api: api, initialData: initialData),
        child: child ?? Container(),
      );

  static OtpBloc? instance(BuildContext context) =>
      BlocProvider.of<OtpBloc>(context);
}
