import 'package:flutter/material.dart';
import 'package:store_manager/lang_provider/language_picker_widget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../dataBase/sql_object.dart';
import '../utils/objects.dart';
import '../utils/utils.dart';

class Report extends StatefulWidget {
  const Report({super.key});

  @override
  State<Report> createState() => _ReportState();
}

class _ReportState extends State<Report> {
  TextEditingController dateController = TextEditingController(),
      dateController1 = TextEditingController();
  late String tag = "Report";
  late List<ChartData> chartDataPrice = <ChartData>[];
  late List<ChartData> chartDataWin = <ChartData>[];
  late List<ChartData> chartDataNumber = <ChartData>[];
  late List<ChartData> chartDataPriceDepot = <ChartData>[];
  late List<ChartData> chartDataWinDepot = <ChartData>[];
  late List<ChartData> chartDataNumberDepot = <ChartData>[];
  late List<ChartData> chartDataPriceDay = <ChartData>[];
  late List<ChartData> chartDataWinDay = <ChartData>[];
  late List<ChartData> chartDataNumberDay = <ChartData>[];
  late double cost = 0, sale = 0, win = 0, number = 0;

  late TooltipBehavior tooltipBehaviorWin,
      tooltipBehaviorPrice,
      tooltipBehaviorNumber;

