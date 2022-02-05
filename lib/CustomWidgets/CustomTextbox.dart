
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:recipy/Utilities/CustomTheme.dart';


class CustomTextbox extends StatefulWidget {
  const CustomTextbox({
    required this.labelText,
    required this.validator,
    required this.onSaved,
    this.controller,
    this.obscured = false,
    required this.formKey,
    this.width = 9999,
    this.errorSize = 11,
    this.inputFormatters = const [],
    this.maxLength = 9999,
    this.padding = const EdgeInsets.symmetric(horizontal: 32.0),
    Key? key}) : super(key: key);

  final String? labelText;
  final FormFieldValidator<String>? validator;
  final FormFieldSetter<String>? onSaved;
  final GlobalKey<FormState> formKey;
  final controller;
  final bool obscured;
  final double width;
  final double errorSize;
  final List<FilteringTextInputFormatter> inputFormatters;
  final int maxLength;
  final EdgeInsets padding;

  @override
  _CustomTextboxState createState() => _CustomTextboxState();
}

class _CustomTextboxState extends State<CustomTextbox> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: widget.padding,
      child: SizedBox(
        height: 80,
        width: widget.width == 9999 ? double.maxFinite : widget.width,
        child: TextFormField(
          onChanged: (value){
            widget.formKey.currentState?.validate();
          },
          style: TextStyle(
            color: CustomTheme.textDark
          ),
          maxLength: widget.maxLength == 9999 ? null : widget.maxLength,
          inputFormatters: widget.inputFormatters,
          obscureText: widget.obscured,
          controller: widget.controller ?? TextEditingController(),
          decoration: InputDecoration(
            errorStyle: TextStyle(
              fontSize: widget.errorSize,
            ),
            errorMaxLines: 2,
            isDense: true,
            labelText: widget.labelText,
            labelStyle: TextStyle(
              color: CustomTheme.art4
            )
          ),
          validator: widget.validator,
          onSaved: widget.onSaved,
        ),
      ),
    );
  }
}


