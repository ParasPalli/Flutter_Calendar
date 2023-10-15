import 'package:flutter/material.dart';

const progressIndication = CircularProgressIndicator(
  valueColor: AlwaysStoppedAnimation<Color>(
    Colors.orange,
  ),
);

const SignInTxtStyle = TextStyle(
  fontSize: 20,
  color: Colors.black54,
  fontWeight: FontWeight.w600,
);

var googleBtnStyle = ButtonStyle(
  backgroundColor: MaterialStateProperty.all(Colors.white),
  shape: MaterialStateProperty.all(
    RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(40),
    ),
  ),
);
