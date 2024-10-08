import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hrms/auth/keycloack.dart';
import 'package:hrms/auth/enteremail.dart';
import 'package:hrms/auth/logincomponents.dart';
import 'package:go_router/go_router.dart';

class Login extends StatefulWidget {
  const Login({super.key});
  static const String id = "hrms_login";

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  // Define secure storage
  final FlutterSecureStorage storage = const FlutterSecureStorage();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      final email = _emailController.text;
      final password = _passwordController.text;
      try {
        final response = await getToken(email, password);
        if (response != null && response['access_token'] != null) {
          await storage.write(key: 'access_token', value: response['access_token']);
          if (context.mounted) {
            // ignore: use_build_context_synchronously
            context.go('/home/dashboard');
          }
        } else {
          throw Exception('Failed to login');
        }
      } catch (e) {
        kerror("An error occurred. Please try again later");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Image.asset(
                "assets/ritsConsulting-Logo.png",
                width: 140,
              ),
              const Text(
                "LOGIN",
                style: TextStyle(
                  color: Color(0xff131416),
                  fontSize: 30,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Text(
                "Enter your credentials to continue",
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
                        height: 20.0,
                      ),
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
                          }
                          return null;
                        },
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const ForgetPassword(),
                            ),
                          );
                        },
                        child: const Text(
                          "Forgot Password?",
                          style: TextStyle(
                            color: Color(0xff87A2FF),
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextButton(
                        onPressed: _handleLogin,
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
                              "Continue",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
