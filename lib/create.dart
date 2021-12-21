import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mon_ami/messages.dart';

import 'dart:convert';

import 'create.dart';
import 'package:http/http.dart' as http;
import 'dart:developer';
import 'main.dart';

class login extends StatefulWidget {
  @override
  _loginState createState() => _loginState();
}

class _loginState extends State<login> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '',
      debugShowCheckedModeBanner: false,
      theme: new ThemeData(scaffoldBackgroundColor: const Color(0xFFEFEFEF)),
      home: const loginPage(title: ''),
    );
  }
}

class loginPage extends StatefulWidget {
  const loginPage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<loginPage> createState() => _loginPageState();
}

class _loginPageState extends State<loginPage> {

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  Future<Login>? _futureLogin;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 100, vertical: 16),
              child: Image.asset('chat.png',width: 300, height: 200, fit: BoxFit.fill),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 100, vertical: 16),
              child: TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: 'Emailadress',
                ),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 100, vertical: 16),
              child: TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: 'Passeword',
                ),
              ),
            ),
            Container(
                margin: EdgeInsets.only(top: 40),
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _futureLogin = LoginUser(_emailController.text ,_passwordController.text);
                    });
                  },
                  child: Text('Log in '),
                  style: ElevatedButton.styleFrom(
                      primary: Colors.orange[800], shape: StadiumBorder()),
                )),
            Container(
                margin: EdgeInsets.only(top: 40),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Second()),
                    );
                  },
                  child: Text('Create an account '),
                  style: ElevatedButton.styleFrom(
                      primary: Colors.greenAccent[600], shape: StadiumBorder()),
                ))
          ],
        ),
      ),
    );
  }
  

  Future<Login> LoginUser(String email,String password) async {
    final response = await http.post(
      Uri.parse('http://localhost:3000/api/login'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      Login login = Login.fromJson(jsonDecode(response.body ));
      if(login.login != "FAILED"){
        Navigator.push(context,MaterialPageRoute(builder: (context) => ChatInputField()));
        return Login(DESC: "",login: "",token: "");
      }else{
        return Login.fromJson(jsonDecode(response.body ));
      }      
    } else {
      throw Exception('Failed to Login.');
    }
  }
}


class Second extends StatefulWidget {
  const Second({Key? key}) : super(key: key);

  @override
  State<Second> createState() => SecondRoute();
}


class SecondRoute extends State<Second> {

  final TextEditingController _firstnameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  Future<User>? _futureUser;

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
            const Padding(
               padding: EdgeInsets.fromLTRB(0, 20, 150, 0),
              child: Text(
                'Sign Up',
                style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
              )
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 100, vertical: 16),
              child: TextFormField(
                controller: _firstnameController,
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: 'Firstname',
                ),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 100, vertical: 16),
              child: TextFormField(
                controller: _lastNameController,

                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: 'Lastname',
                ),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 100, vertical: 16),
              child: TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: 'Emailadress',
                ),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 100, vertical: 16),
              child: TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: 'Passeword',
                ),
              ),
            ),
            Container(
                margin: EdgeInsets.only(top: 20),
                child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    _futureUser = createUser(_firstnameController.text ,_lastNameController.text ,_emailController.text ,_passwordController.text);
                  });
                },
                child: Text('Register'),
                style: ElevatedButton.styleFrom(
                primary: Colors.orange[800], shape: StadiumBorder()),
              )),
              const Padding(
                padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                child: Text(
                  'Alrady have an account?Sign Up',
              )
            ),
          ],
        ),
      ),
    );
  }


  Future<User> createUser(String nom, String prenom,String email,String password) async {
    log('inside the function');

    final response = await http.post(
      Uri.parse('http://localhost:3000/api/signup'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'nom': nom,
        'prenom': prenom,
        'email': email,
        'password': password,
      }),
    );
    if (response.statusCode == 200) {
      return User.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to create User.');
    }
  }
}

class thirdRoute extends StatelessWidget {
  const thirdRoute({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('My Profile'),
          backgroundColor: Colors.orange[800],
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ChatInputField()));
              },
              child: const Text('chat'),
            ),
          ],
        ),
        body: Column(
          children: [
            Image.asset("myprofil.png"),
          ],
        ));
  }
}



class User {
  final int id;
  final String nom;
  final String prenom;
  final String email;
  final String password;

  User({required this.id, required this.nom,required this.prenom,required this.email,required this.password });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      nom: json['nom'],
      prenom: json['prenom'],
      email: json['email'],
      password: json['password'],
    );
  }
}

class Login {
  final String DESC;
  final String login;
  final String token;


  Login({required this.DESC,required this.login,required this.token });

  factory Login.fromJson(Map<String, dynamic> json) {
    return Login(
      DESC: json['DESC'],
      login: json['login'],
      token: json['token'],

    );
  }
}