// Function to sign out the user
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'CalenderAuth.dart';

Future<void> FirebaseLogin(googleUser) async {
  FirebaseAuth auth = FirebaseAuth.instance;

  if (googleUser != null) {
    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleUser.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );

    try {
      await auth.signInWithCredential(credential);
    } catch (e) {
      print(e);
    }
  }
}

Future<void> signOut(BuildContext context) async {
  try {
    if (googleSignIn.currentUser != null) {
      googleSignIn.disconnect();
      googleSignIn.signOut();
    }
    await FirebaseAuth.instance.signOut();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Signed Out for App',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: Color(0xFF0C54BE),
      ),
    );
  } catch (e) {
    print('Error during sign-out: $e');
  }
}
