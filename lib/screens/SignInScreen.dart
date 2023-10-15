import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import '../Widgets/GoogleSignInButton.dart';
import '../const.dart';
import '../utils/gSignOutSignIn.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueAccent,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(
            left: 16.0,
            right: 16.0,
            bottom: 20.0,
          ),
          child: Center(
            child: Column(
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(
                        flex: 1,
                        child: Image.asset(
                          'images/logo.png',
                          height: 160,
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'Flutter Calendar',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 40,
                        ),
                      ),
                    ],
                  ),
                ),
                FutureBuilder(
                  future: Firebase.initializeApp(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Text('Error initializing Firebase');
                    } else if (snapshot.connectionState ==
                        ConnectionState.done) {
                      return Column(
                        children: [
                          GoogleSignInButton(),
                          TextButton(
                            onPressed: () {
                              signOut(context);
                            },
                            style: googleBtnStyle,
                            child: const Padding(
                              padding: EdgeInsets.all(10),
                              child: Text(
                                'Google SignOut',
                                style: SignInTxtStyle,
                              ),
                            ),
                          )
                        ],
                      );
                    }
                    return progressIndication;
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
