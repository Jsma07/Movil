import 'package:flutter/material.dart';

class FondoPantalla extends StatelessWidget {
  final String imageUrl;

  const FondoPantalla({required this.imageUrl, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: NetworkImage(
              'https://i.pinimg.com/736x/71/7d/ce/717dce3d21e998822a3ca37065b932d3.jpg'),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
