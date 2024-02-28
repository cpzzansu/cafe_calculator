import 'dart:convert';

import 'package:cafe_calculator/common/config.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CafeCalculator extends StatefulWidget {
  const CafeCalculator({super.key});

  @override
  State<CafeCalculator> createState() => _CafeCalculatorState();
}

class _CafeCalculatorState extends State<CafeCalculator> {
  late double wonPrice;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getWonPrice();
  }

  Future<void> _getWonPrice() async {
    final response =
        await http.get(Uri.parse('${Config.serverUrl}/exchangeRate'));

    if (response.statusCode == 200) {
      final responseBody = json.decode(response.body);
      setState(() {
        wonPrice = double.parse(responseBody['wonPrice'].toString());
      });
      print(wonPrice);
      print(responseBody['updateTime']);
    } else {
      // 에러 처리: 상태 코드가 200이 아닌 경우 에러 로그 출력 또는 사용자에게 알림
      print('Failed to load exchange rate');
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    Widget titleBox(String title) {
      return DecoratedBox(
        decoration: BoxDecoration(
          color: colorScheme.inverseSurface,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: Text(title,
              style: TextStyle(color: colorScheme.onInverseSurface)),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: screenWidth * 0.25,
        actions: [
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [Text('오늘의 환율 : '), Text('1 USD = $wonPrice WON')],
              ),
              SizedBox(
                width: screenWidth * 0.1,
              ),
              Padding(
                padding: EdgeInsets.only(right: 8.0),
                child: FloatingActionButton.extended(
                  onPressed: () async {
                    var headers = {
                      'Accept-Charset': 'UTF-8',
                      'Content-Type': 'application/json'
                    };

                    double wonPrice = 1330.26;

                    var data = {'wonPrice': wonPrice.toString()};

                    final response = await http.post(
                        Uri.parse('${Config.serverUrl}/exchangeRate'),
                        headers: headers,
                        body: json.encode(data));
                  },
                  label: const Text('환율수정'),
                  icon: const Icon(Icons.edit_outlined),
                ),
              ),
            ],
          )
        ],
      ),
      body: ListView(
        children: [
          SizedBox(
            height: screenWidth * 0.05,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              FloatingActionButton.extended(
                onPressed: () {},
                label: Text('메뉴 수정'),
                icon: Icon(Icons.edit_outlined),
              ),
              SizedBox(
                width: screenWidth * 0.05,
              ),
              FloatingActionButton.extended(
                onPressed: () {},
                label: Text('메뉴 추가'),
                icon: Icon(Icons.add),
              ),
            ],
          ),
          SizedBox(
            height: screenWidth * 0.05,
          ),
          FloatingActionButton.extended(
            onPressed: () {},
            backgroundColor: Colors.white,
            label: Text('아이스아메리카노'),
          )
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
