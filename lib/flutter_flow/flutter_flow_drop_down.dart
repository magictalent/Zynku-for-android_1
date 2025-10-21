import 'package:flutter/material.dart';
import '/flutter_flow/form_field_controller.dart';

class FlutterFlowDropDown<T> extends StatelessWidget {
  final List<T> options;
  final void Function(T?)? onChanged;
  final FormFieldController<T>? controller;
  final String? hintText;
  final TextStyle? textStyle;
  final Widget? icon;
  final Color? fillColor;
  final double? width;
  final double? height;
  final double? elevation;
  final Color? borderColor;
  final double? borderWidth;
  final double? borderRadius;
  final EdgeInsetsGeometry? margin;
  final bool? hidesUnderline;
  final bool? isOverButton;
  final bool? isSearchable;
  final bool? isMultiSelect;

  const FlutterFlowDropDown({
    super.key,
    required this.options,
    this.onChanged,
    this.controller,
    this.hintText,
    this.textStyle,
    this.icon,
    this.fillColor,
    this.width,
    this.height,
    this.elevation,
    this.borderColor,
    this.borderWidth,
    this.borderRadius,
    this.margin,
    this.hidesUnderline,
    this.isOverButton,
    this.isSearchable,
    this.isMultiSelect,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: DropdownButtonFormField<T>(
        decoration: InputDecoration(
          hintText: hintText,
          filled: true,
          fillColor: fillColor ?? Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius ?? 8),
            borderSide: BorderSide(
              color: borderColor ?? Colors.transparent,
              width: borderWidth ?? 0,
            ),
          ),
        ),
        dropdownColor: fillColor ?? Colors.white,
        initialValue: controller?.value,
        icon: icon ?? const Icon(Icons.arrow_drop_down),
        onChanged: (val) {
          if (controller != null) controller!.value = val;
          if (onChanged != null) onChanged!(val);
        },
        items: options
            .map(
              (opt) => DropdownMenuItem<T>(
                value: opt,
                child: Text(opt.toString(), style: textStyle),
              ),
            )
            .toList(),
      ),
    );
  }
}
