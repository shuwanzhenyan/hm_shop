import 'package:flutter/material.dart';

class Toastutils {
  static bool showLoading = false;

  static void showToast(BuildContext context, String? msg) {
    if (Toastutils.showLoading) {
      return;
    }
    Toastutils.showLoading = true;
    Future.delayed(Duration(seconds: 3), () {
      Toastutils.showLoading = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        width: 180,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadiusGeometry.circular(40),
        ),
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: 2),
        content: Text(msg ?? "", textAlign: TextAlign.center),
      ),
    );
  }
}
