class Formatters {
  static String currency(double amount) {
    return '\$${amount.toStringAsFixed(2)}';
  }
}