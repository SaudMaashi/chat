import 'package:chat/components/message_bubble.dart';
import 'package:chat/models/sender_model.dart';
import 'package:chat/screens/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});
  static String id = "chat";
  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  // ignore: unused_field
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  final TextEditingController textController = TextEditingController();

  String message = "";
  List<int> messagesList = [];
  CollectionReference messages =
      FirebaseFirestore.instance.collection("messages");
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection("messages")
          .orderBy("createdAt")
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasData) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.lightBlueAccent,
              automaticallyImplyLeading: false,
              elevation: 0,
              actions: [
                IconButton(
                  onPressed: () async {
                    await _firebaseAuth.signOut();
                    // ignore: use_build_context_synchronously
                    Navigator.pushNamed(context, HomeScreen.id);
                  },
                  icon: const Icon(
                    Icons.logout,
                  ),
                )
              ],
            ),
            body: Column(
              children: [
                Expanded(
                  child: ListView(
                    children: [
                      ...snapshot.data!.docs.map(
                        (DocumentSnapshot document) {
                          Map<String, dynamic> data =
                              document.data()! as Map<String, dynamic>;
                          return Padding(
                            padding: const EdgeInsets.all(10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Text(
                                  data["email"],
                                  textAlign: _firebaseAuth.currentUser!.email ==
                                          data["email"]
                                      ? TextAlign.start
                                      : TextAlign.end,
                                ),
                                MessageBubble(
                                  message: data["message"],
                                  isTheMessanger:
                                      _firebaseAuth.currentUser!.email ==
                                          data["email"],
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                Container(
                  color: Colors.white,
                  width: double.infinity,
                  height: 50,
                  child: TextField(
                    controller: textController,
                    onChanged: (value) {
                      message = value;
                    },
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.send),
                        onPressed: () {
                          if (message != "") {
                            messages.add(
                              {
                                "message": message,
                                "createdAt": DateTime.now(),
                                "email": Provider.of<SenderModel>(context,
                                        listen: false)
                                    .email,
                              },
                            );
                            messagesList.add(1);
                            textController.clear();
                          }
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }
}
