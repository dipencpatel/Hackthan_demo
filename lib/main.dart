import 'package:demo/provider/auth_provider.dart';
import 'package:demo/screens/command_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
        ChangeNotifierProvider.value(
          value: AuthProvider(),
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
        home: StreamBuilder(
          stream: FirebaseAuth.instance.onAuthStateChanged,
          builder: (sbContext, snapshot) {
            print('HAS DATA ${snapshot.hasData}');
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: Scaffold(
                  body: Text('Loading...'),
                ),
              );
            } else {
              return CommandScreen(
                isLoggedIn: snapshot.hasData,
              );
            }
          },
        ),
        debugShowCheckedModeBanner: false,
        routes: {
          CommandScreen.routeName: (cntx) => CommandScreen(),
        },
      ),
    );
  }
}
