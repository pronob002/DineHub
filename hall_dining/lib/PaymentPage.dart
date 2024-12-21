import 'package:flutter/material.dart';
import 'AddBalance.dart';
import 'CheckBalance.dart';
import 'WithdrawBalance.dart';

class PaymentPage extends StatelessWidget {
  final String uid;
  PaymentPage({required this.uid});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      extendBody: true,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.blue, Colors.purple],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 100),
              _buildOptionButton(
                context,
                title: 'Check Balance',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CheckBalance(uid:uid)),
                  );
                },
                color: Colors.teal,
              ),
              SizedBox(height: 20),
              _buildOptionButton(
                context,
                title: 'Add Balance',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AddBalance()),
                  );
                },
                color: Colors.orange,
              ),
              SizedBox(height: 20),
              _buildOptionButton(
                context,
                title: 'Withdraw Balance',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => WithdrawBalance()),
                  );
                },
                color: Colors.red,
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
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 40),
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
