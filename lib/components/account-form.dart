import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:s2s_after_sales/theme/app.dart';

import '../blocs/auth.dart';

class AccountForm extends StatefulWidget {
  final VoidCallback? onSuccess;
  const AccountForm({super.key, this.onSuccess});

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
              const FlutterLogo(size: 80),
              const Spacer(),
              _LoginFormfield(
                label: _auth.pendingAccountNumber.isEmpty
                    ? "Account ID"
                    : _auth.pendingAccountNumber,
                hintText: "63877•••••••",
                icon: Icons.person_2_rounded,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(12),
                  FilteringTextInputFormatter.digitsOnly,
                ],
                onChanged: (an) => setState(
                  () => _auth.pendingAccountNumber = an,
                ),
              ),
              const Spacer(),
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
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Text(
                    errorText,
                    style: TextStyle(color: Colors.red[200], fontSize: 10),
                  ),
                ),
              ),
            ],
          );
  }
}

class _LoginFormfield extends FormField<String> {
  _LoginFormfield({
    String label = "",
    IconData? icon,
    bool isObscure = false,
    List<TextInputFormatter>? inputFormatters,
    String? hintText,
    Function(String)? onChanged,
    Function(String)? onSubmit,
  }) : super(builder: (state) {
          ThemeData theme = Theme.of(state.context);
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: TextField(
                textAlignVertical: TextAlignVertical.center,
                style: TextStyle(color: theme.colorScheme.secondaryColorDark),
                cursorColor: theme.colorScheme.secondaryColorDark,
                inputFormatters: inputFormatters,
                onChanged: onChanged,
                onSubmitted: onSubmit,
                obscureText: isObscure,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.zero,
                  ),
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.zero,
                  ),
                  filled: true,
                  fillColor: theme.colorScheme.secondaryColorLight,
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                  isCollapsed: true,
                  labelText: label,
                  labelStyle:
                      TextStyle(color: theme.colorScheme.secondaryColorDark),
                  hintText: hintText,
                  prefixIcon: Padding(
                    padding: const EdgeInsets.only(right: 16),
                    child: Container(
                      width: 40,
                      color: theme.colorScheme.secondary,
                      child: icon == null
                          ? Container()
                          : Icon(
                              icon,
                              color: Colors.white,
                            ),
                    ),
                  ),
                ),
              ),
            ),
          );
        });
}
