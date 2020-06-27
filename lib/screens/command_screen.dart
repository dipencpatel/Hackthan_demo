import 'package:demo/model/command.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../api_manager/http_exception.dart';
import '../provider/auth_provider.dart';

class CommandScreen extends StatefulWidget {
  static const routeName = '/command_screen';
  final bool isLoggedIn;

  CommandScreen({this.isLoggedIn});

  @override
  _CommandScreenState createState() => _CommandScreenState();
}

class _CommandScreenState extends State<CommandScreen> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  List<ModelCommand> arrCommand = [];

  @override
  void initState() {
    super.initState();
    _setInitialArray();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // SIGN IN
  Future<void> _signIn() async {
    try {
      final auth = Provider.of<AuthProvider>(context, listen: false);
      await auth.signUp(
        username: _usernameController.text,
        password: _passwordController.text,
      );
      _handleAuthSuccess();
    } on HTTPException catch (err) {
      _handleAuthenticationError(error: err.toString());
    } catch (err) {
      _handleAuthenticationError(error: err.toString());
    }
  }

  _handleAuthenticationError({String error}) {
    arrCommand = [];
    _addInfoTextInList(message: error);
    _setInitialArray();
  }

  _handleAuthSuccess() {
    final index = arrCommand.indexWhere(
        (element) => element.inputType == eInputType.authenticating);
    if (index >= 0) {
      setState(() {
        final arrFiltered = arrCommand
            .where((element) =>
                element.commandType == eCommandType.authenticationRequired)
            .toList();
        arrFiltered.forEach((element) {
          element.allowEditing = false;
        });
        arrCommand[index].infoText = 'Login successfully. Welcome to Reto Chat';
      });
    }
  }

  // SETUP INITIAL ARRAY
  _setInitialArray() {
    _addInfoTextInList(
        message: 'Please enter your credential to start Retro Chat!');
    _usernameController.text = '';
    _passwordController.text = '';
    _addAuthTextField(inputType: eInputType.normalTextField);
  }

  // ADD TEXTFIELD FOR AUTHENTICATION
  void _addAuthTextField({eInputType inputType}) {
    final obj = ModelCommand();
    obj.commandType = eCommandType.authenticationRequired;
    obj.allowEditing = true;
    obj.inputType = inputType;
    if (inputType == eInputType.normalTextField) {
      obj.prefixText = '${obj.prefixText} username >';
    } else {
      obj.prefixText = '${obj.prefixText} password >';
    }
    setState(() {
      arrCommand.add(obj);
    });
  }

  // CHECK HAS PASSWORD TEXTFIELD OR NOT
  bool hasPasswordTextField() {
    final hasField = arrCommand
        .where((element) => element.inputType == eInputType.passwordTextField)
        .toList();
    return hasField.length > 0;
  }

  // ADD INFO TEXT
  _addInfoTextInList({
    String message,
    eInputType inputType = eInputType.infoText,
  }) {
    final obj = ModelCommand();
    obj.inputType = inputType;
    obj.prefixText = '${obj.prefixText} >';
    obj.infoText = message;
    setState(() {
      arrCommand.add(obj);
    });
  }

  // HANDLE COMMAND
  _handleInputCommand({String command}) {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   actions: <Widget>[
      //     IconButton(
      //         icon: Icon(Icons.exit_to_app),
      //         onPressed: () {
      //           Provider.of<AuthProvider>(context, listen: false).signOut();
      //         })
      //   ],
      // ),
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 8.0,
          ),
          child: Column(
            children: <Widget>[
              Expanded(
                child: ListView.builder(
                  itemCount: arrCommand.length,
                  itemBuilder: (lvContext, index) {
                    final command = arrCommand[index];
                    // AUTHENTICATION
                    if (command.commandType ==
                        eCommandType.authenticationRequired) {
                      // ASSIGN TEXT EDITING CONTROLLER
                      TextEditingController controller =
                          command.inputType == eInputType.normalTextField
                              ? _usernameController
                              : _passwordController;

                      return getWidgetTextField(
                        command: command,
                        obscureText:
                            command.inputType == eInputType.passwordTextField,
                        controller: controller,
                        onSubmitted: (text) {
                          final trimmedText = text.trim();
                          if (trimmedText.length > 0) {
                            command.inputText = trimmedText;
                            if (!hasPasswordTextField()) {
                              _addAuthTextField(
                                  inputType: eInputType.passwordTextField);
                            } else {
                              _addInfoTextInList(
                                  message: 'Authenticating...',
                                  inputType: eInputType.authenticating);
                              _signIn();
                            }
                          }
                        },
                      );
                    } // AUTHENTICATION
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Text(
                        '${command.prefixText} ${command.infoText}',
                        style: commandTextStyle(),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// AUTHENTICATION WIDGET
Widget getWidgetTextField(
    {ModelCommand command,
    bool obscureText = false,
    TextEditingController controller,
    Function(String) onSubmitted}) {
  return Row(
    children: <Widget>[
      Text(
        '${command.prefixText}',
        style: commandTextStyle(),
      ),
      SizedBox(
        width: 8.0,
      ),
      Expanded(
        child: TextField(
          controller: controller,
          showCursor: true,
          cursorWidth: 8,
          cursorColor: Colors.white,
          onSubmitted: onSubmitted,
          obscureText: obscureText,
          enabled: command.allowEditing,
          autocorrect: false,
          textCapitalization: TextCapitalization.none,
          style: commandTextStyle(),
          decoration: InputDecoration(
            border: InputBorder.none,
          ),
        ),
      )
    ],
  );
}

TextStyle commandTextStyle() {
  return TextStyle(
    color: Colors.white,
    fontSize: 12.0,
  );
}
