import 'package:flutter/material.dart';
import '/auth/authform.dart';

class AuthScreen extends StatefulWidget {
  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Authentication'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: AuthForm(),
    );
  }
}
