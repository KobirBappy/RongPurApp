import 'package:firebase_core/firebase_core.dart';
import 'package:rongpurapp/config/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rongpurapp/screens/register_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyCOOgupkMzM6pu3FQSvlZ-SRzH3yWC8OkU",
          authDomain: "rongpurapp-96593.firebaseapp.com",
          projectId: "rongpurapp-96593",
          storageBucket: "rongpurapp-96593.appspot.com",
          messagingSenderId: "419536431083",
          appId: "1:419536431083:web:183fbed5819283e4051bae",
          measurementId: "G-M1G9ZD3G2M")
          );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          primaryColor: primaryColor,
          textTheme: GoogleFonts.robotoTextTheme(
            Theme.of(context).textTheme,
          ),
          scaffoldBackgroundColor: scaffoldBackgroundColor),
      debugShowCheckedModeBanner: false,
      home: RegisterPage(),
    );
  }
}
