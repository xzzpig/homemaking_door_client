import 'package:flutter/material.dart';
import 'package:homemaking_door/providers/order_provider.dart';
import 'package:homemaking_door/widgets/order_actions.dart';
import 'package:homemaking_door/widgets/order_list_item.dart';
import 'package:homemaking_door/widgets/service_staff_list_item.dart';
import 'package:provider/provider.dart';

class OrderDetailPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<OrderState>(
      builder: (context, orderState, child) {
        var order = orderState.selectedOrder;
        return Scaffold(
            appBar: AppBar(
              title: Text("订单详情"),
            ),
            body: Column(
              children: <Widget>[
                Container(
                  child: OrderListItem(
                    order: order,
                  ),
                  color: Colors.white,
                ),
                Container(
                  height: 8,
                ),
                Container(
                  color: Colors.white,
                  child: ServiceStaffListItem(
                    serviceInfo: order.serviceInfo,
                    showPrice: false,
                  ),
                ),
                Container(
                  height: 8,
                ),
              ],
            ),
            bottomSheet: Container(
                child: OrderActions(order),
                padding: EdgeInsets.all(8),
                // color: Colors.white,
                decoration: new BoxDecoration(
                  border: new Border.all(color: Colors.grey[300], width: 0.5),
                  color: Colors.white,
                )));
      },
    );
  }
}
