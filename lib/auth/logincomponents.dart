import 'package:flutter/material.dart';
import 'package:flutter_dropdown_alert/alert_controller.dart';
import 'package:flutter_dropdown_alert/model/data_alert.dart';

class Label extends StatelessWidget {
  const Label({super.key, this.label});
  final String? label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label!.toUpperCase(),
      style: const TextStyle(
        color: Color(0xff131416),
        fontSize: 14,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}

class InputField extends StatelessWidget {
  const InputField({
    super.key,
    this.labelText,
    this.keyboardType,
    this.obscureText = false,
    this.controller,
    this.validator,
  });

  final String? labelText;
  final TextInputType? keyboardType;
  final bool obscureText;
  final TextEditingController? controller;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 70, // Increase height to account for potential error message
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        obscureText: obscureText,
        style: const TextStyle(
          color: Colors.black54, // Text color of entered value
        ),
        decoration: InputDecoration(
          labelText: labelText, // Label text
          labelStyle: const TextStyle(color: Colors.grey), // Label color
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey), // Default border color
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide:
                BorderSide(color: Colors.black54), // Border color when focused
          ),
          errorBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red), // Border color on error
          ),
          focusedErrorBorder: const OutlineInputBorder(
            borderSide:
                BorderSide(color: Colors.redAccent), // Focused border on error
          ),
          errorMaxLines: 2, // Adjust for multiline errors
          floatingLabelBehavior: FloatingLabelBehavior
              .auto, // Ensure label floats when value is entered
          suffixIcon: const Icon(Icons.email),
        ),
        validator: validator,
      ),
    );
  }
}

class PasswordField extends StatefulWidget {
  const PasswordField({
    super.key,
    this.labelText,
    this.controller,
    this.validator,
  });

  final String? labelText;
  final TextEditingController? controller;
  final String? Function(String?)? validator;

  @override
  // ignore: library_private_types_in_public_api
  _PasswordFieldState createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  late bool _isObscured;

  @override
  void initState() {
    super.initState();
    _isObscured = true; 
  }

  void _toggleVisibility() {
    setState(() {
      _isObscured = !_isObscured; 
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 70, 
      child: TextFormField(
        controller: widget.controller,
        keyboardType: TextInputType.visiblePassword,
        obscureText: _isObscured,
        style: const TextStyle(
          color: Colors.black54, 
        ),
        decoration: InputDecoration(
          labelText: widget.labelText,
          labelStyle: const TextStyle(color: Colors.grey), 
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey), 
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide:
                BorderSide(color: Colors.black54), 
          ),
          errorBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red), 
          ),
          focusedErrorBorder: const OutlineInputBorder(
            borderSide: BorderSide(
                color: Colors.redAccent), 
          ),
          floatingLabelBehavior: FloatingLabelBehavior
              .auto, 
          suffixIcon: IconButton(
            icon: Icon(
              _isObscured
                  ? Icons.visibility_off
                  : Icons.visibility, 
              color: Colors.black54, 
            ),
            onPressed:
                _toggleVisibility, 
          ),
          errorMaxLines: 2, 
        ),
        validator: widget.validator,
      ),
    );
  }
}

// Error Notification
void ksuccess(String message) {
  Map<String, dynamic>? payload = <String, dynamic>{};
  payload["data"] = "content";
  AlertController.show(
    "Success",
    message,
    TypeAlert.success,
    payload,
  );
}

void kwarning(String message) {
  AlertController.show("Warn!", message, TypeAlert.warning);
}

void kerror(String message) {
  AlertController.show("Error", message, TypeAlert.error);
}
