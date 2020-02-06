
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:homemaking_door/beans.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserInfoState with ChangeNotifier{
  SharedPreferences sp;

  UserInfoState({this.sp});

  bool _isLogin(){
    return sp.containsKey("user.token");
  }

  String login(String username,String pasword){
    sp.setString("user.token","$username:$pasword");
    notifyListeners();
    return null;
  }

  String get token => sp.containsKey("user.token")? sp.getString("user.token"):null;

  bool get isLogin => _isLogin();

  PublicUser get info => PublicUser(nickName: "aaa",describe: "hahahah");

  static UserInfoState of(BuildContext context){
    return Provider.of<UserInfoState>(context);
  }
}