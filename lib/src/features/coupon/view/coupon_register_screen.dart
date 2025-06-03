import 'package:flutter/material.dart';

class CouponRegisterScreen extends StatefulWidget {
  const CouponRegisterScreen({super.key});

  @override
  State<CouponRegisterScreen> createState() => _CouponRegisterScreenState();
}

class _CouponRegisterScreenState extends State<CouponRegisterScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(title: const Text('쿠폰 등록')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [const Text('QR 코드를 스캔하여 쿠폰을 등록하세요.')],
        ),
      ),
    );
  }
}
