import 'package:flutter/material.dart';

class CafeCalculator extends StatefulWidget {
  const CafeCalculator({super.key});

  @override
  State<CafeCalculator> createState() => _CafeCalculatorState();
}

class _CafeCalculatorState extends State<CafeCalculator> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        actions: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [Text('오늘의 환율 : '), Text('1 USD = 1336.26 WON')],
          ),
          SizedBox(width: screenWidth * 0.1,),
          _exchangeRateButton()
        ],
      ),
    );
  }

  Widget _exchangeRateButton() {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(color: Colors.red),
    );
  }
}
