import 'package:flutter/material.dart';
import 'package:surf2sawa/blocs/auth.dart';
import 'package:surf2sawa/theme/app.dart';
import 'package:surf2sawa/utils/navigator.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class PLanGauge extends StatelessWidget {
  const PLanGauge({super.key});

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    AuthBloc auth = AuthBloc.instance(context)!;
    return Padding(
      padding: const EdgeInsets.all(24).copyWith(bottom: 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            "Plan Usage\n",
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
                      onPressed: Navigator.of(context).pushToShop,
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
            if (auth.currentAccount!.currentProduct != null) Expanded(
            child: Row(
              children: [
                Expanded(
                  child: Center(
                    child: SfRadialGauge(
                      axes: <RadialAxis>[
                        RadialAxis(
                          minimum: 0,
                          maximum: 6,
                          axisLineStyle: AxisLineStyle(
                            color: theme.highlightColor,
                            cornerStyle: CornerStyle.bothCurve,
                            thickness: 16,
                          ),
                          showLabels: false,
                          showTicks: false,
                          pointers: <GaugePointer>[
                            RangePointer(
                              value: 2,
                              cornerStyle: CornerStyle.bothCurve,
                              width: 16,
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
                                    '2',
                                    style: theme.textTheme.headlineSmall!.copyWith(
                                      color: theme.colorScheme.darkGrayText,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  Text(
                                    'Devices',
                                    style: theme.textTheme.titleSmall!.copyWith(
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
                                '6\nDevices',
                                textAlign: TextAlign.center,
                                style: theme.textTheme.titleLarge!.copyWith(
                                  color: theme.colorScheme.darkGrayText,
                                  fontWeight: FontWeight.w500,
                                ).apply(fontSizeDelta: -4),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Center(
                    child: SfRadialGauge(
                      axes: <RadialAxis>[
                        RadialAxis(
                          minimum: 0,
                          maximum: 30,
                          axisLineStyle: AxisLineStyle(
                            color: theme.highlightColor,
                            cornerStyle: CornerStyle.bothCurve,
                            thickness: 16,
                          ),
                          showLabels: false,
                          showTicks: false,
                          pointers: <GaugePointer>[
                            RangePointer(
                              value: 25,
                              cornerStyle: CornerStyle.bothCurve,
                              width: 16,
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
                                    '5',
                                    style: theme.textTheme.headlineSmall!.copyWith(
                                      color: theme.colorScheme.darkGrayText,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  Text(
                                    'Days Left',
                                    style: theme.textTheme.titleSmall!.copyWith(
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
                                '30\nDays',
                                textAlign: TextAlign.center,
                                style: theme.textTheme.titleLarge!.copyWith(
                                  color: theme.colorScheme.darkGrayText,
                                  fontWeight: FontWeight.w500,
                                ).apply(fontSizeDelta: -4),
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
