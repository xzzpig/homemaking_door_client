import 'package:flutter/material.dart';
import 'package:homemaking_door/beans.dart';
import 'package:homemaking_door/pages/page.dart';
import 'package:homemaking_door/pages/service_staff_star_list_page.dart';
import 'package:homemaking_door/providers/user_provider.dart';
import 'package:homemaking_door/widgets/future_widget.dart';
import 'package:provider/provider.dart';

import 'me_info_page.dart';

class MePage extends StatefulWidget with MyPage {
  @override
  _MePageState createState() => _MePageState();
}

class _MePageState extends State<MePage> {
  @override
  Widget build(BuildContext context) {
    return Consumer<UserInfoState>(
      builder: (context, userinfo, child) {
        if (userinfo == null) return Container();
        return FutureWidget<PublicUser>(
            future: userinfo.info,
            builder: (context, info) {
              return Column(
                children: <Widget>[
                  InkWell(
                    child: ListTile(
                      leading: FlutterLogo(
                        size: 56,
                      ),
                      title: Text(info.nickName.toString()),
                      subtitle: Text(info.describe.toString()),
                    ),
                    onTap: () {
                      Navigator.of(context)
                          .pushNamed(MeInfoPage.routeName)
                          .then((value) => this.setState(() {}));
                    },
                  ),
                  InkWell(
                    child: ListTile(
                      title: Text("我的关注"),
                      trailing: Icon(
                        Icons.arrow_forward_ios,
                        size: 16,
                      ),
                    ),
                    onTap: () {
                      Navigator.of(context)
                          .pushNamed(ServiceStaffStarListPage.routeName);
                    },
                  ),
                  InkWell(
                    child: ListTile(
                      title: Text("软件设置"),
                      trailing: Icon(
                        Icons.arrow_forward_ios,
                        size: 16,
                      ),
                    ),
                    onTap: () {},
                  ),
                  InkWell(
                    child: ListTile(
                      title: Text("问题反馈"),
                      trailing: Icon(
                        Icons.arrow_forward_ios,
                        size: 16,
                      ),
                    ),
                    onTap: () {},
                  ),
                  InkWell(
                    child: ListTile(
                      title: Text("关于"),
                      trailing: Icon(
                        Icons.arrow_forward_ios,
                        size: 16,
                      ),
                    ),
                    onTap: () {},
                  ),
                ],
              );
            });
      },
    );
  }
}
