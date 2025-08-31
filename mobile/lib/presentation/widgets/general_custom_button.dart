
import 'package:flutter/material.dart';

class GeneralButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final double width;
  final double height;
  final double borderRadius;
  final List<Color>? gradientColors;
  final Color? backgroundColor;
  final Color textColor;
  final bool showShadow;
  final Widget? icon;
  final double fontSize;
  final bool useGradientBorder;

  const GeneralButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.width = double.infinity,
    this.height = 50,
    this.borderRadius = 12,
    this.gradientColors,
    this.backgroundColor,
    this.textColor = Colors.white,
    this.showShadow = false,
    this.icon,
    this.fontSize = 16,
    this.useGradientBorder = false,
  });

  @override
  Widget build(BuildContext context) {
    if (useGradientBorder && gradientColors != null) {
      return GestureDetector(
        onTap: onPressed,
        child: Container(
          width: width,
          height: height,
          padding: const EdgeInsets.all(2), // Border width
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: gradientColors!),
            borderRadius: BorderRadius.circular(borderRadius),
            boxShadow: showShadow
                ? [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 6,
                      offset: Offset(0, 4),
                    )
                  ]
                : [],
          ),
          child: Container(
            decoration: BoxDecoration(
              color: backgroundColor ?? Colors.transparent,
              borderRadius: BorderRadius.circular(borderRadius),
            ),
            alignment: Alignment.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (icon != null) ...[
                  icon!,
                  const SizedBox(width: 8),
                ],
                Flexible(
                  child: Text(
                    text,
                    style: TextStyle(
                      color: textColor,
                      fontSize: fontSize,
                      fontWeight: FontWeight.w600,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    // Default button without gradient border
    final decoration = BoxDecoration(
      color: gradientColors == null
          ? backgroundColor ?? Theme.of(context).primaryColor
          : null,
      gradient: gradientColors != null
          ? LinearGradient(colors: gradientColors!)
          : null,
      borderRadius: BorderRadius.circular(borderRadius),
      boxShadow: showShadow
          ? [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 6,
                offset: Offset(0, 4),
              )
            ]
          : [],
    );

    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: width,
        height: height,
        decoration: decoration,
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              icon!,
              const SizedBox(width: 8),
            ],
            Flexible(
              child: Text(
                text,
                style: TextStyle(
                  color: textColor,
                  fontSize: fontSize,
                  fontWeight: FontWeight.w600,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
