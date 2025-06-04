import 'package:flutter/material.dart';

class ChatBubble extends StatelessWidget {
  final String message;
  final bool isCurrentUser;

  const ChatBubble({
    super.key,
    required this.isCurrentUser,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isCurrentUser ? Alignment.centerRight : Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width *
              0.7, // Limit width to 70% of screen width
        ),
        child: Container(
          decoration: BoxDecoration(
            color: isCurrentUser ? Colors.green : Colors.grey.shade500,
            borderRadius: BorderRadius.circular(15),
          ),
          padding: EdgeInsets.all(12),
          margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          child: Text(
            message,
            style:
                TextStyle(color: Colors.black), // Adjust text color if needed
          ),
        ),
      ),
    );
  }
}
