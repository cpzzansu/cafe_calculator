import 'package:cafe_calculator/src/cafe_calculator.dart';
import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/calculator_data.dart';

class CafeMenuList extends StatefulWidget {
  const CafeMenuList({super.key});

  @override
  State<CafeMenuList> createState() => _CafeMenuListState();
}

class _CafeMenuListState extends State<CafeMenuList> {
  List<SelectedMenu> selectedMenus = [];
  List<Widget> selectedMenuList = [];

  @override
  Widget build(BuildContext context) {
    final calculatorData = Provider.of<CalculatorData>(context);
    double screenWidth = MediaQuery.of(context).size.width;
    return FutureBuilder(
      future: calculatorData.getCafeMenuList(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            // 에러 처리
            return Center(child: Text('An error occurred'));
          } else if (snapshot.hasData) {
            // 데이터가 성공적으로 로드되었을 때 UI 구성
            List<dynamic> cafeMenuList = snapshot.data as List<dynamic>;

            // cafeMenuList를 사용하여 FloatingActionButton.extended 위젯 리스트 생성
            List<Widget> menuWidgets = cafeMenuList.map<Widget>((menu) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      height: screenWidth * 0.21,
                      child: FloatingActionButton.extended(
                        onPressed: () {
                          SelectedMenu newMenu = SelectedMenu()
                            ..id = menu['id'] // 예시 id, 실제 데이터 구조에 맞게 조정
                            ..cafeMenuName = menu['cafeMenuName']
                            ..numberOfMenu = menu['numberOfMenu']
                            ..cafeMenuUsdPrice = menu['cafeMenuUsdPrice'];

                          SelectedMenu? existingMenu =
                              selectedMenus.firstWhereOrNull(
                            (element) => element.id == newMenu.id,
                          );

                          if (existingMenu != null) {
                            setState(() {
                              existingMenu.numberOfMenu += 1;
                              List<Widget> newMenuList = selectedMenus
                                  .map((e) => Row(
                                        children: [
                                          Text(e.cafeMenuName),
                                          SizedBox(
                                            width: 6,
                                          ),
                                          Text("${(e.numberOfMenu + 1)}개"),
                                          SizedBox(
                                            width: 6,
                                          ),
                                          Text("${e.cafeMenuUsdPrice * (e.numberOfMenu + 1)} USD"),
                                          SizedBox(
                                            width: 6,
                                          ),
                                          Text(
                                              "${calculatorData.wonPrice * e.cafeMenuUsdPrice * (e.numberOfMenu + 1)} WON"),
                                        ],
                                      ))
                                  .toList();
                              selectedMenuList = newMenuList;
                            });
                          } else {
                            setState(() {
                              selectedMenus.add(newMenu);
                              List<Widget> newMenuList = selectedMenus
                                  .map((e) => Row(
                                        children: [
                                          Text(e.cafeMenuName),
                                          SizedBox(
                                            width: 6,
                                          ),
                                          Text("${(e.numberOfMenu + 1)}개"),
                                          SizedBox(
                                            width: 6,
                                          ),
                                          Text("${e.cafeMenuUsdPrice * (e.numberOfMenu + 1)} USD"),
                                          SizedBox(
                                            width: 6,
                                          ),
                                          Text(
                                              "${calculatorData.wonPrice * e.cafeMenuUsdPrice * (e.numberOfMenu + 1)} WON"),
                                        ],
                                      ))
                                  .toList();
                              selectedMenuList = newMenuList;
                            });
                          }
                        },
                        backgroundColor: Colors.white,
                        label: SizedBox(
                          width: screenWidth * 0.45,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(menu['cafeMenuName']),
                              Text(' USD: ${menu['cafeMenuUsdPrice']}'),
                              Text(
                                  'WON: ${(calculatorData.wonPrice * menu['cafeMenuUsdPrice']).toStringAsFixed(2)}'),
                            ],
                          ),
                        ), // 메뉴 이름으로 라벨 설정
                      ),
                    ),
                    FloatingActionButton.extended(
                      onPressed: () {
                        // 메뉴 선택 시 실행할 동작
                      },
                      backgroundColor: Colors.white,
                      label: Text('수정'), // 메뉴 이름으로 라벨 설정
                    ),
                    FloatingActionButton.extended(
                      onPressed: () async {
                        Future<bool> deleteResult =
                            calculatorData.deleteCafeMenu(menu);

                        if (await deleteResult) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const CafeCalculator()));
                        }
                      },
                      backgroundColor: Colors.white,
                      label: Text('삭제'), // 메뉴 이름으로 라벨 설정
                    )
                  ],
                ),
              );
            }).toList();

            // 생성된 위젯 리스트를 Column의 children으로 사용
            return SingleChildScrollView(
              child: Column(
                children: [
                  Column(
                    children: menuWidgets,
                  ),
                  selectedMenus.isNotEmpty
                      ? Column(
                          children: selectedMenuList,
                        )
                      : SizedBox(
                          height: 1,
                        )
                ],
              ),
            );
          }
        }
        // 데이터 로딩 중 표시
        return Center(child: CircularProgressIndicator());
      },
    );
  }
}

class SelectedMenu {
  late int id;
  late String cafeMenuName;
  late int numberOfMenu;
  late double cafeMenuUsdPrice;
}
