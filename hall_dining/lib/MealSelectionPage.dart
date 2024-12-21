import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class MealSelectionPage extends StatefulWidget {
  @override
  _MealSelectionPageState createState() => _MealSelectionPageState();
}

class _MealSelectionPageState extends State<MealSelectionPage> {
  late TextEditingController dateController;
  late TextEditingController studentIdController; // Added for student ID
  List<String> foodItems = [];
  late List<String> selectedItems;
  late String selectedDate;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    dateController = TextEditingController();
    studentIdController = TextEditingController(); // Initialize here
    selectedItems = [];
    selectedDate = '';
  }

  CollectionReference dataCollection = FirebaseFirestore.instance.collection('FoodMenu');

  Future<void> _fetchFoodItems(String date) async {
    try {
      setState(() {
        isLoading = true;
      });

      DateTime selectedDate = DateTime.parse(date);
      String formattedDate = DateFormat('yyyy-MM-dd').format(selectedDate);
      QuerySnapshot<Map<String, dynamic>> querySnapshot = await dataCollection
          .where('date', isEqualTo: formattedDate)
          .get() as QuerySnapshot<Map<String, dynamic>>;

      if (querySnapshot.docs.isNotEmpty) {
        print('Data found for $date:');
        querySnapshot.docs.forEach(
              (QueryDocumentSnapshot<Map<String, dynamic>> doc) {
            print(doc.data());
            var data = doc.data();
            foodItems = [
              data?['food_items1'] ?? '',
              data?['food_items2'] ?? '',
              data?['food_items3'] ?? '',
              data?['food_items4'] ?? '',
            ];
            setState(() {});
          },
        );
      } else {
        // Log details about the non-existent document
        print('Document does not exist for date: $date');
        print('Document Reference: ${FirebaseFirestore.instance.collection('FoodMenu').doc(date)}');
      }
    } catch (e) {
      print('Error fetching food items: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _submitVote() async {
    try {
      setState(() {
        isLoading = true;
      });

      selectedDate = dateController.text.trim(); // Initialize selectedDate

      await FirebaseFirestore.instance.collection('vote').add({
        'date': selectedDate,
        'studentId': studentIdController.text.trim(),
        'selected_items': selectedItems,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Your vote has been submitted!',
            style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
          ),
        ),
      );
    } catch (e) {
      print('Error submitting vote: $e');
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
        decoration: BoxDecoration(
          color: Colors.yellow, // Set your desired background color
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Center(
                    child: Center(
                      child: TextField(
                        controller: studentIdController,
                        style: TextStyle(fontSize: 18, color: Colors.black, fontWeight: FontWeight.bold),
                        decoration: InputDecoration(
                          labelText: 'Enter Student ID',
                          labelStyle: TextStyle(fontSize: 22, color: Colors.black, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  Center(
                    child: Center(
                      child: TextField(
                        controller: dateController,
                        style: TextStyle(fontSize: 18, color: Colors.black, fontWeight: FontWeight.bold),
                        decoration: InputDecoration(
                          labelText: 'Date (yyyy-MM-dd)',
                          labelStyle: TextStyle(fontSize: 22, color: Colors.black, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () async {
                      selectedDate = dateController.text.trim();
                      await _fetchFoodItems(selectedDate);
                    },
                    icon: Icon(Icons.fastfood),
                    label: Text('Fetch Food Items', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Select 3 out of 4 items:',
                    style: TextStyle(fontSize: 18, color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Wrap(
                    spacing: 8.0,
                    runSpacing: 8.0,
                    children: foodItems.map((item) {
                      return ChoiceChip(
                        label: Text(item),
                        selected: selectedItems.contains(item),
                        onSelected: (selected) {
                          setState(() {
                            if (selected) {
                              selectedItems.add(item);
                            } else {
                              selectedItems.remove(item);
                            }
                          });
                        },
                      );
                    }).toList(),
                  ),
                  SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: selectedItems.length == 3 ? _submitVote : null,
                    icon: Icon(Icons.send),
                    label: Text('Submit Vote', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                  ),
                  SizedBox(height: 16),
                  if (isLoading)
                    CircularProgressIndicator()
                  else
                    SizedBox.shrink(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
