import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pmobile/profil.dart';
import 'login_page.dart';
import 'registration_page.dart';
import 'home_page.dart';
import 'WelcomePage.dart'; 

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyCh2NWOuiFNU43gy7EozKZMUA2uedd6Ij4",
      appId: "1:1049057354666:web:661d3b8aa1bd70f46741d3",
      messagingSenderId: "1049057354666",
      projectId: "projetmob-64e9d",
    ),
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gestion des Utilisateurs',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: WelcomePage(), 
      routes: {
        '/login': (context) => LoginPage(),
        '/registration': (context) => RegistrationPage(),
        '/home': (context) => HomePage(),
      },
    );
  }
}
