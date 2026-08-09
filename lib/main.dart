import 'package:currency_app/first.dart';
import 'package:currency_app/homepage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
void main() {
  runApp(
    // دونوں پرووائیڈرز کو ایپ کی جڑ (Root) میں انجیکٹ کر دیا
     const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Currency Coverter",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true, // جدید مٹیریل 3 ڈیزائن
      ),
      home: const CurrencyApp(), // ایپ کھلتے ہی ہوم اسکرین نظر آئے گی
    );
  }
}
