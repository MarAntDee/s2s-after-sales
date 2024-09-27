import 'dart:convert';
import 'dart:io';
import 'dart:math' as math;

import 'package:pretty_http_logger/pretty_http_logger.dart';
import 'package:s2s_after_sales/blocs/auth.dart';
import 'package:s2s_after_sales/main.dart';

import '../models/account.dart';

abstract class PCApi {
  late final String server;

  Uri url({String path = "", Map<String, String>? query});
  Map<String, String> header();

  //CHECK ACCOUNT
  Future<Map<String, dynamic>> checkAccount(String accountNumber);
  Future<bool> verifyAccount(String pincode, String referenceNumber);
  Future<Account> getAccount(String referenceNumber);

  static HttpWithMiddleware http(String method) => HttpWithMiddleware.build(
        requestTimeout: const Duration(seconds: 30),
        middlewares: [
          CustomHttpLogger(method: method),
        ],
      );

  static _logError(String method, dynamic e) =>
      print("$method ERROR: ${e.toString()}");
}

class ProdApi implements PCApi {
  static HttpWithMiddleware _http(String method) => PCApi.http(method);

  @override
  String server = "https://superapp.s2s.ph/crms/api";

  @override
  Uri url({String path = "", Map<String, String>? query}) {
    String endPoint = server + path;
    String queryString = Uri(queryParameters: query).query;
    String fullUrl = '$endPoint?$queryString';
    return Uri.parse(fullUrl);
  }

  @override
  Map<String, String> header() {
    final AuthBloc _auth = AuthBloc.instance(navigatorKey.currentContext!)!;
    return {
      "Authorization":
          "3600bf62a3f79fa53f9e811bb76eaddf1073f691abd445cce221430092b75bd0",
      "x-device-key": _auth.uuid!,
      "wsc-timestamp": DateTime.now().millisecondsSinceEpoch.toString(),
    };
  }

  @override
  Future<Map<String, dynamic>> checkAccount(String accountNumber) async {
    try {
      Map res = await _http("CHECKING ACCOUNT").post(
        url(path: "/check-account"),
        headers: header(),
        body: {"accountNumber": accountNumber},
      ).then((res) => jsonDecode(res.body));

      if (!(res['status'] ?? false) || (res['code'] ?? 200) != 200) {
        throw res.putIfAbsent('message', () => 'Unknown error');
      }
      if (res['data'] == null) throw "Missing response body";
      if (res['data'] is! Map<String, dynamic>) {
        throw "Invalid response body structure";
      }

      return Map<String, dynamic>.from(res['data']);
    } catch (e) {
      PCApi._logError("CHECKING ACCOUNT", e);
      if (e is String) rethrow;
      if (e is SocketException) throw ("No internet");
      if (e is Map) rethrow;
      throw ("Unknown error");
    }
  }

  @override
  Future<bool> verifyAccount(String pincode, String referenceNumber) async {
    try {
      Map res = await _http("VERIFYING ACCOUNT").post(
        url(path: "/verify-otp"),
        headers: header(),
        body: {
          "referenceNumber": referenceNumber,
          "pincode": pincode,
        },
      ).then((res) => jsonDecode(res.body));

      if (!(res['status'] ?? false) || (res['code'] ?? 200) != 200) {
        throw res.putIfAbsent('message', () => 'Unknown error');
      }
      return res['message'].toString() == "Successfully verified OTP";
    } catch (e) {
      PCApi._logError("VERIFYING ACCOUNT", e);
      if (e is String) rethrow;
      if (e is SocketException) throw ("No internet");
      if (e is Map) rethrow;
      throw ("Unknown error");
    }
  }

