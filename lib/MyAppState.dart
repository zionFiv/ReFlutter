import 'package:flutter/material.dart';

class MyAppState extends ChangeNotifier{
  var typeId = 511;
  void setTypeId(int id){
    typeId = id;
    notifyListeners();
  }
}