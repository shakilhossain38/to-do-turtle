import 'package:flutter/material.dart';

class CommonTextField extends StatelessWidget {
  final FormFieldValidator<String>? validator;
  final TextEditingController? controller;
  final String? labelText;
  final String? hintText;
  final bool? readOnly;
  final String? errorText;
  final int? maxLines;
  final GestureTapCallback? onTap;

  const CommonTextField({
    this.readOnly = false,
    this.validator,
    this.controller,
    this.labelText,
    this.hintText,
    this.onTap,
    this.errorText,
    this.maxLines,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
            maxLines: maxLines,
            validator: validator,
            readOnly: readOnly!,
            onTap: onTap,
            controller: controller,
            decoration: InputDecoration(
              labelText: labelText,
              fillColor: Colors.white,
              hintText: hintText,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5.0),
              ),
            )),
        errorText == null
            ? SizedBox()
            : Padding(
                padding: const EdgeInsets.only(left: 38, top: 0, right: 38),
                child: Text(
                  errorText!,
                  style: TextStyle(color: Colors.red),
                ),
              )
      ],
    );
  }
}
