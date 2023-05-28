import 'package:flutter/material.dart';

class UiPopup {
  static void removeActiveSnackBar(BuildContext context) {
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
  }

  static void showSnackBar({
    required BuildContext context,
    Duration duration = const Duration(seconds: 5),
    String message = '',
    Color? backgroundColor,
    bool closeButton = false,
    Widget? customButton,
  }) {
    return;
  }
}