  @override
  Future<Account> getAccount(String referenceNumber) async {
    try {
      Map res = await _http("GETTING ACCOUNT INFO")
          .get(
            url(path: "/account", query: {
              'x-auth': referenceNumber,
            }),
            headers: header(),
          )
          .then((res) => jsonDecode(res.body));

      if (!(res['status'] ?? false) || (res['code'] ?? 200) != 200) {
        throw res.putIfAbsent('message', () => 'Unknown error');
      }
      if (res['data'] == null) throw "Missing response body";
      if (res['data'] is! Map<String, dynamic>) {
        throw "Invalid response body structure";
      }

      return Account.fromMap(res['data']);
    } catch (e) {
      PCApi._logError("GETTING ACCOUNT INFO", e);
      if (e is String) rethrow;
      if (e is SocketException) throw ("No internet");
      if (e is Map) rethrow;
      throw ("Unknown error");
    }
  }
}

class CustomHttpLogger extends MiddlewareContract {
  final String method;
  final int maxWidth = 90;

  String _bordered(String text, {bool title = false}) {
    if (text.length > maxWidth) return title ? "╔$text" : text;
    return title
        ? "╔$text${"═" * (maxWidth - text.length)}╗"
        : "$text${" " * (maxWidth - text.length + 1)}║";
  }

  String get _space => "║${" " * maxWidth}║";

  CustomHttpLogger({this.method = "UNKNOWN METHOD"});

  @override
  void interceptRequest(RequestData data) {
    data.headers?["Content-Type"] = "application/json";

    print(_bordered("╣ ${data.method.toString().split(".")[1]} ║ $method ╠",
        title: true));
    print(_space);
    print(_bordered("╠══╡ URL: ${data.url.toString().split('?')[0]}"));
    if (data.headers != null) print(_space);
    if (data.headers != null) print(_bordered("╠══╡ HEADERS:"));
    if (data.headers != null)
      data.headers?.forEach((key, value) => _printKV(key, value));
    if (data.url.queryParameters.isNotEmpty) print(_space);
    if (data.url.queryParameters.isNotEmpty)
      print(_bordered("╠══╡ QUERY PARAMETERS:"));
    if (data.url.queryParameters.isNotEmpty)
      data.url.queryParameters.forEach((key, value) => _printKV(key, value));
    if (data.body != null) print(_space);
    if (data.body != null) print(_bordered("╠══╡ BODY:"));
    if (data.body != null)
      data.body?.forEach((key, value) => _printKV(key, value));
    print(_space);
    print(
        "╚══════════════════════════════════════════════════════════════════════════════════════════╝");
    data.body = jsonEncode(data.body);
  }

  @override
  void interceptResponse(ResponseData data) {
    Map res = jsonDecode(data.body);

    print(_bordered("╣ $method DONE ║ ${res['code']} ║", title: true));
    if (res.containsKey("message")) print(_space);
    if (res.containsKey("message"))
      print(_bordered("╠══╡ MESSAGE: ${res['message']}"));
    if (res.containsKey("data")) print(_space);
    if (res.containsKey("data")) print(_bordered("╠══╡ RESPONSE:"));
    if (res["data"] is Map<String, dynamic>)
      Map<String, dynamic>.from(res["data"])
          .forEach((key, value) => _printKV(key, value));
    print(_space);
    print(
        "╚══════════════════════════════════════════════════════════════════════════════════════════╝");
  }

  @override
  void interceptError(error) {
    print(_bordered("╣ $method ERROR ║ ${error.runtimeType.toString()} ║",
        title: true));
    print(_space);
    print(_bordered("╠══╡ MESSAGE: ${error.toString()}"));
    print(_space);
    print(
        "╚══════════════════════════════════════════════════════════════════════════════════════════╝");
    throw error;
  }

  void _printKV(String? key, Object? v, {int layer = 0}) {
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

  void _printBlock(String msg, {int layer = 0}) {
    var lines = (msg.length / maxWidth).ceil();
    for (var i = 0; i < lines; ++i) {
      logPrint(('║  ${"  " * layer}') +
          msg.substring(i * maxWidth,
              math.min<int>(i * maxWidth + maxWidth, msg.length)));
    }
  }

  void Function(Object object) logPrint = print;
}
