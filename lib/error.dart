import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ErrorPage extends StatefulWidget
{
  @override
  ErrorPageState createState() => ErrorPageState();
}


class ErrorPageState extends State<ErrorPage>
{
  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Error!", style: TextStyle(fontSize: 46),),
            SizedBox(height: 5,),

            Text("You got some connection problem :/. Retrying"),
            SizedBox(height: 30,),
            CircularProgressIndicator()
          ],
        ),
      ),
    );
  }
}