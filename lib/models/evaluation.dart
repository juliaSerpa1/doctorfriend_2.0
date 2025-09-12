class Evaluation {
  final String id;
  final String userId;
  final String customerId;
  final String customerName;
  final String text;
  final String? responseText;
  final int rate;
  final bool show;
  final DateTime createdDate;
  final DateTime? responseDate;

  const Evaluation({
    required this.id,
    required this.userId,
    required this.customerId,
    required this.customerName,
    required this.text,
    required this.responseText,
    required this.rate,
    required this.show,
    required this.createdDate,
    required this.responseDate,
  });
}
