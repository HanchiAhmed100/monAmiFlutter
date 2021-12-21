import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../../constants.dart';
import 'create.dart';

class ChatInputField extends StatefulWidget {
  const ChatInputField({Key? key}) : super(key: key);

  @override
  _ChatInputFieldState ChatInputFieldState() => _ChatInputFieldState();

  @override
  State<StatefulWidget> createState() => _ChatInputFieldState();
}

class _ChatInputFieldState extends State<ChatInputField> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(scaffoldBackgroundColor: const Color(0xFFEFEFEF)),
      home: const ChatInputFieldPage(title: ''),
    );
  }
}

class ChatInputFieldPage extends StatefulWidget {
  const ChatInputFieldPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<ChatInputFieldPage> createState() => _ChatInputFieldPageState();
}

class _ChatInputFieldPageState extends State<ChatInputFieldPage> {
  final TextEditingController _messageController = TextEditingController();
  List<dynamic>? messages;

  @override
  void initState() {
    super.initState();
    _getMessages();
  }

  _buildRow(int index) {
    return Text("message : ");
  }

  _getMessages() async {
    final response =
        await http.get(Uri.parse('http://localhost:3000/api/chat/8'));
    print("***********************");
    print(response.body);
    log(response.body);
    print("***********************");

    if (response.statusCode == 200) {
      List<dynamic> newMessages = json
          .decode(response.body)
          .map((data) => Message.fromJson(data))
          .toList();
      setState(() {
        messages = newMessages;
      });
    } else {
      throw Exception('Failed to create User.');
    }
  }

  createMessage(String message) async {
    final response = await http.post(
      Uri.parse('http://localhost:3000/api/signup'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'userText': message,
      }),
    );
    if (response.statusCode == 200) {
      _getMessages();
    } else {
      throw Exception('Failed to create User.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Row(children: [
            Expanded(
                child: SizedBox(
                    height: 200, // constrain height
                    child: ListView.builder(
                        padding: const EdgeInsets.all(8),
                        itemCount: messages?.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Container(
                            height: 50,
                            child: Center(
                                child:
                                    Text('MSG : ${messages?[index].message}')),
                          );
                        })))
          ]),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: kDefaultPadding,
                  vertical: kDefaultPadding / 2,
                ),
                decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  boxShadow: [
                    BoxShadow(
                      offset: const Offset(0, 4),
                      blurRadius: 32,
                      color: const Color(0xFF087949).withOpacity(0.08),
                    ),
                  ],
                ),
                child: SafeArea(
                  child: Row(
                    children: [
                      const Icon(Icons.camera_alt_outlined,
                          color: kPrimaryColor),
                      const SizedBox(width: kDefaultPadding),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: kDefaultPadding * 0.75,
                          ),
                          decoration: BoxDecoration(
                            color: kPrimaryColor.withOpacity(0.05),
                            borderRadius: BorderRadius.circular(40),
                          ),
                          child: Row(
                            children: [
                              const SizedBox(width: kDefaultPadding / 4),
                              Expanded(
                                child: TextField(
                                  controller: _messageController,
                                  decoration: const InputDecoration(
                                    hintText: "Type message",
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                              SizedBox(width: kDefaultPadding / 4),
                              IconButton(
                                icon: const Icon(Icons.send),
                                color: Theme.of(context)
                                    .textTheme
                                    .bodyText1!
                                    .color!
                                    .withOpacity(0.64),
                                onPressed:
                                    createMessage(_messageController.text),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          )
        ],
      ),
    ));
  }
}

class Message {
  final int id;
  final String message;
  final bool msgType;
  final bool seen;
  final String createdAt;
  final String updatedAt;
  final int userId;

  Message(
      {required this.id,
      required this.message,
      required this.seen,
      required this.msgType,
      required this.createdAt,
      required this.updatedAt,
      required this.userId});

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'],
      message: json['message'],
      msgType: json['msgType'],
      seen: json['seen'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      userId: json['userId'],
    );
  }
}
