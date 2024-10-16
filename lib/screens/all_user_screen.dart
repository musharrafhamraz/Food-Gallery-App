// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// import 'package:foodapp/screens/restaurant_chat_screen.dart';
import 'package:foodapp/widgets/background_widget.dart';

class AllUserScreen extends StatefulWidget {
  const AllUserScreen({super.key});

  @override
  _AllUserScreenState createState() => _AllUserScreenState();
}

class _AllUserScreenState extends State<AllUserScreen> {
  // final FirebaseAuth _auth = FirebaseAuth.instance;
  // final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  // User? _currentUser;
  // List<String> usersWithMessages = [];

  // @override
  // void initState() {
  //   super.initState();
  //   _authenticateUser();
  // }

  // // Authenticate the current user
  // void _authenticateUser() async {
  //   _currentUser = _auth.currentUser;
  //   if (_currentUser == null) {
  //     // If the user is not authenticated, redirect to the login screen
  //     Navigator.of(context).pushReplacementNamed('/login');
  //   } else {
  //     print('Authenticated user: ${_currentUser!.email}');
  //     fetchUsersWithMessages();
  //   }
  // }

  // // Fetch users who have exchanged messages with the current user
  // void fetchUsersWithMessages() async {
  //   try {
  //     String currentUserId = _currentUser!.uid;
  //     print('Fetching chat rooms for user ID: $currentUserId');

  //     // Fetch chat rooms where the current user is involved
  //     final chatRoomsSnapshot = await _firestore
  //         .collection('chat_rooms1')
  //         .where('users', arrayContains: currentUserId)
  //         .get();

  //     print('Total chat rooms found: ${chatRoomsSnapshot.docs.length}');

  //     List<String> uniqueUsers = [];

  //     for (var chatRoom in chatRoomsSnapshot.docs) {
  //       print('Processing chat room: ${chatRoom.id}');

  //       final messagesSnapshot =
  //           await chatRoom.reference.collection('messages').get();

  //       print(
  //           'Total messages in chat room ${chatRoom.id}: ${messagesSnapshot.docs.length}');

  //       for (var message in messagesSnapshot.docs) {
  //         final messageData = message.data();
  //         print('Message data: $messageData');

  //         final senderEmail = messageData['senderID'];
  //         final receiverEmail = messageData['receiverID'];

  //         // Add only unique user emails who have chatted with the current user
  //         if (senderEmail != _currentUser!.email &&
  //             !uniqueUsers.contains(senderEmail)) {
  //           print('Adding sender email to list: $senderEmail');
  //           uniqueUsers.add(senderEmail);
  //         } else if (receiverEmail != _currentUser!.email &&
  //             !uniqueUsers.contains(receiverEmail)) {
  //           print('Adding receiver email to list: $receiverEmail');
  //           uniqueUsers.add(receiverEmail);
  //         }
  //       }
  //     }

  //     setState(() {
  //       usersWithMessages = uniqueUsers;
  //     });

  //     if (usersWithMessages.isEmpty) {
  //       print('No users with messages found.');
  //     } else {
  //       print('Users with messages: $usersWithMessages');
  //     }
  //   } catch (e) {
  //     print('Error fetching users with messages: $e');
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chats'),
        centerTitle: true,
        backgroundColor: Colors.orangeAccent, // Foody theme color
        foregroundColor: Colors.white,
      ),
      // body: _currentUser == null
      //     ? const Center(child: CircularProgressIndicator())
      //     : usersWithMessages.isEmpty
      //         ? const Center(child: Text('No users have messaged you yet.'))
      //         : ListView.builder(
      //             itemCount: usersWithMessages.length,
      //             itemBuilder: (context, index) {
      //               return ListTile(
      //                 title: Text(usersWithMessages[index]),
      //                 onTap: () {
      //                   // Navigate to the CustomerChatScreen with the selected user
      //                   Navigator.of(context).push(
      //                     MaterialPageRoute(
      //                       builder: (context) => RestaurantChatScreen(
      //                         customerEmail: usersWithMessages[index],
      //                       ),
      //                     ),
      //                   );
      //                 },
      //               );
      //             },
      //           ),
      body: const BackgroundWidget(
          backgroundImage: Center(
        child: Text(
          'This feature is under development.',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
        ),
      )),
    );
  }
}
