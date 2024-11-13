import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:talks/classstructures.dart';
import 'package:talks/home.dart';
import 'package:talks/main.dart';
import 'package:uuid/uuid.dart';

class ServerCreate extends StatefulWidget {
  ServerCreateState createState() => ServerCreateState();
}

void FirstUse(BuildContext context) {
  showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
              height: 400,
              width: 500,
              color: Colors.indigo,
              child: Column(
                children: [
                  Text("Nice to meet, Welcome to Talks, let's start"),
                  ElevatedButton(
                      onPressed: () =>
                      {Navigator.pop(context), NextValue(context)},
                      child: Text("Next"))
                ],
              )),
        );
      });
}

Future<void> NextValue(BuildContext context) async {
  TextEditingController controller = TextEditingController();

  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        child: Container(
          height: 400,
          width: 500,
          color: Colors.indigo,
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Type your name:",
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
              SizedBox(height: 16),
              TextField(
                controller: controller,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  if (controller.text.isNotEmpty) {
                    DocumentReference docUsers = FirebaseFirestore.instance
                        .collection('users')
                        .doc(currentUser.id);
                    UserInfoClass? info = await getUser(currentUser.id);
                    if (info == null) return;
                    info.name = controller.text;

                    Map<String, dynamic> updatedJson = info.toJson();
                    await docUsers.set(updatedJson, SetOptions(merge: true));
                    currentUser.name = controller.text;
                    controller.text = '';

                    Navigator.pop(context); // Fecha o diálogo
                  }
                },
                child: Text("Set"),
              ),
            ],
          ),
        ),
      );
    },
  );
}

class ServerCreateState extends State<ServerCreate> {
  @override
  void initState() {
    super.initState();
    print("AAAAAAAAAA");
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (firstUse) {
        FirstUse(context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Stack(
        children: [
          Center(
            child: SizedBox(
              height: 60,
              width: (myServers.length + 1) * 60,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: myServers.length + 1,
                itemBuilder: (context, index) {
                  return ServerOption(index: index);
                },
              ),
            ),
          ),
          Positioned(
            bottom: 10,
            left: 10,
            child: IconButton(
              icon: Icon(Icons.refresh, size: 40, color: Colors.blue),
              onPressed: () {
                setState(() {});
              },
            ),
          ),
        ],
      ),
    );
  }
}

class ServerOption extends StatefulWidget {
  final int index;

  const ServerOption({super.key, required this.index});

  @override
  ServerOptionState createState() => ServerOptionState();
}

class ServerOptionState extends State<ServerOption> {
  List<String>? channels = [];
  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
        child: widget.index < myServers.length
            ? FloatingActionButton(
            onPressed: () async =>
            {
              currentServer = myServers[widget.index],
              serverChannels = await getChannels(),
              setState(() {
                GetServerUsers();
                print(serverUsers);
              }),
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => HomePage()),
                    (Route<dynamic> route) => false,
              ),
            },
            child: Icon(Icons.search))
            : FloatingActionButton(
            onPressed: () =>
            {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return Dialog(
                      backgroundColor: Colors.transparent,
                      child: Container(
                        width: 400,
                        height: 500,
                        decoration: BoxDecoration(
                          color: Colors.indigo,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Column(
                          children: [
                            //Placeholder
                            TextField(
                              decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.white),
                              controller: controller,
                            ),
                            ElevatedButton(
                                onPressed: () async =>
                                {
                                  await createServerFirestore(
                                      controller.text),
                                  Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            HomePage()),
                                        (Route<dynamic> route) => false,
                                  )
                                },
                                child: Text("Create New Server"))
                          ],
                        ),
                      ),
                    );
                  })
            },
            child: Icon(Icons.add)));
  }
}

