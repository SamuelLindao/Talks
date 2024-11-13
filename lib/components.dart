import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:talks/servercontroll.dart';
import 'main.dart';
import 'classstructures.dart';
import 'package:talks/MsgCase.dart';
import 'apiservice.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';

class UserProfilePreview extends StatefulWidget {
  final VoidCallback onTap;

  final UserInfoClass user;
  final bool showRole;

  const UserProfilePreview(
      {super.key,
      required this.user,
      required this.onTap,
      this.showRole = true});

  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfilePreview> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        widget.onTap();
      },
      child: Container(
        height: 70,
        color: Colors.amberAccent,
        child: Row(
          children: [
            Icon(
              size: 50,
              Icons.ice_skating,
            ),
            SizedBox(width: 10), // Espaço entre o ícone e o texto
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.user.name),
                if (widget.showRole) Text(widget.user.role),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ChatOption extends StatefulWidget {
  final VoidCallback onTap;
  final String MyText;

  const ChatOption({super.key, required this.onTap, required this.MyText});

  @override
  _ChatOptionState createState() => _ChatOptionState();
}

class _ChatOptionState extends State<ChatOption> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: () {
          widget.onTap();
        },
        style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero)),
        child: Container(
          height: 50,
          alignment: Alignment.center,
          child: Text(widget.MyText),
        ));
  }
}

class MessageCase extends StatefulWidget {
  final VoidCallback onTap;
  final MessageClass messageClass;
  final int index;

  const MessageCase(
      {super.key, required this.onTap, required this.messageClass, required this.index});

  @override
  _MessageCaseState createState() => _MessageCaseState();
}

enum SampleItem { itemOne, itemTwo, itemThree }

class _MessageCaseState extends State<MessageCase> {
  SampleItem? selectedItem;

  bool ShortTime()
  {
   // print( (messagesList[widget.index].TimeSpan - messagesList[widget.index - 1].TimeSpan));
    if(messagesList.isEmpty) return true;
    if(messagesList.length == 1) return true;
    if(widget.index < 1)return true;
    if(messagesList[widget.index].Owner == messagesList[widget.index - 1].Owner &&  (messagesList[widget.index].TimeSpan - messagesList[widget.index - 1].TimeSpan) < 180000) {
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      child: Column(children: [
        if (widget.messageClass.Reply != '')
          Row(
            children: [
              Expanded(
                  child: Container(
                alignment: Alignment.centerLeft,
                color: Colors.green,
                height: 50,
                width: double.infinity,
                child: Text(
                    style: TextStyle(fontWeight: FontWeight.bold),
                    widget.messageClass.Reply),
              )),
            ],
          ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            (ShortTime() || widget.messageClass.Reply != '')?
              Container(
              child: IconButton(
                onPressed: () {},
                padding: EdgeInsets.all(5),
                icon: Icon(size: 40, Icons.usb),
              ),
            ): IconButton(
              onPressed: () {},
              padding: EdgeInsets.all(5),
              icon: Icon(size: 40, null),
            ),
            SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 10),
                  if(ShortTime()|| widget.messageClass.Reply != '')
                    Row(
                    children: [
                      Text(
                        widget.messageClass.Owner,
                        textAlign: TextAlign.start,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(width: 10,),
                      Text(
                          style: TextStyle(fontWeight: FontWeight.w100),
                          textAlign: TextAlign.start,
                          widget.messageClass.Time)
                    ],
                  ),
                  Text(
                    widget.messageClass.Message,
                    textAlign: TextAlign.start,
                    maxLines: 2,
                  ),
                  SizedBox(height: 10),
                ],
              ),
            ),
            SizedBox(width: 8),
            Container(
                child: PopupMenuButton<SampleItem>(
              initialValue: selectedItem,
              onSelected: (SampleItem item) {
                setState(() {
                  selectedItem = item;
                });
              },
              itemBuilder: (BuildContext context) =>
                  <PopupMenuEntry<SampleItem>>[
                const PopupMenuItem<SampleItem>(
                  value: SampleItem.itemOne,
                  child: Text('Sem Ideia'),
                ),
                PopupMenuItem<SampleItem>(
                  value: SampleItem.itemTwo,
                  onTap: () => {
                    setState(() {
                      widget.onTap();
                    })
                  },
                  child: Text('Reply'),
                ),
                const PopupMenuItem<SampleItem>(
                  value: SampleItem.itemThree,
                  child: Text('Opção 3'),
                )
              ],
            )),
          ],
        ),
      ]),
    );
  }
}


