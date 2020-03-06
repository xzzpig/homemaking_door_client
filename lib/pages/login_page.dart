import 'package:flutter/material.dart';
import 'package:homemaking_door/pages/main_page.dart';
import 'package:homemaking_door/pages/register_page.dart';
import 'package:homemaking_door/providers/user_provider.dart';

class LoginPage extends StatefulWidget {
  static String routeName = "/login";

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _pwdVisible = false;
  TextEditingController _username;
  TextEditingController _password;

  @override
  void initState() {
    super.initState();
    _username = TextEditingController();
    _password = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("登录"),
      ),
      body: Builder(builder: buildBody),
    );
  }

  Container buildBody(BuildContext context) {
    var userinfo = UserInfoState.of(context);
    return Container(
      padding: EdgeInsets.fromLTRB(8, 32, 8, 8),
      child: Column(
        children: <Widget>[
          Center(
            child: Container(
              child: Image.asset("assets/logo_circle.png"),
              width: 64,
            ),
          ),
          TextField(
            controller: _username,
            decoration: InputDecoration(
              labelText: "账号",
              contentPadding: EdgeInsets.all(10.0),
              icon: Icon(
                Icons.remove_red_eye,
                color: Theme.of(context).scaffoldBackgroundColor,
              ),
            ),
          ),
          TextField(
            controller: _password,
            decoration: InputDecoration(
              labelText: "密码",
              contentPadding: EdgeInsets.all(10.0),
              icon: InkWell(
                canRequestFocus: false,
                child: Icon(
                  Icons.remove_red_eye,
                  color: _pwdVisible
                      ? Theme.of(context).primaryColor
                      : Theme.of(context).iconTheme.color,
                ),
                onTap: () =>
                    this.setState(() => {this._pwdVisible = !this._pwdVisible}),
              ),
            ),
            obscureText: !this._pwdVisible,
          ),
          Container(
            height: 32,
          ),
          Row(
            children: <Widget>[
              Expanded(
                  child: RaisedButton(
                onPressed: () async {
                  print(_username.text);
                  var result =
                      await userinfo.login(_username.text, _password.text);
                  if (result == null) {
                    Navigator.of(context).pushNamedAndRemoveUntil(
                        MainPage.routeName, (_) => false);
                  } else {
                    Scaffold.of(context)
                        .showSnackBar(SnackBar(content: Text("登录失败:$result")));
                  }
                },
                child: Text(
                  "登录",
                  style: TextStyle(color: Colors.white),
                ),
                color: Theme.of(context).accentColor,
              )),
            ],
          ),
          Container(
            height: 16,
          ),
          Row(
            children: <Widget>[
              Text("忘记密码"),
              Spacer(),
              InkWell(
                  onTap: () {
                    Navigator.of(context).pushNamed(RegisterPage.routeName);
                  },
                  child: Text("注册")),
            ],
          )
        ],
      ),
    );
  }
}
