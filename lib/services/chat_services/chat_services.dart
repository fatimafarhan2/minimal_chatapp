import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:minimal_chatapp/models/message.dart';

class Chatservice {
  // Firebase instances
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Get users stream
  Stream<List<Map<String, dynamic>>> getUsersStream() {
    return _firestore.collection("Users").snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return doc.data() as Map<String, dynamic>;
      }).toList();
    });
  }

  // Send messages
  Future<void> send_messages(String receiverID, String message) async {
    // Current user info
    final String currentUserID = _auth.currentUser!.uid;
    final String currentUserEmail = _auth.currentUser!.email!;
    final Timestamp timestamp = Timestamp.now();

    // Create new message instance
    Message newMessage = Message(
      senderID: currentUserID,
      senderEmail: currentUserEmail,
      receiverID: receiverID,
      message: message,
      timestamp: timestamp,
    );

    // Generate chat room ID
    List<String> ids = [currentUserID, receiverID];
    ids.sort();
    String chatRoomID = ids.join('_'); // Ensure underscore for consistency

    // Add message to Firestore
    await _firestore
        .collection("chat_rooms")
        .doc(chatRoomID)
        .collection("messages")
        .add(newMessage.toMap());
  }

  // Get messages stream
  Stream<QuerySnapshot> getmessages(String userId, String otherUserId) {
    List<String> ids = [userId, otherUserId];
    ids.sort();
    String chatRoomID = ids.join('_'); // Ensure underscore for consistency

    return _firestore
        .collection("chat_rooms")
        .doc(chatRoomID)
        .collection("messages")
        .orderBy("timestamp", descending: false)
        .snapshots();
  }
}









// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:minimal_chatapp/models/message.dart';

// class Chatservice {
//   // Get Firebase instance& auth
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   // Get user stream
//   Stream<List<Map<String, dynamic>>> getUsersStream() {
//     return _firestore.collection("Users").snapshots().map((snapshot) {
//       return snapshot.docs.map((doc) {
//         // Cast data to Map<String, dynamic> to avoid type issues
//         final Map<String, dynamic> user = doc.data() as Map<String, dynamic>;
//         return user;
//       }).toList();
//     });
//   }

// //  send messages
//   Future<void> send_messages(String receiverID, String message) async {
//     //get current user info
//     final String currentUserID = _auth.currentUser!.uid;
//     final String currentUserEmail = _auth.currentUser!.email!;
//     //saving time stamp
//     final Timestamp timestamp = Timestamp.now();

//     //crete new messages
//     Message newmessage = Message(
//       senderID: currentUserEmail,
//       senderEmail: currentUserID,
//       receiverID: receiverID,
//       message: message,
//       timestamp: timestamp,
//     );

//     //construct chat room id for two users

//     List<String> ids = [currentUserID, receiverID];
//     ids.sort(); // sort id )(this ensure chat room id is same for 2 peaople)
//     String chatRoomid = ids.join('_');

//     //add new messages to database

//     //storing these ids in chat room collection

//     await _firestore
//         .collection("chat_rooms")
//         .doc(chatRoomid)
//         .collection("messages")
//         .add(newmessage.toMap());
//   }

// // get messages

//   Stream<QuerySnapshot> getmessages(String userId, String otheruserid) {
//     List<String> ids = [userId, otheruserid];
//     ids.sort();
//     String chatRoomid = ids.join();

//     return _firestore
//         .collection("chat_rooms")
//         .doc(chatRoomid)
//         .collection("messages")
//         .orderBy("timestamp", descending: false)
//         .snapshots();
//   }
// }

// // import 'package:cloud_firestore/cloud_firestore.dart';

// // class Chatservice {
// //   //get firebase instance
// //   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
// // //get user stream
// // /*

// // <List<Map<String,dynamic>>=

// // [-------------------List of maps
// // {-------------map1
// // 'email':test@gmail.com
// // 'id': ..
// // }
// // {---------map2
// // 'email':mitch@gmail.com
// // 'id': ..
// // }
// // ]

// // */

// //   Stream<List<Map<String, dynamic>>> getUsersStream() {
// //     return _firestore.collection("Users").snapshots().map((snapshot) {
// //       return snapshot.docs.map((doc) {
// // //we will go through each indivisual user  and just return that user
// //         final user = doc.data();
// //         return user;
// //       }).toList();
// //     });
// //   }
// // }
