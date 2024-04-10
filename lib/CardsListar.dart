import 'package:flutter/material.dart';
// import 'package:primer_proyecto/CancelarVenta.dart';
// import 'package:primer_proyecto/VisibilityPage.dart';
// import 'package:primer_proyecto/app_bar.dart';

Widget buildSalesListItem({
  required String title,
  required String imageUrl,
  required String subtitle,
  required Function() onVisibilityTap,
  required Function() onCancelTap,
}) {
  return Card(
    child: ListTile(
      leading: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 5,
              blurRadius: 7,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: CircleAvatar(
          radius: 25,
          backgroundImage: NetworkImage(imageUrl),
        ),
      ),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: onVisibilityTap,
            child: Container(
              width: 35,
              height: 35,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color.fromRGBO(112, 185, 244, 1),
              ),
              child: const Icon(
                Icons.visibility,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(width: 10),
          GestureDetector(
            onTap: onCancelTap,
            child: Container(
              width: 35,
              height: 35,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color.fromRGBO(112, 185, 244, 1),
              ),
              child: const Icon(
                Icons.cancel,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
