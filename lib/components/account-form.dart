import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:surf2sawa/theme/app.dart';

import '../blocs/auth.dart';
import '../utils/formatters.dart';

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
  final TextEditingController _controller = TextEditingController();

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
        : ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 480),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  "Welcome!",
                  style: _theme.textTheme.headlineSmall!.copyWith(
                    color: _theme.colorScheme.darkGrayText,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
                Text(
                  "We will send you one-time password to\nyour mobile number",
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  style: _theme.textTheme.labelMedium!.copyWith(
                    color: _theme.colorScheme.darkGrayText,
                  ),
                ),
                const Spacer(),
                Expanded(
                  flex: widget.hasFocus ? 8:2,
                  child: Column(
                    children: <Widget>[
                      Text(
                        "Enter Account number",
                        style: _theme.textTheme.titleLarge!
                            .copyWith(
                          color: _theme.colorScheme.darkGrayText,
                          fontWeight: FontWeight.w400,
                        )
                            .apply(fontSizeDelta: -2),
                        textAlign: TextAlign.center,
                      ),
                      widget.hasFocus ? const SizedBox(height: 36) : const Spacer(),
                      Center(
                        child: _LoginFormfield(
                          controller: _controller,
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
                      ),
                      Divider(
                        color: _theme.primaryColor,
                        indent: 12,
                        endIndent: 12,
                        thickness: widget.hasFocus ? 2 : 1.2,
                        height: 16,
                      ),
                      widget.hasFocus ? const SizedBox(height: 36) : const Spacer(),
                      ElevatedButton(
                        onPressed: _onFieldSubmit,
                        child: const SizedBox(
                          child: Center(
                            child: Text(
                              "Link Account",
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
                      const Spacer(),
                    ],
                  ),
                ),
              ],
            ),
          );
  }
}

class _LoginFormfield extends FormField<String> {
  _LoginFormfield({
    TextEditingController? controller,
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
          return SizedBox(
            width: 180,
            child: TextField(
              controller: controller,
              textAlignVertical: TextAlignVertical.center,
              focusNode: node,
              style: theme.inputDecorationTheme.labelStyle,
              cursorColor: theme.colorScheme.primary,
              inputFormatters: inputFormatters,
              onChanged: onChanged,
              onSubmitted: onSubmit,
              obscureText: isObscure,
              decoration: InputDecoration(
                fillColor: Colors.white,
                border: InputBorder.none,
                hintText: hintText,
                prefixIcon: SizedBox(
                  width: 44,
                  child: Center(
                    child: Text(
                      "+63\t",
                      style: theme.inputDecorationTheme.labelStyle!,
                    ),
                  ),
                ),
              ),
            ),
          );
        });
}
