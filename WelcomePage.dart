import 'package:flutter/material.dart';

class WelcomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text('Bienvenue sur la Gestion Des Femmes De Ménage'),
        ),
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("asserts/imgaccueil.jpg"), 
                fit: BoxFit.cover,
              ),
            ),
          ),
          
          Container(
            //color: const Color.fromARGB(255, 161, 147, 147), 
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () => Navigator.pushNamed(context, '/login'),
                  child: Text('Connexion'),
                ),
                SizedBox(height: 30),
                TextButton(
                  onPressed: () => Navigator.pushNamed(context, '/registration'),
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.blueAccent, textStyle: TextStyle(
                      fontSize: 18, 
                      fontWeight: FontWeight.bold, 
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
                    child: Text(
                      'Pas de compte ? S\'inscrire',
                      style: TextStyle(color: Colors.blue), 
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
