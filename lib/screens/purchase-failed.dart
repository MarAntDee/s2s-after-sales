import 'dart:math';

import 'package:flutter/material.dart';
import 'package:surf2sawa/theme/app.dart';

import '../components/app-logo.dart';
import '../components/background.dart';
import '../utils/navigator.dart';

class PaymentFailedPage extends StatelessWidget {
  const PaymentFailedPage({super.key});

  @override
  Widget build(BuildContext context) {
    ThemeData _theme = Theme.of(context);
    Size _screen = MediaQuery.sizeOf(context);
    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: <Widget>[
              Expanded(
                flex: 4,
                child: Background(
                  dotsPadding: 0,
                  dotsHeight: _screen.height * 0.35,
                ),
              ),
              Expanded(
                flex: 6,
                child: Container(
                  color: Colors.white,
                ),
              )
            ],
          ),
          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(32),
                    child: AppLogo(
                      size: min(_screen.width / 4, _screen.height / 8),
                    ),
                  ),
                  Card(
                    color: Colors.white,
                    surfaceTintColor: Colors.white,
                    shadowColor: Colors.black45,
                    elevation: 2,
                    child: SizedBox(
                      height: _screen.height / 2,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const SizedBox(height: 32),
                          Container(
                            width: 75,
                            height: 75,
                            margin: const EdgeInsets.all(24),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: _theme.colorScheme.secondary,
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.black26,
                                  blurRadius: 2,
                                  spreadRadius: 0,
                                  offset: Offset(0, 3),
                                ),
                              ],
                            ),
                            child: const Center(
                              child: Icon(
                                Icons.close_rounded,
                                color: Colors.white,
                                size: 56,
                              ),
                            ),
                          ),
                          Center(
                            child: Text(
                              "Payment Unsuccessful",
                              style: _theme.textTheme.titleMedium,
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 16),
                            child: Text(
                              "There was an error on your attempt\nto purchase SuperFiber30-6G",
                              textAlign: TextAlign.center,
                              style: _theme.textTheme.bodySmall!.copyWith(
                                color: _theme.colorScheme.lightGrayText,
                              ),
                            ),
                          ),
                          const Divider(
                            thickness: 0.5,
                            color: Color(0xFFD6D6D6),
                            height: 48,
                          ),
                          ...<String, String>{
                            "Load Amount": "₱30.00",
                            "Mobile Number": "09778040687",
                            "Date & Time": "Oct 15, 2024 4:38PM",
                          }
                              .entries
                              .map<Widget>(
                                (entry) => Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 32,
                                    vertical: 4,
                                  ),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Text(
                                        entry.key,
                                        style: _theme.textTheme.bodyMedium!
                                            .copyWith(
                                          color:
                                              _theme.colorScheme.lightGrayText,
                                        ),
                                      ),
                                      const Spacer(),
                                      Text(
                                        entry.value,
                                        style: _theme.textTheme.bodyLarge!
                                            .copyWith(
                                          fontFamily: "Poppins",
                                          color:
                                              _theme.colorScheme.darkGrayText,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                              .toList(),
                          // Expanded(
                          //   flex: 4,
                          //   child: Center(
                          //     child: Padding(
                          //       padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          //       child: SingleChildScrollView(
                          //         child: Column(
                          //           mainAxisSize: MainAxisSize.min,
                          //           children: {"Sample Key": "Sample Value"}
                          //               .entries
                          //               .map(
                          //                 (entry) => Padding(
                          //                   padding: EdgeInsets.only(bottom: 8),
                          //                   child: Row(
                          //                     children: [
                          //                       Expanded(
                          //                         flex: 4,
                          //                         child: Text(
                          //                           "${entry.key}:",
                          //                           style: _theme.textTheme.titleMedium!
                          //                               .copyWith(
                          //                                   fontWeight: FontWeight.w400),
                          //                         ),
                          //                       ),
                          //                       Expanded(
                          //                         flex: 6,
                          //                         child: Text(
                          //                           entry.value.toString(),
                          //                           style: _theme.textTheme.titleMedium!
                          //                               .copyWith(
                          //                                   fontWeight: FontWeight.w700),
                          //                           textAlign: TextAlign.right,
                          //                         ),
                          //                       ),
                          //                     ],
                          //                   ),
                          //                 ),
                          //               )
                          //               .toList(),
                          //         ),
                          //       ),
                          //     ),
                          //   ),
                          // ),
                        ],
                      ),
                    ),
                  ),
                  const Spacer(),
                  ElevatedButton(
                    onPressed: Navigator.of(context).popUntilHome,
                    child: const Text("Back to Home"),
                  ),
                  const Spacer(flex: 6),
                ],
              ),
            ),
          ),
        ],
      ),
    );
    ;
  }

  static route(RouteSettings settings) {
    return BlurredRouter(
      builder: (context) {
        return PaymentFailedPage();
      },
      settings: settings,
    );
  }
}
