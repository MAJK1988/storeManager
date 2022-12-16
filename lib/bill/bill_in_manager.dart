import 'package:flutter/material.dart';
import 'package:store_manager/utils/objects.dart';

import '../dataBase/bill_in_sql.dart';
import '../dataBase/sql_object.dart';
import '../utils/drop_down_button_new.dart';
import '../utils/utils.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class BillInManager extends StatefulWidget {
  final String typeBill;
  const BillInManager({super.key, required this.typeBill});

  @override
  State<BillInManager> createState() => _BillInManagerState();
}

class _BillInManagerState extends State<BillInManager> {
  late String searchFor = "Search for";
  late List<Bill> bills = [];
  late List<Worker> works = [];
  late List<Supplier> suppliers = [];
  late List<ShowObject> showObject = [];
  late List<ShowObject> showItemBillObject = [];
  late List<ItemBill> listItemBill = [];
  late String tag = "BillInManager";
  late int indexBill = 0, indexBillItem = 0;
  late String searchForValue = "";

  TextEditingController dateController = TextEditingController();

  getItemBill({required Bill bill}) async {
    String tableName =
        widget.typeBill == billIn ? billInItemTableName : billIOutItemTableName;
    bool isExist = await DBProvider.db.checkExistTable(tableName: tableName);
    Log(
        tag: tag,
        message:
            "Try to get items bill, table name: $tableName, is exist?! $isExist ");
    if (isExist) {
      var resItemBill = await DBProvider.db
          .getAllBillItemForUniqueBill(tableName: tableName, billId: bill.ID);
      if (resItemBill.isNotEmpty) {
        Log(tag: tag, message: "ItemBill isn't empty");
        for (var i in resItemBill) {
          if (tableName == billIOutItemTableName) {
            ItemBillOut itemBillOut = ItemBillOut.fromJson(i);
          }

          ItemBill b = tableName == billInItemTableName
              ? ItemBill.fromJson(i)
              : ItemBill.fromJsonOut(i);
          //showItemBillObject
          var resItem = await DBProvider.db
              .getObject(id: b.IDItem, tableName: itemTableName);
          var resDepot = await DBProvider.db
              .getObject(id: b.depotID, tableName: depotTableName);
          if (resItem.isNotEmpty && resDepot.isNotEmpty) {
            Item item = Item.fromJson(resItem.first);
            Depot depot = Depot.fromJson(resDepot.first);

            List<DynamicObject> dynamicObjects = [];
            var resItemDepots =
                await DBProvider.db.getAllObjects(tableName: item.depotID);
            if (resItemDepots.isNotEmpty) {
              for (var resItemDepot in resItemDepots) {
                ItemDepot itemDepot = ItemDepot.fromJson(resItemDepot);
                var resDepot = await DBProvider.db.getObject(
                    id: itemDepot.depotId, tableName: depotTableName);
                if (resDepot.isNotEmpty) {
                  Depot depot = Depot.fromJson(resDepot.first);
                  dynamicObjects.add(DynamicObject(
                      param: depot.name,
                      value: itemDepot.number.toStringAsFixed(2)));
                }
              }
            }

            setState(() {
              listItemBill.add(b);
              showItemBillObject.add(ShowObject(
                  value0: item.name,
                  value1: b.productDate,
                  value2: b.number.toStringAsFixed(2),
                  value3: b.price.toStringAsFixed(2),
                  value4: depot.name,
                  dynamicObjects: dynamicObjects));
            });
          }
        }
        Log(tag: tag, message: "ItemBill length is: ${listItemBill.length} ");
      } else {
        Log(tag: tag, message: "ItemBill is empty");
      }
    }
  }

