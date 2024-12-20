import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:js' as js;
import 'dart:math' as math;

import 'package:pretty_http_logger/pretty_http_logger.dart';
import 'package:surf2sawa/blocs/auth.dart';
import 'package:surf2sawa/main.dart';
import 'package:surf2sawa/models/transaction.dart';

import '../models/account.dart';
import '../models/announcement.dart';
import '../models/outage.dart';
import '../models/payment-method.dart';
import '../models/products.dart';

abstract class PCApi {
  late final String server;

  Uri url({String path = "", Map<String, String>? query});
  Map<String, String> header();

  //CHECK ACCOUNT
  Future<Map<String, dynamic>> checkAccount(String accountNumber,
      {String? username, String? userId});
  Future<bool> verifyAccount(String pincode);
  Future<Account> getAccount();
  Future<Outage?> getOutage();

  //SHOP
  Future<List<Product>> getProducts();
  Future<List<PaymentMethod>> getPaymentMethods();
  Future purchase(Product product, PaymentMethod method);
  Future<Map<String, dynamic>> getPaymentDetails(String transactionNumber);

  //PAYMENT HISTORY
  Future<List<Transaction>> getPaymentHistory();

  //NOTIFICATION
  Future<List<Announcement>> getAnnouncementBoard();

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
  Map<String, String> header({Map<String, String>? add}) {
    final AuthBloc auth = AuthBloc.instance(navigatorKey.currentContext!)!;
    return {
      "Authorization":
          "3600bf62a3f79fa53f9e811bb76eaddf1073f691abd445cce221430092b75bd0",
      "x-device-key": auth.uuid!,
      if ((auth.referenceNumber ?? auth.pendingReferenceNumber) != null)
        'x-auth': auth.referenceNumber ?? auth.pendingReferenceNumber!,
      "wsc-timestamp": DateTime.now().millisecondsSinceEpoch.toString(),
      if (add != null) ...add,
    };
  }

