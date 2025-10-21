import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:flutter_rating_stars/flutter_rating_stars.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tugas_flutter/models/order.dart';
import 'package:tugas_flutter/order_detail_page.dart';
import 'dart:convert';

class OrderHistoryPage extends StatefulWidget {
  const OrderHistoryPage({super.key});

  @override
  State<OrderHistoryPage> createState() => _OrderHistoryPageState();
}

class _OrderHistoryPageState extends State<OrderHistoryPage> {
  List<Order> _loadedOrders = [];
  bool _isLoading = true;

  Map<String, double> orderRatings = {};
  Map<String, String> orderReviews = {};
  Map<String, TextEditingController> reviewControllers = {};

  @override
  void initState() {
    super.initState();
    _loadOrderHistory();
  }

  Future<void> _loadOrderHistory() async {
    setState(() {
      _isLoading = true;
    });

    final prefs = await SharedPreferences.getInstance();
    final String? existingData = prefs.getString('order_history');
    List<Order> orders = [];

    if (existingData != null) {
      try {
        final List<dynamic> decoded = jsonDecode(existingData);
        orders = decoded.map((e) {
          return Order.fromMap(e as Map<String, dynamic>);
        }).toList();
      } catch (e) {
        debugPrint('Error decoding order history from SharedPreferences: $e');
      }
    }

    orders.sort((a, b) => b.transactionTime.compareTo(a.transactionTime));

    setState(() {
      _loadedOrders = orders;
      _isLoading = false;
    });

    _loadSavedReviews();
  }

  Future<void> _loadSavedReviews() async {
    final prefs = await SharedPreferences.getInstance();
    for (var order in _loadedOrders) {
      // Menggunakan _loadedOrders
      final rating = prefs.getDouble("rating_${order.orderId}") ?? 0.0;
      final review = prefs.getString("review_${order.orderId}") ?? "";

      orderRatings[order.orderId] = rating;
      orderReviews[order.orderId] = review;
    }
  }

  String formatRupiah(int amount) {
    final format = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ');
    return format.format(amount).replaceAll(',00', '');
  }

  String formatDate(DateTime time) {
    return DateFormat('dd MMM yyyy, HH:mm').format(time);
  }

  @override
  void dispose() {
    for (var controller in reviewControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  void _submitReview(Order order, TextEditingController controller) async {
    final rating = orderRatings[order.orderId] ?? 0.0;
    final reviewText = controller.text.trim();

    if (rating < 1.0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Mohon berikan minimal 1 bintang sebelum mengirim."),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble("rating_${order.orderId}", rating);
    await prefs.setString("review_${order.orderId}", reviewText);

    order.addReview(rating.toInt(), reviewText);

    setState(() {
      // Set rating dan review menjadi kosong setelah dikirim
      orderRatings[order.orderId] = 0.0;
      orderReviews[order.orderId] = "";
      controller.clear();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          "Rating (${rating.toStringAsFixed(1)} Bintang) dan Ulasan berhasil dikirim!",
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 249, 238, 196),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final orders = _loadedOrders;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Riwayat Pesanan"),
        backgroundColor: Colors.deepOrange,
        foregroundColor: Colors.white,
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Colors.deepOrange),
            )
          : orders.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.receipt_long, size: 80, color: Colors.grey),
                  const SizedBox(height: 10),
                  Text(
                    "Belum ada riwayat pesanan.",
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      color: Colors.grey,
                    ),
                  ),
                  Text(
                    "Ayo mulai order makanan kesukaanmu!",
                    style: GoogleFonts.inter(fontSize: 14, color: Colors.grey),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: orders.length,
              itemBuilder: (context, index) {
                final order = orders[index];

                if (!reviewControllers.containsKey(order.orderId)) {
                  reviewControllers[order.orderId] = TextEditingController(
                    text: orderReviews[order.orderId] ?? "",
                  );
                }
                final controller = reviewControllers[order.orderId]!;
                double currentRating = orderRatings[order.orderId] ?? 0.0;

                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.restaurant,
                              color: Colors.deepOrange,
                              size: 24,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                "Pesanan ${order.orderId}",
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.bold,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        OrderDetailPage(order: order),
                                  ),
                                );
                              },
                              child: const Padding(
                                padding: EdgeInsets.only(left: 8.0),
                                child: Icon(
                                  Icons.arrow_forward_ios,
                                  size: 16,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "Waktu: ${formatDate(order.transactionTime)}",
                          style: TextStyle(color: Colors.grey.shade700),
                        ),
                        Text(
                          "Total: ${formatRupiah(order.totalAmount)}",
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            color: Colors.deepOrange,
                          ),
                        ),
                        const Divider(height: 24),
                        Text(
                          "Beri rating:",
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        RatingStars(
                          axis: Axis.horizontal,
                          value: currentRating,
                          onValueChanged: (v) =>
                              setState(() => orderRatings[order.orderId] = v),
                          starCount: 5,
                          starSize: 35,
                          maxValue: 5,
                          starSpacing: 2,
                          valueLabelVisibility: false,
                          animationDuration: const Duration(milliseconds: 600),
                          starOffColor: const Color(0xffe7e8ea),
                          starColor: Colors.amber,
                          angle: 12,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          "Tulis ulasan:",
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        TextField(
                          controller: controller,
                          maxLines: 2,
                          decoration: InputDecoration(
                            hintText: "Tulis ulasan kamu di sini...",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(
                                color: Colors.grey.shade300,
                                width: 1.0,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(
                                color: Colors.deepOrange,
                                width: 2.0,
                              ),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Align(
                          alignment: Alignment.centerRight,
                          child: ElevatedButton.icon(
                            onPressed: () => _submitReview(order, controller),
                            icon: const Icon(
                              Icons.send,
                              size: 18,
                              color: Colors.white,
                            ),
                            label: Text(
                              "Kirim Ulasan",
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.deepOrange,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 15,
                                vertical: 10,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              elevation: 3,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
