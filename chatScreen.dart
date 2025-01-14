import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatScreen extends StatefulWidget {
  final String prestataireId;
  final String clientId;

  ChatScreen({required this.prestataireId, required this.clientId});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}
class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  List<Map<String, dynamic>> _messages = [];
  void _getMessages() async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('messages_reservations')
          .where('destinataire', isEqualTo: widget.prestataireId)  
          .where('expediteur', isEqualTo: widget.clientId) 
          .orderBy('dateEnvoi', descending: true)
          .get();

      setState(() {
        _messages = snapshot.docs.map((doc) {
          return {
            'id': doc.id,
            ...doc.data() as Map<String, dynamic>,
          };
        }).toList();
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur lors de la récupération des messages: $e')),
      );
    }
  }
  void _sendMessage() {
    if (_messageController.text.isNotEmpty) {
      FirebaseFirestore.instance.collection('messages_reservations').add({
        'expediteur': widget.clientId,
        'destinataire': widget.prestataireId,
        'contenu': _messageController.text,
        'dateEnvoi': DateTime.now(),
      });

      setState(() {
        _messages.add({
          'contenu': _messageController.text,
          'expediteur': 'Vous',
          'dateEnvoi': DateTime.now(),
        });
      });

      _messageController.clear();
    }
  }

  @override
  void initState() {
    super.initState();
    _getMessages(); 
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Conversation avec le prestataire'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                return ListTile(
                  title: Text(message['contenu']),
                  subtitle: Text('Expéditeur: ${message['expediteur']}'),
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
                      hintText: 'Votre message...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
