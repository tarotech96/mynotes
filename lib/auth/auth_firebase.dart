import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:twitter_login/twitter_login.dart';

class Authentication {
  /// Login with google account
  Future<UserCredential> signInWithGoogle(
      {required BuildContext context}) async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a credential from the access token
    final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken, idToken: googleAuth?.idToken);

    // return the user credential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  /// Login in with facebook account
  Future<UserCredential> signInWithFacebook(
      {required BuildContext context}) async {
    // Trigger the sign-in flow
    final LoginResult result = await FacebookAuth.instance.login();

    // Create a credential from the access token
    final OAuthCredential facebookAuthCredential =
        FacebookAuthProvider.credential(result.accessToken?.token ?? '');

    // return the user credential
    return await FirebaseAuth.instance
        .signInWithCredential(facebookAuthCredential);
  }

  /// Login with twitter account
  Future<UserCredential> signInWithTwitter(
      {required BuildContext context}) async {
    // Create a twitter login instance
    final twitterLogin = TwitterLogin(
        apiKey: dotenv.env['TWITTER_API_KEY'] ?? '',
        apiSecretKey: dotenv.env['TWITTER_SECRET_KEY'] ?? '',
        redirectURI: dotenv.env['TWITTER_REDIRECT_URI'] ?? '');

    // Trigger the sign-in flow
    final result = await twitterLogin.login();

    // Create a credential from the accesst token
    final twitterAuthCredential = TwitterAuthProvider.credential(
        accessToken: result.authToken!, secret: result.authTokenSecret!);

    // return the user credential
    return await FirebaseAuth.instance
        .signInWithCredential(twitterAuthCredential);
  }

  /// Singn out
  Future<void> signOut({required BuildContext context}) async {
    // final GoogleSignIn googleSignIn = GoogleSignIn();
    // await googleSignIn.signOut();
    return await FirebaseAuth.instance.signOut();
  }
}
