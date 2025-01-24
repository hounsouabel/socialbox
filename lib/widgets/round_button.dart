import 'package:flutter/material.dart';

class RoundButton extends StatelessWidget {
  const RoundButton({
    super.key,
    required this.onPressed,
    required this.label,
    this.color = Colors.lightBlue, // Remplacement de AppColors.lightBlueColor
    this.height = 50,
  });

  final VoidCallback? onPressed;
  final String label;
  final Color color;
  final double height;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        height: height,
        width: double.infinity,
        decoration: BoxDecoration(
          color: onPressed == null ? Colors.transparent : color,
          borderRadius: BorderRadius.circular(25),
          border: Border.all(
            color: Colors.blue, // Remplacement de AppColors.darkBlueColor
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: (color == Colors.lightBlue && onPressed != null)
                  ? Colors.white // Remplacement de AppColors.realWhiteColor
                  : Colors.blue, // Remplacement de AppColors.darkBlueColor
              fontSize: 18,
            ),
          ),
        ),
      ),
    );
  }
}