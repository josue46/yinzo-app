import 'package:flutter/material.dart';
import 'package:yinzo/Chat/Screens/messages_screen.dart';

class ConversationsScreen extends StatelessWidget {
  const ConversationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> conversations = [
      {
        "name": "Agence ImmoPro",
        "lastMessage": "Bonjour, la maison est encore dispo ?",
        "time": "13:45",
        "isVerified": true,
      },
      {
        "name": "Kevin M.",
        "lastMessage": "Merci pour les infos !",
        "time": "11:20",
        "isVerified": false,
      },
      {
        "name": "Kevin M.",
        "lastMessage": "Merci pour les infos !",
        "time": "11:20",
        "isVerified": false,
      },
      {
        "name": "Kevin M.",
        "lastMessage": "Merci pour les infos !",
        "time": "11:20",
        "isVerified": false,
      },
      {
        "name": "Kevin M.",
        "lastMessage": "Merci pour les infos !",
        "time": "11:20",
        "isVerified": false,
      },
      {
        "name": "Kevin M.",
        "lastMessage": "Merci pour les infos !",
        "time": "11:20",
        "isVerified": false,
      },
      {
        "name": "Kevin M.",
        "lastMessage": "Merci pour les infos !",
        "time": "11:20",
        "isVerified": false,
      },
      {
        "name": "Kevin M.",
        "lastMessage": "Merci pour les infos !",
        "time": "11:20",
        "isVerified": false,
      },
      {
        "name": "Kevin M.",
        "lastMessage": "Merci pour les infos !",
        "time": "11:20",
        "isVerified": false,
      },
      {
        "name": "Kevin M.",
        "lastMessage": "Merci pour les infos !",
        "time": "11:20",
        "isVerified": false,
      },
      {
        "name": "Kevin M.",
        "lastMessage": "Merci pour les infos !",
        "time": "11:20",
        "isVerified": false,
      },
      {
        "name": "Kevin M.",
        "lastMessage": "Merci pour les infos !",
        "time": "11:20",
        "isVerified": false,
      },
      {
        "name": "Kevin M.",
        "lastMessage": "Merci pour les infos !",
        "time": "11:20",
        "isVerified": false,
      },
      {
        "name": "Kevin M.",
        "lastMessage": "Merci pour les infos !",
        "time": "11:20",
        "isVerified": false,
      },
      {
        "name": "Kevin M.",
        "lastMessage": "Merci pour les infos !",
        "time": "11:20",
        "isVerified": false,
      },
      {
        "name": "Kevin M.",
        "lastMessage": "Merci pour les infos !",
        "time": "11:20",
        "isVerified": false,
      },
    ];

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Messages",
            style: TextStyle(
              fontSize: Theme.of(context).textTheme.titleLarge!.fontSize,
            ),
          ),
          backgroundColor: Color(0x00f8f9fa),
        ),
        body: ListView.builder(
          itemCount: conversations.length,
          itemBuilder: (context, index) {
            final conv = conversations[index];
            return ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.grey.shade300,
                child: Text(conv["name"][0]),
              ),
              title: Row(
                children: [
                  Text(conv["name"]),
                  if (conv["isVerified"]) ...[
                    const SizedBox(width: 5),
                    const Icon(Icons.verified, color: Colors.blue, size: 16),
                  ],
                ],
              ),
              subtitle: Text(conv["lastMessage"]),
              trailing: Text(conv["time"]),
              onTap: () {
                // Naviguer vers les messages
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) => MessagesScreen(username: conv["name"]),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
