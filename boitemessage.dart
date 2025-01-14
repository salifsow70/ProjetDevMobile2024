import 'package:flutter/material.dart';

class BoiteDeMessage {
  final String titre;
  final String expediteur;
  final String destinataire;
  final String contenu;
  final DateTime dateEnvoi;

  BoiteDeMessage({
    required this.titre,
    required this.expediteur,
    required this.destinataire,
    required this.contenu,
    required this.dateEnvoi,
  });
}

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}
class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final List<BoiteDeMessage> _messages = [
    // Messages de démonstration
    BoiteDeMessage(
      titre: 'Tâche du jour',
      expediteur: 'Employeur',
      destinataire: 'Employée',
      contenu: 'Veuillez passer l\'aspirateur.',
      dateEnvoi: DateTime.now().subtract(Duration(hours: 2)),
    ),
    BoiteDeMessage(
      titre: 'Question',
      expediteur: 'Employée',
      destinataire: 'Employeur',
      contenu: 'Quand faut-il sortir les poubelles ?',
      dateEnvoi: DateTime.now(),
    ),
  ];

  void _sendMessage() {
    if (_messageController.text.isNotEmpty) {
      setState(() {
        _messages.add(
          BoiteDeMessage(
            titre: 'Nouveau message',
            expediteur: 'Vous',
            destinataire: 'Employeur', 
            contenu: _messageController.text,
            dateEnvoi: DateTime.now(),
          ),
        );
        _messageController.clear();
      });
    }
  }
  void _voirReservations() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(
            title: Text('Réservations des clients'),
          ),
          body: Center(
            child: Text("Aucun  réservations "),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text('Mon Compte'),
        ),
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("asserts/femenage.jpg"), 
                fit: BoxFit.cover,
              ),
            ),
          ),
          Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: _messages.length,
                  itemBuilder: (context, index) {
                    final message = _messages[index];
                    return ListTile(
                      title: Text(
                        message.contenu,
                        style: TextStyle(color: Colors.black),
                      ),
                      subtitle: Text(
                        '${message.expediteur} - ${message.dateEnvoi}',
                        style: TextStyle(color: Colors.black),
                      ),
                    );
                  },
                ),
              ),
              Divider(height: 1.0, color: Colors.black),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _messageController,
                        decoration: InputDecoration(
                          hintText: 'Votre message',
                          hintStyle: TextStyle(color: Colors.black),
                          filled: true,
                          fillColor: Colors.black54,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                        ),
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.send, color: Colors.black),
                      onPressed: _sendMessage,
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: _voirReservations,
                child: Text("Voir les réservations des clients"),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

Widget boitemessage() {
  return ChatScreen();
}
