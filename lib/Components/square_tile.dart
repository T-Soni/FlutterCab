import 'package:flutter/material.dart';

class SquareTile extends StatelessWidget {
  final String imagePath;
  const SquareTile({
    super.key,
    required this.imagePath,});

  @override
  Widget build(BuildContext context){
    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.amber),
        borderRadius: BorderRadius.circular(20),
        color: Colors.grey[175],
      ),
      child: Image.asset(
        imagePath,
        height: 40,
      ),
    );
  }
}