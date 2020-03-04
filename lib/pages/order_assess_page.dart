import 'package:flutter/material.dart';
import 'package:homemaking_door/graphql.dart';
import 'package:homemaking_door/pages/main_page.dart';
import 'package:homemaking_door/providers/order_provider.dart';
import 'package:homemaking_door/providers/user_provider.dart';
import 'package:homemaking_door/utils.dart';
import 'package:homemaking_door/widgets/future_widget.dart';
import 'package:homemaking_door/widgets/order_list_item.dart';
import 'package:provider/provider.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

import '../beans.dart';

class OrderAssessPage extends StatefulWidget {
  static String routeName = "/assessOrder";

  @override
  _OrderAssessPageState createState() => _OrderAssessPageState();
}

class _OrderAssessPageState extends State<OrderAssessPage> {
  int score;
  TextEditingController controller;

  @override
  void initState() {
    super.initState();
    score = 5;
    controller = TextEditingController(text: "");
  }

  @override
  Widget build(BuildContext context) {
    OrderAssessPageRouteArguments arguments =
        ModalRoute.of(context).settings.arguments;
    int orderId = arguments.orderId;
    return Consumer2<UserInfoState, OrderState>(
      builder: (context, userInfoState, orderState, child) => FutureWidget<
              Order>(
          future: GraphQLApi.getOrder(userInfoState.token, orderId),
          builder: (context, order) => Scaffold(
                appBar: AppBar(
                  title: "发表评价".toText(),
                  actions: <Widget>[
                    Builder(builder: (context) {
                      return InkWell(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Center(child: "发布".toText()),
                        ),
                        onTap: () {
                          var detail = controller.text;
                          if (detail.trim() == "") detail = null;
                          orderState
                              .assessOrder(
                                  userInfoState.token, orderId, score, detail)
                              .then((value) {
                            Scaffold.of(context)
                                .showSnackBar(
                                    SnackBar(content: "评价发布成功".toText()))
                                .closed
                                .then((value) {
                              Navigator.of(context).popUntil((route) =>
                                  route.settings.name == MainPage.routeName);
                            });
                          }).catchError((err) {
                            print(err);
                            if (err.runtimeType == GraphQLException) {
                              GraphQLException error = err;
                              Scaffold.of(context).showSnackBar(SnackBar(
                                  content:
                                      "发布失败:".join(error.message).toText()));
                            }
                          });
                        },
                      );
                    })
                  ],
                ),
                body: Column(
                  children: <Widget>[
                    OrderListItem(
                      order: order,
                    ),
                    Expanded(
                      child: Card(
                        margin: EdgeInsets.all(8),
                        child: Column(
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.all(8),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    "评分",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Container(
                                    width: 16,
                                  ),
                                  SmoothStarRating(
                                    rating: score.toDouble(),
                                    starCount: 5,
                                    allowHalfRating: false,
                                    size: 20,
                                    onRatingChanged: (rating) {
                                      setState(() {
                                        score = rating.floor();
                                      });
                                    },
                                  )
                                ],
                              ),
                            ),
                            Expanded(
                                child: Container(
                              padding: EdgeInsets.all(8),
                              child: TextField(
                                decoration: InputDecoration.collapsed(
                                    hintText: "服务是否满意？输入你的评价吧！"),
                                maxLines: null,
                                controller: controller,
                              ),
                            ))
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              )),
    );
  }
}

class OrderAssessPageRouteArguments {
  int orderId;
  OrderAssessPageRouteArguments(this.orderId);
}
