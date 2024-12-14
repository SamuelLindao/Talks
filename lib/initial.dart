import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:talks/servercontroll.dart';
import 'auth.dart';
import 'main.dart';
import 'classstructures.dart';

class InitialScreen extends StatefulWidget
{
  @override
  InitialScreenState createState()=> InitialScreenState();
}
class InitialScreenState extends State<InitialScreen>
{
  int state = 0;
  @override
  void initState()
  {
    super.initState();
    _signInUser();

    print("Iniciou");

  }
  Future<void> _signInUser() async {
    try {
      Map<String, String> credentials = await getLoginToken();

      AuthCredential credential = EmailAuthProvider.credential(email: credentials['email']!, password: credentials['password']!);
      userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
      print(userCredential);

      UserInfoClass? user = await getUser(userCredential!.user!.uid.toString());
      currentUser = user!;
      myServers = currentUser.servers;
      print("Numero de Servers == "+ myServers.length.toString());

      state = 1;
    } catch (e) {
      state = 0;
      print("Login Error: $e");
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => state == 1? ServerCreate() : LoginPage()),
    );
  }
  @override
  Widget build(BuildContext context)
  {
     return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 15,),
              Text("Loading...", style:TextStyle(fontSize: 32))
            ],
          ),
        ),
     );
  }
}