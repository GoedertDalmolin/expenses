import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AdaptativeTextField extends StatelessWidget {
  final String labelText;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final Function(String)? onSubmitted;

  const AdaptativeTextField({
    required this.labelText,
    this.controller,
    this.keyboardType,
    this.onSubmitted,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Platform.isIOS
        ? Padding(
            padding: const EdgeInsets.only(bottom: 10.0),
            child: CupertinoTextField(
              placeholder: labelText,
              controller: controller,
              keyboardType: keyboardType,
              onSubmitted: onSubmitted,
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 12),
            ),
          )
        : TextField(
            decoration: InputDecoration(labelText: labelText),
            controller: controller,
            keyboardType: keyboardType,
            onSubmitted: onSubmitted,
          );
  }
}
