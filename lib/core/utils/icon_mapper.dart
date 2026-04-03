import 'package:flutter/material.dart';

/// Converts persisted icon keys to material icons and back.
class IconMapper {
  IconMapper._();

  static IconData fromKey(String key) {
    switch (key) {
      case 'restaurant':
        return Icons.restaurant_outlined;
      case 'shopping_bag':
        return Icons.shopping_bag_outlined;
      case 'directions_car':
        return Icons.directions_car_outlined;
      case 'home':
        return Icons.home_outlined;
      case 'insights':
        return Icons.insights_outlined;
      case 'payments':
        return Icons.payments_outlined;
      case 'local_taxi':
        return Icons.local_taxi_outlined;
      default:
        return Icons.receipt_outlined;
    }
  }

  static String toKey(IconData icon) {
    if (icon == Icons.restaurant_outlined) {
      return 'restaurant';
    }
    if (icon == Icons.shopping_bag_outlined) {
      return 'shopping_bag';
    }
    if (icon == Icons.directions_car_outlined) {
      return 'directions_car';
    }
    if (icon == Icons.home_outlined) {
      return 'home';
    }
    if (icon == Icons.insights_outlined) {
      return 'insights';
    }
    if (icon == Icons.local_taxi_outlined) {
      return 'local_taxi';
    }
    return 'payments';
  }
}
