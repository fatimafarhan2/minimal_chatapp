import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:minimal_chatapp/auth/auth_service.dart';
import 'package:minimal_chatapp/components/chat_bubble.dart';
import 'package:minimal_chatapp/components/my_textfield.dart';
import 'package:minimal_chatapp/services/chat_services/chat_services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

class ChatPage extends StatefulWidget {
  final String receiverEmail;
  final String recieverId;

  const ChatPage({
    super.key,
    required this.receiverEmail,
    required this.recieverId,
  });

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  // Text controller
  final TextEditingController _messageController = TextEditingController();

  // Chat & auth services
  final Chatservice _chatService = Chatservice();
  final AuthService _authService = AuthService();

  DateTime? lastNotifiedMessageTime; // Track last notified message timestamp

  // Send message
  void sendMessage() async {
    if (_messageController.text.isNotEmpty) {
      await _chatService.send_messages(
          widget.recieverId, _messageController.text);
      _messageController.clear(); // Clear the input field after sending
    }
  }

  // Show local notification
  void showLocalNotification(String title, String body) {
    flutterLocalNotificationsPlugin.show(
      0,
      title,
      body,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'chat_channel',
          'Chat Notifications',
          importance: Importance.max,
          priority: Priority.high,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.receiverEmail),
      ),
      body: Column(
        children: [
          // Display message list
          Expanded(child: buildMessageList()),
          // User input
          _buildUserInput(),
        ],
      ),
    );
  }

  // Build message list using StreamBuilder
  Widget buildMessageList() {
    String senderID = _authService.getcurrentuser()!.uid;
    return StreamBuilder(
      stream: _chatService.getmessages(widget.recieverId, senderID),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text("Error loading messages");
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
          return ListView(
            children: snapshot.data!.docs.map((doc) {
              Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
              bool isCurrentUser =
                  data['senderID'] == _authService.getcurrentuser()!.uid;

              // Only show notifications if it's a new message and not from the current user
              if (!isCurrentUser && data['timestamp'] != null) {
                DateTime messageTime =
                    (data['timestamp'] as Timestamp).toDate();
                if (lastNotifiedMessageTime == null ||
                    messageTime.isAfter(lastNotifiedMessageTime!)) {
                  showLocalNotification('New Message', data['message']);
                  lastNotifiedMessageTime =
                      messageTime; // Update the last notified time
                }
              }

              return ChatBubble(
                isCurrentUser: isCurrentUser,
                message: data['message'],
              );
            }).toList(),
          );
        } else {
          return const Center(child: Text("No messages yet"));
        }
      },
    );
  }

  // Input field to type and send messages
  Widget _buildUserInput() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Row(
        children: [
          Expanded(
            child: MyTextField(
              controller: _messageController,
              hintText: 'Type something...',
              obscureText: false,
            ),
          ),
          Container(
            decoration:
                BoxDecoration(color: Colors.green, shape: BoxShape.circle),
            margin: const EdgeInsets.only(right: 25),
            child: IconButton(
              onPressed: sendMessage,
              icon: const Icon(
                Icons.send,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
