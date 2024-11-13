import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:talks/MsgCase.dart';
import 'package:talks/servercontroll.dart';
import 'package:talks/home.dart';
import 'classstructures.dart';
import 'messagesprivate.dart';
import 'apiservice.dart';
import 'test.dart';
import 'auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_options.dart';

UserCredential? userCredential;

bool firstUse = false;
String replyingText = '';

List<MessageClass> messagesList = [];
List<String> recoNames = [];

List<String> myServers = [];
String currentServer = 'Esse';
String currentChannel = 'chan';
UserInfoClass currentUser = UserInfoClass(
    name: 'SamuelRx',
    role: 'Eu',
    accountDate: '00/00/00',
    tasks: [],
    privateChats: [],
    servers: [],
    id: "123");
List<String> serverChannels = [
  'Samuel Lindo',
  'Samuel Gostoso',
  'Samuel Existencialista',
  'Samuel Nilista'
];
List<UserInfoClass> serverUsers = [];
List<UserInfoClass> privateChats = [];
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  void updateChannel(String newChannel) {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: LoginPage());
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
