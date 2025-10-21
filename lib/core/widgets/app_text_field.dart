import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../theme/app_colors.dart';

class AppTextField extends StatefulWidget {
  const AppTextField({
    super.key,
    this.controller,
    this.focusNode,
    this.initialValue,
    this.label,
    this.inputLabel,
    this.placeholder,
    this.labelColor = Colors.black,
    this.fillColor = const Color(0xFFF2F2F2),
    this.prefixSvg,
    this.suffixSvg,
    this.iconColor = const Color(0xFF626262),
    this.isPassword = false,
    this.enabled = true,
    this.readOnly = false,
    this.keyboardType,
    this.textInputAction,
    this.validator,
    this.onChanged,
    this.onSaved,
    this.onFieldSubmitted,
    this.autofillHints,
    this.inputFormatters,
    this.maxLines = 1,
    this.minLines,
  });

  final TextEditingController? controller;
  final FocusNode? focusNode;
  final String? initialValue;
  final String? label;
  final String? inputLabel;
  final String? placeholder;
  final Color labelColor;
  final Color fillColor;
  final String? prefixSvg;
  final String? suffixSvg;
  final Color iconColor;
  final bool isPassword;
  final bool enabled;
  final bool readOnly;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final FormFieldValidator<String>? validator;
  final ValueChanged<String>? onChanged;
  final FormFieldSetter<String>? onSaved;
  final ValueChanged<String>? onFieldSubmitted;
  final Iterable<String>? autofillHints;
  final List<TextInputFormatter>? inputFormatters;
  final int? minLines;
  final int maxLines;

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  late bool _obscure;

  @override
  void initState() {
    super.initState();
    _obscure = widget.isPassword;
  }

  @override
  Widget build(BuildContext context) {
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(color: Color(0xFFE0E0E0)),
    );

    final children = <Widget>[];

    if (widget.label?.isNotEmpty ?? false) {
      children
        ..add(
          Padding(
            padding: const EdgeInsets.only(left: 14),
            child: Text(
              widget.label!,
              style: TextStyle(
                color: widget.labelColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          )
        )
        ..add(const SizedBox(height: 8));
    }

    children.add(
      TextFormField(
        controller: widget.controller,
        focusNode: widget.focusNode,
        initialValue: widget.initialValue,
        enabled: widget.enabled,
        readOnly: widget.readOnly,
        autofillHints: widget.autofillHints,
        keyboardType: widget.keyboardType,
        textInputAction: widget.textInputAction,
        validator: widget.validator,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        onChanged: widget.onChanged,
        onSaved: widget.onSaved,
        inputFormatters: widget.inputFormatters,
        onFieldSubmitted: widget.onFieldSubmitted,
        obscureText: widget.isPassword ? _obscure : false,
        minLines: widget.minLines,
        maxLines: widget.isPassword ? 1 : widget.maxLines,
        decoration: InputDecoration(
          hintText: widget.placeholder,
          hintStyle: TextStyle(
            fontSize: 12,
            letterSpacing: 0,
            fontWeight: FontWeight.w500,
            color: AppColors.grey
          ),
          labelText: widget.inputLabel,
          filled: true,
          fillColor: widget.fillColor,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 18,
          ),
          prefixIcon: widget.prefixSvg != null && widget.prefixSvg!.isNotEmpty
            ? Padding(
                padding: const EdgeInsets.only(left: 20, right: 9),
                child: SvgPicture.asset(
                  widget.prefixSvg!,
                  colorFilter: ColorFilter.mode(widget.iconColor, BlendMode.srcIn),
                  height: 10,
                  width: 10,
                ),
              )
            : null,
          suffixIcon: widget.isPassword
            ? IconButton(
                onPressed: () => setState(() => _obscure = !_obscure),
                icon: Icon(
                  _obscure
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  color: widget.iconColor,
                ),
              )
            : (widget.suffixSvg != null && widget.suffixSvg!.isNotEmpty
                ? Padding(
                    padding: const EdgeInsets.only(right: 12, left: 8),
                    child: SvgPicture.asset(
                      widget.suffixSvg!,
                      colorFilter: ColorFilter.mode(widget.iconColor, BlendMode.srcIn),
                    ),
                  ) 
          : null),
          border: border,
          enabledBorder: border,
          focusedBorder: border.copyWith(
            borderSide: const BorderSide(color: AppColors.primary, width: 1.4),
          ),
        ),
      ),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: children,
    );
  }
}
