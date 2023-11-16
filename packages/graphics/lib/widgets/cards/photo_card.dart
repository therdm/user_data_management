import 'package:flutter/material.dart';

import '../../graphics_consts/consts.dart';

class PhotoCard extends StatelessWidget {
  const PhotoCard({
    super.key,
    this.title,
    this.imgUrl,
    this.description,
  });

  final String? title;
  final String? imgUrl;
  final String? description;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Text(
              title ?? GraphicsStringConsts.titleNotFound,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            (imgUrl != null) ? Expanded(child: Image.network(imgUrl!, fit: BoxFit.cover)) : const Spacer(),
            const SizedBox(height: 8),
            Text(
              description ?? GraphicsStringConsts.descriptionNotFound,
              maxLines: 3,
            )
          ],
        ),
      ),
    );
  }
}
