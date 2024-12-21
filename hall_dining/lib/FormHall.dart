import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:intl/intl.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MaterialApp(
      home: FormHall(),
    ),
  );
}

class FormHall extends StatefulWidget {
  @override
  _FormHallState createState() => _FormHallState();
}

class _FormHallState extends State<FormHall> {
  final _formKey = GlobalKey<FormState>();
  DateTime? selectedDate;
  final _costController = TextEditingController();
  final _balanceController = TextEditingController();
  final _studentsController = TextEditingController();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: Colors.teal,
            hintColor: Colors.teal,
            colorScheme: ColorScheme.light(primary: Colors.teal),
            buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = DateTime(picked.year, picked.month);
      });
    }
  }

  Map<String, dynamic> toJson() {
    return {
      "Month": selectedDate != null ? DateFormat('MMMM yyyy').format(selectedDate!) : null,
      "Total Cost": _costController.text,
      "Total Saved Balance": _balanceController.text,
      "Total Students": _studentsController.text,
    };
  }

  Future<void> _submitForm() async {
    CollectionReference reportsCollection =
    FirebaseFirestore.instance.collection('HallReport');
    if (selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please select a date'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (_formKey.currentState!.validate()) {
      try {
        await reportsCollection.add(toJson());

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Inputs added to the store successfully'),
            backgroundColor: Colors.green,
          ),
        );
      } catch (error) {
        print('Error adding inputs to the store: $error');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to add inputs to the store $error'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _navigateToRatingPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => RatingPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFB2EBF2), Color(0xFF80DEEA)],
          ),
        ),
        padding: EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              ElevatedButton(
                onPressed: () => _selectDate(context),
                style: ElevatedButton.styleFrom(
                  primary: Colors.indigo,
                  onPrimary: Colors.white,
                  elevation: 10,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.calendar_today, color: Colors.white),
                      SizedBox(width: 10),
                      Text(
                        selectedDate == null
                            ? 'Select Month'
                            : DateFormat('MMMM yyyy').format(selectedDate!),
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 30),
              buildTextFormField(_costController, 'Total Cost', Icons.monetization_on),
              SizedBox(height: 10),
              buildTextFormField(_balanceController, 'Total Saved Balance', Icons.account_balance_wallet),
              SizedBox(height: 10),
              buildTextFormField(_studentsController, 'Total Students', Icons.people),
              SizedBox(height: 30),
              buildSubmitButton(),
              SizedBox(height: 20),
              Center(child: Text('See Rating',style: TextStyle(fontSize: 14,color: Colors.red,
              fontWeight: FontWeight.bold),)),
              IconButton(
                icon: Icon(Icons.star, color: Colors.yellow, size: 40),
                onPressed: _navigateToRatingPage,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTextFormField(TextEditingController controller, String label, IconData icon) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.black),
        prefixIcon: Icon(icon, color: Colors.black),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        filled: true,
        fillColor: Colors.white.withOpacity(0.3),
      ),
      style: TextStyle(color: Colors.black),
      validator: (value) => validateInput(value, 'Please enter the $label'),
      onSaved: (value) {
        // Handle the saved value if needed
      },
    );
  }

  Widget buildSubmitButton() {
    return ElevatedButton(
      onPressed: _submitForm,
      child: Text('Submit'),
      style: ElevatedButton.styleFrom(
        primary: Colors.teal,
        onPrimary: Colors.white,
        elevation: 10,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }

  String? validateInput(String? value, String error) {
    if (value == null || value.isEmpty) {
      return error;
    }
    return null;
  }
}




class RatingPage extends StatefulWidget {
  @override
  _RatingPageState createState() => _RatingPageState();
}

class _RatingPageState extends State<RatingPage> {
  DateTime _selectedDate = DateTime.now();
  double _averageRating = 0;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        // Only store the month and year
        _selectedDate = DateTime(picked.year, picked.month);
      });

      // Update the average rating based on the selected date
      _updateAverageRating();
    }
  }

  Future<void> _updateAverageRating() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    CollectionReference feedbackCollection = firestore.collection('Feedback');


    String formattedDate = DateFormat('MMMM yyyy').format(_selectedDate);


    QuerySnapshot feedbackSnapshot = await feedbackCollection.where('date', isEqualTo: formattedDate).get();

    if (feedbackSnapshot.docs.isNotEmpty) {
      double totalRating = 0;
      for (var doc in feedbackSnapshot.docs) {
        totalRating += doc['rating'];
      }
      double averageRating = totalRating / feedbackSnapshot.docs.length;

      setState(() {
        _averageRating = averageRating;
      });
    } else {
      // No feedback found for the selected month and year
      setState(() {
        _averageRating = 0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
              onPressed: () => _selectDate(context),
              style: ElevatedButton.styleFrom(
                primary: Colors.indigo,
                onPrimary: Colors.white,
                elevation: 10,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.calendar_today, color: Colors.white),
                    SizedBox(width: 10),
                    Text(
                      _selectedDate == null
                          ? 'Select Month'
                          : DateFormat('MMMM yyyy').format(_selectedDate),
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            Center(
              child: Text(
                'Average Rating:',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(height: 10),
            Center(
              child: Text(
                _averageRating == 0
                    ? 'No ratings available for the selected month and year.'
                    : '$_averageRating',
                style: TextStyle(
                  fontSize: 35,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.orange, // Set the background color of the scaffold
    );
  }
}


