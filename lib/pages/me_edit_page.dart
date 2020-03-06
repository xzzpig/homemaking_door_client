import 'dart:async';

import 'package:flutter/material.dart';
import 'package:homemaking_door/beans.dart';
import 'package:homemaking_door/graphql.dart';
import 'package:homemaking_door/utils.dart';

class MeEditPage extends StatefulWidget {
  static String routeName = "/editInfo";

  @override
  _MeEditPageState createState() => _MeEditPageState();
}

class _MeEditPageState extends State<MeEditPage> {
  PublicUser info = PublicUser(
      userName: "", nickName: "", sex: false, describe: "", name: "");

  bool get isInfoValid {
    if (info.nickName == null) return false;
    if (info.describe == null) return false;
    if (info.name == null) return false;
    if (info.nickName.trim() == "") return false;
    if (info.describe.trim() == "") return false;
    if (info.name.trim() == "") return false;
    return true;
  }

  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      var info = await context.userInfoState.info;
      setState(() {
        this.info = info;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("编辑资料"),
        actions: <Widget>[
          isInfoValid
              ? Builder(builder: (context) {
                  return InkWell(
                    child: Container(
                      padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                      child: Center(child: Text("完成")),
                    ),
                    onTap: () {
                      context.userInfoState
                          .editInfo(info)
                          .then((value) => Scaffold.of(context)
                              .showSnackBar(SnackBar(
                                content: Text("修改成功"),
                                duration: Duration(seconds: 1),
                              ))
                              .closed)
                          .then((value) => Navigator.pop(context))
                          .catchError((err) {
                        String emsg = err.toString();
                        if (err.runtimeType == GraphQLException) {
                          var error = err as GraphQLException;
                          emsg = error.message;
                        }
                        Scaffold.of(context)
                            .showSnackBar(SnackBar(content: Text(emsg)));
                      });
                    },
                  );
                })
              : Container()
        ],
      ),
      body: Builder(builder: (context) {
        return SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(8),
            child: Column(
              children: <Widget>[
                Container(
                  height: 8,
                ),
                Center(
                  child: FlutterLogo(size: 64),
                ),
                TextField(
                  controller: TextEditingController(text: info.userName),
                  decoration: InputDecoration(labelText: "账号"),
                  readOnly: true,
                ),
                TextField(
                  controller: TextEditingController(text: info.nickName),
                  decoration: InputDecoration(labelText: "昵称"),
                  onSubmitted: (value) => setState(() {
                    info.nickName = value;
                  }),
                ),
                TextField(
                  controller: TextEditingController(text: info.name),
                  decoration: InputDecoration(labelText: "姓名"),
                  onSubmitted: (value) => setState(() {
                    info.name = value;
                  }),
                ),
                TextField(
                  controller: TextEditingController(text: info.sex ? "女" : "男"),
                  decoration: InputDecoration(labelText: "性别"),
                  readOnly: true,
                  onTap: () {
                    showModalBottomSheet(
                        context: context,
                        builder: (context) => Container(
                              height: 128,
                              child: Column(
                                children: <Widget>[
                                  ListTile(
                                    title: Text("男"),
                                    onTap: () {
                                      setState(() {
                                        info.sex = false;
                                      });
                                      Navigator.pop(context);
                                    },
                                  ),
                                  ListTile(
                                    title: Text("女"),
                                    onTap: () {
                                      setState(() {
                                        info.sex = true;
                                      });
                                      Navigator.pop(context);
                                    },
                                  ),
                                ],
                              ),
                            ));
                  },
                ),
                TextField(
                  controller: TextEditingController(text: info.describe),
                  decoration: InputDecoration(labelText: "简介"),
                  maxLines: null,
                  onSubmitted: (value) => this.setState(() {
                    info.describe = value;
                  }),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
