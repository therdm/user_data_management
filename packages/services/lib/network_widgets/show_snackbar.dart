import 'package:flutter/material.dart';
import 'package:services/data_providers/data_providers.dart';

void showSnackBarIfError(BuildContext context, {required ServiceStatus networkStatus}) {
  if(networkStatus.isError){
    showSnackBar(context: context, title: networkStatus.message, isError: true);
  }
}

void showSnackBar({
  required BuildContext context,
  required String title,
  bool? isError,
  Color? color,
  int milliseconds = 1800,
}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      duration: Duration(milliseconds: milliseconds),
      padding: const EdgeInsets.all(16),
      backgroundColor: color ??
          (isError == null
              ? Colors.black
              : isError == true
                  ? Colors.red
                  : const Color(0xff30BA00)),
      content: Text(
        title,
        textAlign: TextAlign.center,
        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
      ),
    ),
  );
}
