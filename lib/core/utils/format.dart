class Format {
  static String formatnumber(double amount) {
    String str = amount.toStringAsFixed(0);
    String result = "";
    int count = 0;
    for (int i = str.length - 1; i >= 0; i--) {
      result = str[i] + result;
      count++;
      if (count == 3 && i > 0) {
        result = "." + result;
        count = 0;
      }
    }

    return result;
  }

  static String formattext(String text) {
    if (text.isEmpty) return text;
    if (text.length <= 15) {
      return text;
    }
    return '${text.substring(0, 10)}...';
  }
}
