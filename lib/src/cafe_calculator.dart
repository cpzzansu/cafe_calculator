import 'package:cafe_calculator/src/component/calculator_menu.dart';
import 'package:cafe_calculator/src/component/exchange_rage.dart';
import 'package:flutter/material.dart';

class CafeCalculator extends StatelessWidget{
  const CafeCalculator({super.key});


  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: ListView(
        children: [
          ExchangeRate(),
          SizedBox(
            height: screenWidth * 0.05,
          ),
          CalculatorMenu(),
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
