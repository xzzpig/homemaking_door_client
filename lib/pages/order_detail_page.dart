import 'package:flutter/material.dart';
import 'package:homemaking_door/providers/order_provider.dart';
import 'package:homemaking_door/providers/user_provider.dart';
import 'package:homemaking_door/utils.dart';
import 'package:homemaking_door/widgets/loading_widget.dart';
import 'package:homemaking_door/widgets/order_actions.dart';
import 'package:homemaking_door/widgets/order_list_item.dart';
import 'package:homemaking_door/widgets/service_staff_list_item.dart';
import 'package:provider/provider.dart';

import '../graphql.dart';

class OrderDetailPage extends StatelessWidget {
  static String routeName="/orderDetail";

  @override
  Widget build(BuildContext context) {
    return Consumer2<OrderState, UserInfoState>(
      builder: (context, orderState, userInfoState, child) {
        return FutureBuilder(
            future: orderState.getSelectedOrder(userInfoState.token),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                var order = snapshot.data;
                return Scaffold(
                  appBar: AppBar(title: "订单详情".toText()),
                  body: SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        Container(
                          color: Colors.white,
                          child: OrderListItem(order: order),
                        ),
                        Card(
                          child: ServiceStaffListItem(
                            serviceInfo: order.serviceInfo,
                            showPrice: false,
                          ),
                        ),
                      ],
                    ),
                  ),
                  bottomNavigationBar: Container(
                      child: OrderActions(order), //OrderActions(order),
                      padding: EdgeInsets.all(8),
                      // color: Colors.white,
                      decoration: new BoxDecoration(
                        border:
                            new Border.all(color: Colors.grey[300], width: 0.5),
                        color: Colors.white,
                      )),
                );
              } else if (snapshot.hasError) {
                if (snapshot.error.runtimeType == GraphQLException) {
                  return (snapshot.error as GraphQLException)
                      .message
                      .toErrorText();
                }
                print(snapshot.error);
                return snapshot.error.toString().toErrorText();
              } else {
                return Loading();
              }
            });
      },
    );
  }
}
