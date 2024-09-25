import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:s2s_after_sales/theme/app.dart';

import '../blocs/auth.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  ThemeData get _theme => Theme.of(context);
  AuthBloc get _auth => AuthBloc.instance(context)!;

  bool isLoading = false;
  String accountNumber = "", errorText = "";

  bool get enabled =>
      accountNumber.length == 12 && accountNumber.startsWith("63877");

  VoidCallback? get _onFieldSubmit => enabled
      ? () {
          setState(() => isLoading = true);
          _auth.checkAccount(accountNumber).catchError(
                (e) => setState(() {
                  isLoading = false;
                  errorText = e;
                }),
              );
        }
      : null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        color: Colors.white,
        child: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/login-bg.png"),
              fit: BoxFit.cover,
            ),
          ),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.transparent, Colors.black12],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: ConstrainedBox(
                    constraints:
                        const BoxConstraints(maxWidth: 360, maxHeight: 480),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SizedBox(height: 60),
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white38,
                              borderRadius: BorderRadius.circular(24),
                            ),
                            child: isLoading
                                ? Center(
                                    child: SizedBox.square(
                                      dimension: 60,
                                      child: CircularProgressIndicator(
                                        color: _theme.colorScheme.secondary,
                                        strokeWidth: 6,
                                      ),
                                    ),
                                  )
                                : Padding(
                                    padding: const EdgeInsets.all(30),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: [
                                        const FlutterLogo(size: 80),
                                        const Spacer(),
                                        _LoginFormfield(
                                          label: accountNumber.isEmpty
                                              ? "Account ID"
                                              : accountNumber,
                                          hintText: "63877•••••••",
                                          icon: Icons.person_2_rounded,
                                          inputFormatters: [
                                            LengthLimitingTextInputFormatter(
                                                12),
                                            FilteringTextInputFormatter
                                                .digitsOnly,
                                          ],
                                          onChanged: (an) => setState(
                                            () => accountNumber = an,
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
                                              style: TextStyle(
                                                  color: Colors.red[200],
                                                  fontSize: 10),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                          ),
                        ),
                        const SizedBox(height: 60),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
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
