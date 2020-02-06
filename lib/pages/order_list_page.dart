import 'package:flutter/material.dart';
import 'package:homemaking_door/pages/page.dart';
import 'package:homemaking_door/providers/order_provider.dart';
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
                      hintStyle: TextStyle(color: Colors.grey[200],fontSize: 12),
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
            onTap: (){
              print("aaa");
            },
            child: Container(
              child: Column(
                children: <Widget>[
                  Row(children: <Widget>[
                    Expanded(
                        child: Text(
                      "服务名称",
                      style:
                          TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
                    )),
                    Text(
                      "订单状态",
                      style: TextStyle(
                          color: Theme.of(context).accentColor, fontSize: 12),
                    ),
                  ]),
                  Row(
                    children: <Widget>[
                      Icon(
                        Icons.ac_unit,
                        size: 48,
                      ),
                      Expanded(
                        child: Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text("服务人员"),
                              Text(
                                "服务时间",
                                style:
                                    TextStyle(fontSize: 12, color: Colors.grey),
                              ),
                              Text(
                                "服务地点",
                                style:
                                    TextStyle(fontSize: 12, color: Colors.grey),
                              ),
                            ],
                          ),
                          margin: EdgeInsets.all(4),
                        ),
                      ),
                      Text("￥20.00", style: TextStyle(fontSize: 15)),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Container(
                        child: OutlineButton(
                          onPressed: () {},
                          child: Text("data"),
                          padding: EdgeInsets.all(0),
                        ),
                        width: 50,
                        height: 20,
                        padding: EdgeInsets.only(left: 4),
                      ),
                      Container(
                        child: OutlineButton(
                          onPressed: () {},
                          child: Text("data"),
                          padding: EdgeInsets.all(0),
                        ),
                        width: 50,
                        height: 20,
                        padding: EdgeInsets.only(left: 4),
                      ),
                      Container(
                        child: OutlineButton(
                          onPressed: () {},
                          child: Text("data"),
                          padding: EdgeInsets.all(0),
                        ),
                        width: 50,
                        height: 20,
                        padding: EdgeInsets.only(left: 4),
                      ),
                      Container(
                        child: OutlineButton(
                          onPressed: () {},
                          child: Text("data"),
                          padding: EdgeInsets.all(0),
                        ),
                        width: 50,
                        height: 20,
                        padding: EdgeInsets.only(left: 4),
                      ),
                    ],
                    mainAxisAlignment: MainAxisAlignment.end,
                  ),
                ],
              ),
              padding: EdgeInsets.all(8),
            ),
          ),
        ),
        itemCount: 10,
      ),
    );
  }
}
