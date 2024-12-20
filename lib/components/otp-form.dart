import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pin_input_text_field/pin_input_text_field.dart';
import 'package:surf2sawa/theme/app.dart';
import 'package:surf2sawa/utils/extensions.dart';

import '../blocs/auth.dart';
import '../blocs/otp-controller.dart';
import '../utils/formatters.dart';
import 'dialogs.dart';

class OTPForm extends StatefulWidget {
  final Future Function(String) onSubmit;
  final Future<String?> Function()? onResend;
  final VoidCallback? onCancel;
  final String? initialData, mobile;
  final bool enableResend;
  final FocusNode? node;

  final int digits = 6;

  const OTPForm({
    super.key,
    required this.onSubmit,
    this.node,
    this.onCancel,
    this.initialData,
    this.mobile,
    this.onResend,
    this.enableResend = true,
  });

  @override
  _OTPFormState createState() => _OTPFormState();
}

class _OTPFormState extends State<OTPForm> with TickerProviderStateMixin {
  bool _enabled = true;
  AuthBloc get _auth => AuthBloc.instance(context)!;
  final FocusNode _node = FocusNode();
  TextEditingController pinController = TextEditingController();
  ThemeData get _theme => Theme.of(context);
  String _code = "";

  late AnimationController _controller;

  _listenForCode() async {
    await SmsAutoFill().listenForCode();
  }

  @override
  void initState() {
    _listenForCode();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _node.addListener(
      () {
        _node.hasFocus ? _controller.forward() : _controller.reverse();
      },
    );
    super.initState();
  }

