import 'package:flutter/material.dart';

const progressIndication = CircularProgressIndicator(
  valueColor: AlwaysStoppedAnimation<Color>(
    Colors.orange,
  ),
);

var googleBtnStyle = ButtonStyle(
  backgroundColor: MaterialStateProperty.all(Colors.white),
  shape: MaterialStateProperty.all(
    RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(40),
    ),
  ),
);
