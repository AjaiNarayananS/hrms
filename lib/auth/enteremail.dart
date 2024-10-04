import 'package:flutter/material.dart';
import 'package:hrms/auth/keycloack.dart';
import 'package:hrms/auth/logincomponents.dart';
import 'package:hrms/auth/setpassword.dart';

class ForgetPassword extends StatefulWidget {
  const ForgetPassword({super.key});

  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  final _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
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
                    Icons.mail,
                    color: Colors.black,
                    size: 30,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  "Forgot password?",
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
                  "No worries, just follow the instructions",
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
                          label: "Email",
                        ),
                        const SizedBox(
                          height: 10.0,
                        ),
                        InputField(
                          controller: _emailController,
                          labelText: 'Enter your Email',
                          keyboardType: TextInputType.emailAddress,
                          obscureText: false,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your email';
                            } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+')
                                .hasMatch(value)) {
                              return 'Please enter a valid email';
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
                              final email = _emailController.text;
                              // print('Email: $email');
                              bool? userFound =
                                  await getUserIDByEmail(context, email);
                              if (userFound == true) {
                                Navigator.push(
                                  // ignore: use_build_context_synchronously
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const Setpassword()),
                                );
                              } else {
                                kwarning(
                                    "No user found with the provided email");
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
                            label: const Text('Back to Log in'),
                            style: TextButton.styleFrom(
                              foregroundColor: const Color(
                                  0xff131416), // Text and icon color
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
