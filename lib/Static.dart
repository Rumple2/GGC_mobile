import 'package:flutter/material.dart';

const globalTextFont = 'RobotoRegular';
final globalColorS = Color.fromRGBO(46, 14, 102, 1);
final globalColor = Color.fromRGBO(1,193, 204, 1);
const textFieldColor = Colors.transparent;//Color.fromRGBO(168, 226, 230, 0.5);
final columnTextStyle = TextStyle(color: Colors.white);
const primaryColor = Colors.white;
const secondaryColor =  Color.fromRGBO(0,32, 33, 1);
const neutralColor = Color.fromRGBO(168,239, 240, 1);
const staticInfoTextStyle = TextStyle(
    fontFamily: globalTextFont,
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: secondaryColor
);
const dataInfoTextStyle = TextStyle(
    fontFamily: globalTextFont,
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: Colors.white,
);
const infoClientTextStyle = TextStyle(
    fontFamily: globalTextFont,
    fontSize: 18,
    color: primaryColor
);
const formTextStyle = TextStyle(
  fontFamily: globalTextFont,
  fontSize: 14,
  color: Colors.black
);

InputDecoration formDecoration(String name){
  return InputDecoration(
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(
        color: neutralColor
      )
    ),
    label: Text(name,style: formTextStyle,),
    border:  const OutlineInputBorder(
    )
  );
}

bool sessionA = false;