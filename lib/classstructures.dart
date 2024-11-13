import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:talks/main.dart';
class TasksClass {
  String taskName;
  String taskDescription;
  String taskStart;
  int taskProgress;
  int taskMax;

  TasksClass({
    required this.taskName,
    this.taskDescription = '',
    this.taskStart = '',
    this.taskProgress = 0,
    this.taskMax = 1,
  });

  Map<String, dynamic> toJson() {
    return {
      'taskName': taskName,
      'taskDescription': taskDescription,
      'taskStart': taskStart,
      'taskProgress': taskProgress,
      'taskMax': taskMax,
    };
  }

  factory TasksClass.fromJson(Map<String, dynamic> json) {
    return TasksClass(
      taskName: json['taskName'],
      taskDescription: json['taskDescription'] ?? '',
      taskStart: json['taskStart'] ?? '',
      taskProgress: json['taskProgress'] ?? 0,
      taskMax: json['taskMax'] ?? 1,
    );
  }
}



class UserInfoClass {
  String name;
  String role;
  String accountDate;
  List<TasksClass> tasks;
  List<String> privateChats;
  List<String> servers;
  String id;

  UserInfoClass({
    required this.name,
    required this.role,
    required this.accountDate,
    required this.tasks,
    required this.servers,
    required this.privateChats,
    required this.id,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'role': role,
      'accountDate': accountDate,
      'tasks': tasks.map((task) => task.toJson()).toList(),
      'friends': privateChats,
      'servers': servers,
      'id': id,
    };
  }

  factory UserInfoClass.fromJson(Map<String, dynamic> json) {
    return UserInfoClass(
      name: json['name'],
      role: json['role'],
      accountDate: json['accountDate'],
      tasks: (json['tasks'] as List)
          .map((task) => TasksClass.fromJson(task))
          .toList(),
      privateChats: List<String>.from(json['friends']),
      servers: List<String>.from(json['servers']),
      id: json['id'],
    );
  }

}
  Future<UserInfoClass?> getUser(String userId) async {
    try {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      if (userDoc.exists) {
        Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
        UserInfoClass userInfo = UserInfoClass.fromJson(userData);
        return userInfo;
      } else {
        print('User not found');
        return null;
      }
    } catch (e) {
      print('Error getting user: $e');
      return null;
    }
  }




List<UserInfoClass> generateRandomUsers(int count) {
  Random random = Random();
  List<UserInfoClass> users = [];

  for (int i = 0; i < count; i++) {
    String name = 'User ${i + 1}';
    String role = random.nextBool() ? 'Admin' : 'User';

    // Gerando uma data de conta válida
    int year = 2020 + random.nextInt(5); // 2020 a 2024
    int month = random.nextInt(12) + 1; // 1 a 12
    int day = random.nextInt(28) +
        1; // 1 a 28 para evitar problemas com dias em meses

    String accountDate =
        '$year-${month.toString().padLeft(2, '0')}-${day.toString().padLeft(2, '0')}';

    // Gerando algumas tarefas aleatórias
    List<TasksClass> tasks = [];
    for (int i = 0; i < random.nextInt(5); i++) {
      tasks.add(TasksClass(taskName: 'Task ${random.nextInt(100)}'));
    }

    // Gerando uma lista aleatória de amigos (IDs)
    List<String> friends =
        List.generate(random.nextInt(5), (index) => random.nextInt(100).toString());

    // Gerando um ID aleatório
    String id = random.nextInt(1000).toString();

    // Adicionando o usuário à lista com os parâmetros corretos
    users.add(UserInfoClass(
      name: name,
      role: role,
      accountDate: accountDate,
      tasks: tasks,
      servers: [],
      privateChats: friends,
      id: id,
    ));
  }

  return users;
}

class MessageClass
{
   String Message = '';
   String Owner = '';
   String Id = '';
   String Time= '';
   int TimeSpan = 0;
   String Reply = '';

}
class ServerInfoId {
  String id = '';
  ServerInfo info = ServerInfo(serverName: '', creationDate: '');
}
class ServerInfo {
  String serverName = '';
  String creationDate = '';

  ServerInfo({
    required this.serverName,
    required this.creationDate,
  });

  Map<String, dynamic> toJson() {
    return {
      'serverName': serverName,
      'creationDate': creationDate,
    };
  }

  factory ServerInfo.fromJson(Map<String, dynamic> json) {
    return ServerInfo(
      serverName: json['serverName'],
      creationDate: json['creationDate'],
    );
  }
}
