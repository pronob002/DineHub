import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(
    MaterialApp(
      home: VerificationPage(),
    ),
  );
}

class VerificationPage extends StatefulWidget {
  @override
  _VerificationPageState createState() => _VerificationPageState();
}

class _VerificationPageState extends State<VerificationPage> {
  TextEditingController userIdController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  List<String> selectedItems = [];
  bool isLoading = false;

  Future<void> _fetchSelectedItems(String userId, String date) async {
    try {
      setState(() {
        isLoading = true;
      });

      CollectionReference voteCollection = FirebaseFirestore.instance.collection('vote');
      QuerySnapshot<Map<String, dynamic>> querySnapshot = await voteCollection
          .where('studentId', isEqualTo: userId)
          .where('date', isEqualTo: date)
          .get() as QuerySnapshot<Map<String, dynamic>>;

      if (querySnapshot.docs.isNotEmpty) {
        var data = querySnapshot.docs.first.data();
        selectedItems = List<String>.from(data['selected_items'] ?? []);
      } else {
        // If no data found, clear the selectedItems list
        selectedItems.clear();
      }
    } catch (e) {
      print('Error fetching selected items: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFE1BEE7), // Light purple
              Color(0xFFD1C4E9), // Light purple
            ],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: TextField(
                    controller: userIdController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Enter User ID',
                      labelStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Center(
                  child: TextField(
                    controller: dateController,
                    decoration: InputDecoration(
                      labelText: 'Date (yyyy-MM-dd)',
                      labelStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    String userId = userIdController.text.trim();
                    String selectedDate = dateController.text.trim();

                    if (userId.isNotEmpty && selectedDate.isNotEmpty) {
                      await _fetchSelectedItems(userId, selectedDate);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.blueAccent,
                    onPrimary: Colors.white,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      'Fetch Selected Items',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                if (isLoading)
                  CircularProgressIndicator()
                else
                  Column(
                    children: [
                      Text(
                        'Selected Food Items:',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.red),
                      ),
                      SizedBox(height: 10),
                      if (selectedItems.isNotEmpty)
                        Column(
                          children: selectedItems.map((item) {
                            return Text(
                              item,
                              style: TextStyle(fontSize: 25, color: Colors.yellowAccent,fontWeight: FontWeight.bold),
                            );
                          }).toList(),
                        )
                      else
                        Text(
                          'No selected items for the given user and date.',
                          style: TextStyle(fontSize: 16, color: Colors.black),
                        ),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
