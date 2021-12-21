
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'create.dart';

class user_info extends StatefulWidget {
  const user_info({Key? key}) : super(key: key);

  @override
  State<user_info> createState() => user_info_route();
}

class user_info_route extends State<user_info> {

  final TextEditingController _age = TextEditingController();
  final TextEditingController _sexe = TextEditingController();
  final TextEditingController _telephone = TextEditingController();
  final TextEditingController _adresse = TextEditingController();
  Future<UserInfo>? _futureUserInfo;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 100, vertical: 16),
              child: Image.asset('chat.png',
                  width: 300, height: 200, fit: BoxFit.fill),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 20, 150, 0),
              child: Text(
                'Sign Up',
                style: const TextStyle(
                    fontSize: 50, fontWeight: FontWeight.bold),
              )
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 100, vertical: 16),
              child: TextFormField(
                controller: _age,
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: 'Votre Age',
                ),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 100, vertical: 16),
              child: TextFormField(
                controller: _adresse,

                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: 'Adresse',
                ),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 100, vertical: 16),
              child: TextFormField(
                controller: _telephone,
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: 'Telephone',
                ),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 100, vertical: 16),
              child: TextFormField(
                controller: _sexe,
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: 'Sexe',
                ),
              ),
            ),
            Container(
                margin: EdgeInsets.only(top: 20),
                child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    _futureUserInfo = createUserInfo(_age.text ,_adresse.text ,_telephone.text ,_sexe.text);
                  });
                },
                child: Text('Register'),
                style: ElevatedButton.styleFrom(
                primary: Colors.orange[800], shape: StadiumBorder()),
              )),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                child: Text(
                  'Alrady have an account?Sign Up',
              )
            ),
          ],
        ),
      ),
    );
  }


  Future<UserInfo> createUserInfo(String age, String adresse,String telephone,String sexe) async {
    log('inside the function');

    final response = await http.post(
      Uri.parse('http://localhost:3000/api/signup'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'age': age,
        'adresse': adresse,
        'telephone': telephone,
        'sexe': sexe,
      }),
    );
    // ignore: avoid_print
    print(response.body);
    log(response.body);

    if (response.statusCode == 200) {
      return UserInfo.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to create User.');
    }
  }
}
class UserInfo {
  final int id;
  final String age;
  final String adresse;
  final String telephone;
  final String sexe;

  UserInfo({required this.id, required this.age,required this.adresse,required this.telephone,required this.sexe });

  factory UserInfo.fromJson(Map<String, dynamic> json) {
    return UserInfo(
      id: json['id'],
      age: json['age'],
      adresse: json['adresse'],
      telephone: json['telephone'],
      sexe: json['sexe'],
    );
  }
}
