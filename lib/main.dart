import 'package:flutter/material.dart';
import 'package:homemaking_door/pages/loading_page.dart';
import 'package:homemaking_door/pages/login_page.dart';
import 'package:homemaking_door/pages/main_page.dart';
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
    return MultiProvider(
      providers: [
        FutureProvider<UserInfoState>(
          create: (context) async =>
              UserInfoState(sp: await SharedPreferences.getInstance()),
        ),
        ChangeNotifierProvider<ServiceState>(create: (context) => ServiceState(),),
        ChangeNotifierProvider<OrderState>(create: (context) => OrderState(),),
        ChangeNotifierProvider<ChatState>(create: (context) => ChatState(),),
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
        initialRoute: "/",
        routes: {
          "/":(context)=>LoadingPage(),
          "/main":(context)=>MainPage(),
          "/login":(context)=>LoginPage(),
        },
      ),
    );
  }
}