import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../api_manager/http_exception.dart';
import '../provider/auth_provider.dart';

class CommandScreen extends StatefulWidget {
  @override
  _CommandScreenState createState() => _CommandScreenState();
}

class _CommandScreenState extends State<CommandScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _signIn() async {
    try {
      final auth = Provider.of<AuthProvider>(context, listen: false);
      await auth.signUp(
        emailID: _emailController.text,
        password: _passwordController.text,
      );
    } on HTTPException catch (err) {
      print(err.toString());
    } catch (err) {
      print(err.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Retro Chat'),
      ),
      body: Column(
        children: <Widget>[
          TextField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
          ),
          TextField(
            controller: _passwordController,
            obscureText: true,
          ),
          FlatButton(
            onPressed: _signIn,
            child: Text('Login'),
          ),
        ],
      ),
    );
  }
}
