import 'package:flutter/material.dart';
import 'package:hrms/auth/keycloack.dart';
// import 'package:hrms/auth/login.dart';
import 'package:hrms/auth/logincomponents.dart';

class Setpassword extends StatefulWidget {
  const Setpassword({super.key});

  @override
  State<Setpassword> createState() => _SetpasswordState();
}

class _SetpasswordState extends State<Setpassword> {
  final _passwordController = TextEditingController();
  final _retypePasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _passwordController.dispose();
    _retypePasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  width: 50.0,
                  height: 50.0,
                  decoration: BoxDecoration(
                    border:
                        Border.all(color: const Color(0xffB3B3B3), width: 1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.password,
                    color: Colors.black,
                    size: 30,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  "Set new password",
                  style: TextStyle(
                    color: Color(0xff131416),
                    fontSize: 30,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                const Text(
                  "Must be at least 6 character",
                  style: TextStyle(
                    color: Color(0xff131416),
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Label(
                          label: "Password",
                        ),
                        const SizedBox(
                          height: 10.0,
                        ),
                        PasswordField(
                          labelText: 'Enter your Password',
                          controller: _passwordController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your password';
                            } else if (value.length < 6) {
                              return 'Password must be at least 6 characters';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        const Label(
                          label: "Confirm Password",
                        ),
                        const SizedBox(
                          height: 10.0,
                        ),
                        PasswordField(
                          labelText: 'Retype your Password',
                          controller: _retypePasswordController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please retype your password';
                            } else if (value != _passwordController.text) {
                              return 'Passwords do not match';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        TextButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              final newPassword = _passwordController.text;
                              bool? userFound =
                                  await resetPassword(context, newPassword);
                              if (userFound == true) {
                               if (context.mounted) Navigator.of(context).popUntil((route) => route.isFirst);
                              } else {
                                kwarning("Failed to set password");
                              }
                            }
                          },
                          child: Container(
                            height: 40,
                            decoration: BoxDecoration(
                              color: const Color(0xff195BF1),
                              border: Border.all(
                                color: const Color(0xff7593EE),
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Center(
                              child: Text(
                                "Reset password",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Center(
                          child: TextButton.icon(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: const Icon(Icons.arrow_back),
                            label: const Text('Back to Email'),
                            style: TextButton.styleFrom(
                              foregroundColor: const Color(
                                  0xff131416),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
