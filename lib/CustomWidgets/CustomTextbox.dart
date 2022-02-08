
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
    this.fontSize = 16,
    this.mode = false,
    this.padding = const EdgeInsets.symmetric(horizontal: 32.0),
    Key? key}) : super(key: key);

  final String? labelText;
  final FormFieldValidator<String>? validator;
  final FormFieldSetter<String>? onSaved;
  final GlobalKey<FormState> formKey;
  final controller;
  final bool obscured;
  final bool mode;
  final double width;
  final double errorSize;
  final double fontSize;
  final List<FilteringTextInputFormatter> inputFormatters;
  final int maxLength;
  final EdgeInsets padding;

  @override
  _CustomTextboxState createState() => _CustomTextboxState();
}

class _CustomTextboxState extends State<CustomTextbox> {
  final TextEditingController _textEditingController = TextEditingController();
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
            color: CustomTheme.textDark,
            fontSize: widget.fontSize
          ),
          maxLength: widget.maxLength == 9999 ? null : widget.maxLength,
          inputFormatters: widget.inputFormatters,
          obscureText: widget.obscured,
          controller: widget.controller ?? _textEditingController,
          decoration: widget.mode ? InputDecoration(
            border: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.grey, width: 1)
            ),
            focusedBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.grey, width: 1)
            ),
            enabledBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.grey, width: 1)
            ),
            errorBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.red, width: 1)
            ),
            focusedErrorBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.red, width: 1)
            ),
            errorStyle: TextStyle(
              fontSize: widget.errorSize,
            ),
            errorMaxLines: 2,
            isDense: true,
            labelText: widget.labelText,
            labelStyle: TextStyle(
              color: CustomTheme.art4
            )
          ) : InputDecoration(
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


