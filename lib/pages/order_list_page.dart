import 'package:flutter/material.dart';
import 'package:homemaking_door/pages/page.dart';
import 'package:homemaking_door/providers/order_provider.dart';
import 'package:homemaking_door/widgets/order_actions.dart';
import 'package:homemaking_door/widgets/order_list_item.dart';
import 'package:provider/provider.dart';

class OrderListPage extends StatelessWidget with MyPage {
  @override
  PreferredSizeWidget appbar(BuildContext context) => AppBar(
        title: Consumer<OrderState>(
          builder: (context, orderState, child) => orderState.searching
              ? TextField(
                  controller: orderState.controller,
                  decoration: InputDecoration(
                      hintText: "搜索我的订单",
                      hintStyle:
                          TextStyle(color: Colors.grey[200], fontSize: 12),
                      labelText: "家政上门",
                      labelStyle: TextStyle(color: Colors.white)),
                  style: TextStyle(color: Colors.white),
                  autofocus: true,
                  onSubmitted: (_) {
                    orderState.search();
                  },
                )
              : Text("家政上门"),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              Provider.of<OrderState>(context, listen: false).search();
            },
            tooltip: "搜索",
          ),
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {},
            tooltip: "新建订单",
          ),
        ],
        bottom: TabBar(
          tabs: [
            Tab(text: "全部"),
            Tab(text: "待确认"),
            Tab(text: "待上门"),
            Tab(text: "待评价"),
          ],
          onTap: (index) {
            print(index);
            Provider.of<OrderState>(context, listen: false)
                .selectOrderState(index - 1);
          },
        ),
      );

  @override
  Widget build(BuildContext context) {
    print("build order list page");
    return Consumer<OrderState>(
      builder: (context, orderState, child) => ListView.builder(
        itemBuilder: (context, index) => Card(
          margin: EdgeInsets.fromLTRB(8, 8, 8, 0),
          child: InkWell(
            onTap: () {
              orderState.selectOrder(0);
              Navigator.of(context).pushNamed("/orderDetail");
            },
            // child: Text("data"),
            child: OrderListItem(
              order: orderState.getOrder(offset: index),
              extras: [
                OrderActions(),
              ],
            ),
          ),
        ),
        itemCount: 10,
      ),
    );
  }
}
