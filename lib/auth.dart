import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:talks/components.dart';
import 'package:talks/servercontroll.dart';
import 'package:talks/home.dart';
import 'classstructures.dart';
import 'main.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  bool _showError = false;

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
              if (_showError)
                const SizedBox(
                  height: 25,
                  width: 350,
                  child: Text(
                    'Invalid Login',
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
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => RegisterPage()),
                      (Route<dynamic> route) => false,
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
                    onPressed: () {
                      login(context, email.text, password.text);
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
  bool _showError = false;
  TextEditingController email = TextEditingController();
  TextEditingController password1 = TextEditingController();
  TextEditingController password2 = TextEditingController();

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
              if (_showError)
                const SizedBox(
                  height: 25,
                  width: 350,
                  child: Text(
                    'Invalid Login',
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
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => LoginPage()),
                      (Route<dynamic> route) => false,
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
                    onPressed: () {
                      if (!widget.FrontEndValidation(
                          password1.text, password2.text))
                        setState(() {
                          password1.text = "";
                          password2.text = "";
                          _showError = true;
                        });
                      else {
                        register(context, email.text, password1.text);
                      }
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

Future<int> login(BuildContext context, String email, String password) async {
  try {
    userCredential = await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);
    UserInfoClass? user = await getUser(userCredential!.user!.uid.toString());
    currentUser = user!;
    myServers = currentUser.servers;
    print("Numero de Servers == "+ myServers.length.toString());

    //Mexendo nisso daqui, que sono.
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => ServerCreate()),
      (Route<dynamic> route) => false,
    );

    return 0;
  } on FirebaseAuthException catch (e) {
    if (e.code == 'user-not-found') {
      print('Nenhum usuário encontrado com esse email.');
      return 1;
    } else if (e.code == 'wrong-password') {
      print('Senha incorreta.');
      return 2;
    } else {
      print('Erro: ${e.message}');
      return 3;
    }
  }
}

Future<void> register(
    BuildContext context, String email, String password) async {
  try {
    UserCredential _userCredential = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);
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
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => ServerCreate()),
        (Route<dynamic> route) => false,
      );
    }
  } on FirebaseAuthException catch (e) {
    print("Erro: ${e.message}");
  }
}
