import 'package:flutter/material.dart';
import 'package:homemaking_door/pages/service_staff_list_page.dart';
import 'package:homemaking_door/providers/service_provider.dart';
import 'package:provider/provider.dart';

class ServiceList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<ServiceState>(
      builder: (context, serviceState, _) {
        if (serviceState == null) return Container();
        var services = serviceState.services;
        return ListView.builder(
          itemBuilder: (context, index) {
            var service = services[index];
            return Container(
              margin: EdgeInsets.fromLTRB(0, 0, 8, 0),
              child: Card(
                child: InkWell(
                  onTap: () {
                    serviceState.selectService(service.id);
                    Navigator.of(context)
                        .pushNamed(ServiceStaffListPage.routeName);
                  },
                  child: ListTile(
                    leading: Icon(Icons.ac_unit),
                    title: Text(service.name),
                    subtitle: Text(service.describe),
                  ),
                ),
              ),
            );
          },
          itemCount: serviceState.services.length,
        );
      },
    );
  }
}
