import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart' as icons;
import 'package:yinzo/widgets_function/show_modal_dialog.dart';

class MessagesScreen extends StatefulWidget {
  final String username;

  const MessagesScreen({super.key, required this.username});

  @override
  State<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, dynamic>> messages = [
    {"text": "Bonjour, la maison est dispo ?", "isSender": true},
    {"text": "Oui, toujours dispo", "isSender": false},
    {"text": "Ok, je peux la visiter demain ?", "isSender": true},
    {
      "text": "Attend je vais te proposer une date pour le rendez-vous",
      "isSender": false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.username, style: TextStyle(fontSize: 25)),
          backgroundColor: Color(0x00f8f9fa),
        ),
        body: Column(
          children: [
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(10),
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  final msg = messages[index];
                  return Align(
                    alignment:
                        msg["isSender"]
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color:
                            msg["isSender"]
                                ? Theme.of(
                                  context,
                                ).primaryColor.withValues(alpha: 0.8)
                                : Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        msg["text"],
                        style: TextStyle(
                          color:
                              msg["isSender"] ? Colors.white : Colors.black87,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () async {
                      await showModalDialog(context);
                    },
                    iconSize: 25,
                    icon: Icon(icons.FontAwesome.images),
                  ),
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      keyboardType: TextInputType.text,
                      decoration: const InputDecoration(
                        hintText: "Écrire un message...",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(100)),
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    iconSize: 25,
                    icon: const Icon(Icons.send),
                    color: Theme.of(context).primaryColor,
                    onPressed: () {
                      final text = _controller.text.trim();
                      if (text.isNotEmpty) {
                        setState(() {
                          messages.add({"text": text, "isSender": true});
                          _controller.clear();
                        });
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
