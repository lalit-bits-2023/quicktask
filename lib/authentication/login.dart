import 'package:flutter/material.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import '../todotask/task.dart';

class LoginApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login Form',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginScreen(),
    );
  }
}

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: LoginForm(),
      ),
    );
  }
}

class LoginForm extends StatefulWidget {
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          TextFormField(
            controller: _usernameController,
            decoration: InputDecoration(labelText: 'Username'),
            validator: (value) {
              if (value != null && value.isEmpty) {
                return 'Please enter your username';
              }
              return null;
            },
          ),
          TextFormField(
            controller: _passwordController,
            decoration: InputDecoration(labelText: 'Password'),
            obscureText: true,
            validator: (value) {
              if (value != null && value.isEmpty) {
                return 'Please enter your password';
              }
              return null;
            },
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                String username = _usernameController.text;
                String password = _passwordController.text;
                try {
                  print('Username: $username, Password: $password');
                  final QueryBuilder<ParseObject> parseQuery =
                      QueryBuilder<ParseObject>(ParseObject('Registration'));
                  parseQuery.keysToReturn(['username', 'password']);
                  parseQuery.whereContains('username', '$username');
                  parseQuery.whereContains('password', '$password');
                  final ParseResponse apiResponse = await parseQuery.query();
                  if (apiResponse.success && apiResponse.results != null) {
                    showSuccess("User was successfully login!");
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => TodoApp()),
                    );
                    for (var o in apiResponse.results!) {
                      print((o as ParseObject).toString());
                    }
                  } else {
                    showFailure("Login Failed!");
                    print("Failed");
                  }
                } catch (e) {
                  print('Error registering user: $e');
                }
              }
            },
            child: Text('Login'),
          ),
        ],
      ),
    );
  }

  void showSuccess(String s) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Login Successful"),
          content: Text('User login successfully.'),
          actions: <Widget>[
            new TextButton(
              child: const Text("ok"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void showFailure(String s) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Login Error"),
          content: Text('Failed to login. Please check your credentials.'),
          actions: <Widget>[
            new TextButton(
              child: const Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
