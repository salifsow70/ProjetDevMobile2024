import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'boitemessage.dart';
class FemmeDeMenage {
  String nom;
  List<String> competences;
  Map<String, bool> disponibilites;
  String adresse;
  List<String> heuresDisponibilites;

  FemmeDeMenage({
    required this.nom,
    required this.adresse,
    required this.competences,
    required this.disponibilites,
    required this.heuresDisponibilites,
  });

  factory FemmeDeMenage.fromJson(Map<String, dynamic> json) => FemmeDeMenage(
        nom: json['nom'],
        adresse: json['adresse'],
        competences: List<String>.from(json['competences']),
        disponibilites: Map<String, bool>.from(json['disponibilites']),
        heuresDisponibilites: List<String>.from(json['heuresDisponibilites']),
      );

  Map<String, dynamic> toJson() => {
        'nom': nom,
        'adresse': adresse,
        'competences': competences,
        'disponibilites': disponibilites,
        'heuresDisponibilites': heuresDisponibilites,
      };
}

class ProfilFemmeDeMenageApp extends StatefulWidget {
  @override
  _ProfilFemmeDeMenageAppState createState() => _ProfilFemmeDeMenageAppState();
}

class _ProfilFemmeDeMenageAppState extends State<ProfilFemmeDeMenageApp> {
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();

  final List<String> competencesDisponibles = [
    'Nettoyage', 'Repassage', 'Cuisine', 'Ménage de printemps'
  ];
  final List<String> joursSemaine = [
    'Lundi', 'Mardi', 'Mercredi', 'Jeudi', 'Vendredi', 'Samedi', 'Dimanche'
  ];
  final List<String> heuresDisponibles = ['Matin', 'Après-midi', 'Soir'];

  Future<void> _addProfil() async {
    if (_formKey.currentState!.saveAndValidate()) {
      final selectedCompetences = List<String>.from(_formKey.currentState!.fields['competences']?.value ?? []);
      final selectedDisponibilites = _getDisponibilites();
      final selectedHeuresDisponibilites = List<String>.from(_formKey.currentState!.fields['heuresDisponibilites']?.value ?? []);

      final newFemmeDeMenage = FemmeDeMenage(
        nom: _formKey.currentState!.fields['nom']?.value ?? '',
        adresse: _formKey.currentState!.fields['adresse']?.value ?? '',
        competences: selectedCompetences,
        disponibilites: selectedDisponibilites,
        heuresDisponibilites: selectedHeuresDisponibilites,
      );

      try {
        // Enregistrer le profil dans Firestore
        await FirebaseFirestore.instance.collection('femmes_de_menage').add(newFemmeDeMenage.toJson());

        // Afficher un message de succès
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Profil ajouté avec succès !')));

        // Redirection vers la page BoiteDeMessagePage
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => boitemessage()),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erreur lors de l\'ajout du profil : $e')));
      }
    }
  }
  Map<String, bool> _getDisponibilites() {
    final selectedDisponibilites = _formKey.currentState!.fields['disponibilites']?.value ?? [];
    final disponibilitesMap = <String, bool>{};

    for (var jour in joursSemaine) {
      disponibilitesMap[jour] = selectedDisponibilites.contains(jour);
    }
    return disponibilitesMap;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Gestion des profils de femmes de ménage')),
      body: FormBuilder(
        key: _formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          children: [
            FormBuilderTextField(
              name: 'nom',
              decoration: InputDecoration(labelText: 'Nom'),
            ),
            FormBuilderTextField(
              name: 'adresse',
              decoration: InputDecoration(labelText: 'Adresse'),
            ),
            FormBuilderCheckboxGroup<String>(
              name: 'competences',
              decoration: InputDecoration(labelText: 'Compétences'),
              options: competencesDisponibles
                  .map((e) => FormBuilderFieldOption(value: e, child: Text(e)))
                  .toList(),
            ),
            FormBuilderCheckboxGroup<String>(
              name: 'disponibilites',
              decoration: InputDecoration(labelText: 'Disponibilités'),
              options: joursSemaine
                  .map((e) => FormBuilderFieldOption(value: e, child: Text(e)))
                  .toList(),
            ),
            FormBuilderCheckboxGroup<String>(
              name: 'heuresDisponibilites',
              decoration: InputDecoration(labelText: 'Heures Disponibilités'),
              options: heuresDisponibles
                  .map((e) => FormBuilderFieldOption(value: e, child: Text(e)))
                  .toList(),
            ),
            ElevatedButton(
              onPressed: _addProfil,
              child: Text('Enregistrer'),
            ),
          ],
        ),
      ),
    );
  }
}

class BoiteDeMessagePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Message')),
      body: Center(
        child: Text('Profil ajouté avec succès !', style: TextStyle(fontSize: 20)),
      ),
    );
  }
}
