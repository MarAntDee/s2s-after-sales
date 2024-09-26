import 'dart:math' as math;

mixin MappedModel {
  Map toMap() => {};
}

class DevTools {
  static void printModel<T extends MappedModel>(T model,
      {bool withNew = false}) {
    print(_bordered("╣${withNew ? " NEW" : ""} ACCOUNT ╠", title: true));
    print(_space);
    model.toMap().forEach((key, value) => _printKV(key, value));
    print(_space);
    print(
        "╚══════════════════════════════════════════════════════════════════════════════════════════╝");
  }

  static const int maxWidth = 90;
  static String _bordered(String text, {bool title = false}) {
    if (text.length > maxWidth) return title ? "╔$text" : text;
    return title
        ? "╔$text${"═" * (maxWidth - text.length)}╗"
        : "$text${" " * (maxWidth - text.length + 1)}║";
  }

  static String get _space => "║${" " * maxWidth}║";
  static void _printKV(String? key, Object? v, {int layer = 0}) {
    String pre = '╟────┤${"  " * layer} ';
    if (key != null) pre = "$pre$key: ";
    final msg = v.toString();

    if (v is Map<String, dynamic>) {
      logPrint(_bordered("$pre{"));
      Map<String, dynamic>.from(v).forEach(
        (k, v) => _printKV(k, v, layer: layer + 1),
      );
      logPrint(_bordered("╟────┤${"  " * layer} }"));
    } else if (v is List<dynamic>) {
      logPrint(_bordered("$pre["));
      List<dynamic>.from(v).forEach((element) {
        _printKV(null, element, layer: layer + 1);
      });
      logPrint(_bordered("╟────┤${"  " * layer} ]"));
    } else if (pre.length + msg.length > maxWidth) {
      logPrint(_bordered(pre));
      _printBlock(msg, layer: layer);
    } else {
      logPrint(_bordered('$pre$msg'));
    }
  }

  static void _printBlock(String msg, {int layer = 0}) {
    var lines = (msg.length / maxWidth).ceil();
    for (var i = 0; i < lines; ++i) {
      logPrint(('║  ${"  " * layer}') +
          msg.substring(i * maxWidth,
              math.min<int>(i * maxWidth + maxWidth, msg.length)));
    }
  }

  static void Function(Object object) logPrint = print;
}
