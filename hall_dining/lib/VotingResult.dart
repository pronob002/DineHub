import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';


void main() {
  runApp(VotingResultPage());
}

class VotingResultPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue, // Choose your primary color
        hintColor: Colors.tealAccent, // Choose your accent color
        fontFamily: 'Roboto',
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Center(
            child: Text(
              'Voting Results',
              style: TextStyle(
                color: Colors.white, // Text color for the app bar title
              ),
            ),
          ),
          backgroundColor: Colors.white, // App bar background color
        ),
        body: VotingResultList(),
        backgroundColor: Colors.white, // Set the background color to yellow
      ),
    );
  }
}

class VotingResultList extends StatefulWidget {
  @override
  _VotingResultListState createState() => _VotingResultListState();
}

class _VotingResultListState extends State<VotingResultList> {
  DateTime? _selectedDate;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ElevatedButton(
            onPressed: () {
              _selectDate(context);
            },
            style: ElevatedButton.styleFrom(
              primary: Theme.of(context).colorScheme.secondary,
              onPrimary: Colors.white,
            ),
            child: Center(child: Text('Select Date')),
          ),
          SizedBox(height: 16.0),
          _selectedDate != null
              ? StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('vote')
                .where('date', isEqualTo: DateFormat('yyyy-MM-dd').format(_selectedDate!))
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return CircularProgressIndicator();
              }

              var votes = snapshot.data!.docs;
              if (votes.isEmpty) {
                return const Center(
                  child: Text(
                    'No votes for the selected date.',
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 20,
                    ),
                  ),
                );
              }

              // Calculate the total count of each item

              Map<String, int> itemCountMap = {};
              for (var vote in votes) {
                var selectedItems = vote['selected_items'] as List?;
                if (selectedItems != null) {
                  for (var item in selectedItems) {
                    itemCountMap[item] = (itemCountMap[item] ?? 0) + 1;
                  }
                }
              }

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      'Voting Results for ${DateFormat('yyyy-MM-dd').format(_selectedDate!)}:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                  SizedBox(height: 8.0),
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: itemCountMap.length,
                    itemBuilder: (context, index) {
                      var item = itemCountMap.keys.elementAt(index);
                      var count = itemCountMap[item]!;
                      return ListTile(
                        title: Text(
                          '$item: $count times',
                          style: const TextStyle(
                              color: Colors.purple,
                              // Text color for the list item
                              fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      );
                    },
                  ),
                ],
              );
            },
          )
              : SizedBox(),
        ],
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: Theme.of(context).primaryColor, // Choose your primary color
            hintColor: Theme.of(context).colorScheme.secondary, // Choose your accent color
            colorScheme: ColorScheme.light(primary: Theme.of(context).primaryColor),
            buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }
}
