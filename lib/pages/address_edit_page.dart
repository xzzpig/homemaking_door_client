import 'package:flutter/material.dart';
import 'package:homemaking_door/beans.dart';
import 'package:homemaking_door/graphql.dart';
import 'package:homemaking_door/pages/region_select_page.dart';
import 'package:homemaking_door/utils.dart';

class AddressEditPage extends StatefulWidget {
  static String routeName = "/addressEdit";

  @override
  _AddressEditPageState createState() => _AddressEditPageState();
}

class _AddressEditPageState extends State<AddressEditPage> {
  Address address;
  TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    if (address == null) {
      address = ModalRoute.of(context).settings.arguments;
    }
    if (address == null)
      address = Address(isDefault: false);
    else {
      controller = TextEditingController(text: address.detail);
    }
    if (controller == null) controller = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        title: Text(address.id == null ? "新建地址" : "编辑地址"),
        actions: <Widget>[
          (address.detail != null && address.region != null)
              ? Builder(builder: (context) {
                  return InkWell(
                    onTap: () async {
                      await context.userInfoState.editAddress(address);
                      await Scaffold.of(context)
                          .showSnackBar(SnackBar(
                            content: "保存成功".toText(),
                            duration: Duration(seconds: 1),
                          ))
                          .closed;
                      Navigator.pop(context);
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text("保存"),
                    ),
                  );
                })
              : Container()
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            ListTile(
              title: Text(
                address.region == null ? "选择区域" : address?.region?.mername,
                style: address.region == null
                    ? TextStyle(color: Colors.grey[400])
                    : null,
              ),
              trailing: Icon(
                Icons.arrow_forward_ios,
                size: 16,
              ),
              onTap: () {
                Navigator.of(context)
                    .pushNamed(RegionSelectPage.routeName,
                        arguments: address?.region?.id)
                    .then((regionId) {
                  if (regionId == null) return;
                  GraphQLApi.getRegion(regionId).then((value) {
                    setState(() {
                      address.region = value;
                    });
                  });
                });
              },
            ),
            Container(
              padding: EdgeInsets.all(8),
              child: TextField(
                controller: controller,
                maxLines: null,
                decoration: InputDecoration(
                  labelText: "详细地址",
                ),
                onSubmitted: (value) {
                  value = value.trim() == "" ? null : value;
                  setState(() {
                    address.detail = value;
                  });
                },
              ),
            ),
            ListTile(
              title: Text("设为默认地址"),
              trailing: Switch(
                  value: address.isDefault,
                  onChanged: (value) {
                    setState(() {
                      address.isDefault = value;
                    });
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
