// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';

// class CustomerChatScreen extends StatefulWidget {
//   const CustomerChatScreen({super.key});

//   @override
//   _CustomerChatScreenState createState() => _CustomerChatScreenState();
// }

// class _CustomerChatScreenState extends State<CustomerChatScreen> {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final TextEditingController _messageController = TextEditingController();

//   final String restaurantEmail = 'gVFEvC2Q8JaASh7a7pOSZ7I3C3o1';

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Chat with Restaurant'),
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: StreamBuilder<QuerySnapshot>(
//               stream: _getMessagesStream(),
//               builder: (context, snapshot) {
//                 if (snapshot.connectionState == ConnectionState.waiting) {
//                   return const Center(child: CircularProgressIndicator());
//                 }

//                 if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//                   return const Center(child: Text('No messages yet.'));
//                 }

//                 final messages = snapshot.data!.docs;
//                 return ListView.builder(
//                   itemCount: messages.length,
//                   itemBuilder: (context, index) {
//                     final messageData =
//                         messages[index].data() as Map<String, dynamic>;
//                     final isMe =
//                         messageData['senderEmail'] == _auth.currentUser!.email;
//                     return ChatBubble(
//                       isMe: isMe,
//                       message: messageData['message'],
//                     );
//                   },
//                 );
//               },
//             ),
//           ),
//           _buildMessageInput(),
//         ],
//       ),
//     );
//   }

//   // Build message input field
//   Widget _buildMessageInput() {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
//       color: Colors.grey[200],
//       child: Row(
//         children: [
//           Expanded(
//             child: TextField(
//               controller: _messageController,
//               decoration: const InputDecoration(
//                 hintText: 'Type your message...',
//                 border: InputBorder.none,
//               ),
//             ),
//           ),
//           IconButton(
//             icon: const Icon(Icons.send),
//             onPressed: _sendMessage,
//           ),
//         ],
//       ),
//     );
//   }

//   // Send message to the restaurant
//   void _sendMessage() async {
//     if (_messageController.text.isEmpty) return;

//     final currentUser = _auth.currentUser!;
//     final message = _messageController.text.trim();

//     // Create a message object
//     final messageData = {
//       'senderID': currentUser.uid,
//       'senderEmail': currentUser.email,
//       'receiverEmail': restaurantEmail,
//       'message': message,
//       'timestamp': Timestamp.now(),
//     };

//     // Create a unique chat room ID with the restaurant user
//     List<String> ids = [currentUser.uid, restaurantEmail];
//     ids.sort();
//     String chatRoomID = ids.join('_');

//     // Save message to Firestore
//     await _firestore
//         .collection('chat_rooms')
//         .doc(chatRoomID)
//         .collection('messages')
//         .add(messageData);

//     // Clear the input field after sending the message
//     _messageController.clear();
//   }

//   // Get message stream between customer and restaurant
//   Stream<QuerySnapshot> _getMessagesStream() {
//     final currentUser = _auth.currentUser!;
//     List<String> ids = [currentUser.uid, restaurantEmail];
//     ids.sort();
//     String chatRoomID = ids.join('_');

//     return _firestore
//         .collection('chat_rooms')
//         .doc(chatRoomID)
//         .collection('messages')
//         .orderBy('timestamp', descending: false)
//         .snapshots();
//   }
// }

// // Chat bubble widget for message display
// class ChatBubble extends StatelessWidget {
//   final bool isMe;
//   final String message;

//   const ChatBubble({super.key, required this.isMe, required this.message});

//   @override
//   Widget build(BuildContext context) {
//     return Align(
//       alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
//       child: Container(
//         margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
//         padding: const EdgeInsets.all(10),
//         decoration: BoxDecoration(
//           color: isMe ? Colors.blue[200] : Colors.grey[300],
//           borderRadius: BorderRadius.circular(10),
//         ),
//         child: Text(
//           message,
//           style: const TextStyle(fontSize: 16),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CustomerChatScreen extends StatefulWidget {
  const CustomerChatScreen({super.key});

  @override
  _CustomerChatScreenState createState() => _CustomerChatScreenState();
}

class _CustomerChatScreenState extends State<CustomerChatScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _messageController = TextEditingController();

  final String restaurantUID =
      'gVFEvC2Q8JaASh7a7pOSZ7I3C3o1'; // Use restaurant UID instead of email

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat with Restaurant'),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _getMessagesStream(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text('No messages yet.'));
                }

                final messages = snapshot.data!.docs;
                return ListView.builder(
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final messageData =
                        messages[index].data() as Map<String, dynamic>;
                    final isMe =
                        messageData['senderID'] == _auth.currentUser!.uid;
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
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      color: Colors.grey[200],
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: const InputDecoration(
                hintText: 'Type your message...',
                border: InputBorder.none,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: _sendMessage,
          ),
        ],
      ),
    );
  }

  // Send message to the restaurant
  void _sendMessage() async {
    if (_messageController.text.isEmpty) return;

    final currentUser = _auth.currentUser!;
    final message = _messageController.text.trim();
    final chatRoomID = _generateChatRoomId(currentUser.uid, restaurantUID);

    try {
      // Reference to the chat room document
      DocumentReference chatRoomDoc =
          _firestore.collection('chat_rooms1').doc(chatRoomID);

      // Check if the chat room document exists
      DocumentSnapshot chatRoomSnapshot = await chatRoomDoc.get();

      // If chat room doesn't exist, create it with chatRoomId and basic info
      if (!chatRoomSnapshot.exists) {
        await chatRoomDoc.set({
          'chatRoomId': '${currentUser.uid}_$restaurantUID',
          'users': [currentUser.uid, restaurantUID],
          'lastMessage': message,
          'lastUpdated': FieldValue.serverTimestamp(),
        });
      }

      // Create a message object
      final messageData = {
        'senderID': currentUser.uid,
        'senderEmail': currentUser.email,
        'receiverID': restaurantUID,
        'message': message,
        'timestamp': Timestamp.now(),
      };

      // Save message to the messages sub-collection
      await chatRoomDoc.collection('messages').add(messageData);

      // Clear the input field after sending the message
      _messageController.clear();
    } catch (e) {
      print('Error sending message: $e');
    }
  }

  // Get message stream between customer and restaurant
  Stream<QuerySnapshot> _getMessagesStream() {
    final currentUser = _auth.currentUser!;
    final chatRoomID = _generateChatRoomId(currentUser.uid, restaurantUID);

    return _firestore
        .collection('chat_rooms1')
        .doc(chatRoomID)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots();
  }

  // Helper method to generate a consistent chat room ID
  String _generateChatRoomId(String senderUid, String receiverUid) {
    List<String> sortedUids = [senderUid, receiverUid]..sort();
    return '${sortedUids[0]}';
  }
}

// Chat bubble widget for message display
class ChatBubble extends StatelessWidget {
  final bool isMe;
  final String message;

  const ChatBubble({super.key, required this.isMe, required this.message});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: isMe ? Colors.blue[200] : Colors.grey[300],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          message,
          style: const TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}
