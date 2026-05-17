import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'services/cart_service.dart';
import 'screens/market_selection_screen.dart';
import 'screens/catalog_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => CartService(),
      child: MaterialApp(
        title: 'Доставка с рынков',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.green,
          fontFamily: 'Roboto',
          scaffoldBackgroundColor: Colors.grey[50],
        ),
        home: const MarketSelectionScreen(),
        routes: {
          '/catalog': (context) => const CatalogScreen(),
        },
      ),
    );
  }
}