import 'package:flutter/material.dart';
import 'package:homemaking_door/beans.dart';
import 'package:homemaking_door/graphql.dart';
import 'package:homemaking_door/pages/main_page.dart';
import 'package:homemaking_door/providers/service_provider.dart';
import 'package:homemaking_door/providers/user_provider.dart';
import 'package:homemaking_door/utils.dart';
import 'package:provider/provider.dart';

class OrderCreatePage extends StatefulWidget {
  static String routeName = "/createOrder";

  @override
  _OrderCreatePageState createState() => _OrderCreatePageState();
}

class _OrderCreatePageState extends State<OrderCreatePage> {
  Address address = null;
  PublicUser userInfo = null;
  String phone = null;
  ServiceInfo serviceInfo;
  DateTime date;
  TimeOfDay time;
  bool enableCreateOrder = true;

  @override
  void initState() {
    super.initState();
    date = DateTime.now();
    time = TimeOfDay.now();
  }

  void initStateData(UserInfoState userInfoState, ServiceState serviceState) {
    if (address == null)
      userInfoState.defaultAddress.then((value) {
        setState(() {
          address = value;
        });
      }).catchError(print);
    if (userInfo == null)
      userInfoState.info.then((value) {
        setState(() {
          userInfo = value;
        });
      }).catchError(print);
    if (phone == null)
      userInfoState.phone.then((value) {
        setState(() {
          phone = value;
        });
      }).catchError(print);
    if (serviceInfo == null)
      serviceState.selectedServiceInfo.then((value) {
        setState(() {
          serviceInfo = value;
        });
      }).catchError(print);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<ServiceState, UserInfoState>(
        builder: (context, serviceState, userInfoState, child) {
      initStateData(userInfoState, serviceState);
      return Scaffold(
          appBar: AppBar(
            title: Text("新建订单"),
          ),
          bottomNavigationBar: Builder(
            builder: (context) => Container(
              color: Colors.black54,
              height: 48,
              padding: EdgeInsets.only(left: 16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                      child: Container(
                    child: Text(
                      "￥${serviceInfo?.price?.toStringAsFixed(2)}",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  )),
                  InkWell(
                    onTap: enableCreateOrder
                        ? () {
                            setState(() {
                              enableCreateOrder = false;
                            });
                            if (serviceInfo == null) {
                              Scaffold.of(context).showSnackBar(
                                  SnackBar(content: "无法获取服务信息".toText()));
                              return;
                            }
                            if (address == null) {
                              Scaffold.of(context).showSnackBar(
                                  SnackBar(content: "无法获取地址".toText()));
                              return;
                            }
                            GraphQLApi.createOrder(
                                    userInfoState.token,
                                    serviceInfo.id,
                                    "{}",
                                    date.add(Duration(
                                        hours: time.hour,
                                        minutes: time.minute)),
                                    address.id)
                                .then((value) {
                              Scaffold.of(context)
                                  .showSnackBar(
                                      SnackBar(content: "创建订单成功".toText()))
                                  .closed
                                  .then((value) {
                                Navigator.of(context).popUntil((route) =>
                                    route.settings.name == MainPage.routeName);
                              });
                            }).catchError(print);
                          }
                        : null,
                    child: Container(
                      height: 48,
                      padding: EdgeInsets.fromLTRB(32, 0, 32, 0),
                      color: enableCreateOrder
                          ? Theme.of(context).accentColor
                          : Colors.white,
                      child: Center(
                          child: enableCreateOrder
                              ? Text(
                                  "下单",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 16),
                                )
                              : CircularProgressIndicator()),
                    ),
                  ),
                ],
              ),
            ),
          ),
          body: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Card(
                  margin: EdgeInsets.all(8),
                  child: InkWell(
                    onTap: () {
                      showDialog<Address>(
                        context: context,
                        builder: (context) => FutureBuilder<List<Address>>(
                          future: userInfoState.addresses,
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              var addresses = snapshot.data;
                              return SimpleDialog(
                                title: Text("选择地址"),
                                children: addresses
                                    .map((_address) => SimpleDialogOption(
                                          onPressed: () {
                                            Navigator.pop(context, _address);
                                          },
                                          child: ListTile(
                                            title: _address.detail.toText(),
                                            subtitle: _address.region.mername
                                                .toText(),
                                            selected:
                                                address?.id == _address.id,
                                          ),
                                        ))
                                    .toList(),
                              );
                            } else {
                              return Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                          },
                        ),
                      ).then((value) {
                        if (value != null)
                          setState(() {
                            address = value;
                          });
                      }).catchError(print);
                    },
                    child: Container(
                      padding: EdgeInsets.all(8),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                              child: Column(
                            children: <Widget>[
                              Text(
                                "${address?.region?.mername},${address?.detail}",
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w400),
                              ),
                              Text("${userInfo?.name}\t$phone")
                            ],
                            crossAxisAlignment: CrossAxisAlignment.start,
                          )),
                          Icon(
                            Icons.arrow_forward_ios,
                            size: 16,
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                Card(
                  margin: EdgeInsets.all(8),
                  child: Column(
                    children: <Widget>[
                      InkWell(
                        onTap: () {
                          showDatePicker(
                                  context: context,
                                  initialDate: date,
                                  firstDate: DateTime.now().isBefore(date)
                                      ? DateTime.now()
                                      : date,
                                  lastDate:
                                      DateTime.now().add(Duration(days: 7)))
                              .then((value) {
                            if (value != null)
                              setState(() {
                                date = value;
                              });
                          }).catchError(print);
                        },
                        child: Container(
                          padding: EdgeInsets.all(8),
                          child: Row(
                            children: <Widget>[
                              Expanded(child: Text("服务日期")),
                              Text(
                                date.humanDate(),
                                style: TextStyle(
                                    color: Theme.of(context).accentColor),
                              ),
                              Icon(
                                Icons.arrow_forward_ios,
                                size: 12,
                                color: Colors.grey[500],
                              )
                            ],
                          ),
                        ),
                      ),
                      Divider(
                        height: 1,
                      ),
                      InkWell(
                        onTap: () {
                          showTimePicker(context: context, initialTime: time)
                              .then((value) {
                            if (value != null)
                              setState(() {
                                time = value;
                              });
                          }).catchError(print);
                        },
                        child: Container(
                          padding: EdgeInsets.all(8),
                          child: Row(
                            children: <Widget>[
                              Expanded(child: Text("服务时间")),
                              Text(
                                time.human(),
                                style: TextStyle(
                                    color: Theme.of(context).accentColor),
                              ),
                              Icon(
                                Icons.arrow_forward_ios,
                                size: 12,
                                color: Colors.grey[500],
                              )
                            ],
                          ),
                        ),
                      ),
                      Divider(
                        height: 1,
                      ),
                      Container(
                        padding: EdgeInsets.all(8),
                        child: Row(
                          children: <Widget>[
                            Expanded(child: Text("服务类型")),
                            Text(
                              serviceInfo?.service?.serviceType?.name
                                  .toString(),
                              style: TextStyle(
                                  color: Theme.of(context).accentColor),
                            ),
                          ],
                        ),
                      ),
                      Divider(
                        height: 1,
                      ),
                      Container(
                        padding: EdgeInsets.all(8),
                        child: Row(
                          children: <Widget>[
                            Expanded(child: Text("服务内容")),
                            Text(
                              serviceInfo?.service?.name.toString(),
                              style: TextStyle(
                                  color: Theme.of(context).accentColor),
                            ),
                          ],
                        ),
                      ),
                      Divider(
                        height: 1,
                      ),
                      Container(
                        padding: EdgeInsets.all(8),
                        child: Row(
                          children: <Widget>[
                            Expanded(child: Text("服务人员")),
                            Text(
                              serviceInfo?.serviceStaff?.publicInfo?.name
                                  .toString(),
                              style: TextStyle(
                                  color: Theme.of(context).accentColor),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Card(
                  margin: EdgeInsets.all(8),
                  child: Column(
                    children: <Widget>[
                      InkWell(
                        onTap: () {},
                        child: Container(
                          padding: EdgeInsets.all(8),
                          child: Row(
                            children: <Widget>[
                              Expanded(child: Text("整数表单")),
                              Text(
                                "10",
                                style: TextStyle(
                                    color: Theme.of(context).accentColor),
                              ),
                              Icon(
                                Icons.arrow_forward_ios,
                                size: 12,
                                color: Colors.grey[500],
                              )
                            ],
                          ),
                        ),
                      ),
                      Divider(
                        height: 1,
                      ),
                      InkWell(
                        onTap: () {},
                        child: Container(
                          padding: EdgeInsets.all(8),
                          child: Row(
                            children: <Widget>[
                              Expanded(child: Text("小数表单")),
                              Text(
                                "10.1",
                                style: TextStyle(
                                    color: Theme.of(context).accentColor),
                              ),
                              Icon(
                                Icons.arrow_forward_ios,
                                size: 12,
                                color: Colors.grey[500],
                              )
                            ],
                          ),
                        ),
                      ),
                      Divider(
                        height: 1,
                      ),
                      InkWell(
                        onTap: () {},
                        child: Container(
                          padding: EdgeInsets.all(8),
                          child: Row(
                            children: <Widget>[
                              Expanded(child: Text("文本表单")),
                              Text(
                                "你好",
                                style: TextStyle(
                                    color: Theme.of(context).accentColor),
                              ),
                              Icon(
                                Icons.arrow_forward_ios,
                                size: 12,
                                color: Colors.grey[500],
                              )
                            ],
                          ),
                        ),
                      ),
                      Divider(
                        height: 1,
                      ),
                      InkWell(
                        onTap: () {},
                        child: Container(
                          padding: EdgeInsets.all(8),
                          child: Row(
                            children: <Widget>[
                              Expanded(child: Text("时间表单")),
                              Text(
                                "10:30",
                                style: TextStyle(
                                    color: Theme.of(context).accentColor),
                              ),
                              Icon(
                                Icons.arrow_forward_ios,
                                size: 12,
                                color: Colors.grey[500],
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ));
    });
  }
}