  getAllBillIn() async {
    Log(tag: tag, message: "read all bill in");
    String tableName =
        widget.typeBill == billIn ? billInTableName : billIOutTableName;
    Log(tag: tag, message: "tableName: $tableName");
    var res = await DBProvider.db.getAllObjects(tableName: tableName);

    if (res.isNotEmpty) {
      for (var b in res) {
        Bill bill = Bill.fromJson(b);
        //get bill worker
        var resW = await DBProvider.db
            .getObject(id: bill.workerId, tableName: workerTableName);
        //get bill supplier
        var resS = await DBProvider.db
            .getObject(id: bill.outsidePersonId, tableName: supplierTableName);

        if (resS.isNotEmpty && resW.isNotEmpty) {
          setState(() {
            bills.add(bill);
            Supplier s = Supplier.fromJson(resS.first, supplierType);
            Worker w = Worker.fromJson(resW.first);
            suppliers.add(s);
            works.add(w);
            showObject.add(ShowObject(
                value0: bill.dateTime,
                value1: s.name,
                value2: w.name,
                value3: bill.totalPrices.toStringAsFixed(2)));
          });
        }
      }
      Log(
          tag: tag,
          message:
              "Bill table isn't empty, Bill number is: ${bills.length}, Worker number is: ${works.length},"
              "suppliers number is: ${suppliers.length}");
    } else {
      Log(tag: tag, message: "Bill table is empty");
    }
  }

  getAllBillInFromList({required List<Bill> listBill}) async {
    String tagLocal = "$tag/getAllBillInFromList";
    Log(tag: tagLocal, message: "read all bill in");

    if (listBill.isNotEmpty) {
      setState(() {
        bills.clear();
        suppliers.clear();
        works.clear();
        showObject.clear();
      });
      for (var bill in listBill) {
        //get bill worker
        var resW = await DBProvider.db
            .getObject(id: bill.workerId, tableName: workerTableName);
        //get bill supplier
        var resS = await DBProvider.db
            .getObject(id: bill.outsidePersonId, tableName: supplierTableName);

        if (resS.isNotEmpty && resW.isNotEmpty) {
          setState(() {
            bills.add(bill);
            Supplier s = Supplier.fromJson(resS.first, supplierType);
            Worker w = Worker.fromJson(resW.first);
            suppliers.add(s);
            works.add(w);
            showObject.add(ShowObject(
                value0: bill.dateTime,
                value1: s.name,
                value2: w.name,
                value3: bill.totalPrices.toStringAsFixed(2)));
          });
        }
      }
    } else {
      Log(tag: tagLocal, message: "Bill list is empty");
    }
  }

