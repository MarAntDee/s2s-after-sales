import 'dart:math';

import 'package:flutter/material.dart';
import 'package:surf2sawa/blocs/auth.dart';
import 'package:surf2sawa/theme/app.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class PLanGauge extends StatelessWidget {
  const PLanGauge({super.key});

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    AuthBloc auth = AuthBloc.instance(context)!;
    bool isScreenShort = MediaQuery.sizeOf(context).height < 720;
    return Padding(
      padding: const EdgeInsets.all(24).copyWith(bottom: 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            "Plan Usage",
            textAlign: TextAlign.start,
            style: theme.textTheme.titleLarge!
                .copyWith(
                    fontWeight: FontWeight.w500,
                    color: theme.colorScheme.darkGrayText)
                .apply(fontSizeDelta: -4),
          ),
          if (auth.currentAccount!.currentProduct == null)
            Expanded(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      "No Active Plans yet!",
                      style: theme.textTheme.bodyLarge!.copyWith(
                        color: theme.colorScheme.lightGrayText,
                      ),
                    ),
                    ElevatedButton(
                      onPressed: auth.pushToShop,
                      child: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Icon(Icons.search_rounded),
                            Text("Check Available Plans"),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          if (auth.currentAccount!.currentProduct != null)
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: Center(
                      child: SfRadialGauge(
                        axes: <RadialAxis>[
                          RadialAxis(
                            minimum: 0,
                            maximum: (max(auth.currentAccount!.productDays ?? 100, auth.currentAccount!.daysLeft ?? 0)).toDouble(),
                            axisLineStyle: AxisLineStyle(
                              color: theme.highlightColor,
                              cornerStyle: CornerStyle.bothCurve,
                              thickness: isScreenShort ? 8 : 16,
                            ),
                            showLabels: false,
                            showTicks: false,
                            pointers: <GaugePointer>[
                              RangePointer(
                                value: (auth.currentAccount!.daysLeft ?? 0).toDouble(),
                                cornerStyle: CornerStyle.bothCurve,
                                width: isScreenShort ? 8 : 16,
                                enableAnimation: true,
                                gradient: SweepGradient(
                                  colors: [
                                    theme.colorScheme.primarySwatch[700]!,
                                    theme.colorScheme.primary,
                                    theme.colorScheme.secondaryColorDark,
                                    theme.colorScheme.secondary,
                                  ],
                                ),
                              ),
                            ],
                            annotations: <GaugeAnnotation>[
                              GaugeAnnotation(
                                angle: 270,
                                positionFactor: 0.2,
                                widget: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      (max(auth.currentAccount!.daysLeft ?? 0, 0)).toString(),
                                      style: theme.textTheme.headlineSmall!
                                          .copyWith(
                                        color: theme.colorScheme.darkGrayText,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    Text(
                                      'Days Left',
                                      style:
                                          theme.textTheme.titleSmall!.copyWith(
                                        color: theme.disabledColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              GaugeAnnotation(
                                angle: 90,
                                positionFactor: 0.85,
                                widget: Text(
                                  '${(max(auth.currentAccount!.productDays ?? 0, auth.currentAccount!.daysLeft ?? 0))}\nDays',
                                  textAlign: TextAlign.center,
                                  style: (isScreenShort
                                          ? theme.textTheme.titleMedium!
                                          : theme.textTheme.titleLarge!)
                                      .copyWith(
                                        color: theme.colorScheme.darkGrayText,
                                        fontWeight: FontWeight.w500,
                                      )
                                      .apply(
                                          fontSizeDelta:
                                              isScreenShort ? 0 : -4),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
