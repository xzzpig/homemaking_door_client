import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:homemaking_door/pages/address_edit_page.dart';
import 'package:homemaking_door/providers/user_provider.dart';
import 'package:homemaking_door/widgets/future_widget.dart';
import 'package:provider/provider.dart';

import '../beans.dart';

class AddressListPage extends StatefulWidget {
  static String routeName = "/addressList";

  @override
  _AddressListPageState createState() => _AddressListPageState();
}

class _AddressListPageState extends State<AddressListPage> {
  @override
  Widget build(BuildContext context) {
    print("build address list page");
    return Consumer<UserInfoState>(
      builder: (context, userInfoState, child) {
        print("consume userInfoState");
        return FutureWidget<List<Address>>(
            future: userInfoState.addresses,
            builder: (context, addressList) {
              print("consume addressList");
              return Scaffold(
                appBar: AppBar(
                  title: Text("我的地址"),
                  actions: <Widget>[
                    IconButton(
                      icon: Icon(Icons.add),
                      onPressed: () {
                        Navigator.pushNamed(context, AddressEditPage.routeName,
                                arguments: null)
                            .then((value) => this.setState(() {}));
                      },
                      tooltip: "添加新地址",
                    ),
                  ],
                ),
                body: ListView.builder(
                    itemCount: addressList.length,
                    itemBuilder: (context, index) {
                      var address = addressList[index];
                      return ListTile(
                        title: Text(address.detail),
                        subtitle: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            address.isDefault
                                ? Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(2, 0, 2, 2),
                                    child: Badge(
                                      badgeContent: Text(
                                        "默认",
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 10),
                                      ),
                                      shape: BadgeShape.square,
                                      borderRadius: 4,
                                      padding:
                                          const EdgeInsets.fromLTRB(2, 1, 2, 1),
                                      badgeColor: Theme.of(context).accentColor,
                                    ),
                                  )
                                : Container(),
                            Text(address.region.mername),
                          ],
                        ),
                        trailing: IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: () {
                              Navigator.pushNamed(
                                      context, AddressEditPage.routeName,
                                      arguments: address)
                                  .then((value) => this.setState(() {}));
                            }),
                      );
                    }),
              );
            });
      },
    );
  }
}
