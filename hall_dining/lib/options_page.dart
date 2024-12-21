import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'FormHall.dart';
import 'FormManager.dart';
import 'HomePage.dart';
import 'StockForm.dart';

class StudentOptionsPage extends StatefulWidget {
  @override
  _StudentOptionsPageState createState() => _StudentOptionsPageState();
}

class _StudentOptionsPageState extends State<StudentOptionsPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isLoading = false;
  String errorMessage = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          color: Colors.white, // Yellow backgroundgr
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(height: 50),
                    Icon(
                      Icons.restaurant_menu,
                      size: 100,
                      color: Colors.black,
                    ),
                    SizedBox(height: 30),
                    TextField(
                      key: ValueKey('email'),
                      controller: emailController,
                      style: TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                        labelText: 'Student Email',
                        prefixIcon: Icon(Icons.person, color: Colors.black),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black, width: 2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black, width: 2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    TextField(
                      key: ValueKey('password'),
                      controller: passwordController,
                      obscureText: true,
                      style: TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                        labelText: 'Password',
                        prefixIcon: Icon(Icons.lock, color: Colors.black),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black, width: 2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black, width: 2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    SizedBox(height: 30),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.black,
                        onPrimary: Colors.white,
                        elevation: 10,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 100, vertical: 20),
                      ),
                      onPressed: isLoading
                          ? null
                          : () async {
                        setState(() {
                          isLoading = true;
                        });
                        String email = emailController.text;
                        String password = passwordController.text;
                        await AuthServices.loginStudent(email, password, context, this);
                        setState(() {
                          isLoading = false;
                        });
                      },
                      child: Text('Login', style: TextStyle(fontSize: 18)),
                    ),
                    SizedBox(height: 40),
                    if (isLoading) CircularProgressIndicator(), // Display loading indicator if isLoading is true
                    SizedBox(height: 20),
                    Text(
                      errorMessage,
                      style: TextStyle(color: Colors.red),
                    ),
                    // Additional space at the bottom to avoid the white space issue
                    SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class AuthServices {
  static loginStudent(
      String email, String password, BuildContext context, _StudentOptionsPageState pageState) async {
    try {
      await Future.delayed(Duration(seconds: 3));
      await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
      String uid = email;
      print(" uid is this  $uid");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('You are logged in')));
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HomePage(uid: uid)),
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        pageState.setState(() {
          pageState.errorMessage = 'No user found with this email';
        });
      } else if (e.code == 'wrong-password') {
        pageState.setState(() {
          pageState.errorMessage = 'Password did not match';
        });
      }
    }
  }
}
class ManagementOptionsPage extends StatefulWidget {
  @override
  _ManagementOptionsPageState createState() => _ManagementOptionsPageState();
}

class _ManagementOptionsPageState extends State<ManagementOptionsPage> {
  final TextEditingController managementIdController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isLoading = false;
  String errorMessage = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          color: Colors.white, // Light green background
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(height: 50),
                    Icon(
                      Icons.restaurant,
                      size: 100,
                      color: Colors.green[700], // Deep green color
                    ),
                    SizedBox(height: 30),
                    TextField(
                      key: ValueKey('email'),
                      controller: managementIdController,
                      style: TextStyle(color: Colors.green[700]),
                      decoration: InputDecoration(
                        labelText: 'Management Email',
                        prefixIcon: Icon(Icons.person, color: Colors.green[700]),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.green[700]!, width: 2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.green[700]!, width: 2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    TextField(
                      key: ValueKey('password'),
                      controller: passwordController,
                      obscureText: true,
                      style: TextStyle(color: Colors.green[700]),
                      decoration: InputDecoration(
                        labelText: 'Password',
                        prefixIcon: Icon(Icons.lock, color: Colors.green[700]),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.green[700]!, width: 2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.green[700]!, width: 2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.green[700],
                        onPrimary: Colors.white,
                        elevation: 10,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 100, vertical: 20),
                      ),
                      onPressed: isLoading
                          ? null
                          : () async {
                        setState(() {
                          isLoading = true;
                        });
                        String email = managementIdController.text;
                        String password = passwordController.text;
                        await AuthServices2.loginManagement(email, password, context, this);
                        setState(() {
                          isLoading = false;
                        });
                      },
                      child: Text('Login', style: TextStyle(fontSize: 18)),
                    ),
                    SizedBox(height: 40),
                    if (isLoading) CircularProgressIndicator(), // Display loading indicator if isLoading is true
                    SizedBox(height: 20),
                    Text(
                      errorMessage,
                      style: TextStyle(color: Colors.red),
                    ),
                    // Additional space at the bottom to avoid the white space issue
                    SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class AuthServices2 {
  static loginManagement(
      String email, String password, BuildContext context, _ManagementOptionsPageState pageState) async {
    try {
      await Future.delayed(Duration(seconds: 3));
      if (email == "manager@gmail.com") {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ItemPriceForm()),
        );
        await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('You are logged in as manager')));
      }
      if (email == "stock@gmail.com") {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => StockForm()),
        );
        await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('You are logged in as dining worker')));
      }
      if (email == "hall@gmail.com") {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => FormHall()),
        );
        await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('You are logged in as hall authority')));
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found' || e.code == 'wrong-password') {
        pageState.setState(() {
          pageState.errorMessage = 'Invalid Management ID or Password';
        });
      } else {
        pageState.setState(() {
          pageState.errorMessage = 'An error occurred. Please try again later.';
        });
      }
    }
  }
}
