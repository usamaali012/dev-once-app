import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_extensions_pack/flutter_extensions_pack.dart';
import '../theme/app_colors.dart';

class AppTextFieldV2 extends StatefulWidget {
  const AppTextFieldV2({
    super.key,
    this.controller,
    this.focusNode,
    this.initialValue,
    this.noLabel = false,
    this.placeholder,
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
  final bool noLabel;
  final String? placeholder;
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
  State<AppTextFieldV2> createState() => _AppTextFieldV2State();
}

class _AppTextFieldV2State extends State<AppTextFieldV2> {
  bool _obscure = false;
  TextEditingController? _controller;
  FocusNode? _focusNode;

  @override
  void initState() {
    super.initState();
    _obscure = widget.isPassword;
    _controller = widget.controller ?? TextEditingController(text: widget.initialValue);
    _focusNode = widget.focusNode ?? FocusNode();
    _controller!.addListener(_onChangedInternal);
  }

  @override
  void dispose() {
    _controller?.removeListener(_onChangedInternal);
    if (widget.controller == null) _controller?.dispose();
    if (widget.focusNode == null) _focusNode?.dispose();
    super.dispose();
  }

  void _onChangedInternal() {
    setState(() {});
    if (widget.onChanged != null) widget.onChanged!(_controller?.text ?? '');
  }

  @override
  Widget build(BuildContext context) {
    final primary = AppColors.primary;

    return FormField<String>(
      initialValue: _controller?.text ?? widget.initialValue,
      validator: widget.validator,
      onSaved: widget.onSaved,
      builder: (state) {
        final children = <Widget>[];

        // Show the label only when there is no text in the field
        if (!widget.noLabel && widget.placeholder.existAndNotEmpty && _controller!.text.isNotEmpty) {
          children
            ..add(
              Text(
                widget.placeholder!,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0,
                  fontSize: 12,
                  color: AppColors.grey
                ),
              ),
            )
            ..add(const SizedBox(height: 3));
        } else {
          children.add(const SizedBox(height: 10));
        }

        children.add(
          LayoutBuilder(
            builder: (context, constraints) {
              final maxW = constraints.maxWidth;

              // Measure the current text width using TextPainter
              final textVal = _controller?.text ?? '';
              final painter = TextPainter(
                text: TextSpan(
                  text: textVal,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                textDirection: Directionality.of(context),
                maxLines: 1,
              )..layout(maxWidth: maxW);

              // Add a small overshoot so the primary segment visually matches glyphs/caret
              const double progressExtra = 6.0; // tweak if needed
              final double progressW = textVal.isEmpty
                  ? 0
                  : (painter.width + progressExtra).clamp(0.0, maxW);

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: _controller,
                    focusNode: _focusNode,
                    enabled: widget.enabled,
                    readOnly: widget.readOnly,
                    autofillHints: widget.autofillHints,
                    keyboardType: widget.keyboardType,
                    textInputAction: widget.textInputAction,
                    onSubmitted: widget.onFieldSubmitted,
                    inputFormatters: widget.inputFormatters,
                    obscureText: widget.isPassword ? _obscure : false,
                    minLines: widget.minLines,
                    maxLines: widget.isPassword ? 1 : widget.maxLines,
                    style: TextStyle(
                      fontSize: 15, 
                      fontWeight: FontWeight.w500,
                    ),
                    decoration: InputDecoration(
                      hintText: widget.placeholder,
                      hintStyle: TextStyle(
                        fontSize: 14,
                        letterSpacing: 0,
                        fontWeight: FontWeight.w500,
                        color: AppColors.grey,
                      ),
                      isDense: true,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 0,
                        vertical: 0,
                      ),
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      errorText: null,
                      errorStyle: const TextStyle(fontSize: 0, height: 0),
                    ),
                    onChanged: (v) => state.didChange(v),
                  ),
                  SizedBox(height: 6),
                  Stack(
                    children: [
                      Container(
                        height: 2,
                        width: maxW,
                        color: Color(0xFFD9D9D9),
                      ),
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 120),
                        curve: Curves.easeOut,
                        height: 2,
                        width: progressW,
                        color: primary,
                      ),
                    ],
                  ),
                  if (state.hasError) ...[
                    Text(
                      state.errorText!,
                      style: const TextStyle(color: Colors.red, fontSize: 12, fontWeight: FontWeight.w400),
                    ),
                  ]
                ],
              );
            },
          ),
        );

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: children,
        );
      },
    );
  }
}
