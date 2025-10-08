import 'cart.dart';

class Order {
  final String orderId;
  final String customerName;
  final String paymentMethod;
  final DateTime transactionTime;
  final List<CartItem> items;
  final int totalAmount;

  String status; // Completed, Canceled
  int? rating; // 1-5
  String? review;

  Order({
    required this.orderId,
    required this.customerName,
    required this.paymentMethod,
    required this.transactionTime,
    required this.items,
    required this.totalAmount,
    this.status = 'Completed',
    this.rating,
    this.review,
  });

  // Tambah rating & review
  void addReview(int newRating, String newReview) {
    rating = newRating;
    review = newReview;
  }

  // Serialize ke Map (untuk JSON/SharedPreferences)
  Map<String, dynamic> toMap() {
    return {
      'orderId': orderId,
      'customerName': customerName,
      'paymentMethod': paymentMethod,
      'transactionTime': transactionTime.toIso8601String(),
      'totalAmount': totalAmount,
      'status': status,
      'rating': rating,
      'review': review,
      'items': items.map((i) => i.toMap()).toList(),
    };
  }

  // Deserialize dari Map
  factory Order.fromMap(Map<String, dynamic> map) {
    return Order(
      orderId: map['orderId'],
      customerName: map['customerName'],
      paymentMethod: map['paymentMethod'],
      transactionTime: DateTime.parse(map['transactionTime']),
      totalAmount: map['totalAmount'],
      status: map['status'] ?? 'Completed',
      rating: map['rating'],
      review: map['review'],
      items: List<CartItem>.from(
        (map['items'] as List<dynamic>).map(
          (i) => CartItem.fromMap(Map<String, dynamic>.from(i)),
        ),
      ),
    );
  }
}
