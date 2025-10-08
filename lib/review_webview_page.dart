// review_webview_page.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_windows/webview_windows.dart';
import 'package:tugas_flutter/models/order.dart';
import 'package:intl/intl.dart';

class ReviewWebViewPage extends StatefulWidget {
  final List<Order> orders;
  const ReviewWebViewPage({super.key, required this.orders});

  @override
  State<ReviewWebViewPage> createState() => _ReviewWebViewPageState();
}

class _ReviewWebViewPageState extends State<ReviewWebViewPage> {
  final _webviewController = WebviewController();

  @override
  void initState() {
    super.initState();
    _initWebView();
  }

  Future<void> _initWebView() async {
    // Inisialisasi WebView
    await _webviewController.initialize();

    // Load HTML dari assets sebagai data URL
    final htmlContent = await rootBundle.loadString('assets/web/review_page.html');
    final dataUrl = 'data:text/html;charset=utf-8,${Uri.encodeComponent(htmlContent)}';
    await _webviewController.loadUrl(dataUrl);

    // Setelah halaman siap, kirim data review
    _sendReviewsToWebView();
  }

  void _sendReviewsToWebView() {
    final reviews = widget.orders.map((order) {
      final date = DateFormat(
        'dd MMM yyyy, HH:mm',
      ).format(order.transactionTime);
      return {
        "orderId": order.orderId,
        "rating": order.rating ?? 0,
        "review": order.review ?? "",
        "date": date,
      };
    }).toList();

    final jsonReviews = jsonEncode(reviews);

    // Kirim ke JavaScript di WebView
    _webviewController.executeScript("loadReviews($jsonReviews);");
    print("Reviews sent: $jsonReviews");
  }

  @override
  void dispose() {
    _webviewController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Review Pesanan"),
        backgroundColor: Colors.deepOrange,
      ),
      body: Webview(_webviewController),
      floatingActionButton: FloatingActionButton(
        onPressed: _sendReviewsToWebView, // Bisa refresh manual
        backgroundColor: Colors.deepOrange,
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
