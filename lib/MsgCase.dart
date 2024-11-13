import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:talks/main.dart';

class MsgCase {
  final String? id;
  final String server;
  final String channel;
  final String owner;
  final String message;

  final int? datespan;
  final String reply;

  MsgCase({this.id,required this.server, required this.channel, required this.owner, required this.message, required this.reply, this.datespan});

  factory MsgCase.fromJson(Map<String, dynamic> json) {
    return MsgCase(
      id: json['id'] as String?,
      server: json['server'] as String,
      channel: json['channel'] as String,
      owner: json['owner'] as String,
      message: json['message'] as String,
      datespan: json['dateSpan'] as int?,
      reply: json['reply'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'server':server,
      'channel':channel,
      'owner': owner,
      'message': message ,
      'datespan': datespan ?? DateTime.now().millisecondsSinceEpoch,
      'reply': reply,
    };
  }
  Future<void> saveToFirestore() async {
    CollectionReference messages = FirebaseFirestore.instance
        .collection('servers').doc('servers')
        .collection(currentServer)
        .doc("channels").collection("channels")
        .doc(currentChannel)
        .collection('messages');
    DocumentReference docRef = await messages.add(this.toJson());
    await docRef.update({'id': docRef.id});
    }
}
