import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'login_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyAtdakbOjHdsXTrMoMnIx9zM9Ld-5S4QGY",
      appId: "1:1043817070610:android:b56eba782fc140cffc98cb",
      messagingSenderId: "1043817070610",
      projectId: "halldiningmanagement-81e12",
    ),
  );
  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  int _countdown = 4;

  @override
  void initState() {
    super.initState();
    Timer.periodic(
      Duration(seconds: 1),
          (Timer timer) {
        if (_countdown == 0) {
          timer.cancel();
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => LoginPage(),
            ),
          );
        } else {
          setState(() {
            _countdown--;
          });
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Your logo widget here
            ClipOval(
              child: Image.asset('assets/logo.png', width: 100, height: 100),
            ),

            SizedBox(height: 20),

            Text(
              'DineHub',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),

            SizedBox(height: 20),

            Text(
              'Loading in $_countdown seconds...',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
