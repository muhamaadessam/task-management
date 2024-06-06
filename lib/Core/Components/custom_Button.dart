import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    this.onPressed,
    required this.child,
    this.backgroundColor,
    this.elevationColor,
    this.elevation,
    this.borderRadius,
  });

  final void Function()? onPressed;
  final Widget child;
  final Color? backgroundColor;
  final Color? elevationColor;
  final double? elevation;
  final double? borderRadius;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ButtonStyle(
        elevation:
            MaterialStateProperty.resolveWith((states) => elevation ?? 9),
        shadowColor: MaterialStateColor.resolveWith(
            (states) => elevationColor ?? Colors.black.withOpacity(0.5)),
        backgroundColor: MaterialStateColor.resolveWith(
            (states) => backgroundColor ?? const Color(0xff00CA5D)),
        shape: MaterialStateProperty.resolveWith(
          (states) => RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius ?? 10)),
        ),
      ),
      child: child,
    );
  }
}
