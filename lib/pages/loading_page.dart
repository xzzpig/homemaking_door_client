import 'dart:async';

import 'package:flutter/material.dart';
import 'package:homemaking_door/providers/user_provider.dart';
import 'package:provider/provider.dart';

class LoadingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print("build loading page");
    doInit(context);
    return Container();
  }

  void doInit(BuildContext context) {
    var userinfo = Provider.of<UserInfoState>(context);
    if (userinfo != null) {
      if (userinfo.isLogin) {
        print("push main page");
        Timer(
            Duration(seconds: 1),
            () => Navigator.of(context)
                .pushNamedAndRemoveUntil("/main", (_) => false));
        return;
      } else {
        print("push login page");
        Timer(
            Duration(seconds: 1),
            () => Navigator.of(context)
                .pushNamedAndRemoveUntil("/login", (_) => false));
        return;
      }
    }
  }
}
