import 'dart:async';

import 'package:flutter/material.dart';
import 'package:homemaking_door/pages/login_page.dart';
import 'package:homemaking_door/pages/main_page.dart';
import 'package:homemaking_door/providers/user_provider.dart';
import 'package:homemaking_door/widgets/loading_widget.dart';
import 'package:provider/provider.dart';

class LoadingPage extends StatelessWidget {
  static String routeName = "/";

  @override
  Widget build(BuildContext context) {
    print("build loading page");
    doInit(context);
    return Loading();
  }

  void doInit(BuildContext context) {
    var userinfo = Provider.of<UserInfoState>(context);
    if (userinfo != null) {
      if (userinfo.isLogin) {
        print("push main page");
        Timer(
            Duration(seconds: 1),
            () => Navigator.of(context)
                .pushNamedAndRemoveUntil(MainPage.routeName, (_) => false));
        return;
      } else {
        print("push login page");
        Timer(
            Duration(seconds: 1),
            () => Navigator.of(context)
                .pushNamedAndRemoveUntil(LoginPage.routeName, (_) => false));
        return;
      }
    }
  }
}
