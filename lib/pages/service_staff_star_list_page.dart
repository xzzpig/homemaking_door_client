import 'package:flutter/material.dart';
import 'package:homemaking_door/beans.dart';
import 'package:homemaking_door/pages/service_staff_detail_page.dart';
import 'package:homemaking_door/providers/service_provider.dart';
import 'package:homemaking_door/providers/user_provider.dart';
import 'package:homemaking_door/utils.dart';
import 'package:homemaking_door/widgets/future_widget.dart';
import 'package:homemaking_door/widgets/service_staff_list_item.dart';
import 'package:provider/provider.dart';

class ServiceStaffStarListPage extends StatelessWidget {
  static String routeName = "/starList";

  @override
  Widget build(BuildContext context) {
    return Consumer2<UserInfoState, ServiceState>(
        builder: (context, userInfoState, serviceState, child) =>
            FutureWidget<List<ServiceStaff>>(
                future: userInfoState.starStaffs,
                builder: (context, staffs) => Scaffold(
                      appBar: AppBar(title: "关注列表".toText()),
                      body: ListView.builder(
                          itemCount: staffs.length,
                          itemBuilder: (context, index) => Card(
                                child: InkWell(
                                  onTap: () {
                                    serviceState
                                        .selectServiceStaff(staffs[index].id);
                                    Navigator.pushNamed(context,
                                        ServiceStaffDetailPage.routeName);
                                  },
                                  child: ServiceStaffListItem(
                                    serviceInfo: ServiceInfo(
                                        serviceStaff: staffs[index]),
                                    showPrice: false,
                                  ),
                                ),
                              )),
                    )));
  }
}
