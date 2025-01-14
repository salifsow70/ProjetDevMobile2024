import 'package:flutter/material.dart';
import 'recherche.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Ma Bonne",
      home:/*ChatScreen(),*/
      Scaffold(
        appBar:AppBar(
          title:Text("Application pour les femmes de ménages"),
          ),
        body:Padding(
          padding:const EdgeInsets.all(16.0),
          child: RecherchePrestataire(),
           
          ),
        ),
      );
  }
}