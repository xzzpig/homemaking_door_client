import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:homemaking_door/beans.dart';
import 'package:homemaking_door/pages/loading_page.dart';
import 'package:homemaking_door/pages/region_select_page.dart';
import 'package:homemaking_door/utils.dart';
import 'package:homemaking_door/widgets/loading_widget.dart';

import '../graphql.dart';

class RegisterNextPage extends StatefulWidget {
  static String routeName = "/registerNext";

  @override
  _RegisterNextPageState createState() => _RegisterNextPageState();
}

class _RegisterNextPageState extends State<RegisterNextPage> {
  bool isLoading = false;

  String userName;
  String password;

  String name;
  String nickName;
  bool sex;
  String phone;
  Region region;

  String get nameErr {
    if (name == null) return null;
    if (name.trim() == "") return "";
    return null;
  }

  String get nickNameErr {
    if (nickName == null) return null;
    if (nickName.trim() == "") return "";
    return null;
  }

  String get phoneErr {
    if (phone == null) return null;
    if (phone.trim() == "") return "";
    if (phone.length != 11) return "";
    return null;
  }

  String regionErr;

  bool get enableRegister {
    if (userName == null) return false;
    if (userName.trim() == "") return false;
    if (password == null) return false;
    if (password.trim() == "") return false;
    if (name == null) return false;
    if (name.trim() == "") return false;
    if (nickName == null) return false;
    if (nickName.trim() == "") return false;
    if (phone == null) return false;
    if (phone.trim() == "") return false;
    if (phone.length != 11) return false;
    if (region == null) return false;
    return true;
  }

  @override
  void initState() {
    super.initState();
    sex = false;
    Future.microtask(() {
      RegisterNextPageArguments arguments =
          ModalRoute.of(context).settings.arguments;
      userName = arguments?.userName;
      password = arguments?.password;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("完善资料"),
      ),
      body: Builder(builder: (context) {
        return Container(
          padding: EdgeInsets.all(8),
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                TextField(
                  decoration:
                      InputDecoration(labelText: "姓名", errorText: nameErr),
                  onSubmitted: (value) {
                    setState(() {
                      name = value;
                    });
                  },
                ),
                TextField(
                  decoration:
                      InputDecoration(labelText: "昵称", errorText: nickNameErr),
                  onSubmitted: (value) {
                    setState(() {
                      nickName = value;
                    });
                  },
                ),
                TextField(
                  controller: TextEditingController(text: sex ? "女" : "男"),
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
                                        sex = false;
                                      });
                                      Navigator.pop(context);
                                    },
                                  ),
                                  ListTile(
                                    title: Text("女"),
                                    onTap: () {
                                      setState(() {
                                        sex = true;
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
                  decoration:
                      InputDecoration(labelText: "手机号", errorText: phoneErr),
                  keyboardType: TextInputType.phone,
                  inputFormatters: <TextInputFormatter>[
                    WhitelistingTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(11)
                  ],
                  onSubmitted: (value) {
                    setState(() {
                      phone = value;
                    });
                  },
                ),
                TextField(
                  decoration:
                      InputDecoration(labelText: "区域", errorText: regionErr),
                  controller: TextEditingController(text: region?.mername),
                  readOnly: true,
                  onTap: () {
                    Navigator.of(context)
                        .pushNamed(RegionSelectPage.routeName,
                            arguments: region?.id)
                        .then((regionId) {
                      if (regionId == null) return;
                      GraphQLApi.getRegion(regionId).then((value) {
                        setState(() {
                          region = value;
                        });
                      });
                    });
                  },
                ),
                Container(
                  height: 32,
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                        child: isLoading
                            ? Loading()
                            : RaisedButton(
                                onPressed: enableRegister
                                    ? () async {
                                        setState(() {
                                          isLoading = true;
                                        });
                                        try {
                                          await GraphQLApi.register(
                                              userName,
                                              userName.join(password).md5(),
                                              name,
                                              nickName,
                                              sex,
                                              phone,
                                              region.id);
                                          await Scaffold.of(context)
                                              .showSnackBar(SnackBar(
                                                content: Text(
                                                  "注册成功",
                                                ),
                                                duration: Duration(seconds: 1),
                                              ))
                                              .closed;
                                          Navigator.pushNamedAndRemoveUntil(
                                              context,
                                              LoadingPage.routeName,
                                              (route) => false);
                                        } on GraphQLException catch (e) {
                                          Scaffold.of(context).showSnackBar(
                                              SnackBar(
                                                  content: Text(
                                                      "注册失败:" + e.message)));
                                        } catch (e) {
                                          Scaffold.of(context).showSnackBar(
                                              SnackBar(
                                                  content: Text("注册失败:未知异常")));
                                        } finally {
                                          setState(() {
                                            isLoading = false;
                                          });
                                        }
                                      }
                                    : null,
                                child: Text(
                                  "注册",
                                  style: TextStyle(color: Colors.white),
                                ),
                                color: Theme.of(context).accentColor,
                              )),
                  ],
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}

class RegisterNextPageArguments {
  String userName;
  String password;
  RegisterNextPageArguments(this.userName, this.password);
}
