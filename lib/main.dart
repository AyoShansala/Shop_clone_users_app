import 'package:amazon_universal_app/assistant_methods/address_changer.dart';
import 'package:amazon_universal_app/assistant_methods/cart_item_counter.dart';
import 'package:amazon_universal_app/assistant_methods/total_amount.dart';
import 'package:amazon_universal_app/global/global.dart';
import 'package:amazon_universal_app/splashScreen/my_splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  sharedPreferences = await SharedPreferences.getInstance();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (c) => CartItemCounter(),
        ),
        ChangeNotifierProvider(
          create: (c) => TotalAmount(),
        ),
        ChangeNotifierProvider(
          create: (c) => AddressChanger(),
        )
      ],
      child: MaterialApp(
        title: 'Users App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        debugShowCheckedModeBanner: false,
        home: MySplashScreen(),
      ),
    );
  }
}
