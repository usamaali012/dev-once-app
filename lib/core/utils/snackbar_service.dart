import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';

abstract class SnackbarService {
  static ScaffoldFeatureController showSnack(BuildContext context, String message) {
    return _buildSnackBar(
      context: context,
      title: 'Info',
      message: message,
      contentType: ContentType.help,
    );
  }

  static ScaffoldFeatureController showSuccessSnack(BuildContext context, String message) {
    return _buildSnackBar(
      context: context,
      title: 'Success',
      message: message,
      contentType: ContentType.success,
    );
  }

  static ScaffoldFeatureController showWarningSnack(BuildContext context, String message) {
    return _buildSnackBar(
      context: context,
      title: 'Warning',
      message: message,
      contentType: ContentType.warning,
    );
  }

  static ScaffoldFeatureController showErrorSnack(BuildContext context, String message) {
    return _buildSnackBar(
      context: context,
      title: 'Oops!',
      message: message,
      contentType: ContentType.failure,
    );
  }

  static ScaffoldFeatureController _buildSnackBar({
    required BuildContext context,
    required String title,
    required String message,
    required ContentType contentType,
  }) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        content: AwesomeSnackbarContent(title: title, message: message, contentType: contentType),
      ),
    );
  }
}
