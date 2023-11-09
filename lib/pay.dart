import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:pay/result.dart';

class PayScreen extends StatefulWidget {
  const PayScreen({super.key, required this.money});

  final String money;

  @override
  State<PayScreen> createState() => _PayScreenState();
}

class _PayScreenState extends State<PayScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pay Screen"),
      ),
      body: InAppWebView(
          initialUrlRequest: URLRequest(
              url: Uri.parse(
                  "https://vnpay-aiohs.onrender.com/order/create_payment_url"),
              method: 'POST',
              body: Uint8List.fromList(utf8
                  .encode("amount=${widget.money}&bankCode=&language=vn")),
              headers: {'Content-Type': 'application/x-www-form-urlencoded'}),
          onWebViewCreated: (controller) {
            debugPrint("Open web success");
          },
          onLoadStart: (controller, url) async {
            if (url.toString().contains("/order/vnpay_return")) {
              var response = await controller.evaluateJavascript(
                  source: 'document.body.innerText');
              var code = jsonDecode(response)['code'];
              Navigator.pop(context);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ResultScreen(result: code)));
              debugPrint(code);
            }
          }

          // onLoadStart: (controller, url) async {
          //   if (url.toString().contains("/order/vnpay_return")) {
          //     var query = url!.query;
          //     await controller.goBack();
          //     //redirect to url
          //     debugPrint(query);
          //     var redirectLink = 'http://10.0.2.2:8888/order/vnpay_return?$query';
          //     //load redirectLink
          //     //convert redirectLink to URLRequest

          //     await controller.loadUrl(
          //         urlRequest: URLRequest(url: Uri.parse(redirectLink)));
          //     //get data from web
          //     var response = await controller.evaluateJavascript(
          //         source: 'document.body.innerText');
          //     print(response);
          //     debugPrint("Open web success 2");
          //   }
          // },
          ),
    );
  }
}
