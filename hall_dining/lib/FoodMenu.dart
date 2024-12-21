import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

import 'VotingResult.dart';

void main() {
  runApp(FoodMenu());
}

class FoodMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.orange[500],
        primarySwatch: Colors.orange,
        hintColor: Colors.green,
        fontFamily: 'Roboto',
      ),
      home: FoodMenuPage(),
    );
  }
}

class FoodMenuPage extends StatefulWidget {
  @override
  _FoodMenuPageState createState() => _FoodMenuPageState();
}

class _FoodMenuPageState extends State<FoodMenuPage> {
  final TextEditingController _foodItem1Controller = TextEditingController();
  final TextEditingController _foodItem2Controller = TextEditingController();
  final TextEditingController _foodItem3Controller = TextEditingController();
  final TextEditingController _foodItem4Controller = TextEditingController();

  late DateTime _selectedDate = DateTime.now();
  bool isFlagged = false;
  int currentFlagStatus = 0;

  @override
  void initState() {
    super.initState();
    _fetchFlagStatus();
  }

  Future<void> _fetchFlagStatus() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    DocumentReference notificationDocRef =
    firestore.collection('Notification').doc('YAxIcpJFHL3j1LbnRhWf');

    DocumentSnapshot snapshot = await notificationDocRef.get();

    if (snapshot.exists) {
      setState(() {
        currentFlagStatus =
            (snapshot.data() as Map<String, dynamic>?)?['flag'] ?? 0;
      });
    }
  }

  void _submitForm() async {
    if (_selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Please select a date'),
      ));
      return;
    }

    String foodItem1 = _foodItem1Controller.text;
    String foodItem2 = _foodItem2Controller.text;
    String foodItem3 = _foodItem3Controller.text;
    String foodItem4 = _foodItem4Controller.text;

    String formattedDate = DateFormat('yyyy-MM-dd').format(_selectedDate);

    FirebaseFirestore firestore = FirebaseFirestore.instance;

    await firestore.collection('FoodMenu').add({
      'date': formattedDate,
      'food_items1': foodItem1,
      'food_items2': foodItem2,
      'food_items3': foodItem3,
      'food_items4': foodItem4,
    });

    _foodItem1Controller.clear();
    _foodItem2Controller.clear();
    _foodItem3Controller.clear();
    _foodItem4Controller.clear();

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Food items submitted successfully'),
    ));
  }

  Future<void> _selectDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );

    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange[500],
        title: const Center(
          child: Text(
            'Voting Result>>',
            style: TextStyle(
              color: Colors.yellowAccent,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.timeline),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => VotingResultPage()),
              );
            },
          ),
          Row(
            children: [
              IconButton(
                icon: Icon(Icons.notifications),
                onPressed: () {
                  _onNotificationButtonPressed();
                },
              ),
              Text('Flag: $currentFlagStatus',style: TextStyle(
                color: Colors.blue,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),),
            ],
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: _selectDate,
                style: ElevatedButton.styleFrom(
                  primary: Theme.of(context).colorScheme.secondary,
                  onPrimary: Colors.white,
                ),
                child: Text(
                  'Select Date',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
              ),
              _selectedDate != null
                  ? Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  'Selected Date: ${DateFormat('yyyy-MM-dd').format(_selectedDate.toLocal())}',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              )
                  : SizedBox(),
              SizedBox(height: 10),
              _buildItemFormField('Food Item 1', _foodItem1Controller),
              SizedBox(height: 10),
              _buildItemFormField('Food Item 2', _foodItem2Controller),
              SizedBox(height: 10),
              _buildItemFormField('Food Item 3', _foodItem3Controller),
              SizedBox(height: 10),
              _buildItemFormField('Food Item 4', _foodItem4Controller),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitForm,
                style: ElevatedButton.styleFrom(
                  primary: Theme.of(context).primaryColor,
                  onPrimary: Colors.white,
                ),
                child: Text(
                  'Submit',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onNotificationButtonPressed() {
    _updateFlagStatus();
  }

  void _updateFlagStatus() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    DocumentReference notificationDocRef =
    firestore.collection('Notification').doc('YAxIcpJFHL3j1LbnRhWf');

    DocumentSnapshot snapshot = await notificationDocRef.get();

    if (snapshot.exists) {
      int currentFlag = (snapshot.data() as Map<String, dynamic>?)?['flag'] ?? 0;

      await notificationDocRef.update({
        'flag': currentFlag == 0 ? 1 : 0,
      });

      setState(() {
        currentFlagStatus = currentFlag == 0 ? 1 : 0;
      });

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Flag status updated successfully'),
      ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error updating flag status'),
        backgroundColor: Colors.red,
      ));
    }
  }

  Widget _buildItemFormField(
      String label, TextEditingController foodController) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        TextField(
          controller: foodController,
          decoration: InputDecoration(
            labelText: 'Food Item',
            filled: true,
            fillColor: Colors.lightGreenAccent,
            labelStyle: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}
