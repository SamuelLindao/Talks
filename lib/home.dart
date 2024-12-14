import 'dart:core';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:talks/servercontroll.dart';
import 'classstructures.dart';
import 'components.dart';
import 'messagesprivate.dart';
import 'main.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePage createState() => _HomePage();
}

class _HomePage extends State<HomePage> with TickerProviderStateMixin {
  late TabController? _controller;
  late ScrollController _scrollController;

  Future<void> createChannel(String channelName) async {
    try {
      DocumentReference channelRef = FirebaseFirestore.instance
          .collection('servers')
          .doc('servers')
          .collection(currentServer)
          .doc("channels")
          .collection("channels")
          .doc(channelName);

      DocumentSnapshot snapshot = await channelRef.get();
      if (!snapshot.exists) {
        await channelRef.set({'initialized': true});
        serverChannels = await getChannels();
      } else {
        print("O canal já existe.");
      }
    } catch (e) {
      print("Erro ao criar canal: $e");
    }
  }

  bool _showTasks = true;
  TextEditingController newChatController = TextEditingController();
  TextEditingController newTaskController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  MessageClass msg = MessageClass();

  String _userName = currentUser.name; // Placeholder
  String _role = currentUser.role; // Placeholder
  UserInfoClass? info = UserInfoClass(
      name: "name",
      role: "role",
      accountDate: "accountDate",
      tasks: [],
      servers: [],
      privateChats: [],
      id: "id");
  DocumentReference userRef = FirebaseFirestore.instance
      .collection('users')
      .doc(userCredential!.user!.uid);

  @override
  void initState() {
    super.initState();
    print(serverChannels);
    print('Talvez Tenha funcionado');
    _scrollController = ScrollController();
    _focusNode.requestFocus();
    setState(() {
      currentChannel = serverChannels.length != 0 ? serverChannels[0] : '';
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      scrollToEnd();
    });
  }

  void createPrivateChat(int index) async {
    // for (int i = 0; i < serverUsers[index].privateChats.length; i++) {
    //   if (!serverUsers[index].privateChats[i].contains(currentUser.id)) {
    //     info = await getUser(serverUsers[index].id);
    //     info!.privateChats.add(currentUser.id + "_" + serverUsers[index].id);
    //     userRef = FirebaseFirestore.instance
    //         .collection('users')
    //         .doc(serverUsers[index].id);
    //     Map<String, dynamic> updatedJson = info!.toJson();
    //     await userRef.set(updatedJson, SetOptions(merge: true));
    //
    //     info = await getUser(currentUser.id);
    //     info!.privateChats.add(currentUser.id + "_" + serverUsers[index].id);
    //     userRef =
    //         FirebaseFirestore.instance.collection('users').doc(currentUser.id);
    //     Map<String, dynamic> updatedJsonA = info!.toJson();
    //     await userRef.set(updatedJsonA, SetOptions(merge: true));
    //     currentUser = info!;
    //
    //     currentChannel =
    //         currentServer = currentUser.id + "_" + serverUsers[index].id;
    //
    //     print("i dont know the result");
    //   } else {
    //     print("i know the result");
    //     currentChannel = currentServer = serverUsers[index]
    //         .privateChats
    //         .firstWhere((chat) => chat.contains(currentUser.id));
    //   }
    // }
  }

  @override
  void dispose() {
    _controller!.dispose();
    _scrollController.dispose();
    _focusNode.dispose();
    newChatController.dispose();

    super.dispose();
  }

