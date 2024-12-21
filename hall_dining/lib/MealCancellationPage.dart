import 'package:flutter/material.dart';

void main() {
  runApp(
    MaterialApp(
      home: MealCancellationPage(),
    ),
  );
}

class MealCancellationPage extends StatefulWidget {
  @override
  _MealCancellationPageState createState() => _MealCancellationPageState();
}

class _MealCancellationPageState extends State<MealCancellationPage> {
  DateTime? fromDate;
  DateTime? toDate;
  DateTime? requestDate;
  TimeOfDay? requestTime;
  String cause = '';

  Future<void> _selectDate(BuildContext context, bool isFrom) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isFrom ? fromDate ?? DateTime.now() : toDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );

    if (picked != null && picked != (isFrom ? fromDate : toDate)) {
      setState(() {
        if (isFrom) {
          fromDate = picked;
        } else {
          toDate = picked;
        }
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: requestTime ?? TimeOfDay.now(),
    );

    if (picked != null && picked != requestTime) {
      setState(() {
        requestTime = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF536DFE),
                  Color(0xFF64B5F6),
                ],
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: 20),
                  Center(
                    child: Text(
                      'Meal Cancellation',
                      style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ),
                  SizedBox(height: 20),
                  _buildDateField('From Date', fromDate, true),
                  SizedBox(height: 10),
                  _buildDateField('To Date', toDate, false),
                  SizedBox(height: 10),
                  _buildDateTimeField('Request Date', requestDate, true),
                  SizedBox(height: 10),
                  _buildDateTimeField('Request Time', requestTime, false),
                  SizedBox(height: 10),
                  _buildCauseTextField(),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      // Implement logic for submitting meal cancellation
                      print('Meal Cancellation Submitted');
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.amber,
                      onPrimary: Colors.white,
                      padding: EdgeInsets.all(15),
                    ),
                    child: Text(
                      'Submit Cancellation',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDateField(String label, DateTime? selectedDate, bool isFrom) {
    return GestureDetector(
      onTap: () => _selectDate(context, isFrom),
      child: Container(
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
            ),
            Text(
              selectedDate != null ? '${selectedDate.toLocal()}'.split(' ')[0] : 'Select Date',
              style: TextStyle(fontSize: 18, color: Colors.black),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateTimeField(String label, dynamic selectedValue, bool isDate) {
    return GestureDetector(
      onTap: isDate ? () => _selectDate(context, false) : () => _selectTime(context),
      child: Container(
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
            ),
            Text(
              selectedValue != null ? (isDate ? '${(selectedValue as DateTime).toLocal()}'.split(' ')[0] : (selectedValue as TimeOfDay).format(context)) : 'Select ${isDate ? 'Date' : 'Time'}',
              style: TextStyle(fontSize: 18, color: Colors.black),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCauseTextField() {
    return Container(
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
      ),
      child: TextField(
        maxLines: 5,
        onChanged: (value) {
          setState(() {
            cause = value;
          });
        },
        style: TextStyle(fontSize: 18, color: Colors.black),
        decoration: InputDecoration(
          labelText: 'Cause',
          border: InputBorder.none,
          labelStyle: TextStyle(fontSize: 18, color: Colors.black),
        ),
      ),
    );
  }
}
