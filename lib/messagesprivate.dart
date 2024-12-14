import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'classstructures.dart';
import 'components.dart';
import 'home.dart';
import 'main.dart';

class MessagesPage extends StatefulWidget {
  @override
  MessagesPageState createState() => MessagesPageState();
}

class MessagesPageState extends State<MessagesPage>
    with SingleTickerProviderStateMixin {
  late TabController _controller;
  final FocusNode _focusNode = FocusNode();
  MessageClass msg = MessageClass();
  @override
  void initState() {
    super.initState();
    print(currentServer);
    _controller = TabController(length: privateChats.length, vsync: this);
    _focusNode.requestFocus();
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  Widget build(BuildContext build) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Messages',
        ),
        centerTitle: true,
        toolbarHeight: 50,
        backgroundColor: Colors.greenAccent,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HomePage()),
            );
          },
        ),
      ),
      body: Row(
        children: [
          Container(
            color: Colors.black45,
            width: 300,
            child: ListView.builder(
                itemCount: privateChats.length,
                itemBuilder: (context, index) {
                  return UserProfilePreview(
                    onTap: () {
                     setState(() {
                       currentChannel = privateChats[index].name;
                       currentServer = privateChats[index].name;
                       _controller.animateTo(index);
                       print("Algo Mudou");
                       print(currentChannel);
                     });
                    },
                    user: privateChats[index],
                    showRole: false,
                  );
                }),
          ),
          Expanded(
              child: Column(
            children: [
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('servers').doc('servers')
                    .collection(currentServer)
                    .doc("channels").collection("channels")
                    .doc(currentChannel)
                    .collection('messages')
                    .where('channel', isEqualTo: currentChannel)
                    .snapshots(),
                builder: (context, snapshot) {

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Expanded(
                        child: Center(child: Text('No messages')));
                  }

                  messagesList = snapshot.data!.docs.map((doc) {
                    var data = doc.data() as Map<String, dynamic>;
                    MessageClass msg = MessageClass();
                    msg.Message = data['message'];
                    msg.Owner = data['owner'];
                    msg.Reply = data['reply'];
                    msg.TimeSpan = data['datespan'];
                    DateTime date =
                        DateTime.fromMillisecondsSinceEpoch(msg.TimeSpan);
                    msg.Time =
                        "${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute}";
                    return msg;
                  }).toList();

                  messagesList
                      .sort((a, b) => a.TimeSpan!.compareTo(b.TimeSpan!));

                  return Expanded(
                    child: TabBarView(
                      controller: _controller,
                      children: List.generate(privateChats.length, (index) {
                        return ListView.builder(
                          itemCount: messagesList.length,
                          itemBuilder: (context, index) {
                            return Align(
                              alignment: Alignment.centerLeft,
                              child: MessageCase(
                                onTap: () {
                                  setState(() {
                                    print("Replying to message");
                                    replyingText = messagesList[index].Message;
                                  });
                                },
                                messageClass: messagesList[index],
                                index: index,
                              ),
                            );
                          },
                        );
                      }),
                    ),
                  );
                },
              ),
              MessageInput(
                state: () => {setState(() {})},
              )
            ],
          ))
        ],
      ),
    );
  }
}
