import 'package:flutter/material.dart';

class AppIcons {
  static const List<IconData> defaultWalletIcons = [
    Icons.account_balance_wallet_outlined, Icons.savings_outlined,
    Icons.payments_outlined, Icons.credit_card_outlined,
  ];

  static const List<IconData> extendedWalletIcons = [
    Icons.shopping_cart_outlined, Icons.fastfood_outlined, Icons.local_gas_station_outlined,
    Icons.flight_outlined, Icons.medical_services_outlined, Icons.school_outlined,
    Icons.home_outlined, Icons.phone_android_outlined, Icons.laptop_outlined,
    Icons.pets_outlined, Icons.fitness_center_outlined, Icons.movie_outlined,
    Icons.music_note_outlined, Icons.sports_esports_outlined, Icons.restaurant_outlined,
    Icons.coffee_outlined, Icons.stroller_outlined, Icons.directions_car_outlined,
    Icons.redeem_outlined, Icons.favorite_border_outlined
  ];

  static IconData getIconFromData(String iconDataStr) {
    try {
      int codePoint = int.parse(iconDataStr);
      return IconData(codePoint, fontFamily: 'MaterialIcons');
    } catch (e) {
      switch (iconDataStr) {
        case 'wallet': return Icons.account_balance_wallet;
        case 'bank': return Icons.account_balance;
        case 'credit_card': return Icons.credit_card;
        case 'piggy_bank': return Icons.savings;
        default: return Icons.account_balance_wallet_outlined;
      }
    }
  }
}