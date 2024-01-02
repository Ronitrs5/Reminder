import 'package:flutter/material.dart';
import 'package:reminder/homepage.dart';
import 'package:reminder/loginpage.dart';
import 'package:shared_preferences/shared_preferences.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: FutureBuilder(
        // Use FutureBuilder to check if the user is already logged in
        future: _checkIfUserLoggedIn(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            // If the user is logged in, navigate to HomePage
            if (snapshot.data == true) {
              return const HomePage();
            } else {
              // If the user is not logged in, show LoginPage
              return const LoginPage();
            }
          } else {
            // Show a loading indicator while checking if the user is logged in
            return const CircularProgressIndicator();
          }
        },
      ),
    );
  }

  Future<bool> _checkIfUserLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? storedUserName = prefs.getString('user_name');
    return storedUserName != null && storedUserName.isNotEmpty;
  }
}