Future<void> createServerFirestore(String serverName) async {
  ServerInfo info = ServerInfo(
      serverName: serverName, creationDate: DateTime.now().toString());
  var uuid = Uuid();
  String uniqueId = uuid.v4();
  CollectionReference server = FirebaseFirestore.instance
      .collection('servers')
      .doc('servers')
      .collection(uniqueId);
  CollectionReference users = FirebaseFirestore.instance
      .collection('servers')
      .doc('servers')
      .collection(uniqueId)
      .doc('users')
      .collection('serverUsers');
  DocumentReference serverInfo = FirebaseFirestore.instance
      .collection('servers')
      .doc('servers')
      .collection(uniqueId)
      .doc('info');

  await server.add({'initialized': true});
  await serverInfo.set(info.toJson());
  List<String> initialChannels = ["Home", "Work-In-Progress", "Finished"];
  for (int i = 0; i < 3; i++) {
    DocumentReference docs = FirebaseFirestore.instance
        .collection('servers')
        .doc('servers')
        .collection(uniqueId)
        .doc("channels")
        .collection("channels")
        .doc(initialChannels[i]);
    docs.set({'initialized': true});
  }
  serverChannels = initialChannels;

  if (userCredential != null) {
    DocumentReference userRef = FirebaseFirestore.instance
        .collection('users')
        .doc(userCredential!.user!.uid);
    UserInfoClass? info = await getUser(userCredential!.user!.uid);
    //print('Saporra funcionou' + userRef.toString());
    info!.servers.add(uniqueId);
    info.role = 'admin';
    currentUser.role = 'admin';
    currentServer = uniqueId;
    Map<String, dynamic> updatedJson = info.toJson();

    await userRef.set(updatedJson, SetOptions(merge: true));
    await users
        .doc(userCredential!.user!.uid)
        .set({'user': userCredential!.user!.uid});
    await GetServerUsers();
    // await users.add({'role': 'admin'});
  } else {
    await users.add({'user': "1"});
  }
}

Future<List<String>> getChannels() async {
  try {
    print("Current");
    print(currentServer.toString());
    CollectionReference serversCollection = FirebaseFirestore.instance
        .collection('servers')
        .doc('servers')
        .collection(currentServer)
        .doc("channels")
        .collection("channels");

    QuerySnapshot querySnapshot = await serversCollection.get();
    print("Valor == " + querySnapshot.docs.length.toString());
    for (int i = 0; i < querySnapshot.docs.length; i++) {
      print(i);
    }

    List<String> serverChannelsT =
    querySnapshot.docs.map((doc) => doc.id).toList();

    print("Valores_" + currentServer + "_" + serverChannelsT.length.toString());
    serverChannels = serverChannelsT;
    print("Finalizou");
    return serverChannelsT;
  } catch (e) {
    print(e);
  }
  return [];
}

Future<void> GetServerUsers() async {
  print("Ativa rapariga");
  try {
    CollectionReference serversCollection = FirebaseFirestore.instance
        .collection('servers')
        .doc('servers')
        .collection(currentServer)
        .doc('users')
        .collection('serverUsers');

    QuerySnapshot querySnapshot = await serversCollection.get();
    List<String> users = await querySnapshot.docs.map((doc) {
      return doc.id;
    }).toList();

    List<UserInfoClass> inf = [];
    for (int i = 0; i < users.length; i++) {
      UserInfoClass? userInfo = await getUser(users[i]);

      if (userInfo != null) {
        print(userInfo.name);
        inf.add(userInfo);
      }
      ;
    }
    serverUsers = inf;
    print(serverUsers);
  } catch (e) {
    print(e);
  }
  return;
}

Future<int> UserAddServer(String UserId) async {
  try {
    DocumentReference docUsers =
    FirebaseFirestore.instance.collection('users').doc(UserId);

    UserInfoClass? info = await getUser(UserId);
    if (info == null) return 2;
    if (!info!.servers.contains(currentServer)) {
      info!.servers.add(currentServer);
      info.role = 'developer';
      Map<String, dynamic> updatedJson = info.toJson();
      await docUsers.set(updatedJson, SetOptions(merge: true));
    } else {
      return 1;
    }
  } catch (e) {
    print("Deu Erro");
  }
  return 0;
}
