import 'package:flutter/material.dart';
import 'package:homemaking_door/beans.dart';
import 'package:homemaking_door/pages/address_list_page.dart';
import 'package:homemaking_door/pages/loading_page.dart';
import 'package:homemaking_door/pages/region_select_page.dart';
import 'package:homemaking_door/providers/user_provider.dart';
import 'package:homemaking_door/utils.dart';
import 'package:homemaking_door/widgets/future_widget.dart';
import 'package:provider/provider.dart';

import 'me_edit_page.dart';

class MeInfoPage extends StatefulWidget {
  static String routeName = "/info";

  @override
  _MeInfoPageState createState() => _MeInfoPageState();
}

class _MeInfoPageState extends State<MeInfoPage> {
  @override
  Widget build(BuildContext context) {
    return Consumer<UserInfoState>(
      builder: (context, userinfo, child) {
        if (userinfo == null) return Container();
        return FutureWidget<PublicUser>(
            future: userinfo.info,
            builder: (context, info) {
              return Scaffold(
                appBar: AppBar(
                  title: "个人信息".toText(),
                ),
                body: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      InkWell(
                        child: ListTile(
                          leading: FlutterLogo(
                            size: 56,
                          ),
                          title: Text(info.nickName),
                          subtitle: Text(info.describe.toString()),
                          trailing: Container(
                            height: 20,
                            width: 32,
                            child: OutlineButton(
                              padding: EdgeInsets.all(0),
                              onPressed: null,
                              child: Text(
                                "编辑",
                                style: TextStyle(fontSize: 10),
                              ),
                              disabledBorderColor:
                                  Theme.of(context).accentColor,
                              disabledTextColor: Theme.of(context).accentColor,
                            ),
                          ),
                        ),
                        onTap: () {
                          Navigator.of(context)
                              .pushNamed(MeEditPage.routeName)
                              .then((value) => this.setState(() {}));
                        },
                      ),
                      InkWell(
                        child: ListTile(
                          title: Text("修改密码"),
                          trailing: Icon(
                            Icons.arrow_forward_ios,
                            size: 16,
                          ),
                        ),
                        onTap: () {},
                      ),
                      InkWell(
                        child: ListTile(
                          title: Text("地区设置"),
                          subtitle: info.region.mername.toText(),
                          trailing: Icon(
                            Icons.arrow_forward_ios,
                            size: 16,
                          ),
                        ),
                        onTap: () {
                          selectRegion(context, info, userinfo);
                        },
                      ),
                      InkWell(
                        child: ListTile(
                          title: Text("我的地址"),
                          trailing: Icon(
                            Icons.arrow_forward_ios,
                            size: 16,
                          ),
                        ),
                        onTap: () {
                          Navigator.of(context)
                              .pushNamed(AddressListPage.routeName);
                        },
                      ),
                    ],
                  ),
                ),
                bottomNavigationBar: Container(
                  padding: EdgeInsets.all(8),
                  child: MaterialButton(
                    onPressed: () {
                      userinfo.logout();
                      Navigator.of(context).pushNamedAndRemoveUntil(
                          LoadingPage.routeName, (route) => false);
                    },
                    child: Text("退出登录"),
                    color: Colors.red,
                    textColor: Colors.white,
                  ),
                ),
              );
            });
      },
    );
  }

  void selectRegion(
      BuildContext context, PublicUser info, UserInfoState userInfoState) {
    Navigator.of(context)
        .pushNamed(RegionSelectPage.routeName, arguments: info.region.id)
        .then((regionId) {
      if (regionId == null) return;
      userInfoState.changeRegion(regionId).then((value) {
        Navigator.of(context).popAndPushNamed(MeInfoPage.routeName);
      });
    });
  }
}