  @override
  void initState() {
    tooltipBehaviorWin = TooltipBehavior(
        enable: true,
        builder: (dynamic data, dynamic point, dynamic series, int pointIndex,
            int seriesIndex) {
          return Card(
              child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('${point.x} : ${point.y.toStringAsFixed(2)}\$'),
          ));
        });
    tooltipBehaviorPrice = TooltipBehavior(
        enable: true,
        builder: (dynamic data, dynamic point, dynamic series, int pointIndex,
            int seriesIndex) {
          return Card(
              child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('${point.x} : ${point.y.toStringAsFixed(2)}\$'),
          ));
        });
    tooltipBehaviorNumber = TooltipBehavior(
        enable: true,
        builder: (dynamic data, dynamic point, dynamic series, int pointIndex,
            int seriesIndex) {
          return Card(
              child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('${point.x} : ${point.y.toStringAsFixed(2)}'),
          ));
        });
    super.initState();
  }

  searchInItemBillIn(
      {String typeBill = billIn,
      required String date,
      required String date1}) async {
    String tagLocal = "$tag/searchInItemBill";
    setState(() {
      chartDataPrice = <ChartData>[];
      chartDataWin = <ChartData>[];
      chartDataNumber = <ChartData>[];
      chartDataPriceDepot = <ChartData>[];
      chartDataWinDepot = <ChartData>[];
      chartDataNumberDepot = <ChartData>[];
      chartDataPriceDay = <ChartData>[];
      chartDataWinDay = <ChartData>[];
      chartDataNumberDay = <ChartData>[];
    });
    Log(tag: tagLocal, message: "Start function1");
    String tableNameBill =
        typeBill == billIn ? billInTableName : billIOutTableName;
    String tableName =
        typeBill == billIn ? billInItemTableName : billIOutItemTableName;
    Log(tag: tagLocal, message: "Table name is: $tableNameBill");
    if (date.isNotEmpty) {
      Log(tag: tagLocal, message: "Try to get prise, cost, sales and number ");
      var resPriceWin = await DBProvider.db.getPriceWinByDate(
          price: "price",
          win: "win",
          number: "number",
          tableName: tableName,
          element: "date",
          date: date,
          date1: date1,
          tag: tagLocal);
      if (resPriceWin.isNotEmpty) {
        Log(
            tag: tagLocal,
            message:
                "resPriceWin is not empty ,price: ${resPriceWin.first['price']}, win: ${resPriceWin.first['win']}");
        setState(() {
          win = resPriceWin.first['win'];
          sale = cost = resPriceWin.first['price'];
          number = resPriceWin.first['number'];
        });
      } else {
        Log(tag: tagLocal, message: "No data price ...!! ");
      }
      var resMaxPriceInItem =
          await DBProvider.db.getObjectsByDateMaxNumberGroupeElement(
        elementMax: "price",
        elementMax1: "win",
        elementGroup: "IDItem",
        tableName: tableName,
        tag: tagLocal,
        element: "date",
        date: date,
        date1: date1,
      );
      if (resMaxPriceInItem.isNotEmpty) {
        for (var jsonItemId in resMaxPriceInItem) {
          Log(tag: tagLocal, message: "jsonItemId: $jsonItemId ");
          var itemVar = await DBProvider.db
              .getObject(id: jsonItemId['IDItem'], tableName: itemTableName);
          if (itemVar.isNotEmpty) {
            setState(() {
              Item item = Item.fromJson(itemVar.first);
              chartDataPrice.add(ChartData(item.name, jsonItemId['price']));
              chartDataWin.add(ChartData(item.name, jsonItemId['win']));
              chartDataNumber.add(ChartData(item.name, jsonItemId['number']));
            });
          }
        }
      } else {
        Log(tag: tagLocal, message: "No data chart data 1..!!");
      }
      var resMaxPriceInDepot =
          await DBProvider.db.getObjectsByDateMaxNumberGroupeElement(
        elementMax: "price",
        elementMax1: "win",
        elementGroup: "depotID",
        tableName: tableName,
        tag: tagLocal,
        element: "date",
        date: date,
        date1: date1,
      );
      if (resMaxPriceInDepot.isNotEmpty) {
        for (var jsonDepotId in resMaxPriceInDepot) {
          Log(tag: tagLocal, message: "jsonDepotId: $jsonDepotId ");
          var depotVar = await DBProvider.db
              .getObject(id: jsonDepotId['depotID'], tableName: depotTableName);
          if (depotVar.isNotEmpty) {
            setState(() {
              Depot depot = Depot.fromJson(depotVar.first);
              chartDataPriceDepot
                  .add(ChartData(depot.name, jsonDepotId['price']));
              chartDataWinDepot.add(ChartData(depot.name, jsonDepotId['win']));
              chartDataNumberDepot
                  .add(ChartData(depot.name, jsonDepotId['number']));
            });
          }
        }
      } else {
        Log(tag: tagLocal, message: "No data chart data 2..!!");
      }
      DateTime dt = DateTime.parse(date);
      DateTime dt1 = DateTime.parse(date1);
      while (dt.compareTo(dt1) <= 0) {
        Log(tag: tag, message: "dt: $dt, dt1: $dt1");

        var resMaxPerDay = await DBProvider.db.getPriceWinByDate(
            price: "price",
            win: "win",
            number: "number",
            tableName: tableName,
            element: "date",
            date: dt.toString(),
            tag: tagLocal);

        if (resMaxPerDay.isNotEmpty) {
          setState(() {
            chartDataPriceDay.add(ChartData(
                "${dt.month}/${dt.day}", resMaxPerDay.first['price']));
            chartDataWinDay.add(
                ChartData("${dt.month}/${dt.day}", resMaxPerDay.first['win']));
            chartDataNumberDay.add(ChartData(
                "${dt.month}/${dt.day}", resMaxPerDay.first['number']));
          });
        }
        dt = DateTime(dt.year, dt.month, dt.day + 1);
      }
    } else {
      Log(tag: tag, message: "date is empty");
    }
  }

  late double width = 0, height = 0;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double width = 0, height = 0;
    Log(
        tag: tag,
        message: " size width: ${size.width}, size height: ${size.height}");
    if (size.width < 1400 && size.width > 1000) {
      width = 300;
      height = 70;
    } else if (size.width <= 1000 && size.width > 800) {
      width = 240;
      height = 70;
    } else if (size.width <= 800 && size.width > 600) {
      width = 580;
      height = 70;
    } else if (size.width <= 600 && size.width > 400) {
      width = 380;
      height = 70;
    } else if (size.width <= 400) {
      width = size.width;
      height = 50;
    } else if (size.width > 1000 && size.width <= 1400) {
      width = 300;
      height = 80;
    } else if (size.width > 1400 && size.width <= 1600) {
      width = 400;
      height = 80;
    } else if (size.width > 1600) {
      width = 500;
      height = 90;
    }

    Log(tag: tag, message: "  width: $width, size height: $height");
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.report),
        centerTitle: true,
        actions: [
          LanguagePickerWidget(),
          const SizedBox(width: 12),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
            //mainAxisAlignment: MainAxisAlignment.start,
            //crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // search date
              Row(
                children: [
                  Flexible(
                    child: inputElementDateFormField(
                        context: context,
                        controller: dateController,
                        onChanged: ((value) {
                          setState(() {
                            dateController.text = value!;
                          });
                        })),
                  ),
                  Flexible(
                    child: inputElementDateFormField(
                        context: context,
                        controller: dateController1,
                        onChanged: ((value) {
                          setState(() {
                            dateController1.text = value!;
                          });
                        })),
                  ),
                  IconButton(
                    icon: const Icon(Icons.search),
                    onPressed: () async {
                      Log(
                          tag: "searchInItemBill",
                          message: dateController1.text);
                      DateTime dt = DateTime.parse("2022-06-01");
                      DateTime dt1 = DateTime.parse("2022-06-20");
                      if (dt.compareTo(dt1) < 0) {
                        await searchInItemBillIn(
                            date1: "2022-06-30", date: "2022-06-01");
                      }
                    },
                  ),
                ],
              ),
              // cost, revenue and sales
              Visibility(
                visible: cost != 0,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Wrap(
                    //mainAxisAlignment: MainAxisAlignment.start,
                    // direction: size.width > 930 ? Axis.horizontal : Axis.vertical,
                    children: [
                      reportIcon(
                          iconData: Icons.format_list_numbered,
                          title: 'Number:',
                          data: number.toStringAsFixed(2)),
                      reportIcon(
                          iconData: const IconData(0xe3f8,
                              fontFamily: 'MaterialIcons'),
                          title: 'Cost:',
                          data: '\$${cost.toStringAsFixed(2)}'),
                      reportIcon(
                          iconData: Icons.price_check_sharp,
                          title: 'Sales:',
                          data: '\$${sale.toStringAsFixed(2)}'),
                      reportIcon(
                          iconData: Icons.price_check_sharp,
                          title: 'Revenue:',
                          data: '\$${win.toStringAsFixed(2)}'),
                    ],
                  ),
                ),
              ),
              //plot item title
              Visibility(
                  visible: chartDataPrice.isNotEmpty,
                  child: analyseSectionTitle(title: "Items Report:")),
              // plots win , price and number per item
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  child: Flex(
                    direction:
                        size.width > 800 ? Axis.horizontal : Axis.vertical,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      getChart(
                          xTitle: AppLocalizations.of(context)!.item,
                          yTitle: AppLocalizations.of(context)!.price,
                          width: width,
                          tooltipBehavior: tooltipBehaviorPrice,
                          title: AppLocalizations.of(context)!.sale_by_item,
                          data: chartDataPrice),
                      getChart(
                          xTitle: AppLocalizations.of(context)!.item,
                          yTitle: AppLocalizations.of(context)!.win,
                          tooltipBehavior: tooltipBehaviorWin,
                          width: width,
                          title: AppLocalizations.of(context)!.win_by_item,
                          data: chartDataWin),
                      getChart(
                          xTitle: AppLocalizations.of(context)!.item,
                          tooltipBehavior: tooltipBehaviorNumber,
                          yTitle: AppLocalizations.of(context)!.number,
                          width: width,
                          title: AppLocalizations.of(context)!.number_by_item,
                          data: chartDataNumber),
                    ],
                  ),
                ),
              ), // plots win , price and number per depot
              //plot pie title
              Visibility(
                  visible: chartDataPrice.isNotEmpty,
                  child: analyseSectionTitle(title: "Items Report Pie:")),
              // Pie win , price and number per item
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  child: Flex(
                    direction:
                        size.width > 800 ? Axis.horizontal : Axis.vertical,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      getCircularChart(
                          xTitle: AppLocalizations.of(context)!.item,
                          yTitle: AppLocalizations.of(context)!.price,
                          width: width,
                          tooltipBehavior: tooltipBehaviorPrice,
                          title: AppLocalizations.of(context)!.sale_by_item,
                          data: chartDataPrice),
                      getCircularChart(
                          xTitle: AppLocalizations.of(context)!.item,
                          yTitle: AppLocalizations.of(context)!.win,
                          tooltipBehavior: tooltipBehaviorWin,
                          width: width,
                          title: AppLocalizations.of(context)!.win_by_item,
                          data: chartDataWin),
                      getCircularChart(
                          xTitle: AppLocalizations.of(context)!.item,
                          tooltipBehavior: tooltipBehaviorNumber,
                          yTitle: AppLocalizations.of(context)!.number,
                          width: width,
                          title: AppLocalizations.of(context)!.number_by_item,
                          data: chartDataNumber),
                    ],
                  ),
                ),
              ), // plots win , price and number per depot
              //plot depot title
              Visibility(
                  visible: chartDataPriceDepot.isNotEmpty,
                  child: analyseSectionTitle(title: "Depot Report:")),
              // plots win , price and number per depot
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  child: Flex(
                    direction:
                        size.width > 800 ? Axis.horizontal : Axis.vertical,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      getChart(
                          xTitle: AppLocalizations.of(context)!.item,
                          yTitle: AppLocalizations.of(context)!.price,
                          width: width,
                          tooltipBehavior: tooltipBehaviorPrice,
                          title: AppLocalizations.of(context)!.sale_by_item,
                          data: chartDataPriceDepot),
                      getChart(
                          xTitle: AppLocalizations.of(context)!.item,
                          yTitle: AppLocalizations.of(context)!.win,
                          tooltipBehavior: tooltipBehaviorWin,
                          width: width,
                          title: AppLocalizations.of(context)!.win_by_item,
                          data: chartDataWinDepot),
                      getChart(
                          xTitle: AppLocalizations.of(context)!.item,
                          tooltipBehavior: tooltipBehaviorNumber,
                          yTitle: AppLocalizations.of(context)!.number,
                          width: width,
                          title: AppLocalizations.of(context)!.number_by_item,
                          data: chartDataNumberDepot),
                    ],
                  ),
                ),
              ), //plot day title
              //Pie depot title
              Visibility(
                  visible: chartDataPriceDepot.isNotEmpty,
                  child: analyseSectionTitle(title: "Depot Report Pie:")),
              // plots win , price and number per depot
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  child: Flex(
                    direction:
                        size.width > 800 ? Axis.horizontal : Axis.vertical,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      getCircularChart(
                          xTitle: AppLocalizations.of(context)!.item,
                          yTitle: AppLocalizations.of(context)!.price,
                          width: width,
                          tooltipBehavior: tooltipBehaviorPrice,
                          title: AppLocalizations.of(context)!.sale_by_item,
                          data: chartDataPriceDepot),
                      getCircularChart(
                          xTitle: AppLocalizations.of(context)!.item,
                          yTitle: AppLocalizations.of(context)!.win,
                          tooltipBehavior: tooltipBehaviorWin,
                          width: width,
                          title: AppLocalizations.of(context)!.win_by_item,
                          data: chartDataWinDepot),
                      getCircularChart(
                          xTitle: AppLocalizations.of(context)!.item,
                          tooltipBehavior: tooltipBehaviorNumber,
                          yTitle: AppLocalizations.of(context)!.number,
                          width: width,
                          title: AppLocalizations.of(context)!.number_by_item,
                          data: chartDataNumberDepot),
                    ],
                  ),
                ),
              ), //plot day title

              //plot day title
              Visibility(
                  visible: chartDataPriceDepot.isNotEmpty,
                  child: analyseSectionTitle(title: "Day Report:")),
              // plots win , price and number per day
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  child: Flex(
                    direction:
                        size.width > 800 ? Axis.horizontal : Axis.vertical,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      getChart(
                          //showColumnSeries: false,
                          xTitle: AppLocalizations.of(context)!.item,
                          yTitle: AppLocalizations.of(context)!.price,
                          width: width,
                          tooltipBehavior: tooltipBehaviorPrice,
                          title: AppLocalizations.of(context)!.sale_by_item,
                          data: chartDataPriceDay),
                      getChart(
                          xTitle: AppLocalizations.of(context)!.item,
                          yTitle: AppLocalizations.of(context)!.win,
                          tooltipBehavior: tooltipBehaviorWin,
                          width: width,
                          title: AppLocalizations.of(context)!.win_by_item,
                          data: chartDataWinDay),
                      getChart(
                          xTitle: AppLocalizations.of(context)!.item,
                          tooltipBehavior: tooltipBehaviorNumber,
                          yTitle: AppLocalizations.of(context)!.number,
                          width: width,
                          title: AppLocalizations.of(context)!.number_by_item,
                          data: chartDataNumberDay),
                    ],
                  ),
                ),
              )
            ]),
      ),
    );
  }
}
