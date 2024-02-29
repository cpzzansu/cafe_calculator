import 'dart:convert';

import 'package:cafe_calculator/common/config.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class CalculatorData extends ChangeNotifier {
  dynamic _cafeMenuList;
  dynamic _wonPrice;
  dynamic _updateTime;

  dynamic get updateTime => _updateTime;
  dynamic get cafeMenuList => _cafeMenuList;
  dynamic get wonPrice => _wonPrice;

  set wonPrice(dynamic value) {
    if (_wonPrice != value) {
      _wonPrice = value;
    }
  }

  set updateTime(dynamic value) {
    if (_updateTime != value) {
      _updateTime = value;
    }
  }

  dynamic getCafeMenuList() async {
    await _fetchCafeMenuList();
    return _cafeMenuList;
  }

  dynamic fetchWonPrice() async {
    await _fetchWonPrice();
  }

  Future<bool> deleteCafeMenu(dynamic menu) async {
    return await _deleteCafeMenu(menu);
  }

  Future<void> _fetchCafeMenuList() async {
    var headers = {
      'Accept-Charset': 'UTF-8',
      'Content-Type': 'application/json'
    };

    final response = await http.get(Uri.parse('${Config.serverUrl}/cafeMenu'),
        headers: headers);

    if (response.statusCode == 200) {
      _cafeMenuList = json.decode(response.body);
      print(_cafeMenuList);
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<bool> _deleteCafeMenu(dynamic menu) async {
    final response = await http.delete(Uri.parse('${Config.serverUrl}/cafeMenu?deleteId=${menu['id']}'));

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future<void> _fetchWonPrice() async {
    final response =
    await http.get(Uri.parse('${Config.serverUrl}/exchangeRate'));

    if (response.statusCode == 200) {
      _wonPrice = json.decode(response.body)['wonPrice'];
      _updateTime = json.decode(response.body)['updateTime'];

    } else {
      // 에러 처리: 상태 코드가 200이 아닌 경우 에러 로그 출력 또는 사용자에게 알림
      print('Failed to load exchange rate');
    }
  }
}
