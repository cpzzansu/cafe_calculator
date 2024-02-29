import 'dart:convert';

import 'package:cafe_calculator/src/cafe_calculator.dart';
import 'package:cafe_calculator/src/component/today_exchage_rate.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

import '../../common/config.dart';

class ExchangeRate extends StatefulWidget {
  const ExchangeRate({super.key});

  @override
  State<ExchangeRate> createState() => _ExchangeRateState();
}

class _ExchangeRateState extends State<ExchangeRate> {
  final TextEditingController _exchangeRateController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }


  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TodayExchangeRate(),
          SizedBox(
            width: screenWidth * 0.1,
          ),
          Padding(
            padding: EdgeInsets.only(right: 8.0),
            child: FloatingActionButton.extended(
              onPressed: () async {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      content: SizedBox(
                        height: screenWidth * 0.3,
                        child: Column(
                          children: [
                            Text('환율을 입력하세요.'),
                            Text('1 USD ='),
                            Row(
                              children: [
                                SizedBox(
                                    width: screenWidth * 0.5,
                                    child: TextField(
                                      keyboardType: TextInputType.numberWithOptions(decimal: true), // 숫자 및 소수점 키보드 활성화
                                      inputFormatters: [
                                        FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')), // 숫자와 소수점만 입력 허용, 소수점은 한 번만
                                      ],
                                      decoration: InputDecoration(
                                        hintText: '환율을 입력해주세요.',
                                      ),
                                      controller: _exchangeRateController,
                                    )),
                                Text('원'),
                              ],
                            )
                          ],
                        ),
                      ),
                      actions: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                              onPressed: () async {
                                var headers = {
                                  'Accept-Charset': 'UTF-8',
                                  'Content-Type': 'application/json'
                                };

                                var data = {'wonPrice': _exchangeRateController.value.text};

                                final response = await http.post(
                                    Uri.parse('${Config.serverUrl}/exchangeRate'),
                                    headers: headers,
                                    body: json.encode(data));

                                if (response.statusCode == 200) {
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => CafeCalculator()));
                                }
                              },
                              child: Text('환율수정'),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text('닫기'),
                            ),
                          ],
                        ),
                      ],
                    );
                  },
                );
              },
              label: const Text('환율수정'),
              icon: const Icon(Icons.edit_outlined),
            ),
          ),
        ],
      ),
    );
  }
}