  @override
  void dispose() {
    _auth.expiredOtps.clear();
    SmsAutoFill().unregisterListener();
    _node.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(
        maxWidth: 400
      ),
      child: OtpBloc.build(
        api: widget.onResend,
        initialData: widget.initialData,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Builder(
            builder: (context) {
              OtpBloc otpController = OtpBloc.instance(context)!;
              return Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Center(
                    child: Text(
                      "OTP Verification",
                      style: _theme.textTheme.headlineSmall!.copyWith(
                        color: _theme.colorScheme.darkGrayText,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        text: 'Enter the OTP sent to ',
                        style: _theme.textTheme.labelMedium!.copyWith(
                          color: _theme.colorScheme.darkGrayText,
                        ),
                        children: <TextSpan>[
                          TextSpan(
                            text: '+${widget.mobile}',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Spacer(),
                  StreamBuilder<String>(
                    stream: otpController.pincodeStream,
                    initialData: widget.initialData,
                    builder: (context, pincode) {
                      otpController.beOtp = pincode.data;
                      return Column(
                        children: [
                          CustomPinFieldAutoFill(
                            enabled: _enabled,
                            codeLength: widget.digits,
                            controller: pinController,
                            focusNode: widget.node ?? _node,
                            autoFocus: false,
                            cursor: Cursor(
                              color: _theme.colorScheme.secondaryColorDark,
                              enabled: true,
                              radius: const Radius.circular(2),
                              width: 2,
                              height: 18,
                            ),
                            decoration: UnderlineDecoration(
                              textStyle: _theme.inputDecorationTheme.labelStyle!.copyWith(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                              lineHeight: 0.87,
                              colorBuilder:
                                  CustomColorBuilder(context, enabled: _enabled),
                            ),
                            currentCode: _code,
                            onCodeSubmitted: (code) {
                              setState(() => _enabled = false);
                              widget.onSubmit(code).catchError((e) {
                                setState(() => _enabled = true);
                                // Popup.showError(e);
                              }).whenComplete(() {
                                setState(() => _enabled = true);
                                pinController.clear();
                                _code = "";
                              });
                            },
                            onCodeChanged: (code) async {
                              print(code.trim());
                              String trimmedCode =
                                  (code.isNumeric || code.trim().isEmpty)
                                      ? code.trim()
                                      : code
                                          .trim()
                                          .substring(0, code.trim().length - 1);
                              pinController.text = trimmedCode;
                              pinController.selection =
                                  TextSelection.fromPosition(
                                TextPosition(offset: trimmedCode.length),
                              );
                              _code = trimmedCode;
                              if (trimmedCode.length == widget.digits) {
                                FocusScope.of(context).requestFocus(FocusNode());
                              }
                              setState(() {});
                            },
                          ),
                          ((pincode.data ?? "").isNotEmpty)
                              ? Text(
                                  "PIN: ${pincode.data ?? ""}",
                                  style: _theme.textTheme.labelSmall,
                                )
                              : Container(),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    flex: 2,
                    child: _enabled
                        ? Column(
                            children: [
                              if (widget.enableResend)
                                _ResendButton(pinController),
                              const Spacer(flex: 2),
                              ElevatedButton(
                                onPressed: _code.length == widget.digits
                                    ? () async {
                                        try {
                                          if (_code.isEmpty) {
                                            throw "OTP is required";
                                          }
                                          setState(() => _enabled = false);
                                          if (_auth.expiredOtps.contains(_code)) {
                                            throw "You have entered an expired OTP";
                                          }
                                          if (otpController.beOtp?.toString() !=
                                                  null &&
                                              otpController.beOtp.toString() !=
                                                  _code) {
                                            throw "You have entered an invalid OTP";
                                          }
                                          _auth.expiredOtps.clear();
                                          await widget.onSubmit(_code);
                                        } catch (e) {
                                          setState(() => _enabled = true);
                                          await Popup.showError(e);
                                        } finally {
                                          setState(() => _enabled = true);
                                          pinController.clear();
                                          _code = "";
                                        }
                                      }
                                    : null,
                                child: const SizedBox(
                                  child: Center(
                                    child: Text(
                                      "Verify",
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              if (widget.onCancel != null)
                                TextButton(
                                  onPressed: _enabled ? widget.onCancel : null,
                                  style: TextButton.styleFrom(
                                    foregroundColor: _theme.primaryColor,
                                  ),
                                  child: const Text("Cancel"),
                                ),
                              const Spacer(),
                            ],
                          )
                        : Center(
                            child: SizedBox.square(
                              dimension: 60,
                              child: CircularProgressIndicator(
                                color: _theme.colorScheme.secondary,
                                strokeWidth: 6,
                              ),
                            ),
                          ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class CustomColorBuilder extends ColorBuilder {
  final Color? enteredColor, notEnteredColor, currentIndexColor;
  final BuildContext context;
  final bool enabled;
  var currentIndex = 0;

  ThemeData get _theme => Theme.of(context);

  CustomColorBuilder(this.context,
      {this.enteredColor,
      this.notEnteredColor,
      this.currentIndexColor,
      this.enabled = false});

  @override
  Color indexProperty(int index) {
    if (!enabled) return Colors.grey[300]!;
    if (index == currentIndex) {
      return currentIndexColor ?? _theme.colorScheme.secondaryColorDark;
    } else if (index < currentIndex) {
      return enteredColor ?? _theme.colorScheme.primary;
    } else {
      return notEnteredColor ?? Colors.grey[300]!;
    }
  }

  @override
  void notifyChange(String enteredPin) {
    currentIndex = enteredPin.length;
  }
}

class CustomPinFieldAutoFill extends StatefulWidget {
  final int codeLength;
  final bool autoFocus;
  final bool enabled;
  final TextEditingController? controller;
  final String? currentCode;
  final Function(String)? onCodeSubmitted;
  final Function(String)? onCodeChanged;
  final PinDecoration? decoration;
  final FocusNode? focusNode;
  final Cursor cursor;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;

  const CustomPinFieldAutoFill({
    super.key,
    this.keyboardType = const TextInputType.numberWithOptions(),
    this.textInputAction = TextInputAction.done,
    this.focusNode,
    required this.cursor,
    this.controller,
    this.decoration,
    this.onCodeSubmitted,
    this.onCodeChanged,
    this.currentCode,
    this.autoFocus = false,
    this.enabled = false,
    this.codeLength = 6,
  });

  @override
  State<StatefulWidget> createState() {
    return _CustomPinFieldAutoFillState();
  }
}

class _CustomPinFieldAutoFillState extends State<CustomPinFieldAutoFill>
    with CodeAutoFill {
  late TextEditingController controller;
  bool _shouldDisposeController = false;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 32,
      child: PinInputTextField(
        enabled: widget.enabled,
        pinLength: widget.codeLength,
        decoration: widget.decoration ??
            UnderlineDecoration(
                colorBuilder: const FixedColorBuilder(Colors.black),
                textStyle: const TextStyle(color: Colors.black)),
        focusNode: widget.focusNode,
        enableInteractiveSelection: false,
        autocorrect: false,
        cursor: widget.cursor,
        autofillHints: const <String>[AutofillHints.oneTimeCode],
        textCapitalization: TextCapitalization.none,
        toolbarOptions: const ToolbarOptions(paste: true),
        keyboardType: widget.keyboardType,
        autoFocus: widget.autoFocus,
        controller: controller,
        textInputAction: widget.textInputAction,
        onSubmit: widget.onCodeSubmitted,
      ),
    );
  }

  @override
  void initState() {
    _shouldDisposeController = widget.controller == null;
    controller = widget.controller ?? TextEditingController(text: '');
    code = widget.currentCode;
    codeUpdated();
    controller.addListener(() {
      if (controller.text != code) {
        code = controller.text;
        if (widget.onCodeChanged != null) {
          widget.onCodeChanged!(code!);
        }
      }
    });
    listenForCode();
    super.initState();
  }

  @override
  void didUpdateWidget(CustomPinFieldAutoFill oldWidget) {
    if (widget.controller != null && widget.controller != controller) {
      controller.dispose();
      controller = widget.controller!;
    }

    if (widget.currentCode != oldWidget.currentCode ||
        widget.currentCode != code) {
      code = widget.currentCode;
      codeUpdated();
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void codeUpdated() {
    if (controller.text != code) {
      controller.value = TextEditingValue(text: code ?? '');
      if (widget.onCodeChanged != null) {
        widget.onCodeChanged!(code ?? '');
      }
    }
  }

  @override
  void dispose() {
    cancel();
    if (_shouldDisposeController) {
      controller.dispose();
    }
    unregisterListener();
    super.dispose();
  }
}

mixin CodeAutoFill {
  final SmsAutoFill _autoFill = SmsAutoFill();
  String? code;
  StreamSubscription? _subscription;

  void listenForCode({String? smsCodeRegexPattern}) {
    _subscription = _autoFill.code.listen((code) {
      this.code = code;
      codeUpdated();
    });
    (smsCodeRegexPattern == null)
        ? _autoFill.listenForCode()
        : _autoFill.listenForCode(smsCodeRegexPattern: smsCodeRegexPattern);
  }

  Future<void> cancel() async {
    return _subscription?.cancel();
  }

  Future<void> unregisterListener() {
    return _autoFill.unregisterListener();
  }

  void codeUpdated();
}

class SmsAutoFill {
  static SmsAutoFill? _singleton;
  static const MethodChannel _channel = MethodChannel('sms_autofill');
  final StreamController<String> _code = StreamController.broadcast();

  factory SmsAutoFill() => _singleton ??= SmsAutoFill._();

  SmsAutoFill._() {
    _channel.setMethodCallHandler(_didReceive);
  }

  Future<void> _didReceive(MethodCall method) async {
    if (method.method == 'smscode') {
      _code.add(method.arguments);
    }
  }

  Stream<String> get code => _code.stream;

  Future<String?> get hint async {
    if ((defaultTargetPlatform == TargetPlatform.android ||
            defaultTargetPlatform == TargetPlatform.iOS) &&
        !kIsWeb) {
      final String hint = await _channel.invokeMethod('requestPhoneHint');
      return hint;
    }
    return null;
  }

  Future<void> listenForCode({String smsCodeRegexPattern = '\\d{4,6}'}) async {
    if ((defaultTargetPlatform == TargetPlatform.android ||
            defaultTargetPlatform == TargetPlatform.iOS) &&
        !kIsWeb) {
      await _channel.invokeMethod('listenForCode',
          <String, String>{'smsCodeRegexPattern': smsCodeRegexPattern});
    }
  }

  Future<void> unregisterListener() async {
    if ((defaultTargetPlatform == TargetPlatform.android ||
            defaultTargetPlatform == TargetPlatform.iOS) &&
        !kIsWeb) {
      await _channel.invokeMethod('unregisterListener');
    }
  }

  Future<String> get getAppSignature async {
    if (defaultTargetPlatform == TargetPlatform.android && !kIsWeb) {
      final String? appSignature =
          await _channel.invokeMethod('getAppSignature');
      return appSignature ?? '';
    }
    return '';
  }
}

class _ResendButton extends StatefulWidget {
  const _ResendButton(this.pinController);
  final TextEditingController pinController;

  @override
  _ResendButtonState createState() => _ResendButtonState();
}

class _ResendButtonState extends State<_ResendButton> {
  OtpBloc get _otpController => OtpBloc.instance(context)!;
  AuthBloc get _auth => AuthBloc.instance(context)!;
  ThemeData get _theme => Theme.of(context);
  late Timer _timer;
  int _start = 300;
  bool resending = false;
  String resendingError = "";

  _initTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(oneSec, (timer) {
      if (_start == 0) {
        showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) => PopScope(
            canPop: false,
            child: StatefulBuilder(
              builder: (context, setState) => AlertDialog(
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      "OTP has expired",
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      resendingError,
                      style: _theme.textTheme.labelSmall!.copyWith(
                          color: _theme.colorScheme.secondaryColorDark),
                    ),
                  ],
                ),
                actions: [
                  if (resending)
                    const SizedBox.square(
                      dimension: 30,
                      child: CircularProgressIndicator(),
                    ),
                  if (!resending)
                    TextButton(
                      style: TextButton.styleFrom(
                        foregroundColor: _theme.primaryColor,
                        textStyle: const TextStyle(
                          decoration: TextDecoration.none,
                        ),
                      ),
                      onPressed: () async {
                        try {
                          setState(() {
                            resending = true;
                            resendingError = "";
                          });
                          await _resendOTP();
                          Navigator.of(context).pop();
                          _auth.expiredOtps.add(_otpController.beOtp!);
                        } catch (e) {
                          setState(() => resendingError = e.toString());
                        } finally {
                          setState(() => resending = false);
                        }
                      },
                      child: const Text('Resend OTP'),
                    ),
                ],
              ),
            ),
          ),
        );
        setState(() {
          timer.cancel();
        });
      } else {
        setState(() {
          _start--;
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _initTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  _resendOTP() async {
    widget.pinController.clear();
    await _otpController.api?.call().then((pincode) {
      if (pincode != null) _otpController.pincode = pincode;
      _start = 300;
      _initTimer();
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: null,
        child: Text(
          (_start <= 0)
              ? "Didn’t you receive the OTP? Resend OTP"
              : "Didn’t you receive the OTP? Resend OTP in ${TimeFormatter().timeLeft(_start)}",
          style:
              _theme.textTheme.titleSmall!.apply(color: _theme.disabledColor),
        ));
  }
}
