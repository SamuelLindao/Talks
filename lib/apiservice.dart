import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:talks/classstructures.dart';
import 'MsgCase.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';




class MessageList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('messages').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        // Criar uma lista de MsgCase a partir dos dados recuperados
        List<MsgCase> msgCases = snapshot.data!.docs.map((DocumentSnapshot document) {
          Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
          return MsgCase.fromJson(data);
        }).toList();

        List<MessageClass> messages = [];
        for (int i = 0; i < msgCases.length; i++) {
          MessageClass msg = MessageClass();
          msg.Message = msgCases[i].message;
          msg.Owner = msgCases[i].owner;
          msg.Id = msgCases[i].id?.toString() ?? '';
          msg.Reply = msgCases[i].reply;
          msg.TimeSpan = msgCases[i].datespan ?? 0;
          messages.add(msg);
        }

        // Renderiza a lista de mensagens
       return Center();
      },
    );
  }
}
