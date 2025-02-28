import 'package:flutter/material.dart';
import 'package:flutter_nellicious/pages/transaction_error_page.dart';
import 'package:flutter_nellicious/pages/transaction_success_page.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PaymentPage extends StatefulWidget {
  final String midtransToken;
  final List items;
  const PaymentPage({
    super.key,
    required this.midtransToken,
    required this.items,
  });

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  WebViewController? webViewController;
  int loadingProgress = 0;

  @override
  void initState() {
    super.initState();
    webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            setState(() {
              loadingProgress = progress;
            });
          },
          onPageStarted: (String url) {
            if (url.contains("status_code=202&transaction_status=deny")) {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => TransactionErrorPage(),
              ));
            }
            if (url.contains("status_code=200&transaction_status=settlement")) {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) =>
                    TransactionSuccessPage(items: widget.items),
              ));
            }
          },
          onPageFinished: (String url) {
            setState(() {
              loadingProgress = 100;
            });
          },
          onHttpError: (HttpResponseError error) {},
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.startsWith('https://www.youtube.com/')) {
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(
          'https://app.sandbox.midtrans.com/snap/v2/vtweb/${widget.midtransToken}'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
            )),
        centerTitle: true,
        backgroundColor: Colors.green,
        title: Text(
          "Pembayaran",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        children: [
          // Progress Bar
          if (loadingProgress < 100)
            LinearProgressIndicator(value: loadingProgress / 100),
          Expanded(
            child: WebViewWidget(controller: webViewController!),
          ),
        ],
      ),
    );
  }
}
