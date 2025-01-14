import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'chatScreen.dart'; // Assurez-vous que ChatScreen est correctement importé

class RecherchePrestataire extends StatefulWidget {
  @override
  _RecherchePrestataireState createState() => _RecherchePrestataireState();
}

class _RecherchePrestataireState extends State<RecherchePrestataire> {
  final TextEditingController _competenceController = TextEditingController();
  final TextEditingController _adresseController = TextEditingController();
  List<Map<String, dynamic>> _prestataires = [];

  void _rechercherPrestataires() async {
    String competence = _competenceController.text.trim();
    String adresse = _adresseController.text.trim();

    if (competence.isEmpty || adresse.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Veuillez remplir tous les champs.')),
      );
      return;
    }

    // Recherche dans la base competences et adresse
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('femmes_de_menage')
        .where('competences', arrayContains: competence)
        .where('adresse', isEqualTo: adresse)
        .get();

    setState(() {
      _prestataires = snapshot.docs.map((doc) {
        return {
          'id': doc.id,
          ...doc.data() as Map<String, dynamic>,
        };
      }).toList();
    });
  }
  void _reserverPrestataire(String prestataireId, String prestataireNom) async {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Réservation envoyée pour le prestataire $prestataireNom')),
    );
    try {
      await FirebaseFirestore.instance.collection('messages_prestataires').add({
        'prestataireId': prestataireId,
        'message': 'Vous avez une nouvelle réservation de la part d\'un client.',
        'date': FieldValue.serverTimestamp(),
      });
      Future.delayed(Duration(seconds: 2), () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => ChatScreen(
              prestataireId: prestataireId, 
              clientId: 'clientId',
            ),
          ),
        );
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur lors de l\'envoi du message au prestataire: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Recherche de Prestataires'),
      ),
      backgroundColor: Colors.red, 
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _competenceController,
              decoration: InputDecoration(
                labelText: 'Compétence',
                hintText: 'Entrez une compétence (ex: Nettoyage)',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _adresseController,
              decoration: InputDecoration(
                labelText: 'Adresse',
                hintText: 'Entrez une adresse',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _rechercherPrestataires,
              child: Text('Rechercher'),
            ),
            SizedBox(height: 16),
            _prestataires.isEmpty
                ? Text('Aucun prestataire trouvé.')
                : Expanded(
                    child: ListView.builder(
                      itemCount: _prestataires.length,
                      itemBuilder: (context, index) {
                        final prestataire = _prestataires[index];
                        return Card(
                          child: ListTile(
                            title: Text(prestataire['nom'] ?? 'Nom inconnu'),
                            subtitle: Text(
                                'Adresse: ${prestataire['adresse']}\nCompétence: ${prestataire['competences'].join(', ')}'),
                            trailing: ElevatedButton(
                              onPressed: () => _reserverPrestataire(
                                prestataire['id'],
                                prestataire['nom'],
                              ),
                              child: Text('Réserver'),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
