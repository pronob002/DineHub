import 'package:flutter/material.dart';
import 'package:flutter_gradient_colors/flutter_gradient_colors.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: GuestPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class GuestPage extends StatefulWidget {
  @override
  _GuestPageState createState() => _GuestPageState();
}

class _GuestPageState extends State<GuestPage> {
  int _guestCount = 1;
  String _selectedMeal = 'Select Meal';
  String _selectedTime = 'Select Time';
  DateTime _selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: GradientColors.blue,
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 20),
              _buildDateSection(),
              SizedBox(height: 20),
              _buildMealSection(),
              SizedBox(height: 20),
              _buildGuestCountSection(),
              SizedBox(height: 20),
              _buildMealTimeSection(),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Add functionality to handle button press
                  print("submitted");
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.yellow, // Change this color to your desired color
                  onPrimary: Colors.yellow,
                  padding: EdgeInsets.all(16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  'Submit',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                    color: Colors.black,
                    fontFamily: 'Roboto',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDateSection() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Date:',
            style: TextStyle(fontSize: 18, color: Colors.black),
          ),
          InkWell(
            onTap: () => _selectDate(context),
            child: Container(
              padding: EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Row(
                children: [
                  Icon(Icons.calendar_today, color: Colors.white),
                  SizedBox(width: 8),
                  Text(
                    "${_formattedDate()}",
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formattedDate() {
    return "${_selectedDate.day}-${_selectedDate.month}-${_selectedDate.year}";
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2022),
      lastDate: DateTime(2024),
    );

    if (picked != null && picked != _selectedDate)
      setState(() {
        _selectedDate = picked;
      });
  }

  Widget _buildMealSection() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: DropdownButtonFormField<String>(
        value: _selectedMeal,
        onChanged: (value) {
          setState(() {
            _selectedMeal = value!;
          });
        },
        items: ['Select Meal', 'Polao,fish,chicken', 'Polao,mutton,shrimp', 'Biryani,misti,doi']
            .map<DropdownMenuItem<String>>(
              (String value) => DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          ),
        )
            .toList(),
        style: TextStyle(fontSize: 18, color: Colors.black),
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: 'Select Meal',
        ),
      ),
    );
  }

  Widget _buildGuestCountSection() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'No. of Guests:',
            style: TextStyle(fontSize: 18, color: Colors.black),
          ),
          Row(
            children: [
              IconButton(
                onPressed: () {
                  setState(() {
                    if (_guestCount > 1) {
                      _guestCount--;
                    }
                  });
                },
                icon: Icon(Icons.remove),
                color: Colors.black,
              ),
              Text(
                '$_guestCount',
                style: TextStyle(fontSize: 18, color: Colors.black),
              ),
              IconButton(
                onPressed: () {
                  setState(() {
                    _guestCount++;
                  });
                },
                icon: Icon(Icons.add),
                color: Colors.black,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMealTimeSection() {
    return Center(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: DropdownButtonFormField<String>(
          value: _selectedTime,
          onChanged: (value) {
            setState(() {
              _selectedTime = value!;
            });
          },
          items: ['Select Time', 'Lunch', 'Dinner', 'Both']
              .map<DropdownMenuItem<String>>(
                (String value) => DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            ),
          )
              .toList(),
          style: TextStyle(fontSize: 18, color: Colors.black),
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: 'Select Time',
          ),
        ),
      ),
    );
  }
}
