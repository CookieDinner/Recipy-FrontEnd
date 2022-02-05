
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:recipy/Utilities/CustomTheme.dart';


class CustomTextbox extends StatefulWidget {
  const CustomTextbox({required this.labelText, required this.validator, required this.onSaved, this.controller, this.obscured = false, required this.formKey, Key? key}) : super(key: key);

  final String? labelText;
  final FormFieldValidator<String>? validator;
  final FormFieldSetter<String>? onSaved;
  final GlobalKey<FormState> formKey;
  final controller;
  final bool obscured;

  @override
  _CustomTextboxState createState() => _CustomTextboxState();
}

class _CustomTextboxState extends State<CustomTextbox> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32.0),
      child: SizedBox(
        height: 80,
        child: TextFormField(
          onChanged: (value){
            widget.formKey.currentState?.validate();
          },
          obscureText: widget.obscured,
          controller: widget.controller ?? TextEditingController(),
          decoration: InputDecoration(
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
