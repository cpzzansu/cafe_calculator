import 'package:cafe_calculator/src/provider/calculator_data.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TodayExchangeRate extends StatefulWidget {
  const TodayExchangeRate({super.key});

  @override
  State<TodayExchangeRate> createState() => _TodayExchangeRateState();
}

class _TodayExchangeRateState extends State<TodayExchangeRate> {
  late Future<void> _fetchWonPriceFuture; // Future 객체를 저장할 변수 선언


  @override
  void initState() {
    super.initState();
    final calculatorData = Provider.of<CalculatorData>(context, listen: false);
    _fetchWonPriceFuture = calculatorData.fetchWonPrice(); // initState에서 Future를 초기화

  }

  @override
  Widget build(BuildContext context) {
    final calculatorData = Provider.of<CalculatorData>(context);
    return FutureBuilder(
      future: _fetchWonPriceFuture, // FutureBuilder에 저장된 Future 객체 전달
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            // 에러 처리
            return Center(child: Text('An error occurred'));
          } else if (snapshot.hasData || !snapshot.hasData) { // 데이터가 있거나 없거나 UI 업데이트
            DateTime time = DateTime.parse(calculatorData.updateTime);
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('오늘의 환율 : '),
                Text('1 USD = ${calculatorData.wonPrice} WON'),
                Text('환율수정날짜 : '),
                Text(
                    '${time.year}년 ${time.month}월 ${time.day}일 ${time.hour}시')
              ],
            );
          }
        }
        // 데이터 로딩 중 표시
        return Center(child: CircularProgressIndicator());
      },
    );
  }
}
