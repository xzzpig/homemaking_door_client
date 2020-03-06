import 'package:flutter/material.dart';
import 'package:homemaking_door/graphql.dart';
import 'package:homemaking_door/pages/register_next_page.dart';
import 'package:homemaking_door/widgets/loading_widget.dart';

class RegisterPage extends StatefulWidget {
  static String routeName = "/register";

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool _pwdVisible = false;
  bool _pwdVisible2 = false;
  bool _loading = false;

  bool get enableNext {
    if (_username.text.trim() == "") return false;
    if (_password.text.trim() == "") return false;
    if (_password2.text != _password.text) return false;
    return true;
  }

  TextEditingController _username;
  TextEditingController _password;
  TextEditingController _password2;

  void onEditFinish(String value) {
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _username = TextEditingController();
    _password = TextEditingController();
    _password2 = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("注册"),
      ),
      body: Builder(builder: buildBody),
    );
  }

  Container buildBody(BuildContext context) {
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
            onSubmitted: onEditFinish,
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
            onSubmitted: onEditFinish,
          ),
          TextField(
            controller: _password2,
            decoration: InputDecoration(
              labelText: "重复密码",
              contentPadding: EdgeInsets.all(10.0),
              icon: InkWell(
                canRequestFocus: false,
                child: Icon(
                  Icons.remove_red_eye,
                  color: _pwdVisible2
                      ? Theme.of(context).primaryColor
                      : Theme.of(context).iconTheme.color,
                ),
                onTap: () => this
                    .setState(() => {this._pwdVisible2 = !this._pwdVisible2}),
              ),
            ),
            obscureText: !this._pwdVisible2,
            onSubmitted: onEditFinish,
          ),
          Container(
            height: 32,
          ),
          Row(
            children: <Widget>[
              Expanded(
                  child: _loading
                      ? Loading()
                      : RaisedButton(
                          onPressed: enableNext
                              ? () async {
                                  setState(() {
                                    _loading = true;
                                  });
                                  try {
                                    var exist = await GraphQLApi.isUserExist(
                                        _username.text);
                                    if (exist) {
                                      Scaffold.of(context)
                                          .showSnackBar(SnackBar(
                                        content: Text("用户名已存在"),
                                      ));
                                    } else {
                                      Navigator.of(context).pushNamed(
                                          RegisterNextPage.routeName,
                                          arguments: RegisterNextPageArguments(
                                              _username.text, _password.text));
                                    }
                                  } on GraphQLException catch (e) {
                                    Scaffold.of(context).showSnackBar(SnackBar(
                                      content: Text(e.message),
                                    ));
                                  } finally {
                                    setState(() {
                                      _loading = false;
                                    });
                                  }
                                }
                              : null,
                          child: Text(
                            "下一步",
                            style: TextStyle(color: Colors.white),
                          ),
                          color: Theme.of(context).accentColor,
                        )),
            ],
          ),
        ],
      ),
    );
  }
}
