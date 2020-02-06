import 'package:flutter/material.dart';
import 'package:homemaking_door/providers/service_provider.dart';
import 'package:provider/provider.dart';

class ServiceTypeList extends StatefulWidget {
  @override
  _ServiceTypeListState createState() => _ServiceTypeListState();
}

class _ServiceTypeListState extends State<ServiceTypeList> {
  @override
  Widget build(BuildContext context) {
    print("build service type list");
    return Consumer<ServiceState>(
        builder: (context, serviceState, _) => Container(
              child: ListView.builder(
                itemBuilder: (context, index) => Container(
                  color: index == serviceState.selectedServiceTypeIndex
                      ? Colors.white
                      : Theme.of(context).scaffoldBackgroundColor,
                  padding: EdgeInsets.all(8),
                  child: InkWell(
                    onTap: () => serviceState.selectServiceType(index),
                    child: Center(
                        child: Text(
                      serviceState.serviceTypes[index].name,
                      style: TextStyle(
                          color: index == serviceState.selectedServiceTypeIndex
                              ? Colors.black
                              : Colors.grey),
                    )),
                  ),
                ),
                itemCount: serviceState.serviceTypes.length,
              ),
            ));
  }
}
