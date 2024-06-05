import 'package:flutter/material.dart';

class SquareTile extends StatelessWidget {
  final String imagePath;
  final FUnctions()? onTap;
  const SquareTile({
    super.key,
    required this.imagePath,
    required this.onTap,});

  @override
  Widget build(BuildContext context){
    return GestureDetector(
      onTap: onTap,
      child: Container(
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
      ),
    );
  }
}