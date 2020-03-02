import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:homemaking_door/beans.dart';
import 'package:homemaking_door/graphql.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserInfoState with ChangeNotifier {
  SharedPreferences sp;

  UserInfoState({this.sp});

  bool _isLogin() {
    return sp.containsKey("user.token");
  }

  AuthUser _authUser = null;

  Future<String> login(String username, String pasword) async {
    try {
      var token = await GraphQLApi.login(username, pasword);
      sp.setString("user.token", token);
      notifyListeners();
      GraphQLApi.getAuthUser(token).then((value) {
        _authUser = value;
        notifyListeners();
      });
    } on GraphQLException catch (e) {
      return e.message;
    } on IndexError catch (_) {
      return "网络连接错误";
    }
    return null;
  }

  String get token =>
      sp.containsKey("user.token") ? sp.getString("user.token") : null;

  bool get isLogin => _isLogin();

  Future<PublicUser> get info async {
    if (_authUser == null) {
      _authUser = await GraphQLApi.getAuthUser(token);
    }
    return _authUser.info;
  }

  Address _defaultAddress = null;
  Future<Address> get defaultAddress async {
    if (_defaultAddress == null) {
      _defaultAddress = await GraphQLApi.getDefaultAddress(token);
    }
    return _defaultAddress;
  }

  List<Address> _addresses = null;
  Future<List<Address>> get addresses async {
    if (_addresses == null) {
      _addresses = await GraphQLApi.getAddresses(token);
    }
    return _addresses;
  }

  String _phone = null;
  Future<String> get phone async {
    if (_phone == null) _phone = await GraphQLApi.getPhone(token);
    return _phone;
  }

  static UserInfoState of(BuildContext context) {
    return Provider.of<UserInfoState>(context);
  }
}
