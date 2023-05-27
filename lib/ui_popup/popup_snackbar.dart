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
    SnackBar snackBar = SnackBar(
      padding: const EdgeInsets.all(8.0),
      margin: const EdgeInsets.all(8.0),
      behavior: SnackBarBehavior.floating,
      duration: duration,
      backgroundColor:
          backgroundColor ?? Theme.of(context).snackBarTheme.backgroundColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      content: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(message.toString()),
            ),
          ),
          Visibility(
            visible: closeButton,
            child: IconButton(
                onPressed: () {
                  removeActiveSnackBar(context);
                },
                icon: const Icon(Icons.close)),
          ),
          customButton ?? const SizedBox.shrink(),
        ],
      ),
      dismissDirection: DismissDirection.horizontal,
    );
    ScaffoldMessenger.of(context)
      ..removeCurrentSnackBar()
      ..showSnackBar(snackBar);
  }
}