  searchInItemBill() async {
    String tagLocal = "$tag/searchInItemBill";
    Log(tag: tagLocal, message: "Start function1");
    String tableNameBill =
        widget.typeBill == billIn ? billInTableName : billIOutTableName;
    String tableName =
        widget.typeBill == billIn ? billInItemTableName : billIOutItemTableName;
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
        await getAllBillInFromList(listBill: listBill);
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
          setState(() {
            showItemBillObject.clear();
          });
          for (var jsonBillOutItem in resDateSearchBillOutItem) {
            setState(() {
              ItemBillOut itemBillOut = ItemBillOut.fromJson(jsonBillOutItem);

              showItemBillObject.add(ShowObject(
                  value0: itemBillOut.IDItem.toString(),
                  value1: itemBillOut.productDate,
                  value2: itemBillOut.number.toStringAsFixed(2),
                  value3: itemBillOut.price.toStringAsFixed(2),
                  value4: itemBillOut.depotID.toString()));
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
  void initState() {
    // TODO: implement initState
    () async {
      await getAllBillIn();
      if (bills.isNotEmpty) {
        Bill b = bills[0];

        await getItemBill(bill: b);
      }
    }();
    super.initState();
  }

  late List<String> listSearchElement = getElementsBill();
  late String initElementSearch = getElementsBill().first;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.bill_manager),
        centerTitle: true,
      ),
      body: Center(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Flexible(
              child: Column(
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: searchForWidget(searchFor: searchForValue),
                      ),
                      IconButton(
                        icon: const Icon(Icons.search),
                        onPressed: () async {
                          await searchInItemBill();
                        },
                      ),
                      DropdownButtonNew(
                          initValue: initElementSearch,
                          flex: 1,
                          items: listSearchElement,
                          icon: Icons.fact_check,
                          onSelect: (value) {
                            if (value!.isNotEmpty) {
                              setState(() {
                                searchForValue = "date";
                              });
                            }
                          }),
                    ],
                  ),
                  Expanded(
                      child: Card(
                    child: ListView.builder(
                      itemCount: showObject.length,
                      itemBuilder: (context, index) {
                        return Card(
                          color: index == indexBill
                              ? Colors.blue.shade100
                              : Colors.blue.shade50,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ListTile(
                              leading: Text(
                                  '${AppLocalizations.of(context)!.supplier}: ${showObject[index].value1}'),
                              title: Text(
                                  '${AppLocalizations.of(context)!.date}: ${showObject[index].value0}'),
                              subtitle: Text(
                                  '${AppLocalizations.of(context)!.worker}: ${showObject[index].value2}'),
                              trailing: Stack(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(right: 30),
                                    child: Text(
                                      '${AppLocalizations.of(context)!.price}: ${showObject[index].value3} \$',
                                    ),
                                  ),
                                  Positioned.fill(
                                    top: -10,
                                    child: Align(
                                      alignment: Alignment.topRight,
                                      child: IconButton(
                                          iconSize: 20,
                                          icon: const Icon(Icons.delete),
                                          onPressed: () async {
                                            Log(
                                                tag: tag,
                                                message:
                                                    "Try to launch delete bill process");
                                            Bill b = bills[index];
                                            if (widget.typeBill == billOut) {
                                              await deleteBillOut(
                                                  bill: b, tagMain: tag);
                                            } else {
                                              await deleteBillIn(
                                                  bill: b, tagMain: tag);
                                            }
                                          }),
                                    ),
                                  ),
                                ],
                              ),
                              onTap: () async {
                                Log(
                                    tag: tag,
                                    message:
                                        "Try to get item bill of $index bill");
                                if (index < bills.length) {
                                  setState(() {
                                    showItemBillObject.clear();
                                    indexBill = index;
                                  });
                                  Bill b = bills[index];
                                  await getItemBill(bill: b);
                                }
                              },
                            ),
                          ),
                        );
                      },
                    ),
                  )),
                ],
              ),
            ),
            // Show bill item
            Flexible(
              child: Column(
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: inputElementTable(
                            controller: null,
                            hintText: searchFor,
                            onChang: (value) {},
                            context: context),
                      ),
                      IconButton(
                        icon: const Icon(Icons.search),
                        onPressed: () {},
                      ),
                      DropdownButtonNew(
                          initValue: initElementSearch,
                          flex: 1,
                          items: listSearchElement,
                          icon: Icons.fact_check,
                          onSelect: (value) {
                            if (value!.isNotEmpty) {
                              setState(() {});
                            }
                          }),
                    ],
                  ),
                  Expanded(
                      child: Card(
                    child: ListView.builder(
                      itemCount: showItemBillObject.length,
                      itemBuilder: (context, index) {
                        return Card(
                          color: index == indexBillItem
                              ? Colors.blue.shade100
                              : Colors.blue.shade50,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ListTile(
                              leading: Text(
                                  '${AppLocalizations.of(context)!.name}: ${showItemBillObject[index].value0}'),
                              title: Text(
                                  '${AppLocalizations.of(context)!.date}: ${showItemBillObject[index].value1}'),
                              subtitle: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                        '${AppLocalizations.of(context)!.count}: ${showItemBillObject[index].value2}'),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                        '${AppLocalizations.of(context)!.depot}: ${showItemBillObject[index].value4}'),
                                  ),
                                ],
                              ),
                              trailing: Stack(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(right: 30),
                                    child: Text(
                                      '${AppLocalizations.of(context)!.price}: ${showItemBillObject[index].value3} \$',
                                    ),
                                  ),
                                  Positioned.fill(
                                    top: -10,
                                    child: Align(
                                      alignment: Alignment.topRight,
                                      child: IconButton(
                                          iconSize: 20,
                                          icon: const Icon(Icons.delete),
                                          onPressed: () {}),
                                    ),
                                  ),
                                ],
                              ),
                              onTap: () {
                                setState(() {
                                  indexBillItem = index;
                                });
                              },
                            ),
                          ),
                        );
                      },
                    ),
                  )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  searchForWidget({required String searchFor}) {
    switch (searchFor) {
      case "date":
        {
          return inputElementDateFormField(
              context: context,
              controller: dateController,
              onChanged: ((value) {
                setState(() {
                  dateController.text = value!;
                });
              }));
        }

      default:
        {
          return inputElementTable(
              controller: null,
              hintText: searchFor,
              onChang: (value) {},
              context: context);
        }
    }
  }
}
