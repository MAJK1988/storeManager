import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:store_manager/dataBase/sql_object.dart';
import 'package:store_manager/utils/utils.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../utils/drop_down_button_new.dart';
import '../utils/objects.dart';
import '../utils/utils.dart';

class ReportElement extends StatefulWidget {
  final String tableName;
  final dynamic element;
  const ReportElement(
      {super.key, required this.tableName, required this.element});

  @override
  State<ReportElement> createState() => _ReportElementState();
}

class _ReportElementState extends State<ReportElement> {
  late String tag = "ReportElement", elementSearch = "", objectSearch = "";
  late List<String> listSearchElement = ['Depot', 'Date', 'Supplier'];
  late List<ChartData> chartDataItemDepot = <ChartData>[];
  late TooltipBehavior tooltipBehavior;
  @override
  void initState() {
    // TODO: implement initState
    if (widget.element is Item) {
      Log(tag: tag, message: "element is Item");
      setState(() {
        objectSearch = itemTableName;
      });
    }
    tooltipBehavior = TooltipBehavior(
        enable: true,
        builder: (dynamic data, dynamic point, dynamic series, int pointIndex,
            int seriesIndex) {
          return Card(
              child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('${point.x} : ${point.y.toStringAsFixed(2)}\$'),
          ));
        });

    super.initState();
  }

  getReportElements({required String searchIn}) async {
    String tagLocal = "$tag/getReportElements";
    if (objectSearch.isNotEmpty) {
      if (widget.element is Item) {
        Item item = widget.element;
        if (searchIn == listSearchElement[0]) {
          Log(
              tag: tagLocal,
              message:
                  "Search for ${widget.element.name} in ${listSearchElement[0]}");
          // search for item in depot, in item
          var resultSearch =
              await DBProvider.db.getAllObjects(tableName: item.depotID);
          if (resultSearch.isNotEmpty) {
            for (var resJson in resultSearch) {
              Log(
                  tag: tagLocal,
                  message:
                      "depotId: ${ItemDepot.fromJson(resJson).depotId}, number: ${ItemDepot.fromJson(resJson).number}");
              Log(tag: tag, message: "Get depot from depot table");
              var depotResult = await DBProvider.db.getObject(
                  id: ItemDepot.fromJson(resJson).depotId,
                  tableName: depotTableName);
              if (depotResult.isNotEmpty) {
                Depot depot = Depot.fromJson(depotResult.first);
                setState(() {
                  chartDataItemDepot.add(ChartData(
                      depot.name, ItemDepot.fromJson(resJson).number));
                });
                /*Log(
                    tag: tagLocal,
                    message:
                        "Try to get the item number in depot name ${depot.name}");

                var checkExistItemInDepot = await DBProvider.db
                    .getObjectsNumberGroupeElement(
                        checkedElement: "itemId",
                        checkedValue: item.ID,
                        tableName: depot.depotListItem,
                        outElement: "number",
                        tag: tagLocal);
                if (checkExistItemInDepot.isNotEmpty) {
                  double number = checkExistItemInDepot.first['number'];
                  Log(
                      tag: tagLocal,
                      message: "item number in ${depot.name} is $number");
                }*/
              }
            }
          } else {
            Log(tag: tag, message: "${item.depotID} is not exist!!!");
          }
        }
      }
    }
  }

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
    return Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.report),
          centerTitle: true,
        ),
        body: Column(
          //direction: Axis.horizontal,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      child: RichText(
                          text: TextSpan(
                              style: const TextStyle(
                                  color: Color.fromARGB(
                                      255, 59, 59, 60)), //apply style to all
                              children: [
                            const TextSpan(
                                text: 'Element name: ',
                                style: TextStyle(fontSize: 16)),
                            TextSpan(
                                text: widget.element.name,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                    fontStyle: FontStyle.italic))
                          ])),
                    ),
                    Row(
                      children: [
                        const Text("Search by: ",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            )),
                        SizedBox(
                          width: 150,
                          child: DropdownButtonNew(
                              initValue: listSearchElement[0],
                              flex: 1,
                              items: listSearchElement,
                              icon: Icons.arrow_circle_down_outlined,
                              onSelect: (value) {
                                setState(() {
                                  if (value!.isNotEmpty) {
                                    elementSearch = value;
                                  }
                                });
                              }),
                        ),
                      ],
                    ),
                    Visibility(
                      visible: elementSearch.isNotEmpty,
                      child: IconButton(
                          icon: const Icon(Icons.search),
                          onPressed: () async {
                            await getReportElements(searchIn: elementSearch);
                          }),
                    )
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                child: Flex(
                  direction: size.width > 800 ? Axis.horizontal : Axis.vertical,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    getChart(
                        xTitle: AppLocalizations.of(context)!.item,
                        yTitle: AppLocalizations.of(context)!.price,
                        width: width,
                        tooltipBehavior: tooltipBehavior,
                        title: AppLocalizations.of(context)!.sale_by_item,
                        data: chartDataItemDepot),
                    getCircularChart(
                        xTitle: AppLocalizations.of(context)!.item,
                        yTitle: AppLocalizations.of(context)!.price,
                        width: width,
                        tooltipBehavior: tooltipBehavior,
                        title: AppLocalizations.of(context)!.sale_by_item,
                        data: chartDataItemDepot),
                  ],
                ),
              ),
            ), // plots win , price and number per depot
          ],
        ));
  }
}
