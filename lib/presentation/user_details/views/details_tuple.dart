import 'package:flutter/material.dart';

class DetailsTuple extends StatelessWidget {
  const DetailsTuple({
    super.key,
    required this.title,
    required this.value,
  });

  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
              child: Text(
                title,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              )),
          Expanded(
              flex: 2,
              child: Text(
                value,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              )),
        ],
      ),
    );
  }
}
