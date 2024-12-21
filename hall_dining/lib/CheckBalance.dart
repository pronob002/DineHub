import 'package:flutter/material.dart';
import 'AddBalance.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CheckBalance extends StatelessWidget {
  final String uid;

  CheckBalance({required this.uid});

  Future<int> getCount() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('vote')
          .where('studentId', isEqualTo: uid.substring(1, 8))
          .get();
      return querySnapshot.size;
    } catch (e) {
      print('Error counting documents in vote collection: $e');
      return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<int>(
        future: getCount(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator(); // Loading indicator while fetching data
          }

          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          int? count = snapshot.data;
          return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
            stream: FirebaseFirestore.instance.collection('Student').where('email', isEqualTo: uid).snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator(); // Loading indicator while fetching data
              }

              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return const Text('Document does not exist'); // Handle the case where the document doesn't exist
              }

              int? credit = snapshot.data!.docs.first['credit'] as int?;

              if (credit == null) {
                return const Text('Credit not available'); // Handle the case where 'credit' is not present or is null
              }
                credit=credit-count!*40;
              return Center(
                child: Container(
                  color: Colors.white,
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.account_balance,
                            size: 100,
                            color: Colors.deepPurple,
                          ),
                          const SizedBox(height: 20),
                          const Text(
                            'Available Balance:',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.deepPurple,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            '\$$credit', // Display the fetched credit
                            style: const TextStyle(
                              fontSize: 36,
                              fontWeight: FontWeight.bold,
                              color: Colors.deepPurple,
                            ),
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: () {
                              // Implement logic to navigate to the payment page
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => AddBalance()),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              primary: Colors.orange,
                              onPrimary: Colors.white,
                            ),
                            child: const Padding(
                              padding: EdgeInsets.all(10.0),
                              child: Text(
                                'Make a Payment',
                                style: TextStyle(fontSize: 18),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
