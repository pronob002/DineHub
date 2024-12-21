import 'package:flutter/material.dart';
import 'package:flutter_gradient_colors/flutter_gradient_colors.dart';

import 'HallReportPage.dart';
import 'ManagerReportPage.dart';
import 'StockReportPage.dart';

void main() {
  runApp(
    MaterialApp(
      home: ReportPage(),
    ),
  );
}

class ReportPage extends StatelessWidget {
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
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildReportOption(context, 'Manager Report', () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ManagerReportPage()),
                );
              }),
              SizedBox(height: 16),
              _buildReportOption(context, 'Hall Office Report', () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HallReportPage()),
                );
              }),
              SizedBox(height: 16),
              _buildReportOption(context, 'Stock Report', () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => StockReportPage()),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildReportOption(BuildContext context, String reportType, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.all(16),
        primary: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        side: BorderSide(color: Colors.white, width: 2),
      ),
      child: Text(
        reportType,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }
}

