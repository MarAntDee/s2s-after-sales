import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:s2s_after_sales/theme/app.dart';

import '../blocs/auth.dart';
import '../utils/formatters.dart';
import 'app-logo.dart';

class AccountForm extends StatefulWidget {
  final VoidCallback? onSuccess;
  final FocusNode? node;
  final bool hasFocus;
  const AccountForm(
      {super.key, this.onSuccess, this.node, this.hasFocus = false});

  @override
  State<AccountForm> createState() => _AccountFormState();
}

class _AccountFormState extends State<AccountForm> {
  ThemeData get _theme => Theme.of(context);
  AuthBloc get _auth => AuthBloc.instance(context)!;

  bool isLoading = false;
  String errorText = "";

  bool get enabled =>
      _auth.pendingAccountNumber.length == 12 &&
      _auth.pendingAccountNumber.startsWith("63877");

  VoidCallback? get _onFieldSubmit => enabled
      ? () {
          setState(() => isLoading = true);
          _auth.checkAccount().then((_) {
            if (widget.onSuccess != null) widget.onSuccess!();
          }).catchError(
            (e) {
              setState(() {
                isLoading = false;
                errorText = e;
              });
            },
          );
        }
      : null;

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Center(
            child: SizedBox.square(
              dimension: 60,
              child: CircularProgressIndicator(
                color: _theme.colorScheme.secondary,
                strokeWidth: 6,
              ),
            ),
          )
        : Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Spacer(flex: widget.hasFocus ? 1 : 2),
              const Expanded(flex: 3, child: AppLogo()),
              Spacer(flex: widget.hasFocus ? 2 : 3),
              const Text(
                "Enter S2S Account Number",
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              _LoginFormfield(
                hintText: "877 xxxx xxx",
                icon: Icons.person_2_rounded,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(12),
                  FilteringTextInputFormatter.digitsOnly,
                  AccountFormatter(),
                ],
                node: widget.node,
                onChanged: (an) {
                  setState(
                    () => _auth.pendingAccountNumber =
                        "63${an.replaceAll(" ", "")}",
                  );
                },
                onSubmit: (_) {
                  if (_onFieldSubmit != null) _onFieldSubmit!();
                },
              ),
              Spacer(flex: widget.hasFocus ? 2 : 1),
              ElevatedButton(
                onPressed: _onFieldSubmit,
                child: const SizedBox(
                  height: 40,
                  child: Center(
                    child: Text(
                      "Check Account",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: Text(
                  errorText,
                  style: _theme.textTheme.labelMedium!.copyWith(
                    color: _theme.colorScheme.error,
                  ),
                ),
              ),
              Spacer(flex: widget.hasFocus ? 3 : 2),
            ],
          );
  }
}

class _LoginFormfield extends FormField<String> {
  _LoginFormfield({
    String? label,
    IconData? icon,
    bool isObscure = false,
    List<TextInputFormatter>? inputFormatters,
    String? hintText,
    FocusNode? node,
    Function(String)? onChanged,
    Function(String)? onSubmit,
  }) : super(builder: (state) {
          ThemeData theme = Theme.of(state.context);
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: SizedBox(
                height: 50,
                child: TextField(
                  textAlignVertical: TextAlignVertical.center,
                  focusNode: node,
                  style: TextStyle(color: theme.colorScheme.secondaryColorDark),
                  cursorColor: theme.colorScheme.secondaryColorDark,
                  inputFormatters: inputFormatters,
                  onChanged: onChanged,
                  onSubmitted: onSubmit,
                  obscureText: isObscure,
                  decoration: InputDecoration(
                    fillColor: Colors.white,
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: Colors.grey, width: 2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: theme.colorScheme.secondary, width: 2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    hintText: hintText,
                    hintStyle: theme.textTheme.titleMedium!.copyWith(
                      color: Colors.black.withOpacity(0.6),
                    ),
                    prefixIcon: Container(
                      width: 48,
                      margin: const EdgeInsets.only(right: 8),
                      padding: EdgeInsets.symmetric(horizontal: 4),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.secondary,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(6.0),
                          bottomLeft: Radius.circular(6.0),
                        ),
                        border: Border.all(color: Colors.transparent, width: 2),
                      ),
                      child: Center(
                        child: Text(
                          "63",
                          style: theme.primaryTextTheme.titleLarge!.copyWith(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        });
}