  @override
  Future<Map<String, dynamic>> checkAccount(String accountNumber,
      {String? username, String? userId}) async {
    try {
      Map res = await _http("CHECKING ACCOUNT").post(
        url(path: "/check-account"),
        headers: header(),
        body: {
          "accountNumber": accountNumber,
          if (userId != null) "userId": userId,
          if (username != null) "username": username,
        },
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
      if (e is TimeoutException) throw ("Request timeout");
      if (e is String) rethrow;
      if (e is SocketException) throw ("No internet");
      if (e is Map) rethrow;
      throw ("Unknown error");
    }
  }

  @override
  Future<bool> verifyAccount(String pincode) async {
    try {
      Map res = await _http("VERIFYING ACCOUNT").post(
        url(path: "/verify-otp"),
        headers: header(),
        body: {
          "pincode": pincode,
        },
      ).then((res) => jsonDecode(res.body));

      if (!(res['status'] ?? false) || (res['code'] ?? 200) != 200) {
        throw res.putIfAbsent('message', () => 'Unknown error');
      }
      return res['message'].toString() == "Successfully verified OTP";
    } catch (e) {
      PCApi._logError("VERIFYING ACCOUNT", e);
      if (e is TimeoutException) throw ("Request timeout");
      if (e is String) rethrow;
      if (e is SocketException) throw ("No internet");
      if (e is Map) rethrow;
      throw ("Unknown error");
    }
  }

  @override
  Future<Account> getAccount() async {
    try {
      Map res = await _http("GETTING ACCOUNT INFO")
          .get(
            url(path: "/account"),
            headers: header(
              add: {
                "testmode": "true",
              },
            ),
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
      if (e is TimeoutException) throw ("Request timeout");
      if (e is String) rethrow;
      if (e is SocketException) throw ("No internet");
      if (e is Map) rethrow;
      throw ("Unknown error");
    }
  }

  @override
  Future<Outage?> getOutage() async {
    try {
      Map res = await _http("GETTING OUTAGE INFO")
          .get(
        url(path: "/outage-data"),
        headers: header(
          add: {
            "testmode": "true",
          },
        ),
      )
          .then((res) => jsonDecode(res.body));

      if (!(res['status'] ?? false) || (res['code'] ?? 200) != 200) {
        throw res.putIfAbsent('message', () => 'Unknown error');
      }
      if (res['data'] == null) throw "Missing response body";
      if (res['data']['outage'] == null) return null;
      return Outage.fromMap(res['data']['outage']);
    } catch (e) {
      PCApi._logError("GETTING OUTAGE INFO", e);
      if (e is TimeoutException) throw ("Request timeout");
      if (e is String) rethrow;
      if (e is SocketException) throw ("No internet");
      if (e is Map) rethrow;
      throw ("Unknown error");
    }
  }

  @override
  Future<List<Product>> getProducts() async {
    try {
      Map res = await _http("GETTING PRODUCT LIST")
          .get(
            url(path: "/sku-list"),
            headers: header(),
          )
          .then((res) => jsonDecode(res.body));

      if (!(res['status'] ?? false) || (res['code'] ?? 200) != 200) {
        throw res.putIfAbsent('message', () => 'Unknown error');
      }
      if (res['data'] is! Map<String, dynamic>?) {
        throw "Invalid response body structure";
      }
      if (res['data']?['list'] == null) throw "Missing response body";
      return List.from(res['data']!['list'])
          .map<Product>((payload) => Product.fromMap(payload))
          .toList();
    } catch (e) {
      PCApi._logError("GETTING PRODUCT LIST ERROR", e);
      if (e is TimeoutException) throw ("Request timeout");
      if (e is String) rethrow;
      if (e is SocketException) throw ("No internet");
      if (e is Map) rethrow;
      throw ("Unknown error");
    }
  }

  @override
  Future<List<PaymentMethod>> getPaymentMethods() async {
    try {
      Map res = await _http("GETTING PAYMENT METHOD")
          .get(
            url(path: "/payment-methods"),
            headers: header(),
          )
          .then((res) => jsonDecode(res.body));

      if (!(res['status'] ?? false) || (res['code'] ?? 200) != 200) {
        throw res.putIfAbsent('message', () => 'Unknown error');
      }
      if (res['data'] is! Map<String, dynamic>?) {
        throw "Invalid response body structure";
      }
      if (res['data']?['paymentMethods'] == null) throw "Missing response body";
      return List.from(res['data']!['paymentMethods'])
          .map<PaymentMethod>((payload) => PaymentMethod.fromMap(payload))
          .toList();
    } catch (e) {
      PCApi._logError("GETTING PAYMENT METHOD", e);
      if (e is TimeoutException) throw ("Request timeout");
      if (e is String) rethrow;
      if (e is SocketException) throw ("No internet");
      if (e is Map) rethrow;
      throw ("Unknown error");
    }
  }

  @override
  Future purchase(Product product, PaymentMethod method) async {
    try {
      Map res = await _http(
              "PURCHASE ${product.name.toUpperCase()} USING ${method.name.toUpperCase()}")
          .post(
        url(path: "/payment"),
        headers: header(),
        body: {
          "skuId": product.sku.toString(),
          "paymentMethod": method.code,
          "force": true,
        },
      ).then((res) => jsonDecode(res.body));

      if (!(res['status'] ?? false) || (res['code'] ?? 200) != 200) {
        throw res.putIfAbsent('message', () => 'Unknown error');
      }
      if (res['data'] is! Map<String, dynamic>?) {
        throw "Invalid response body structure";
      }
      if (res['data'] == null) throw "Missing response body";
      String redirectUrl = res['data']!['redirectUrl'];
      js.context.callMethod('open', [redirectUrl, '_self']);
      return;
    } catch (e) {
      PCApi._logError("PURCHASE", e);
      if (e is TimeoutException) throw ("Request timeout");
      if (e is String) rethrow;
      if (e is SocketException) throw ("No internet");
      if (e is Map) rethrow;
      throw ("Unknown error");
    }
  }

  @override
  Future<List<Transaction>> getPaymentHistory() async {
    try {
      Map res = await _http("GETTING PAYMENT HISTORY")
          .get(
            url(path: "/history"),
            headers: header(),
          )
          .then((res) => jsonDecode(res.body));

      if (!(res['status'] ?? false) || (res['code'] ?? 200) != 200) {
        throw res.putIfAbsent('message', () => 'Unknown error');
      }
      if (res['data'] is! Map<String, dynamic>?) {
        throw "Invalid response body structure";
      }
      if (res['data']?['history'] == null) throw "Missing response body";
      return List.from(res['data']!['history'])
          .map<Transaction>((payload) => Transaction.fromMap(payload))
          .toList()
          .reversed
          .toList();
    } catch (e) {
      PCApi._logError("GETTING PAYMENT HISTORY", e);
      if (e is TimeoutException) throw ("Request timeout");
      if (e is String) rethrow;
      if (e is SocketException) throw ("No internet");
      if (e is Map) rethrow;
      throw ("Unknown error");
    }
  }

  @override
  Future<List<Announcement>> getAnnouncementBoard() async {
    try {
      Map res = await _http("GETTING ANNOUNCEMENT BOARD")
          .get(
        url(path: "/notification-list"),
        headers: header(),
      )
          .then((res) => jsonDecode(res.body));

      if (!(res['status'] ?? false) || (res['code'] ?? 200) != 200) {
        throw res.putIfAbsent('message', () => 'Unknown error');
      }
      if (res['data'] is! Map<String, dynamic>?) {
        throw "Invalid response body structure";
      }
      if (res['data']?['notifications'] == null) throw "Missing response body";
      return List.from(res['data']!['notifications'])
      // return List
      //     .generate(20, (index) => {
      //   "title": "Announcement #$index",
      //   "message": "This is the message for announcement #$index",
      // },)
          .map<Announcement>((payload) => Announcement.fromMap(payload))
          .toList()
          .reversed
          .toList();
    } catch (e) {
      PCApi._logError("GETTING ANNOUNCEMENT BOARD", e);
      if (e is TimeoutException) throw ("Request timeout");
      if (e is String) rethrow;
      if (e is SocketException) throw ("No internet");
      if (e is Map) rethrow;
      throw ("Unknown error");
    }
  }

  @override
  Future<Map<String, dynamic>> getPaymentDetails(String transactionNumber) async {
    try {
      Map res = await _http("GETTING PAYMENT DETAILS")
          .get(
        url(path: "/payment-details",
          query: {
          "transactionNumber": transactionNumber,
          },
        ),
        headers: header(),
      )
          .then((res) => jsonDecode(res.body));
      if (!(res['status'] ?? false) || (res['code'] ?? 200) != 200) {
        throw res.putIfAbsent('message', () => 'Unknown error');
      }
      if (res['data'] is! Map<String, dynamic>?) {
        throw "Invalid response body structure";
      }
      return Map<String, dynamic>.from(res['data']);
    } catch (e) {
      PCApi._logError("GETTING ANNOUNCEMENT BOARD", e);
      if (e is TimeoutException) throw ("Request timeout");
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
    if (data.headers != null) {
      data.headers?.forEach((key, value) => _printKV(key, value));
    }
    if (data.url.queryParameters.isNotEmpty) print(_space);
    if (data.url.queryParameters.isNotEmpty) {
      print(_bordered("╠══╡ QUERY PARAMETERS:"));
    }
    if (data.url.queryParameters.isNotEmpty) {
      data.url.queryParameters.forEach((key, value) => _printKV(key, value));
    }
    if (data.body != null) print(_space);
    if (data.body != null) print(_bordered("╠══╡ BODY:"));
    if (data.body != null) {
      data.body?.forEach((key, value) => _printKV(key, value));
    }
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
    if (res.containsKey("message")) {
      print(_bordered("╠══╡ MESSAGE: ${res['message']}"));
    }
    if (res.containsKey("data")) print(_space);
    if (res.containsKey("data")) print(_bordered("╠══╡ RESPONSE:"));
    if (res["data"] is Map<String, dynamic>) {
      Map<String, dynamic>.from(res["data"])
          .forEach((key, value) => _printKV(key, value));
    }
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
      for (var element in List<dynamic>.from(v)) {
        _printKV(null, element, layer: layer + 1);
      }
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
