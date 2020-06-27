import 'package:demo/provider/auth_provider.dart';
import 'package:demo/screens/command_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './provider/user_provider.dart';


///added this to check all dependancies are downloaded or not

void main() {
  runApp(
    MyApp(),
  );
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (cntx) => AuthProvider(),
        ),
        ChangeNotifierProvider(
          create: (cntx) => UserList(),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.deepOrange,
          accentColor: Colors.deepOrangeAccent,
          fontFamily: 'Lato',
          textTheme: TextTheme(
            headline6: TextStyle(
              fontFamily: 'Anton',
            ),
          ),
        ),
        initialRoute: '/',
        debugShowCheckedModeBanner: false,
        routes: {
          '/': (cntx) => CommandScreen(),
        },
      ),
    );
  }
}