  void scrollToEnd() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 1),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // Canal lateral
          Column(
            children: [
              Expanded(
                child: Container(
                  width: 250,
                  color: Colors.blue,
                  child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('servers')
                        .doc('servers')
                        .collection(currentServer)
                        .doc("channels")
                        .collection("channels")
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        var newServerChannels = snapshot.data!.docs.map((doc) {
                          return doc.id;
                        }).toList();

                        if (newServerChannels != serverChannels) {
                          serverChannels = newServerChannels;
                            _controller = TabController(
                                length: serverChannels.length, vsync: this);
                        }
                        ;
                      }

                      return ListView.builder(
                        itemCount: currentUser.role == 'admin'
                            ? serverChannels.length + 1
                            : serverChannels.length,
                        itemBuilder: (context, index) {
                          return index < serverChannels.length
                              ? ChatOption(
                                  onTap: () async {
                                    currentChannel = serverChannels[index];
                                    print(serverChannels[index]);
                                    setState(() {
                                      _controller!.animateTo(index);
                                    });
                                    scrollToEnd();
                                  },
                                  MyText: serverChannels[index],
                                )
                              : ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        CupertinoColors.inactiveGray,
                                    shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.zero),
                                  ),
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext contextA) {
                                        return Dialog(
                                          backgroundColor: Colors.transparent,
                                          child: Container(
                                            height: 150,
                                            width: 400,
                                            color: Colors.teal,
                                            alignment: Alignment.center,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                const Text("Chat name"),
                                                const SizedBox(height: 16),
                                                TextField(
                                                  controller: newChatController,
                                                  decoration:
                                                      const InputDecoration(
                                                    filled: true,
                                                    fillColor: Colors.white,
                                                  ),
                                                ),
                                                const SizedBox(height: 16),
                                                ElevatedButton(
                                                  onPressed: () async {
                                                    await createChannel(
                                                        newChatController.text);
                                                    setState(() {});
                                                    newChatController.text = '';
                                                    Navigator.pop(contextA);
                                                  },
                                                  child: const Text("Create"),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  },
                                  child: Container(
                                    height: 50,
                                    alignment: Alignment.center,
                                    child: const Text('Create New Chat'),
                                  ),
                                );
                        },
                      );
                    },
                  ),
                ),
              ),
              // Usuário e Configurações
              Container(
                height: 125,
                width: 250,
                color: Colors.blueGrey,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        IconButton(
                          iconSize: 50,
                          onPressed: () {
                            Clipboard.setData(
                                ClipboardData(text: currentUser.id));
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("ID copied!"),
                                duration:
                                    Duration(seconds: 2), // Duração do SnackBar
                              ),
                            );
                          },
                          icon: const Icon(Icons.import_contacts),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [Text(_userName), Text(_role)],
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {},
                            child: const Row(
                              children: [
                                Icon(Icons.verified_user),
                                Text('Profile'),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {},
                            child: const Row(
                              children: [
                                Icon(Icons.settings),
                                Text("Settings"),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          // Chat principal
          Expanded(
            child: Container(
              child: Column(
                verticalDirection: VerticalDirection.down,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Barra superior de tarefas e mensagens
                  Column(
                    children: [
                      Container(
                        height: 35,
                        color: Colors.amberAccent,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            ElevatedButton(
                              onPressed: () async {
                                currentUser =
                                    await getUser(userCredential!.user!.uid) ??
                                        UserInfoClass(
                                            name: "name",
                                            role: "role",
                                            accountDate: "accountDate",
                                            tasks: [],
                                            servers: [],
                                            privateChats: [],
                                            id: "id");
                                myServers = currentUser.servers;

                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ServerCreate()),
                                );
                              },
                              child: Icon(Icons.exit_to_app),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  _showTasks = !_showTasks;
                                });
                              },
                              child:
                                  const Icon(Icons.task, color: Colors.white),
                              style: ButtonStyle(
                                backgroundColor:
                                    WidgetStateProperty.all(Colors.red),
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                currentChannel =
                                    currentServer = currentUser.privateChats[0];
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => MessagesPage(),
                                  ),
                                );
                              },
                              style: ButtonStyle(
                                backgroundColor:
                                    WidgetStateProperty.all(Colors.indigo),
                              ),
                              child: const Icon(Icons.message,
                                  color: Colors.white),
                            ),
                            if (currentUser.role == 'admin')
                              ElevatedButton(
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return ShowAddUserDialog(
                                        onTap: () {
                                          setState(() {
                                            GetServerUsers();
                                          });
                                        },
                                      );
                                    },
                                  );
                                },
                                style: ButtonStyle(
                                  backgroundColor:
                                      WidgetStateProperty.all(Colors.green),
                                ),
                                child:
                                    const Icon(Icons.add, color: Colors.white),
                              ),
                          ],
                        ),
                      ),
                      if (_showTasks)
                        Container(
                          height: 115,
                          color: Colors.green,
                        ),
                    ],
                  ),
                  // Lista de mensagens
                  Expanded(
                    child: StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('servers')
                          .doc('servers')
                          .collection(currentServer)
                          .doc("channels")
                          .collection("channels")
                          .doc(currentChannel)
                          .collection('messages')
                          .where('channel', isEqualTo: currentChannel)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                          return const Center(child: Text('No messages'));
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
                            .sort((a, b) => a.TimeSpan.compareTo(b.TimeSpan));

                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          scrollToEnd();
                        });

                        return TabBarView(
                          controller: _controller ?? null,
                          children: List.generate(
                            serverChannels.length,
                            (index) {
                              return ListView.builder(
                                controller: _scrollController,
                                itemCount: messagesList.length,
                                itemBuilder: (context, index) {
                                  return Align(
                                    alignment: Alignment.centerLeft,
                                    child: MessageCase(
                                      onTap: () {
                                        setState(() {
                                          replyingText =
                                              messagesList[index].Message;
                                        });
                                      },
                                      messageClass: messagesList[index],
                                      index: index,
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ),
                  // Campo de input de mensagens
                  MessageInput(
                    state: () {
                      setState(() {
                        scrollToEnd();
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
          // Barra lateral de usuários
          Container(
              width: 200,
              color: Colors.tealAccent,
              child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('servers')
                      .doc('servers')
                      .collection(currentServer)
                      .doc("users")
                      .collection("serverUsers")
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      Future.wait(snapshot.data!.docs.map((doc) async {
                        return await getUser(doc.id);
                      })).then((newUsers) {
                        List<UserInfoClass> updatedUsers =
                            newUsers.whereType<UserInfoClass>().toList();

                        if (!listEquals(serverUsers, updatedUsers)) {
                          serverUsers = updatedUsers;
                        }
                      });
                    }

                    print(serverUsers);
                    return ListView.builder(
                      itemCount: serverUsers.length,
                      itemBuilder: (context, index) {
                        return UserProfilePreview(
                          onTap: () {
                            if (serverUsers[index].id != currentUser.id) {
                              showDialog(
                                context: context,
                                builder: (BuildContext contextA) {
                                  return Dialog(
                                    backgroundColor: Colors.transparent,
                                    child: Container(
                                      width: 325,
                                      height: 550,
                                      padding: const EdgeInsets.all(20),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      child: Column(
                                        children: [
                                          Column(
                                            children: [
                                              const Icon(Icons.verified_user,
                                                  size: 75),
                                              Text(serverUsers[index].name),
                                              Text(serverUsers[index].role),
                                            ],
                                          ),
                                          const SizedBox(height: 20),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              if (currentUser.role == 'admin')
                                                ElevatedButton(

                                                onPressed: () {
                                                  showDialog(
                                                    context: contextA,
                                                    builder: (BuildContext contextB)
                                                      {
                                                        return Dialog(
                                                          backgroundColor:  Colors.transparent,
                                                          child: Container(
                                                            width: 325,
                                                            height: 250,
                                                            padding: const EdgeInsets.all(20),
                                                            decoration: BoxDecoration(
                                                              color: Colors.white,
                                                              borderRadius: BorderRadius.circular(15)
                                                            ),
                                                            child: Column(
                                                             children: [
                                                               Text("Task Name"),
                                                               TextField(
                                                                 controller: newTaskController,
                                                               )
                                                             ],
                                                            ),
                                                          ),
                                                        );

                                                      }
                                                  );
                                                },
                                                child: const Row(
                                                  children: [
                                                    Icon(Icons.add),
                                                    Text("Add Task")
                                                  ],
                                                ),
                                              ),
                                              ElevatedButton(
                                                onPressed: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          MessagesPage(),
                                                    ),
                                                  );
                                                },
                                                child: const Row(
                                                  children: [
                                                    Icon(Icons.chat),
                                                    Text("Chat User")
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 20),
                                          Expanded(
                                            child: Container(
                                              color: Colors.lightBlue,
                                              child: ListView.builder(
                                                itemCount: serverUsers[index]
                                                    .tasks
                                                    .length,
                                                itemBuilder: (context, indexA) {
                                                  return TaskCase(
                                                      task: serverUsers[index]
                                                          .tasks[indexA]);
                                                },
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              );
                            } else {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return Dialog(
                                    backgroundColor: Colors.transparent,
                                    child: Container(
                                      color: Colors.green,
                                      width: 200,
                                      height: 200,
                                      child: const Center(
                                        child: Text('This is you bro!'),
                                      ),
                                    ),
                                  );
                                },
                              );
                            }
                          },
                          user: serverUsers[index],
                        );
                      },
                    );
                  })),
        ],
      ),
    );
  }
}
