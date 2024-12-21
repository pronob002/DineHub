import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'ReportPage.dart';
import 'ContactPage.dart';
import 'Feedback.dart';
import 'GuestPage.dart';
import 'MealPage.dart';
import 'MealSelectionPage.dart';
import 'PaymentPage.dart';
import 'Profile.dart';

class CoolIcons {
  static const IconData restaurant = Icons.restaurant;
  static const IconData fastfood = Icons.fastfood;
  static const IconData analytics = Icons.analytics;
  static const IconData feedback = Icons.feedback;
  static const IconData notifications = Icons.notifications;
  static const IconData menu = Icons.menu;

  static const IconData settings = Icons.settings;
  static const IconData exitToApp = Icons.exit_to_app;
  static const IconData business = Icons.business;
  static const IconData accountBalanceWallet = Icons.account_balance_wallet;
  static const IconData home = Icons.home;
  static const IconData photo = Icons.photo;
  static const IconData person = Icons.person;
}

class HomePage extends StatelessWidget {
  final String uid;
  Future<int> getUnreadNotificationCount() async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore.instance
          .collection('Notification')
          .where('flag', isEqualTo: 1)
          .get();

      return querySnapshot.size;
    } catch (e) {
      print('Error counting unread notifications: $e');
      return 0;
    }
  }

  HomePage({required this.uid});
  final List<String> images = [
    'assets/bbh1.jpg',
    'assets/bbh2.jpg',
    'assets/bbh3.jpg',
    // Add more image paths as needed
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildAppBarButton(
              context,
              FontAwesomeIcons.moneyBill,
              'Payment',
                  () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PaymentPage(uid: uid,)),
                );
              },
            ),
            _buildAppBarButton(
              context,
              FontAwesomeIcons.hamburger,
              'Meal',
                  () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MealPage()),
                );
              },
            ),
            _buildAppBarButton(
              context,
              FontAwesomeIcons.chartBar,
              'ReportPage',
                  () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ReportPage()),
                );
              },
            ),
            _buildAppBarButton(
              context,
              FontAwesomeIcons.comment,
              'Feedback',
                  () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => FeedbackPage()),
                );
              },
            ),
            _buildAppBarButton(
              context,
              FontAwesomeIcons.bell,
              'Notifications',
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MealSelectionPage()),
                    );
              },
            ),
            _buildAppBarButton(
                context,
                CoolIcons.person,
                'Profile',
                    () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ProfilePage(uid: uid)),
                  );
                }
            ),
          ],
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.white!, Colors.white!],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),

      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 10),
            _buildImageCarousel(),

            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildOptionCard(
                    context,
                    title: 'Payment',
                    icon: FontAwesomeIcons.moneyBill,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => PaymentPage(uid: uid)),
                      );
                    },
                    gradientColors: [Colors.black, Colors.green],
                  ),

                  _buildOptionCard(
                    context,
                    title: 'Meal',
                    icon: FontAwesomeIcons.hamburger,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => MealPage()),
                      );
                    },
                    gradientColors: [Colors.black, Colors.yellow],
                  ),
                  _buildOptionCard(
                    context,
                    title: 'Guest Meal Reservation',
                    icon: FontAwesomeIcons.calendarAlt,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => GuestPage()),
                      );
                    },
                    gradientColors: [Colors.black, Colors.teal],
                  ),
                  _buildOptionCard(
                    context,
                    title: 'Report',
                    icon: FontAwesomeIcons.chartBar,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ReportPage()),
                      );
                    },
                    gradientColors: [Colors.black, Colors.deepPurple],
                  ),
                  _buildOptionCard(
                    context,
                    title: 'Feedback',
                    icon: FontAwesomeIcons.comment,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => FeedbackPage()),
                      );
                    },
                    gradientColors: [Colors.black, Colors.pink],
                  ),
                  _buildOptionCard(
                    context,
                    title: 'Contact',
                    icon: FontAwesomeIcons.mailBulk,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ContactPage()),
                      );
                    },
                    gradientColors: [Colors.black, Colors.blue],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageCarousel() {
    return CarouselSlider(
      options: CarouselOptions(
        height: 200.0,
        enlargeCenterPage: true,
        autoPlay: true,
        aspectRatio: 16 / 9,
        autoPlayCurve: Curves.fastOutSlowIn,
        enableInfiniteScroll: true,
        autoPlayAnimationDuration: Duration(milliseconds: 500),
        viewportFraction: 0.8,
      ),
      items: images.map((imagePath) {
        return Builder(
          builder: (BuildContext context) {
            return Container(
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.symmetric(horizontal: 5.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.indigo.withOpacity(0.5),
                    blurRadius: 10.0,
                    spreadRadius: 2.0,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16.0),
                child: Image.asset(
                  imagePath,
                  fit: BoxFit.cover,
                ),
              ),
            );
          },
        );
      }).toList(),
    );
  }

  Widget _buildOptionCard(
      BuildContext context, {
        required String title,
        required IconData icon,
        required VoidCallback onTap,
        required List<Color> gradientColors,
      }) {
    return Hero(
      tag: title,
      child: Card(
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: InkWell(
          onTap: onTap,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: gradientColors,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16.0),
            ),
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  size: 50,
                  color: Colors.white,
                ),
                SizedBox(height: 10),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAppBarButton(BuildContext context, IconData icon, String title, VoidCallback onTap) {
    if (title == 'Notifications') {
      return FutureBuilder<int>(
        future: getUnreadNotificationCount(),
        builder: (context, snapshot) {
          int notificationCount = snapshot.data ?? 0;

          return Stack(
            children: [
              IconButton(
                icon: Icon(Icons.notifications, color: Colors.black, size: 30),
                onPressed: onTap,
              ),
              if (notificationCount > 0)
                Positioned(
                  top: 0,
                  right: 0,
                  child: Container(
                    padding: EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.red,
                    ),
                    child: Text(
                      '$notificationCount',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
            ],
          );
        },
      );
    } else {
      return Hero(
        tag: title,
        child: IconButton(
          icon: Icon(icon, color: Colors.black, size: 30),
          onPressed: onTap,
        ),
      );
    }
  }
}