class InputChatArea extends StatefulWidget {
  final TextEditingController input;
  final List<String> messages;

  const InputChatArea({super.key, required this.input, required this.messages});

  @override
  InputChatState createState() => InputChatState();
}

class InputChatState extends State<InputChatArea> {
  Widget build(BuildContext context) {
    return Row(children: [
      Expanded(
        child: TextField(
          controller: widget.input,
          decoration: InputDecoration(
              labelText: 'Type your text',
              border: OutlineInputBorder(),
              fillColor: Colors.white,
              filled: true),
        ),
      ),
      IconButton(
          onPressed: () => {
                setState(() {
                  widget.messages.add(widget.input.text);
                  widget.input.text = "";
                })
              },
          icon: const Icon(
            Icons.send,
            color: Colors.white,
          ))
    ]);
  }
}

class MessageInput extends StatefulWidget {
  final VoidCallback state;

  const MessageInput({super.key, required this.state});

  @override
  MessageInputState createState() => MessageInputState();
}

class MessageInputState extends State<MessageInput>
    with SingleTickerProviderStateMixin {
  MessageClass msg = MessageClass();
  TextEditingController _input = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  //final apiService = ApiService('http://localhost:5082');
  File? _selectedFile;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false,
    );

    if (result != null && result.files.single.path != null) {
      setState(() {
        _selectedFile = File(result.files.single.path!);
        print(_selectedFile!.path.toString());
      });
    } else {
      print('Nenhum arquivo selecionado.');
    }
  }

  Future<void> sendMessage() async {
    if(_input.text.isEmpty) return;
    MessageClass msg = MessageClass();
    msg.Message = _input.text;
    msg.Reply = replyingText;
    msg.Owner = currentUser.name;


    _input.clear();
    replyingText = '';
    _focusNode.requestFocus();

    widget.state();
    //Preciso refazer a logica de enviar imagens
    //print(_selectedFile!.path.toString() + "Essa caminho");

    MsgCase item = MsgCase(
      server: currentServer,
      channel: currentChannel,
      owner: currentUser.name,
      message: msg.Message,
      reply: msg.Reply,
    );
    //await apiService.createItem(item);

    if(_selectedFile!=null&& await _selectedFile!.exists())
    {
      try {
        String filePath = 'images/${DateTime.now()}.png';
          await _storage.ref().child(filePath).putFile(_selectedFile!);
      }
      catch(e)
      {
        print("Errado : " + e.toString());
      }

    }

    await item.saveToFirestore();
    _selectedFile=null;
    messagesList.add(msg);
  }

  @override
  void initState() {
    super.initState();
    _focusNode.requestFocus();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 100 ,
        color: Colors.black26,
        child: Column(
          children: [
            if(_selectedFile != null)
            Expanded(
              child: Container(
                width: double.infinity,
                height: 100,
                color: Colors.orange,
                alignment: Alignment.centerLeft,
                child: Image.file(_selectedFile!)
              ),
            ),
            if (replyingText != '')
              Expanded(
                child: Container(
                  width: double.infinity,
                  height: 100,
                  color: Colors.green,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    replyingText,
                    textAlign: TextAlign.start,
                  ),
                ),
              ),
            const SizedBox(
              height: 10,
            ),
            Row(children: [
              Expanded(
                child: TextField(
                  focusNode: _focusNode,
                  controller: _input,
                  onSubmitted: (value) {
                    setState(() {
                      sendMessage();
                    });
                  },
                  decoration: const InputDecoration(
                    labelText: 'Type your text',
                    border: OutlineInputBorder(),
                    fillColor: Colors.white,
                  ),
                ),
              ),
              IconButton(onPressed:()=>{
                  _pickFile()
              }, icon: Icon(Icons.attach_file, color: Colors.white,)),
              IconButton(
                  onPressed: () => {
                        setState(() {
                          msg.Message = _input.text;
                          msg.Reply = replyingText;

                          msg.Owner = 'SamuelRx';
                          messagesList.add(msg);
                          msg = MessageClass();
                          _focusNode.requestFocus();
                          replyingText = '';
                          _input.text = '';
                          widget.state();
                        })
                      },
                  icon: Icon(
                    Icons.send,
                    color: Colors.white,
                  )),

            ]),
          ],
        ));
  }
}

