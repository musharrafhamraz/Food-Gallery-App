import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RestaurantChatScreen extends StatefulWidget {
  final String customerEmail; // The email of the customer we are chatting with

  RestaurantChatScreen({required this.customerEmail});

  @override
  _RestaurantChatScreenState createState() => _RestaurantChatScreenState();
}

class _RestaurantChatScreenState extends State<RestaurantChatScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat with ${widget.customerEmail}'),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _getMessagesStream(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(child: Text('No messages yet.'));
                }

                final messages = snapshot.data!.docs;
                return ListView.builder(
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final messageData =
                        messages[index].data() as Map<String, dynamic>;
                    final isMe =
                        messageData['senderEmail'] == _auth.currentUser!.email;
                    return ChatBubble(
                      isMe: isMe,
                      message: messageData['message'],
                    );
                  },
                );
              },
            ),
          ),
          _buildMessageInput(),
        ],
      ),
    );
  }

  // Build message input field
  Widget _buildMessageInput() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      color: Colors.grey[200],
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: InputDecoration(
                hintText: 'Type your message...',
                border: InputBorder.none,
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.send),
            onPressed: _sendMessage,
          ),
        ],
      ),
    );
  }

  // Send message to the customer
  void _sendMessage() async {
    if (_messageController.text.isEmpty) return;

    final currentUser = _auth.currentUser!;
    final message = _messageController.text.trim();

    // Create a message object
    final messageData = {
      'senderID': currentUser.uid,
      'senderEmail': currentUser.email,
      'receiverEmail': widget.customerEmail,
      'message': message,
      'timestamp': Timestamp.now(),
    };

    // Create a unique chat room ID with the customer user
    List<String> ids = [currentUser.uid, widget.customerEmail];
    ids.sort();
    String chatRoomID = ids.join('_');

    // Save message to Firestore
    await _firestore
        .collection('chat_rooms1')
        .doc(chatRoomID)
        .collection('messages')
        .add(messageData);

    // Clear the input field after sending the message
    _messageController.clear();
  }

  // Get message stream between restaurant and customer
  Stream<QuerySnapshot> _getMessagesStream() {
    final currentUser = _auth.currentUser!;
    List<String> ids = [currentUser.uid, widget.customerEmail];
    ids.sort();
    String chatRoomID = ids.join('_');

    return _firestore
        .collection('chat_rooms1')
        .doc(chatRoomID)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots();
  }
}

// Chat bubble widget for message display
class ChatBubble extends StatelessWidget {
  final bool isMe;
  final String message;

  ChatBubble({required this.isMe, required this.message});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: isMe ? Colors.blue[200] : Colors.grey[300],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          message,
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}
