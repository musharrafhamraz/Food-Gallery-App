class Order {
  final String id;
  final String customerName;
  final String measurements;
  final DateTime deadline;
  bool isCompleted;
  bool isInProgress;

  Order({
    required this.id,
    required this.customerName,
    required this.measurements,
    required this.deadline,
    this.isCompleted = false,
    this.isInProgress = false,
    required CustomerProfile customerProfile,
  });
}

class CustomerProfile {
  final String name;
  final String contact;
  final List<Order> pastOrders;

  CustomerProfile({
    required this.name,
    required this.contact,
    required this.pastOrders,
  });
}
