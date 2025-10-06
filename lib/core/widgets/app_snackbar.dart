import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';

void showAppSnackBar(
  BuildContext context, {
  required String title,
  required String message,
  ContentType type = ContentType.success,
  Duration duration = const Duration(seconds: 4),
}) {
  final messenger = ScaffoldMessenger.of(context);
  messenger.hideCurrentSnackBar();

  final snackBar = SnackBar(
    behavior: SnackBarBehavior.floating,
    elevation: 0,
    backgroundColor: Colors.transparent,
    margin: EdgeInsets.fromLTRB(
      12,
      0,
      12,
      12 + MediaQuery.of(context).viewPadding.bottom,
    ),
    duration: duration,
    content: AwesomeSnackbarContent(
      title: title,
      message: message,
      inMaterialBanner: false,
      contentType: type,
    ),
  );

  messenger.showSnackBar(snackBar);
}

