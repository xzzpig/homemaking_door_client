import 'package:flutter/material.dart';
import 'package:homemaking_door/beans.dart';
import 'package:homemaking_door/pages/service_staff_detail_page.dart';
import 'package:homemaking_door/providers/service_provider.dart';
import 'package:homemaking_door/providers/user_provider.dart';
import 'package:homemaking_door/widgets/service_staff_list_item.dart';
import 'package:provider/provider.dart';

class ServiceStaffListPage extends StatelessWidget {
  static String routeName = "/stafflist";

  @override
  Widget build(BuildContext context) {
    //  Timer(
    //         Duration(seconds: 1),
    //         () => Navigator.of(context)
    //             .pushNamed("/staffdetail"));
    return Consumer2<ServiceState, UserInfoState>(
      builder: (context, serviceState, userInfoState, child) => Scaffold(
        appBar: AppBar(
          title: Text("家政上门"),
        ),
        body: ListView.builder(
          itemBuilder: (context, index) {
            return FutureBuilder<ServiceInfo>(
                future: serviceState.getServiceInfo(userInfoState.token, index),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    var serviceInfo = snapshot.data;
                    return InkWell(
                      onTap: () {
                        serviceState.selectServiceInfo(serviceInfo);
                        Navigator.pushNamed(
                            context, ServiceStaffDetailPage.routeName);
                      },
                      child: ServiceStaffListItem(serviceInfo: serviceInfo),
                    );
                  } else
                    return Container();
                });
          },
          itemCount: serviceState.serviceInfoCount(userInfoState.token),
        ),
      ),
    );
  }
}
