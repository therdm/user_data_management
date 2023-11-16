import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class UserDetailsRow extends StatelessWidget {
  const UserDetailsRow({
    super.key,
    required this.imageUrl,
    required this.userName,
    required this.userEmail,
    this.onSelect,
  });

  final String imageUrl;
  final String userName;
  final String userEmail;
  final void Function()? onSelect;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Colors.grey.withOpacity(0.2), borderRadius: BorderRadius.circular(4)),
      margin: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
      child: ListTile(
        onTap: onSelect,
        onLongPress: onSelect,
        leading: Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(48)),
          clipBehavior: Clip.hardEdge,
          child: CachedNetworkImage(
            imageUrl: imageUrl,
            errorWidget: (_, __, ___) {
              return const Column(
                children: [
                  Icon(Icons.error),
                  Text('Image not found', textScaleFactor: 0.6, textAlign: TextAlign.center),
                ],
              );
            },
            height: 50,
            width: 50,
            fit: BoxFit.fill,
          ),
        ),
        title: Text(
          userName,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
        ),
        subtitle: Text(
          userEmail,
          style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
        ),
      ),
    );
  }
}
