import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:homemaking_door/beans.dart';
import 'package:homemaking_door/graphql.dart';
import 'package:homemaking_door/utils.dart';

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
    if (_searching == false) {
      _cacheOrderMap.clear();
      _orderCount.clear();
    }
    notifyListeners();
  }

  Map<int, Map<int, Order>> _cacheOrderMap = {};
  Future<Order> getOrder(String token, int offset) async {
    var searchText = _controller.text;
    var state = _selectedOrderState;
    if (state == -1) state = null;
    if (searchText == "") searchText = null;
    if (!_cacheOrderMap.containsKey(_selectedOrderState))
      _cacheOrderMap[_selectedOrderState] = {};
    var orderMap = _cacheOrderMap[_selectedOrderState];
    if (!orderMap.containsKey(offset)) {
      var orders =
          await GraphQLApi.getOrders(token, state, searchText, offset, 10);
      orders.forEachIndexed((index, element) {
        orderMap[offset + index] = element;
      });
    }
    return orderMap[offset];
  }

  Map<int, int> _orderCount = {};
  int getOrderCount(String token) {
    var searchText = _controller.text;
    var state = _selectedOrderState;
    if (state == -1) state = null;
    if (searchText == "") searchText = null;
    if (!_orderCount.containsKey(_selectedOrderState)) {
      GraphQLApi.getOrderCount(token, state, searchText).then((value) {
        _orderCount[_selectedOrderState] = value;
        notifyListeners();
      }).catchError(print);
      return 0;
    }
    return _orderCount[_selectedOrderState];
  }

  var _selectedOrderId = 0;
  int get selectedOrderId => _selectedOrderId;
  Future<Order> getSelectedOrder(String token) async {
    return GraphQLApi.getOrder(token, _selectedOrderId);
  }

  void selectOrder(int id) {
    _selectedOrderId = id;
    notifyListeners();
  }

  Future<void> confirmOrder(String token, int order) async {
    await GraphQLApi.confirmOrder(token, order);
    _cacheOrderMap.clear();
    _orderCount.clear();
    notifyListeners();
  }

  Future<void> confirmDoor(String token, int order) async {
    await GraphQLApi.confirmDoor(token, order);
    _cacheOrderMap.clear();
    _orderCount.clear();
    notifyListeners();
  }

  Future<void> assessOrder(
      String token, int order, int score, String detail) async {
    await GraphQLApi.assessOrder(token, order, score, detail);
    _cacheOrderMap.clear();
    _orderCount.clear();
    notifyListeners();
  }
}
