import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

void main() async {
  runApp(HallReportPage());
}

class HallReportPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DateSelectionPage(),
      theme: ThemeData(
        primaryColor: Colors.blue,
        scaffoldBackgroundColor: Colors.blue,
      ),
      debugShowCheckedModeBanner: false, // Remove debug banner
    );
  }
}

class DateSelectionPage extends StatefulWidget {
  @override
  _DateSelectionPageState createState() => _DateSelectionPageState();
}

class _DateSelectionPageState extends State<DateSelectionPage> {
  DateTime? selectedDate;
  bool isLoading = false;
  bool hasData = false;

  CollectionReference dataCollection =
  FirebaseFirestore.instance.collection('HallReport');

  Future<void> getDataFromFirestore(String formattedDate) async {
    print(formattedDate);
    try {
      setState(() {
        isLoading = true;
        hasData = false;
      });

      QuerySnapshot<Map<String, dynamic>> querySnapshot = await dataCollection
          .where('Month', isEqualTo: formattedDate)
          .get() as QuerySnapshot<Map<String, dynamic>>;

      if (querySnapshot.docs.isNotEmpty) {
        print('Data found for $formattedDate:');
        querySnapshot.docs.forEach(
              (QueryDocumentSnapshot<Map<String, dynamic>> doc) {
            print(doc.data());
            showDataDialog(context, formattedDate, doc);
          },
        );
        setState(() {
          hasData = true;
        });
      } else {
        print('No data found for $formattedDate');
        // You may want to show a message to the user indicating no data.
      }
    } catch (e) {
      print('Error fetching data: $e');
      // Handle errors, e.g., show an error message to the user.
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void showDataDialog(
      BuildContext context,
      String formattedDate,
      QueryDocumentSnapshot<Map<String, dynamic>> doc,
      ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: contentBox(context, formattedDate, doc),
        );
      },
    );
  }

  Widget contentBox(
      BuildContext context,
      String formattedDate,
      QueryDocumentSnapshot<Map<String, dynamic>> doc,
      ) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.8,
      height: MediaQuery.of(context).size.height * 0.5,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Text(
                  '$formattedDate',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
                SizedBox(height: 20),
                buildItemRow('Cost', doc['Total Cost']),
                buildItemRow('Saving', doc['Total Saved Balance']),
                buildItemRow('Students', doc['Total Students']),
              ],
            ),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget buildItemRow(String item, dynamic value) {
    // Check if value is a number (int or double)

      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Text(
              '$item',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
          ),
          Flexible(
            child: Text(
              '$value',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
          ),
        ],
      );

  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      firstDate: DateTime(2022, 1),
      lastDate: DateTime(2025, 12),
      initialDate: selectedDate ?? DateTime.now(),
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });

      // Format the selected date to match the database format
      String formattedDate = DateFormat('MMMM yyyy').format(selectedDate!);

      // Retrieve data from Firestore based on the formatted date
      await getDataFromFirestore(formattedDate);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue, Colors.blue],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                selectedDate == null
                    ? 'No Date Selected'
                    : 'Selected Date: ${DateFormat('MMMM yyyy').format(selectedDate!)}',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => _selectDate(context),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.restaurant_menu,
                      color: Colors.black,
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Select Month',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              if (isLoading)
                CircularProgressIndicator()
              else if (!isLoading && !hasData)
                Text(
                  'No data found for the selected month.',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
