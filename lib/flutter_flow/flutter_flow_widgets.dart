import 'package:flutter/material.dart';

class FFButtonOptions {
  final double width;
  final double height;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry iconPadding;
  final Color color;
  final TextStyle textStyle;
  final double elevation;
  final BorderSide? borderSide;
  final BorderRadius borderRadius;

  FFButtonOptions({
    required this.width,
    required this.height,
    required this.padding,
    required this.iconPadding,
    required this.color,
    required this.textStyle,
    required this.elevation,
    this.borderSide,
    required this.borderRadius,
  });
}

class FFButtonWidget extends StatelessWidget {
  final VoidCallback? onPressed;
  final String text;
  final Icon? icon;
  final FFButtonOptions options;

  const FFButtonWidget({
    super.key,
    required this.onPressed,
    required this.text,
    this.icon,
    required this.options,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: options.width,
      height: options.height,
      child: icon != null
          ? ElevatedButton.icon(
              onPressed: onPressed,
              icon: icon!,
              label: Text(text, style: options.textStyle),
              style: ElevatedButton.styleFrom(
                backgroundColor: options.color,
                elevation: options.elevation,
                shape: RoundedRectangleBorder(
                  borderRadius: options.borderRadius,
                  side: options.borderSide ?? BorderSide.none,
                ),
              ),
            )
          : ElevatedButton(
              onPressed: onPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: options.color,
                elevation: options.elevation,
                shape: RoundedRectangleBorder(
                  borderRadius: options.borderRadius,
                  side: options.borderSide ?? BorderSide.none,
                ),
              ),
              child: Text(text, style: options.textStyle),
            ),
    );
  }
}
