import 'dart:convert';

import 'package:flutter/material.dart';
import 'create.dart';
import 'package:http/http.dart' as http;
import 'dart:developer';

void main() {
  runApp(login());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '',
      theme: new ThemeData(scaffoldBackgroundColor: const Color(0xFFEFEFEF)),
      home: const MyHomePage(title: ''),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _firstnameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  Future<User>? _futureUser;

  void _incrementCounter() {
    setState(() {});
  }

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
                margin:const EdgeInsets.only(top: 20),
                child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    _futureUser = createUser(_firstnameController.text ,_lastNameController.text ,_emailController.text ,_passwordController.text);
                  });
                },
                child: const Text('Register'),
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
      // This trailing comma makes auto-formatting nicer for build methods.
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

  if (response.statusCode == 201) {
    return User.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to create User.');
  }
}


}