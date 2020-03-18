import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vocab_builder/helpers/generateRoute.dart';
import 'package:vocab_builder/screens/homepage.dart';
import 'package:vocab_builder/screens/login_in_screen.dart';
import './helpers/generateRoute.dart';

void main() async {
  String token;
  try {
    if(!kIsWeb) {
      final store = await SharedPreferences.getInstance();
      token = store.getString('vocab-builder');
    }
    else if(kIsWeb){
      token = "logged_in"; 
    }
  }
  catch(e) {
    print(e.toString());
  }
  runApp(MyApp(token: token));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  String initial_route;
  String token;
  @override

  MyApp({this.token}){
    if(this.token==null) initial_route = '/log_in_screen';
    else initial_route = '/homepage';
    print(initial_route);
  }

  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Vocab Builder',

      theme: ThemeData(appBarTheme: AppBarTheme(color: Colors.white)),
      
      initialRoute: initial_route,

      onGenerateRoute: generateRoute,

      routes: {
        '/homepage': (context) => Homepage(token),
        '/log_in_screen': (context) => Loginscreen(),
      },

    );
  }
}