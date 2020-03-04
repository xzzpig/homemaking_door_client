import 'package:flutter/material.dart';
import 'package:homemaking_door/graphql.dart';
import 'package:homemaking_door/pages/address_edit_page.dart';
import 'package:homemaking_door/pages/address_list_page.dart';
import 'package:homemaking_door/pages/loading_page.dart';
import 'package:homemaking_door/pages/login_page.dart';
import 'package:homemaking_door/pages/main_page.dart';
import 'package:homemaking_door/pages/me_info_page.dart';
import 'package:homemaking_door/pages/order_assess_page.dart';
import 'package:homemaking_door/pages/order_create_page.dart';
import 'package:homemaking_door/pages/order_detail_page.dart';
import 'package:homemaking_door/pages/region_select_page.dart';
import 'package:homemaking_door/pages/service_staff_detail_page.dart';
import 'package:homemaking_door/pages/service_staff_list_page.dart';
import 'package:homemaking_door/pages/service_staff_star_list_page.dart';
import 'package:homemaking_door/providers/chat_provider.dart';
import 'package:homemaking_door/providers/order_provider.dart';
import 'package:homemaking_door/providers/service_provider.dart';
import 'package:homemaking_door/providers/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // GraphQLApi.getPhone(
    //         "eyJyb2xlcyI6WyJ1c2VyIl0sImFsZyI6IkhTNTEyIn0.eyJqdGkiOiIxIiwiaWF0IjoxNTgxNzY4NTc1LCJhdWQiOiJ4enpwaWcifQ.dRDAG21-fUaQ3_6J7t7sIqLGjtVtEejI9kR3pZnjxlVoga-sizW2FmJ2_EBdJ1QicsWQZux8Da4gUYDqS-w-MA")
    //     .then(print);
    GraphQLApi.getServiceInfo(1);
    return MultiProvider(
      providers: [
        FutureProvider<UserInfoState>(
          create: (context) async =>
              UserInfoState(sp: await SharedPreferences.getInstance()),
        ),
        ChangeNotifierProvider<ServiceState>(
          create: (context) => ServiceState(),
        ),
        ChangeNotifierProvider<OrderState>(
          create: (context) => OrderState(),
        ),
        ChangeNotifierProvider<ChatState>(
          create: (context) => ChatState(),
        ),
      ],
      child: MaterialApp(
        title: '家政上门',
        theme: ThemeData(
          // This is the theme of your application.
          //
          // Try running your application with "flutter run". You'll see the
          // application has a blue toolbar. Then, without quitting the app, try
          // changing the primarySwatch below to Colors.green and then invoke
          // "hot reload" (press "r" in the console where you ran "flutter run",
          // or simply save your changes to "hot reload" in a Flutter IDE).
          // Notice that the counter didn't reset back to zero; the application
          // is not restarted.
          primarySwatch: Colors.blue,
        ),
        debugShowCheckedModeBanner: false,
        initialRoute: LoadingPage.routeName,
        routes: {
          LoadingPage.routeName: (context) => LoadingPage(),
          MainPage.routeName: (context) => MainPage(),
          LoginPage.routeName: (context) => LoginPage(),
          ServiceStaffListPage.routeName: (context) => ServiceStaffListPage(),
          ServiceStaffDetailPage.routeName: (context) =>
              ServiceStaffDetailPage(),
          OrderDetailPage.routeName: (context) => OrderDetailPage(),
          OrderCreatePage.routeName: (context) => OrderCreatePage(),
          OrderAssessPage.routeName: (context) => OrderAssessPage(),
          ServiceStaffStarListPage.routeName: (context) =>
              ServiceStaffStarListPage(),
          MeInfoPage.routeName: (context) => MeInfoPage(),
          RegionSelectPage.routeName: (context) => RegionSelectPage(),
          AddressListPage.routeName: (context) => AddressListPage(),
          AddressEditPage.routeName: (context) => AddressEditPage(),
        },
      ),
    );
  }
}
