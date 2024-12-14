import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:talks/components.dart';
import 'package:talks/servercontroll.dart';
import 'package:talks/home.dart';
import 'classstructures.dart';
import 'main.dart';


String result = '';
class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  @override
  void dispose() {
    email.dispose();
    password.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      appBar: AppBar(title: Text('Login Placeholder')),
      body: Center(
        child: Container(
          width: 350,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
                 SizedBox(
                  height: 25,
                  width: 350,
                  child: Text(
                    result,
                    textAlign: TextAlign.start,
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              const SizedBox(height: 10), //Gap
              SizedBox(
                height: 50,
                width: 350,
                child: TextField(
                  controller: email,
                  decoration: const InputDecoration(
                    labelText: 'Digita ae',
                    border: OutlineInputBorder(), // Borda do TextField
                    filled: true, // Campo preenchido
                    fillColor: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 10), //Gap
              SizedBox(
                height: 50,
                width: 350,
                child: TextField(
                  controller: password,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Digita ae dnv',
                    border: OutlineInputBorder(), // Borda do TextField
                    filled: true, // Campo preenchido
                    fillColor: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 10), //Gap
              SizedBox(
                height: 30,
                width: 350,
                child: Center(
                    child: GestureDetector(
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => RegisterPage()),
                    );
                    print('Texto clicado!');
                  },
                  child: Text(
                    'Register Here',
                    style: TextStyle(
                        color: Colors.blue,
                        fontSize: 20,
                        decoration: TextDecoration.underline),
                  ),
                )),
              ),
              const SizedBox(height: 10), //Gap
              SizedBox(
                height: 50,
                width: 250,
                child: ElevatedButton(
                    onPressed: () async{
                      result = await login(context, email.text, password.text) ;
                      setState(() {

                      });

                    },
                    child: Text('Login')),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class RegisterPage extends StatefulWidget {
  bool FrontEndValidation(String password1, String password2) {
    if (password1 != password2 ||
        password1.characters.contains(' ') ||
        password2.characters.contains(' ')) return false;
    return true;
  }

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  TextEditingController email = TextEditingController();
  TextEditingController password1 = TextEditingController();
  TextEditingController password2 = TextEditingController();
  @override
  void dispose() {
    email.dispose();
    password1.dispose();
    password2.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      appBar: AppBar(title: Text('Login Placeholder')),
      body: Center(
        child: Container(
          width: 350,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
                 SizedBox(
                  height: 25,
                  width: 350,
                  child: Text(
                    result,
                    textAlign: TextAlign.start,
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              const SizedBox(height: 10), //Gap
              SizedBox(
                height: 50,
                width: 350,
                child: TextField(
                  controller: email,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(), // Borda do TextField
                    filled: true, // Campo preenchido
                    fillColor: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 10), //Gap

              const SizedBox(height: 10), //Gap
              SizedBox(
                height: 50,
                width: 350,
                child: TextField(
                  controller: password1,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Digita ae dnv',
                    border: OutlineInputBorder(), // Borda do TextField
                    filled: true, // Campo preenchido
                    fillColor: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 10),

              SizedBox(
                height: 50,
                width: 350,
                child: TextField(
                  controller: password2,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Digita ae dnv',
                    border: OutlineInputBorder(), // Borda do TextField
                    filled: true, // Campo preenchido
                    fillColor: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 10), //Gap

              SizedBox(
                height: 30,
                width: 350,
                child: Center(
                    child: GestureDetector(
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => LoginPage()),
                    );
                    print('Texto clicado!');
                  },
                  child: Text(
                    'Tem uma conta? Login',
                    style: TextStyle(
                        color: Colors.blue,
                        fontSize: 20,
                        decoration: TextDecoration.underline),
                  ),
                )),
              ),
              const SizedBox(height: 10), //Gap

              SizedBox(
                height: 50,
                width: 250,
                child: ElevatedButton(
                    onPressed: () async{


                       if(password1.text == password2.text)
                         result = await register(context, email.text, password1.text) as String;
                       else
                         result = "Passwords do not match";
                       setState(() {

                       });

                    },
                    child: Text('Register')),
              )
            ],
          ),
        ),
      ),
    );
  }
}
Future<void> writeLoginToken(String email, String password) async {
  final documents = await getApplicationDocumentsDirectory();
  String directory = '${documents.path}/talksTemp';
  final dir = Directory(directory);

  if (!await dir.exists()) {
    await dir.create(recursive: true);
    print('Diretório criado: $directory');
  }

  final file = File('$directory/tok.txt');

  Map<String, String> credentials = {
    'email': email,
    'password': password
  };

  String content = json.encode(credentials);

  await file.writeAsString(content, mode: FileMode.write);
  print("Dados de login salvos com sucesso.");
}

Future<Map<String, String>> getLoginToken() async {
  final documents = await getApplicationDocumentsDirectory();
  String directory = '${documents.path}/talksTemp/tok.txt';
  final file = File(directory);

  if (await file.exists()) {
    String content = await file.readAsString();

    Map<String, String> credentials = Map<String, String>.from(json.decode(content));

    return credentials;
  } else {
    return {};
  }
}


Future<String> login(BuildContext context, String email, String password) async {
  try {
      userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

    await writeLoginToken(email, password);


    UserInfoClass? user = await getUser(userCredential!.user!.uid.toString());
    currentUser = user!;
    myServers = currentUser.servers;
    print("Numero de Servers == "+ myServers.length.toString());

    result = '';
     Navigator.pushReplacement(
       context,
       MaterialPageRoute(builder: (context) => ServerCreate()),
     );

    return "Login Sucessfuly";
  } on FirebaseAuthException catch (e) {
    String errorMessage;

    switch (e.code) {
      case 'user-not-found':
        errorMessage = "No user found for that email. Please check and try again.";
        break;
      case 'wrong-password':
        errorMessage = "Incorrect password. Please try again.";
        break;
      case 'invalid-email':
        errorMessage = "The email address is not valid.";
        break;
      default:
        errorMessage = e.message ?? "An unknown error occurred.";
    }

    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage))
    );

    return errorMessage;
  }
}

Future<String> register(
    BuildContext context, String email, String password) async {
  try {
    UserCredential _userCredential = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);
    await writeLoginToken(email, password);

    firstUse = true;
    print(firstUse);
    if (firstUse) {
      userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      print("Ativou");
      User? user = _userCredential.user;

      UserInfoClass userInf = UserInfoClass(name: '', role: '', accountDate: '', privateChats: [], tasks: [], servers: [], id: '');
      if (user != null) {
        DocumentReference userRef = FirebaseFirestore.instance.collection('users').doc(user.uid.toString());
        userInf.name = "user_" + _userCredential.user!.uid.toString();
        userInf.accountDate = DateTime.now().toString();
        userInf.id = user.uid.toString();

        currentUser = userInf;
        await userRef.set(userInf.toJson(), SetOptions(merge: true));
      }
      result = '';

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => ServerCreate()),
      );
    }
    return "User Registered";
  } on FirebaseAuthException catch (e) {
    String errorMessage;

    switch (e.code) {
      case 'email-already-in-use':
        errorMessage = "The email address is already in use by another account.";
        break;
      case 'weak-password':
        errorMessage = "The password is too weak. Please choose a stronger password.";
        break;
      case 'invalid-email':
        errorMessage = "The email address is not valid.";
        break;
      default:
        errorMessage = e.message ?? "Unknown error occurred.";
    }

    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage))
    );

    return errorMessage;
  }

}
