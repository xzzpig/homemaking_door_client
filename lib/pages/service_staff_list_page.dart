
import 'package:flutter/material.dart';
import 'package:homemaking_door/providers/service_provider.dart';
import 'package:homemaking_door/widgets/service_staff_list_item.dart';
import 'package:provider/provider.dart';

class ServiceStaffListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //  Timer(
    //         Duration(seconds: 1),
    //         () => Navigator.of(context)
    //             .pushNamed("/staffdetail"));
    return Consumer<ServiceState>(
      builder: (context, serviceState, child) => Scaffold(
        appBar: AppBar(
          title: Text("家政上门"),
        ),
        body: ListView.builder(
          itemBuilder: (context, index) {
            var serviceInfo = serviceState.serviceInfos[index];
            return InkWell(
              onTap: () {
                serviceState.selectServiceInfo(index);
                Navigator.pushNamed(context, "/staffdetail");
              },
              child: ServiceStaffListItem(serviceInfo: serviceInfo),
            );
          },
          itemCount: serviceState.serviceInfos.length,
        ),
      ),
    );
  }
}
