import 'package:flutter/material.dart';
import 'package:surf2sawa/blocs/auth.dart';

class HomePanel extends StatelessWidget {
  final String _iconPath = "assets/icons/";

  const HomePanel({super.key});
  @override
  Widget build(BuildContext context) {
    AuthBloc auth = AuthBloc.instance(context)!;
    ThemeData theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
      color: theme.primaryColor,
      // child: Center(
      //   child: ConstrainedBox(
      //     constraints: const BoxConstraints(maxWidth: 540),
      //     child: Row(
      //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      //       children: ["Buy"].map((key) {
      //         return Material(
      //           color: Colors.transparent,
      //           child: InkWell(
      //             onTap: () {
      //               switch (key) {
      //                 case "Buy":
      //                   Navigator.of(context).pushToShop();
      //                   break;
      //               }
      //             },
      //             child: Padding(
      //               padding: const EdgeInsets.symmetric(vertical: 16),
      //               child: Column(
      //                 children: [
      //                   Padding(
      //                     padding: const EdgeInsets.symmetric(horizontal: 20)
      //                         .copyWith(bottom: 8),
      //                     child: Image.asset(
      //                       "$_iconPath${key.toString().toLowerCase()}.png",
      //                       width: 32,
      //                       height: 32,
      //                     ),
      //                   ),
      //                   Text(
      //                     key,
      //                     style: theme.primaryTextTheme.bodySmall,
      //                   ),
      //                 ],
      //               ),
      //             ),
      //           ),
      //         );
      //       }).toList(),
      //     ),
      //   ),
      // ),
    );
  }
}
