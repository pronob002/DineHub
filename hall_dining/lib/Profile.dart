import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfilePage extends StatefulWidget {
  final String uid; // Assuming uid is an email

  ProfilePage({required this.uid});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late Future<DocumentSnapshot> _userFuture;

  @override
  void initState() {
    super.initState();
    _userFuture = _fetchUserData(widget.uid);
  }

  Future<DocumentSnapshot> _fetchUserData(String email) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('Student')
        .where('email', isEqualTo: email)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      // Assuming email is unique, so there should be only one document
      return querySnapshot.docs.first;
    } else {
      throw Exception('User not found');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FutureBuilder<DocumentSnapshot>(
          future: _userFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else if (!snapshot.hasData || !snapshot.data!.exists) {
              return Text('User not found');
            }

            var userData = snapshot.data!.data() as Map<String, dynamic>;

            return SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildHeader(context, userData),
                  _buildProfileDetails(userData),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, Map<String, dynamic> userData) {
    return UserAccountsDrawerHeader(
      accountName: Text(
        userData['name'] ?? 'Name not available',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      accountEmail: Text(
        userData['email'] ?? 'Email not available',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      currentAccountPicture: Center(
        child: CircleAvatar(
          radius: 100,
          backgroundImage: AssetImage(userData['image'] ?? 'assets/default_image.jpg'),
        ),
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue, Colors.green],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
    );
  }


  Widget _buildProfileDetails(Map<String, dynamic> userData) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(height: 20),
        Icon(Icons.account_circle, size: 40),
        SizedBox(height: 10),
        Text(
          'Department: ${userData['department'] ?? 'Department not available'}',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10),
        Icon(Icons.location_on, size: 40),
        SizedBox(height: 10),
        Text(
          'Hall: ${userData['hall'] ?? 'Hall not available'}',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10),
        Icon(Icons.room, size: 40),
        SizedBox(height: 10),
        Text(
          'Room: ${userData['room'] ?? 'Room not available'}',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 20),
        // Add more profile details or actions as needed...
      ],
    );
  }
}
