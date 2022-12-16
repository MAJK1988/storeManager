import 'package:flutter/material.dart';
import 'package:store_manager/lang_provider/language_picker_widget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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

  searchInItemBillIn({String typeBill = billIn}) async {
    String tagLocal = "$tag/searchInItemBill";
    Log(tag: tagLocal, message: "Start function1");
    String tableNameBill =
        typeBill == billIn ? billInTableName : billIOutTableName;
    String tableName =
        typeBill == billIn ? billInItemTableName : billIOutItemTableName;
    Log(tag: tagLocal, message: "Table name is: $tableNameBill");
    if (dateController.text.isNotEmpty) {
      var resBillSearchResult = await DBProvider.db.getObjectsByDate(
          tableName: tableNameBill,
          element: "dateTime",
          date: dateController.text,
          tag: tagLocal);
      if (resBillSearchResult.isNotEmpty) {
        Log(tag: tagLocal, message: "resBillSearchResult is not empty");
        List<Bill> listBill = [];
        for (var jsonBill in resBillSearchResult) {
          listBill.add(Bill.fromJson(jsonBill));
        }
        Log(
            tag: tagLocal,
            message:
                "Number of bill in ${dateController.text}: is ${listBill.length + 1}");
        var resDateSearchBillOutItem = await DBProvider.db
            .getObjectsByDateMaxNumber(
                tableName: tableName,
                element: "date",
                date: dateController.text,
                elementGroup: "IDItem",
                elementOrder: "number",
                tag: tagLocal);
        if (resDateSearchBillOutItem.isNotEmpty) {
          var resSearchMaxPrice = await DBProvider.db.getObjectsByDateMaxPrice(
              id: "id",
              tableName: tableName,
              element: "date",
              date: dateController.text,
              elementMax: "price",
              tag: tagLocal);
          Log(
              tag: tagLocal,
              message: "Index of itemBill out is $resSearchMaxPrice");
          if (resSearchMaxPrice.isNotEmpty) {
            ItemBillOut itemBillOutMaxPrice =
                ItemBillOut.fromJson(resSearchMaxPrice.first);
            Log(
                tag: tagLocal,
                message:
                    "Item of max price is ${itemBillOutMaxPrice.IDItem}, price max is ${itemBillOutMaxPrice.price}");
          }
          var resMaxPriceInDepot = await DBProvider.db
              .getObjectsByDateMaxNumberGroupeElement(
                  elementMax: "price",
                  elementGroup: "depotID",
                  tableName: tableName,
                  tag: tagLocal,
                  element: "date",
                  date: dateController.text);
          if (resMaxPriceInDepot.isNotEmpty) {
            /*ItemBillOut itemBillOutMaxPriceDepot =
                ItemBillOut.fromJson(resMaxPriceInDepot.first);
            Log(
                tag: tagLocal,
                message:
                    "Item of max price is ${itemBillOutMaxPriceDepot.IDItem}, Depot of max price is ${itemBillOutMaxPriceDepot.depotID}, price max is ${itemBillOutMaxPriceDepot.price}");
          */
            for (var jsonDepotId in resMaxPriceInDepot) {
              Log(tag: tagLocal, message: "jsonDepotId: $jsonDepotId ");
            }
          }
          var resMaxPriceInItem = await DBProvider.db
              .getObjectsByDateMaxNumberGroupeElement(
                  elementMax: "price",
                  elementMax1: "win",
                  elementGroup: "IDItem",
                  tableName: tableName,
                  tag: tagLocal,
                  element: "date",
                  date: dateController.text);
          if (resMaxPriceInItem.isNotEmpty) {
            for (var jsonDepotId in resMaxPriceInItem) {
              Log(tag: tagLocal, message: "jsonDepotId: $jsonDepotId ");
            }
          }
          var resMaxWinInItem = await DBProvider.db
              .getObjectsByDateMaxNumberGroupeElement(
                  elementMax: "win",
                  elementGroup: "IDItem",
                  tableName: tableName,
                  tag: tagLocal,
                  element: "date",
                  date: dateController.text);
          if (resMaxPriceInItem.isNotEmpty) {
            for (var jsonDepotId in resMaxWinInItem) {
              Log(tag: tagLocal, message: "jsonDepotId: $jsonDepotId ");
            }
          }

          var reportDayPriceWin = await DBProvider.db.getReportDayByObject(
              dateString: "date",
              tableName: tableName,
              tag: tagLocal,
              element: "price",
              element1: "win",
              date: dateController.text);
          if (reportDayPriceWin.isNotEmpty) {
            for (var jsonDepotId in reportDayPriceWin) {
              Log(tag: tagLocal, message: "Day report: $jsonDepotId ");
            }
          }

          Log(tag: tagLocal, message: "resDateSearchBillOutItem is not empty");

          for (var jsonBillOutItem in resDateSearchBillOutItem) {
            setState(() {
              ItemBillOut itemBillOut = ItemBillOut.fromJson(jsonBillOutItem);
            });
          }
        } else {
          Log(tag: tagLocal, message: "resDateSearchBillOutItem is  empty");
        }
      } else {
        Log(tag: tagLocal, message: "resBillSearchResult is empty");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
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
        child: Column(children: [
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
              IconButton(
                icon: const Icon(Icons.search),
                onPressed: () async {
                  await searchInItemBillIn();
                },
              ),
            ],
          )
        ]),
      ),
    );
  }
}
/**inputElementDateFormField(
              context: context,
              controller: dateController,
              onChanged: ((value) {
                setState(() {
                  dateController.text = value!;
                });
              })); */
