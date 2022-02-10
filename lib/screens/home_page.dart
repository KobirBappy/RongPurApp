import 'package:firebase_auth/firebase_auth.dart';
import 'package:rongpurapp/screens/register_page.dart';
import 'package:rongpurapp/services/firebase_services.dart';
import 'package:rongpurapp/tabs/home_tab.dart';
import 'package:rongpurapp/tabs/saved_tab.dart';
import 'package:rongpurapp/tabs/search_tab.dart';
import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  FirebaseServices _firebaseServices = FirebaseServices();


  int page = 0;

  List<Widget> bodypage = [
    HomeScreen(),
    SearchScreen(),
    SavedScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: bodypage[page],
      bottomNavigationBar: CurvedNavigationBar(
        index: 0,
        height: 60.0,
        items: <Widget>[
          Icon(Icons.home, size: 30),
          Icon(Icons.search, size: 30),
          Icon(Icons.save, size: 30),
          IconButton(
              onPressed: () {
                FirebaseAuth.instance.signOut().then((value) =>
                    Navigator.pushAndRemoveUntil(context,
                        MaterialPageRoute(builder: (context) {
                      return RegisterPage();
                    }), (route) => false));
                 FirebaseUser user = FirebaseAuth.instance.currentUser;
              },
              icon: Icon(Icons.logout))
        ],
        color: Colors.greenAccent,
        buttonBackgroundColor: Colors.orangeAccent,
        backgroundColor: Colors.blueAccent,
        animationCurve: Curves.easeInOut,
        animationDuration: Duration(milliseconds: 300),
        onTap: (index) {
          setState(() {
            page = index;
          });
        },
        letIndexChange: (index) => true,
      ),
    );
  }
}
