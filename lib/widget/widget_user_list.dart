import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/user_provider.dart';

class UserListWidget extends StatefulWidget {
  @override
  _UserListWidgetState createState() => _UserListWidgetState();
}

class _UserListWidgetState extends State<UserListWidget> {
  var _isInit = true;
  var _isLoading = false;
  List<User> userList = [];
  String userNameList = '';

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    if (_isInit) {
      setState(() {
        _isInit = false;
        _isLoading = true;
      });
      final userProvider = Provider.of<UserList>(context, listen: false);
      await userProvider.fetchUserList();
      userList = userProvider.userList;

      userList.forEach((item) {
        userNameList += item.userName + " ";
      });
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal:10,vertical: 5),
      color: Colors.black,
      child: _isLoading
          ? Text('loading')
          : RichText(
              text: TextSpan(
                style: TextStyle(
                  color: Colors.white,
                  wordSpacing: 15,
                  height: 1.7
                ),
                text: userNameList,
              ),
            ),
    );
  }
}
