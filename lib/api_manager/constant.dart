library constant;

import 'dart:ffi';

// API KEY
const String API_KEY = 'AIzaSyBsOPJVj7m5Glp1IpuqpD47Tb28b3NW9Es';

// BASE URL
const String baseURL = 'https://retrochat2020-d602a.firebaseio.com/';

// AUTH URL
const String authURLSignup =
    'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=$API_KEY';
const String authURLSignIn =
    'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=$API_KEY';

// Firebase Node
final firebaseNodeUser = 'users';
final firebaseNodeRecentChat = 'recentChat';
final firebaseNodeMessage = 'message';
