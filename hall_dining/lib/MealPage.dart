import 'package:flutter/material.dart';
import 'package:hall_dining/MealSelectionPage.dart';
import 'MealCancellationPage.dart';
import 'VerificationPage.dart';
void main() {
  runApp(
    MaterialApp(
      home: MealPage(),
    ),
  );
}

class MealPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.blue, Colors.purple], // Customize your gradient colors
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildOptionButton(
                context,
                title: 'Meal Selection',
                onTap: () {
                  // Navigate to the MealSelectionPage
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MealSelectionPage()),
                  );
                },
                color: Colors.green,
              ),
              SizedBox(height: 20),
              _buildOptionButton(
                context,
                title: 'Meal Cancellation',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MealCancellationPage()),
                  );
                },
                color: Colors.red,
              ),
              SizedBox(height: 20),
              _buildOptionButton(
                context,
                title: 'Verification',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => VerificationPage()),
                  );
                },
                color: Colors.orange,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOptionButton(
      BuildContext context, {
        required String title,
        required VoidCallback onTap,
        required Color color,
      }) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(vertical: 20),
        primary: color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }
}
