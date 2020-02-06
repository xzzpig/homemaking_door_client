import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

class OrderState with ChangeNotifier{
  var _selectedOrderState=-1;
  int get selectedOrderState=>_selectedOrderState;
  void selectOrderState(int index){
    _selectedOrderState=index;
    notifyListeners();
  }

  var _controller = TextEditingController();
  TextEditingController get controller=>_controller;

  var _searching = false;
  bool get searching=>_searching;
  void search(){
    _searching=!searching;
    if(_searching){
      //TODO
    }
    notifyListeners();
  }
}