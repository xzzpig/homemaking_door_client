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

  void logout() {
    sp.remove("user.token");
  }

  AuthUser _authUser;

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

  Address _defaultAddress;
  Future<Address> get defaultAddress async {
    if (_defaultAddress == null) {
      _defaultAddress = await GraphQLApi.getDefaultAddress(token);
    }
    return _defaultAddress;
  }

  List<Address> _addresses;
  Future<List<Address>> get addresses async {
    if (_addresses == null) {
      _addresses = await GraphQLApi.getAddresses(token);
    }
    return _addresses;
  }

  String _phone;
  Future<String> get phone async {
    if (_phone == null) _phone = await GraphQLApi.getPhone(token);
    return _phone;
  }

  Future<List<ServiceStaff>> get starStaffs => GraphQLApi.getStarStaffs(token);

  Future<void> changeRegion(int regionId) async {
    await GraphQLApi.changeRegion(token, regionId);
    _authUser = null;
    notifyListeners();
  }

  Future<void> editAddress(Address address) async {
    await GraphQLApi.editAddress(token, address.id, address.region.id,
        address.detail, address.isDefault);
    _addresses = null;
    _defaultAddress = null;
    notifyListeners();
  }

  void update() {
    notifyListeners();
  }

  static UserInfoState of(BuildContext context) {
    return Provider.of<UserInfoState>(context);
  }
}
