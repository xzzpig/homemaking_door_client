import 'package:homemaking_door/pages/page.dart';
import 'package:flutter/material.dart';
import 'package:homemaking_door/widgets/service_list.dart';
import 'package:homemaking_door/widgets/service_type_list.dart';

class ServiceTypePage extends StatelessWidget  with MyPage{
  @override
  Widget build(BuildContext context) {
    print("build service type page");
    return Row(
      children: <Widget>[
        Container(width: 80,child: ServiceTypeList(),),
        Expanded(child: ServiceList())
      ],
    );
  }
}