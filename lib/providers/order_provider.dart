import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:homemaking_door/beans.dart';

class OrderState with ChangeNotifier {
  var _selectedOrderState = -1;
  int get selectedOrderState => _selectedOrderState;
  void selectOrderState(int index) {
    _selectedOrderState = index;
    notifyListeners();
  }

  var _controller = TextEditingController();
  TextEditingController get controller => _controller;

  var _searching = false;
  bool get searching => _searching;
  void search() {
    _searching = !searching;
    if (_searching) {
      //TODO
    }
    notifyListeners();
  }

  Order getOrder({int offset, String searchText, int state = -1}) {
    return selectedOrder;
  }

  var _selectedOrderId = 0;
  int get selectedOrderId => _selectedOrderId;
  Order get selectedOrder => Order(
      serviceInfo: ServiceInfo(
          service: Service(name: "服务名称"),
          serviceStaff: ServiceStaff(
              publicInfo: PublicUser(name: "服务人员", headImage: ""),
              score: 3,
              tags: ['aa', 'bb'],
              orderCount: 10),price: 10),
      state: 0,
      staff: ServiceStaff(publicInfo: PublicUser(name: "服务人员")),
      time: DateTime.now(),
      address: Address(detail: "服务地点"),
      userConfirm: false,
      price: 20,
      staffConfirm: false);
  void selectOrder(int id) {
    _selectedOrderId = id;
    notifyListeners();
  }
}
