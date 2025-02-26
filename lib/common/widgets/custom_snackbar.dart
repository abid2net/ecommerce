import 'package:ecommerce/theme/app_theme.dart';
import 'package:flutter/material.dart';

void showSuccessSnackBar({
  required BuildContext context,
  required String message,
}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message, style: TextStyle(fontWeight: FontWeight.w500)),
      backgroundColor: AppTheme.tertiaryColor,
    ),
  );
}

void showErrorSnackBar({
  required BuildContext context,
  required String message,
}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message, style: TextStyle(fontWeight: FontWeight.w500)),
      backgroundColor: AppTheme.quaternaryColor,
    ),
  );
}

void showInfoSnackBar({
  required BuildContext context,
  required String message,
}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message, style: TextStyle(fontWeight: FontWeight.w500)),
      backgroundColor: AppTheme.primaryColor,
    ),
  );
}
