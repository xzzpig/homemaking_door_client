import 'package:flutter/foundation.dart';
import 'package:homemaking_door/beans.dart';

class ServiceState with ChangeNotifier{
  List<ServiceType> get serviceTypes =>[ServiceType(0,"aaa"),ServiceType(1,"bbb"),ServiceType(2,"ccc"),ServiceType(3,"ddd")];
  
  var _selectedServiceTypeIndex = 0;
  int get selectedServiceTypeIndex=>_selectedServiceTypeIndex;
  void selectServiceType(int index){
    _selectedServiceTypeIndex=index;
    notifyListeners();
  }

  int _selectedServiceId = -1;
  List<Service> get services =>[Service(name: "eee",describe: "fff"),Service(name: "eee",describe: "fff"),Service(name: "eee",describe: "fff"),Service(name: "eee",describe: "fff")];
  void selectService(int id){
    _selectedServiceId=id;
    notifyListeners();
  }
}