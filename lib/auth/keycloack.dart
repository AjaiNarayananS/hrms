// ignore_for_file: use_build_context_synchronously
import 'package:hrms/auth/logincomponents.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';

const clientId = "hrm-app";
const keycloackUrl = "http://192.168.0.139:8181";
const realm = "spring-boot-microservices-realm";
const clientSecret = "3RCyrsoevwaut2omiaXW4JyNKteU6QxI";
const userName = "senthil";
const password = "Rits@12345";
String userId = "";
String accessToken = "";

// Login using username and password (Direct Access Grant)
Future<Map<String, dynamic>?> getToken(String email, String password) async {
  final url =
      Uri.parse('$keycloackUrl/realms/$realm/protocol/openid-connect/token');
  try {
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      body: {
        'client_id': clientId,
        'grant_type': 'password',
        'username': email,
        'password': password,
        'client_secret': clientSecret,
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      // print('Failed to login. Status: ${response.statusCode}');
      kwarning("Failed to login");
      return null;
    }
  } catch (error) {
    // print('Error during login: $error');
    kwarning("Error during login");
    return null;
  }
}

// Reset Password - Step 1: Check if the email is present or not
Future<bool?> getUserIDByEmail(BuildContext context, String email) async {
  final url = Uri.parse("$keycloackUrl/admin/realms/$realm/users?email=$email");

  try {
    var adminAccesstoken = await getToken(userName, password);
    if (adminAccesstoken == null ||
        !adminAccesstoken.containsKey('access_token')) {
      // print('Failed to obtain access token');
      kwarning("An error occurred. Please try again later");
      return null;
    }

    accessToken = adminAccesstoken['access_token'];
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json',
        'client_secret': clientSecret,
      },
    );

    // print('Response status: ${response.statusCode}');
    // print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      List<dynamic> users = jsonDecode(response.body);
      if (users.isNotEmpty) {
        var user = users[0] as Map<String, dynamic>;
        // print('User ID: ${user['id']}');
        userId = user['id'];
        return true;
      } else {
        // print('No user found for the email $email');
        kwarning("No user found for the email $email");
        return false;
      }
    } else {
      // Handle error responses
      // print('Failed to fetch user. Status code: ${response.statusCode}');
      // print('Response: ${response.body}');
      kwarning("Failed to fetch user Data.Try again");
      return false;
    }
  } catch (error) {
    // print('Error fetching user ID: $error');
    kwarning("Failed to fetch user Data.Try again");
    return false;
  }
}

Future<bool?> resetPassword(BuildContext context, String password) async {
  // print("userId: $userId");
  // print("accessToken: $accessToken");

  final url = Uri.parse(
      "$keycloackUrl/admin/realms/$realm/users/$userId/reset-password");
  // print("url: $url");

  try {
    final response = await http.put(
      url,
      headers: {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json',
        'client_secret': clientSecret,
      },
      body: jsonEncode({
        "type": "password",
        "temporary": false,
        "value": password,
      }),
    );

    // print('Response status: ${response.statusCode}');
    // print('Response body: ${response.body}');

    // Handle response status
    if (response.statusCode == 204) {
      // 204 No Content means the password reset was successful
      // print('Password reset successfully.');
      ksuccess("Password reset successfully");
      return true;
    } else {
      // Handle error
      // print('Failed to reset password. Status code: ${response.statusCode}');
      kwarning("An error occurred");
      return false;
    }
  } catch (error) {
    // print('Error occurred while resetting password: $error');
    kwarning("An error occurred");
    return false;
  }
}
