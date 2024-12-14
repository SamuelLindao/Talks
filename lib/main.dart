import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'classstructures.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'initial.dart';
import 'package:tray_manager/tray_manager.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';

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
ConnectivityResult? connectivityResult;
//Problema da ErrorPage() para resolver.
class MyAppState extends State<MyApp> with TrayListener{
  late StreamSubscription<List<ConnectivityResult>> subscription;

  @override
  void initState() {
    super.initState();
    _initializeTray();

    subscription = Connectivity().onConnectivityChanged.listen((List<ConnectivityResult> resultList) {
        connectivityResult = resultList.isNotEmpty ? resultList.first : ConnectivityResult.none;
        print(connectivityResult);

      });

  }

  Future<void> _initializeTray() async {
    trayManager.addListener(this);
    await trayManager.setIcon('assets/app_icon.png');
    await trayManager.setToolTip('Meu App');
    await trayManager.setContextMenu(Menu(items: [
      MenuItem(key: 'show', label: 'Mostrar'),
      MenuItem(key: 'exit', label: 'Sair'),
    ]));
  }


  @override
  void dispose() {
    trayManager.removeListener(this);
    subscription.cancel();
    super.dispose();
  }


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
        home:   InitialScreen() ) ;
  }
  @override
  void onTrayIconMouseDown() {
    appWindow.show();
  }

  @override
  void onTrayMenuItemClick(MenuItem menuItem) {
    if (menuItem.key == 'show') {
      appWindow.show();
    } else if (menuItem.key == 'exit') {
      appWindow.close();
    }
  }
}

