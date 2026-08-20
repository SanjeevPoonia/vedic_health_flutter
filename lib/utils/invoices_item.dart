class InvoiceItem {
  final String title;
  final double cost;
  final int unit;

  InvoiceItem({
    required this.title,
    required this.cost,
    required this.unit,
  });

  double get total => cost * unit;
}