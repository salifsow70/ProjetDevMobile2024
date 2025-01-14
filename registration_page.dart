import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RegistrationPage extends StatefulWidget {
  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nomController = TextEditingController();
  final _prenomController = TextEditingController();
  final _adresseController = TextEditingController();
  bool _isLoading = false;

  void _register() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );

        await FirebaseFirestore.instance
            .collection('users')
            .doc(userCredential.user?.uid)
            .set({
          'nom': _nomController.text,
          'prenom': _prenomController.text,
          'email': _emailController.text,
          'adresse': _adresseController.text,
          'createdAt': DateTime.now(),
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Inscription réussie')),
        );
        Navigator.pushReplacementNamed(context, '/login');
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Une erreur est survenue: $e')),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Inscription'),
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("asserts/fondmobile.jpg"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SingleChildScrollView(
            padding: EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextFormField(
                    controller: _nomController,
                    decoration: InputDecoration(
                      labelText: 'Nom',
                      labelStyle: TextStyle(color: Colors.white), 
                      border: OutlineInputBorder(),
                    ),
                    style: TextStyle(color: Colors.white), 
                    validator: (value) => value == null || value.isEmpty
                        ? 'Champ requis'
                        : null,
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: _prenomController,
                    decoration: InputDecoration(
                      labelText: 'Prénom',
                      labelStyle: TextStyle(color: Colors.white), 
                      border: OutlineInputBorder(),
                    ),
                    style: TextStyle(color: Colors.white),
                    validator: (value) => value == null || value.isEmpty
                        ? 'Champ requis'
                        : null,
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      labelStyle: TextStyle(color: Colors.white), 
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    style: TextStyle(color: Colors.white), 
                    validator: (value) => value == null || value.isEmpty
                        ? 'Email requis'
                        : null,
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                      labelText: 'Mot de passe',
                      labelStyle: TextStyle(color: Colors.white), 
                      border: OutlineInputBorder(),
                    ),
                    obscureText: true,
                    style: TextStyle(color: Colors.white), 
                    validator: (value) => value == null || value.isEmpty
                        ? 'Mot de passe requis'
                        : null,
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: _adresseController,
                    decoration: InputDecoration(
                      labelText: 'Adresse',
                      labelStyle: TextStyle(color: Colors.white), 
                      border: OutlineInputBorder(),
                    ),
                    style: TextStyle(color: Colors.white), 
                    validator: (value) => value == null || value.isEmpty
                        ? 'Adresse requise'
                        : null,
                  ),
                  SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: _isLoading ? null : _register,
                    child: _isLoading
                        ? CircularProgressIndicator()
                        : Text('S\'inscrire'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}











