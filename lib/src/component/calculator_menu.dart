import 'dart:convert';

import 'package:cafe_calculator/src/component/cafe_menu_list.dart';
import 'package:cafe_calculator/src/provider/calculator_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../../common/config.dart';
import '../cafe_calculator.dart';

class CalculatorMenu extends StatefulWidget {
  const CalculatorMenu({super.key});

  @override
  State<CalculatorMenu> createState() => _CalculatorMenuState();
}

class _CalculatorMenuState extends State<CalculatorMenu> {
  final TextEditingController _cafeMenuNameController = TextEditingController();
  final TextEditingController _cafeMenuUsdPriceController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton.extended(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      content: SizedBox(
                        height: screenWidth * 0.4,
                        child: Column(
                          children: [
                            Text('메뉴 이름'),
                            Row(
                              children: [
                                SizedBox(
                                    width: screenWidth * 0.5,
                                    child: TextField(
                                      controller: _cafeMenuNameController,
                                    )),
                              ],
                            ),
                            Text('가격'),
                            Row(
                              children: [
                                SizedBox(
                                    width: screenWidth * 0.5,
                                    child: TextField(
                                      keyboardType:
                                      TextInputType.numberWithOptions(
                                          decimal: true),
                                      // 숫자 및 소수점 키보드 활성화
                                      inputFormatters: [
                                        FilteringTextInputFormatter.allow(
                                            RegExp(r'^\d*\.?\d*')),
                                        // 숫자와 소수점만 입력 허용, 소수점은 한 번만
                                      ],
                                      controller: _cafeMenuUsdPriceController,
                                    )),
                                Text('USD'),
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

                                var data = {
                                  'cafeMenuName':
                                  _cafeMenuNameController.value.text,
                                  'cafeMenuUsdPrice':
                                  _cafeMenuUsdPriceController.value.text,
                                };

                                final response = await http.post(
                                    Uri.parse(
                                        '${Config.serverUrl}/cafeMenu'),
                                    headers: headers,
                                    body: json.encode(data));

                                if (response.statusCode == 200) {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              CafeCalculator()));
                                }
                              },
                              child: Text('메뉴 추가'),
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
              label: Text('메뉴 추가'),
              icon: Icon(Icons.add),
            ),
          ],
        ),
        SizedBox(
          height: screenWidth * 0.05,
        ),
        CafeMenuList()
      ],
    );
  }
}
