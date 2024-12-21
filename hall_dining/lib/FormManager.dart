import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'FoodMenu.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MaterialApp(
      home: ItemPriceForm(),
    ),
  );
}

class ItemPriceForm extends StatefulWidget {
  @override
  _ItemPriceFormState createState() => _ItemPriceFormState();
}

class _ItemPriceFormState extends State<ItemPriceForm> {
  final _formKey = GlobalKey<FormState>();
  DateTime? selectedDate;
  TextEditingController item1NameController = TextEditingController();
  TextEditingController item2NameController = TextEditingController();
  TextEditingController item3NameController = TextEditingController();
  TextEditingController item4NameController = TextEditingController();
  TextEditingController item1PriceController = TextEditingController();
  TextEditingController item2PriceController = TextEditingController();
  TextEditingController item3PriceController = TextEditingController();
  TextEditingController item4PriceController = TextEditingController();
  TextEditingController otherItemsPriceController = TextEditingController();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  Map<String, dynamic> toJson() {
    String formattedDate = selectedDate != null
        ? DateFormat('yyyy-MM-dd').format(selectedDate!)
        : '';

    return {
      "Date": formattedDate,
      "Item1": item1NameController.text,
      "PriceItem1": double.tryParse(item1PriceController.text) ?? 0.0,
      "Item2": item2NameController.text,
      "PriceItem2": double.tryParse(item2PriceController.text) ?? 0.0,
      "Item3": item3NameController.text,
      "PriceItem3": double.tryParse(item3PriceController.text) ?? 0.0,
      "Item4": item4NameController.text,
      "PriceItem4": double.tryParse(item4PriceController.text) ?? 0.0,
      "Others(Spices)": double.tryParse(otherItemsPriceController.text) ?? 0.0,
    };
  }

  Future<void> _submitForm() async {
    CollectionReference reportsCollection =
    FirebaseFirestore.instance.collection('ManagerReport');
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
        // Store the data in Firestore
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.lightBlueAccent, Colors.white],
          ),
        ),
        padding: EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '                              Poll Menu >>',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.green[900],
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => FoodMenu(),
                          ),
                        );
                      },
                      icon: Icon(Icons.fastfood),
                      color: Colors.yellow,
                      iconSize: 30.0,
                    ),
                  ],
                ),
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
                              ? 'Select Date'
                              : DateFormat('yyyy-MM-dd').format(selectedDate!),
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20),
                _buildItemFormField('Item 1', item1NameController),
                _buildItemPriceFormField('Item 1', item1PriceController),
                SizedBox(height: 10),
                _buildItemFormField('Item 2', item2NameController),
                _buildItemPriceFormField('Item 2', item2PriceController),
                SizedBox(height: 10),
                _buildItemFormField('Item 3', item3NameController),
                _buildItemPriceFormField('Item 3', item3PriceController),
                SizedBox(height: 10),
                _buildItemFormField('Item 4', item4NameController),
                _buildItemPriceFormField('Item 4', item4PriceController),
                SizedBox(height: 10),
                _buildItemPriceFormField(
                    'Other Items', otherItemsPriceController),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _submitForm,
                  child: Text('Submit', style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.indigo,
                    onPrimary: Colors.white,
                    elevation: 10,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildItemFormField(
      String label, TextEditingController controller) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: 'Name of $label',
        labelStyle: TextStyle(color: Colors.black),
      ),
      style: TextStyle(color: Colors.black),
    );
  }

  Widget _buildItemPriceFormField(
      String label, TextEditingController controller) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: 'Price of $label',
        labelStyle: TextStyle(color: Colors.black),
        prefixIcon: Icon(Icons.attach_money, color: Colors.black),
      ),
      style: TextStyle(color: Colors.black),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter the price of $label';
        }
        return null;
      },
    );
  }
}
