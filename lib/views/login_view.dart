import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:learn_flutter/auth/auth_firebase.dart';
import 'package:learn_flutter/constants/routes.dart';
import 'package:learn_flutter/my-icons/twitter_icon.dart';
import 'dart:developer';

enum Provider { google, facebook, twitter }

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
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
    void handleLogin({required context, required provider}) async {
      log('Start login with $provider ...');
      final authentication = Authentication();
      try {
        late final UserCredential userCredential;
        switch (provider) {
          case Provider.google:
            userCredential =
                await authentication.signInWithGoogle(context: context);
            break;
          case Provider.facebook:
            userCredential =
                await authentication.signInWithFacebook(context: context);
            break;
          case Provider.twitter:
            userCredential =
                await authentication.signInWithTwitter(context: context);
            break;
          default:
            log('No provider was provided');
            break;
        }

        log(userCredential.user.toString());
        if (userCredential.user != null) {
          Navigator.of(context)
              .pushNamedAndRemoveUntil(notesRoute, (_) => false);
        }
      } on FirebaseAuthException catch (e) {
        log(e.code);
      } catch (e) {
        log('Something went wrong...');
        log(e.toString());
      }
    }

    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: const BoxDecoration(
            image: DecorationImage(
                opacity: 0.5,
                image: NetworkImage(
                    'https://images.pexels.com/photos/733852/pexels-photo-733852.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2'),
                fit: BoxFit.cover)),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          const Text(
            'Login',
            style: TextStyle(
                color: Colors.purple,
                fontSize: 36,
                fontWeight: FontWeight.bold,
                fontFamily: 'Monsterrat'),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Container(
              alignment: Alignment.center,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(5),
                    child: SizedBox(
                      width: 250,
                      height: 50,
                      child: ElevatedButton.icon(
                        onPressed: () => handleLogin(
                            context: context, provider: Provider.google),
                        icon: Image.network(
                          'https://upload.wikimedia.org/wikipedia/commons/thumb/5/53/Google_%22G%22_Logo.svg/800px-Google_%22G%22_Logo.svg.png',
                          width: 20,
                          height: 20,
                          fit: BoxFit.contain,
                        ),
                        label: const Text('Continue with Google'),
                        style: ElevatedButton.styleFrom(
                            primary: const Color.fromARGB(255, 105, 210, 109)),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(5),
                    child: SizedBox(
                      width: 250,
                      height: 50,
                      child: ElevatedButton.icon(
                        onPressed: () => handleLogin(
                            context: context, provider: Provider.facebook),
                        icon: const Icon(Icons.facebook_sharp),
                        label: const Text('Continue with Facebook'),
                        style: ElevatedButton.styleFrom(
                            primary: const Color.fromARGB(255, 86, 122, 206)),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(5),
                    child: SizedBox(
                      width: 250,
                      height: 50,
                      child: ElevatedButton.icon(
                        onPressed: () => handleLogin(
                            context: context, provider: Provider.twitter),
                        icon: const Icon(TwitterIcon.twitterBird),
                        label: const Text('Continue with Twitter'),
                        style: ElevatedButton.styleFrom(
                            primary: const Color.fromARGB(255, 86, 206, 156)),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 8),
            child: SizedBox(
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
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 8),
            child: SizedBox(
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
          ),
          Padding(
            padding: const EdgeInsets.all(0),
            child: SizedBox(
              width: 300,
              height: 50,
              child: ElevatedButton(
                  onPressed: () async {
                    final email = _email.text;
                    final password = _password.text;

                    try {
                      await FirebaseAuth.instance.signInWithEmailAndPassword(
                          email: email, password: password);

                      Navigator.of(context)
                          .pushNamedAndRemoveUntil(notesRoute, (_) => false);
                    } on FirebaseException catch (e) {
                      if (e.code == 'user-not-found') {
                        await showErrorDialog(context, 'User not found');
                      } else if (e.code == 'wrong-password') {
                        await showErrorDialog(context, 'Wrong password');
                      } else {
                        await showErrorDialog(context, 'Error: ${e.code}');
                      }
                    } catch (e) {
                      await showErrorDialog(context, 'Error: $e.toString()');
                    }
                  },
                  child: const Text(
                    'Login',
                    style: TextStyle(fontSize: 20),
                  )),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pushNamedAndRemoveUntil(
                registerRoute,
                (_) => false,
              );
            },
            child: const Text('Not registered yet? Register here'),
          )
        ]),
      ),
    );
  }
}

Future<void> showErrorDialog(BuildContext context, String message) async {
  return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(''),
          content: Text(message),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK')),
          ],
        );
      });
}
