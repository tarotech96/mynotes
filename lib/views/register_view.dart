import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:learn_flutter/constants/routes.dart';
import 'dart:developer';

class RegisterView extends StatefulWidget {
  const RegisterView({Key? key}) : super(key: key);

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: const BoxDecoration(
            image: DecorationImage(
                opacity: 0.5,
                image: NetworkImage(
                    'https://images.pexels.com/photos/1762851/pexels-photo-1762851.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2'),
                fit: BoxFit.cover)),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          const Text(
            'Register',
            style: TextStyle(
                color: Colors.purple,
                fontSize: 36,
                fontWeight: FontWeight.bold,
                fontFamily: 'Monsterrat'),
          ),
          Padding(
            padding: const EdgeInsets.all(4),
            child: Container(
              alignment: Alignment.center,
              child: Column(
                children: [
                  SizedBox(
                    width: 300,
                    height: 50,
                    child: TextField(
                      controller: _email,
                      enableSuggestions: false,
                      autocorrect: false,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                          hintText: 'Enter your email here',
                          border: OutlineInputBorder()),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(4),
            child: Container(
              alignment: Alignment.center,
              child: Column(
                children: [
                  SizedBox(
                    width: 300,
                    height: 50,
                    child: TextField(
                        controller: _password,
                        obscureText: true,
                        enableSuggestions: false,
                        autocorrect: false,
                        keyboardType: TextInputType.visiblePassword,
                        decoration: const InputDecoration(
                            hintText: 'Enter your password here',
                            border: OutlineInputBorder())),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(4),
            child: Container(
              alignment: Alignment.center,
              child: Column(
                children: [
                  SizedBox(
                    width: 300,
                    height: 50,
                    child: ElevatedButton(
                        onPressed: () async {
                          final email = _email.text;
                          final password = _password.text;

                          try {
                            final userCredentials = await FirebaseAuth.instance
                                .createUserWithEmailAndPassword(
                              email: email,
                              password: password,
                            );

                            if (userCredentials.user != null) {
                              Navigator.of(context).pushNamedAndRemoveUntil(
                                  loginRoute, (_) => false);
                            }
                          } on FirebaseAuthException catch (e) {
                            if (e.code == 'weak-password') {
                              log('The password provided is too weak.');
                            } else if (e.code == 'email-already-in-use') {
                              log('The account already exists for that email.');
                            } else if (e.code == 'invalid-email') {
                              log('Invalid email entered.');
                            } else {
                              log(e.code);
                            }
                          }
                        },
                        child: const Text(
                          'Register',
                          style: TextStyle(fontSize: 20),
                        )),
                  ),
                ],
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context)
                  .pushNamedAndRemoveUntil(loginRoute, (route) => false);
            },
            child: const Text('Already registered? Login here'),
          )
        ]),
      ),
    );
  }
}