class SugestOption extends StatefulWidget {
  final String name;

  const SugestOption({super.key, required this.name});

  @override
  SugestOptionState createState() => SugestOptionState();
}

class SugestOptionState extends State<SugestOption> {
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(8.0),
        child: Row(
          children: [
            Icon(Icons.house_rounded),
            Text(widget.name),
          ],
        ));
  }
}

class TaskCase extends StatefulWidget {
  final TasksClass task;

  const TaskCase({super.key, required this.task});

  @override
  TaskCaseState createState() => TaskCaseState();
}

class TaskCaseState extends State<TaskCase> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      alignment: Alignment.centerLeft,
      color: Colors.amber[600],
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
              alignment: Alignment.center,
              width: 75,
              height: 60,
              color: Colors.greenAccent,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(widget.task.taskName),
                  Text(widget.task.taskStart == ''
                      ? '00/00/00'
                      : widget.task.taskStart),
                ],
              )),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                alignment: Alignment.center,
                color: Colors.greenAccent,
                height: 15,
                width: 210,
                child: LinearProgressIndicator(
                  minHeight: 15,
                  value: 1,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(widget.task.taskProgress.toString().padLeft(2, '0')),
                  Text("/"),
                  Text(widget.task.taskProgress.toString().padLeft(2, '0')),
                ],
              )
            ],
          )
        ],
      ),
    );
  }
}

class CardUser extends StatefulWidget {
  @override
  CardUserState createState() => CardUserState();
}

class CardUserState extends State<CardUser> {
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      elevation: 5,
    );
  }
}
class ShowAddUserDialog extends StatefulWidget {
  final VoidCallback onTap;

  ShowAddUserDialog({required this.onTap});

  @override
  _ShowAddUserDialogState createState() => _ShowAddUserDialogState();
}

class _ShowAddUserDialogState extends State<ShowAddUserDialog> {
  int currentState = -1;
  String? textToShow;
  TextEditingController controller = TextEditingController();
  CollectionReference users = FirebaseFirestore.instance
      .collection('servers')
      .doc('servers')
      .collection(currentServer)
      .doc('users')
      .collection('serverUsers');

  @override
  void initState() {
    super.initState();
    // Defina o texto com base no currentState
    setState(() {
      switch (currentState) {
        case -1:
          textToShow = '';
          break;
        case 0:
          textToShow = 'User Successfully added';
          break;
        case 1:
          textToShow = 'User is already on the server';
          break;
        case 2:
          textToShow = 'User Not Found';
          break;
          case 3:
        textToShow = 'Loading';
        break;
        default:
          textToShow = 'Unknown Error';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: 300,
        height: 150,
        color: Colors.green,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(textToShow ?? 'Loading...'),
            Text("User Id:", textAlign: TextAlign.start),
            SizedBox(
              width: 280,
              child: TextField(
                controller: controller,
                decoration: const InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                setState(() {
                  currentState = 3;

                });
                await users.doc(controller.text).set({'user': controller.text});
                // Atualiza o currentState com base no sucesso da operação
                int result = await UserAddServer(controller.text);
                setState(() {
                  currentState = result;
                  textToShow = _getTextForState(currentState);
                });
                print("Successfully Added_" + serverUsers.toString() + "_"+ currentState.toString() + controller.text);
                widget.onTap();

              },
              child: Text("Add User"),
            ),
          ],
        ),
      ),
    );
  }

  String _getTextForState(int state) {
    switch (state) {
      case -1:
        return '';
      case 0:
        return 'User Successfully added';
      case 1:
        return 'User is already on the server';
      case 2:
        return 'User Not Found';
      default:
        return 'Unknown Error';
    }
  }
}