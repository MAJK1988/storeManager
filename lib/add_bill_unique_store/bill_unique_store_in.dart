import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:store_manager/pdf/print_invoice.dart';
import 'package:store_manager/utils/objects.dart';

import '../dataBase/bill_in_sql.dart';
import '../dataBase/search_column.dart';
import '../dataBase/sql_object.dart';
import '../utils/utils.dart';

class BillUniqStoreIn extends StatefulWidget {
  final String billType;
  const BillUniqStoreIn({super.key, this.billType = billIn});

  @override
  State<BillUniqStoreIn> createState() => _BillUniqStoreInState();
}

class _BillUniqStoreInState extends State<BillUniqStoreIn> {
  final String tag = "BillUniqStoreIn";
  late bool searchVisibility = false;
  late String initObjectSearch = "";
  TextEditingController billInDateController = TextEditingController(),
      itemController = TextEditingController(),
      numberController = TextEditingController(),
      supplierController = TextEditingController(),
      workerController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  late final List<ItemBill> itemBillIns = [];
  late Item selectedItem;
  late Depot selectedDepot = intDepot;
  late Supplier selectedSupplier = intSupplier;
  late Worker selectedWorker = intWorker;
  late String productionDate;
  late double itemNumber = 0;
  late double toTalPrice = 0.0;

  late List<Item> listItems = [];
  late List<Item> listSelectedItems = [];
  late List<Worker> listWorkers = [];
  late List<Supplier> listSupplier = [];
  late List<Depot> listDepot = [];
  late List<Depot> listDepotSelected = [];
  late List<ShowObject> listShowObject = [];
  late List<ShowObject> listShowObjectMainTable = [];
  late List<ItemsDepot> listItemsDepot = [];
  late List<ItemsDepot> listSelectedItemsDepot = [];
  late ItemsDepot selectedItemsDepot = selectedItemsDepot.init();
  late List<String> listSearchElement = getElementsItems();
  late String initElementSearch = getElementsItems().first;
  late List<String> listObjectSearch = getObjectsNameListAddBillIn();
  late String tableName = itemTableName;
  late String titleDialog = "";
  late Widget widgetDialog = SizedBox();
  late String dateProduction = "";
  late int depotItemIndex = -1;
  late List<int> depotItemIndexList = [];
  late double totalPrice = 0.0;
  late double price = 0.0;
  late int indexItemsDepot = 0;

  dataEntryTable({required String billType}) {
    if (billType == billIn) {
      return TableRow(children: [
        TableCell(
            // item
            child: Card(
          child: inputElementTable(
              controller: itemController,
              ontap: (value) {
                setState(() {
                  initObjectSearch = "Item";
                  searchVisibility = !searchVisibility;
                });
              },
              onChang: (value) {},
              context: context),
        )),
        //number
        Card(
          child: TableCell(
              child: inputElementTable(
                  controller: numberController,
                  onChang: (value) {
                    if (double.tryParse(value!) != null) {
                      setState(() {
                        itemNumber = double.parse(value);
                        totalPrice = price * itemNumber;
                      });
                    }
                  },
                  context: context)),
        ),
        //production date

        //price
        Card(
          child: Center(
            child: TableCell(
                child: Padding(
              padding: EdgeInsets.all(padding),
              child: Text(
                '${price.toStringAsFixed(2)} \$',
                style: const TextStyle(fontSize: 18),
              ),
            )),
          ),
        ),
        //Depot
        // totalPrice
        Card(
          child: Stack(children: [
            TableCell(
                child: Center(
              child: Padding(
                padding: EdgeInsets.all(padding),
                child: Text(
                  '${totalPrice.toStringAsFixed(2)} \$',
                  style: const TextStyle(fontSize: 18),
                ),
              ),
            )),
            Positioned(
              top: -10,
              right: -10,
              child: IconButton(
                  icon: const Icon(
                    Icons.save,
                    color: Colors.blue,
                  ),
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      if (widget.billType == billIn) {
                        double newAvailableCapacity = 0.0;
                        int indexDepot =
                            searchInDepotList(index: selectedDepot.Id);
                        if (indexDepot != -1) {
                          // calculate new availableCapacity
                          newAvailableCapacity =
                              listDepotSelected[indexDepot].availableCapacity +
                                  selectedDepot.availableCapacity +
                                  double.parse(numberController.text) *
                                      selectedItem.volume;
                        } else {
                          newAvailableCapacity =
                              selectedDepot.availableCapacity +
                                  double.parse(numberController.text) *
                                      selectedItem.volume;
                        }
                        if ((newAvailableCapacity < selectedDepot.capacity ||
                                (selectedDepot.capacity == 0)) &&
                            widget.billType == billIn) {
                          setState(() {
                            if (indexDepot != -1) {
                              listDepotSelected
                                  .remove(listDepotSelected[indexDepot]);
                            }
                            selectedDepot.availableCapacity =
                                newAvailableCapacity;
                            listDepotSelected.add(selectedDepot);

                            Log(
                                tag: tag,
                                message:
                                    "Add itemBillIn to list, length is ${itemBillIns.length}");
                            ScaffoldMessenger.of(context)
                                .showSnackBar(SnackBar(content: Text(
                                    // ignore: use_build_context_synchronously
                                    "Depot ${selectedDepot.name} capacity  is  $newAvailableCapacity, total capacity is ${selectedDepot.capacity} , index: $indexDepot , Depot number is: ${listDepotSelected.length}")));
                            Log(
                                tag: tag,
                                message:
                                    "Depot ${selectedDepot.name} capacity  is  $newAvailableCapacity");
                            listSelectedItems.add(selectedItem);

                            itemBillIns.add(ItemBill(
                                date: billInDateController.text,
                                id: 0,
                                IDItem: selectedItem.ID,
                                number: double.parse(numberController.text),
                                productDate: "",
                                win: 0.0,
                                price: selectedItem.actualPrice,
                                depotID: selectedDepot.Id,
                                billId: -1));
                            toTalPrice = toTalPrice +
                                selectedItem.actualPrice *
                                    double.parse(numberController.text);
                            listShowObjectMainTable.add(ShowObject(
                                value0: selectedItem.name,
                                value1: numberController.text,
                                value2: "",
                                value3:
                                    selectedItem.actualPrice.toStringAsFixed(2),
                                value4: selectedDepot.name,
                                value5: totalPrice.toStringAsFixed(2)));

                            selectedItem = Item(
                              ID: -2,
                              name: "",
                              barCode: "",
                              category: "",
                              description: "",
                              soldBy: "",
                              madeIn: "",
                              prices: "",
                              validityPeriod: 0.0,
                              volume: 0.0,
                              actualPrice: 0.0,
                              actualWin: 0.0,
                              supplierID: "",
                              customerID: "",
                              depotID: "",
                              count: 0,
                              // image: ""
                            );
                          });
                          itemController.text = "";

                          numberController.text = "";

                          price = 0.0;

                          totalPrice = 0.0;
                          Log(tag: tag, message: "form key is validate");
                        } else if (newAvailableCapacity >
                                selectedDepot.capacity &&
                            widget.billType == billIn) {
                          Log(
                              tag: tag,
                              message:
                                  "selectedDepot.capacity: ${selectedDepot.capacity}, selectedDepot.availableCapacity: ${selectedDepot.availableCapacity}");
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(
                            // ignore: use_build_context_synchronously
                            AppLocalizations.of(context)!.depot_message,
                          )));
                        }
                      }
                    }
                    //addItemBillIns();
                  }),
            ),
          ]),
        )
      ]);
    } else {
      return TableRow(children: [
        TableCell(
            // item
            child: Card(
          child: inputElementTable(
              controller: itemController,
              ontap: (value) {
                setState(() {
                  initObjectSearch = "Item";
                  searchVisibility = !searchVisibility;
                });
                // searchFunctionConfig();
              },
              onChang: (value) {},
              context: context),
        )),
        //number
        Card(
          child: TableCell(
              child: inputElementTable(
                  controller: numberController,
                  onChang: (value) {
                    if (double.tryParse(value!) != null) {
                      setState(() {
                        itemNumber = double.parse(value);
                        totalPrice = price * itemNumber;
                      });
                    }
                  },
                  context: context)),
        ),
        //production date

        //price
        Card(
          child: Center(
            child: TableCell(
                child: Padding(
              padding: EdgeInsets.all(padding),
              child: Text(
                '${price.toStringAsFixed(2)} \$',
                style: const TextStyle(fontSize: 18),
              ),
            )),
          ),
        ),

        // totalPrice
        Card(
          child: Stack(children: [
            TableCell(
                child: Center(
              child: Padding(
                padding: EdgeInsets.all(padding),
                child: Text(
                  '${totalPrice.toStringAsFixed(2)} \$',
                  style: const TextStyle(fontSize: 18),
                ),
              ),
            )),
            Positioned(
              top: -10,
              right: -10,
              child: IconButton(
                  icon: const Icon(
                    Icons.save,
                    color: Colors.blue,
                  ),
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      double availableItem = -1.1;

                      // searchInListItemDepot(number: double.parse(numberController.text));

                      Log(
                          tag: tag,
                          message:
                              " listItemsDepot[index].number: ${listSelectedItemsDepot[indexItemsDepot].number}, number: ${numberController.text}");
                      availableItem =
                          listSelectedItemsDepot[indexItemsDepot].number -
                              double.parse(numberController.text);

                      if (availableItem < 0.0) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(
                          // ignore: use_build_context_synchronously
                          AppLocalizations.of(context)!.depot_message_no_item,
                        )));
                      } else {
                        Log(
                            tag: tag,
                            message: "availableItem is: $availableItem");

                        ItemsDepot itemDepot = ItemsDepot(
                          id: selectedItemsDepot.id,
                          itemId: selectedItemsDepot.itemId,
                          itemBillId: selectedItemsDepot.itemBillId,
                          number: availableItem,
                          billId: selectedItemsDepot.billId,
                        );
                        var resItemBill = await DBProvider.db.getObject(
                            id: selectedItemsDepot.itemBillId,
                            tableName: billInItemTableName);
                        if (resItemBill.isNotEmpty) {
                          ItemBill itemBill =
                              ItemBill.fromJson(resItemBill.first);
                          setState(() {
                            //listSelectedItemsDepot.remove(selectedItemsDepot);
                            listSelectedItemsDepot[indexItemsDepot] =
                                itemDepot; //itemBillIns listShowObjectMainTable listSelectedItemsDepot
                            selectedItemsDepot = itemDepot;

                            Log(
                                tag: tag,
                                message:
                                    "Update itemDepot, number is: ${itemDepot.number}, Index: $indexItemsDepot, listItemsDepot length: ${listItemsDepot.length}");

                            listSelectedItems.add(selectedItem);
                            depotItemIndexList.add(indexItemsDepot);
                            Log(
                                tag: tag,
                                message:
                                    "Update itemDepot, number is: ${itemDepot.number}, Index: $indexItemsDepot, depotItemIndexList length: ${depotItemIndexList.length} ${depotItemIndexList[0]}");

                            itemBillIns.add(ItemBill(
                                id: 0,
                                IDItem: selectedItem.ID,
                                number: double.parse(numberController.text),
                                productDate: dateProduction,
                                date: "",
                                win: itemBill.win *
                                    double.parse(numberController.text),
                                price: itemBill.price *
                                    (1 + itemBill.win) *
                                    double.parse(numberController.text),
                                depotID: selectedDepot.Id,
                                billId: -1));
                            toTalPrice = toTalPrice +
                                selectedItem.actualPrice *
                                    double.parse(numberController.text);
                            Log(
                                tag: tag,
                                message:
                                    "Number of item bill is: ${itemBillIns.length}");

                            listShowObjectMainTable.add(ShowObject(
                                //
                                value0: selectedItem.name,
                                value1: numberController.text,
                                value2: dateProduction,
                                value3:
                                    selectedItem.actualPrice.toStringAsFixed(2),
                                value4: selectedDepot.name,
                                value5: totalPrice.toStringAsFixed(2)));

                            selectedItem = Item(
                              ID: -2,
                              name: "",
                              barCode: "",
                              category: "",
                              description: "",
                              soldBy: "",
                              madeIn: "",
                              prices: "",
                              validityPeriod: 0.0,
                              volume: 0.0,
                              actualPrice: 0.0,
                              actualWin: 0.0,
                              supplierID: "",
                              customerID: "",
                              depotID: "",
                              count: 0,
                              // image: ""
                            );

                            itemController.text = "";
                            numberController.text = "";

                            price = 0.0;
                            totalPrice = 0.0;
                            dateProduction = "";
                          });
                        }
                      }
                    }
                    //addItemBillIns();
                  }),
            ),
          ]),
        )
      ]);
    }
  }

  int searchInDepotList({required int index}) {
    if (listDepotSelected.isEmpty) {
      return -1;
    } else {
      for (int i = 0; i < listDepotSelected.length; i++) {
        if (index == listDepotSelected[i].Id) {
          Log(tag: "$tag searchInDepotList", message: "Depot is exist");
          return i;
        }
      }
    }
    return -1;
  }

  @override
  void initState() {
    // TODO: implement initState
    () async {
      var resItemDepot = await DBProvider.db
          .getAllObjects(tableName: initDepot().depotListItem);
      if (resItemDepot.isNotEmpty) {
        for (var depotItem in resItemDepot) {
          setState(() {
            listSelectedItemsDepot.add(ItemsDepot.fromJson(depotItem));
          });
        }
        Log(
            tag: tag,
            message: "Number of depot item: ${listSelectedItemsDepot.length}");
      }
    }();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.bill_receipt),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
            child: Wrap(children: <Widget>[
          Visibility(
            visible: searchVisibility && initObjectSearch != "",
            child: Center(
              child: Expanded(
                child: SizedBox(
                  width: size.width * 0.95,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 40, bottom: 30),
                    child: Card(
                        child: SearchColumnSTF(
                      initObjectSearch: initObjectSearch,
                      billType: widget.billType,
                      size: size,
                      getIndex: (value) {
                        setState(() {
                          indexItemsDepot = value;
                          selectedItemsDepot =
                              listSelectedItemsDepot[indexItemsDepot];
                        });
                      },
                      getElement: (value) {
                        Log(tag: tag, message: "value: $value");
                        setState(() {
                          if (value != null) {
                            searchVisibility = false;
                          }
                          if (value is Supplier) {
                            selectedSupplier = value;
                            supplierController.text = selectedSupplier.name;
                          } else if (value is Worker) {
                            selectedWorker = value;
                            workerController.text = selectedWorker.name;
                          } else if (value is Item) {
                            selectedItem = value;
                            itemController.text = selectedItem.name;
                            listItems.add(value);
                            if (widget.billType == billIn) {
                              price = selectedItem.actualPrice;
                            } else {
                              price = selectedItem.actualPrice *
                                  (1 + selectedItem.actualWin);
                            }
                          }
                        });
                      },
                    )),
                  ),
                ),
              ),
            ),
          ),
          Form(
              key: _formKey,
              child: Column(
                children: [
                  Card(
                    //title
                    child: Padding(
                        padding: EdgeInsets.only(
                            right: padding, left: padding, bottom: padding),
                        child: size.width > 800
                            ? Row(
                                //direction: Axis.horizontal,
                                //mainAxisAlignment: MainAxisAlignment.start,
                                // crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Expanded(
                                    flex: 1,
                                    child: inputElementDateFormField(
                                        controller: billInDateController,
                                        context: context,
                                        padding: padding,
                                        icon: Icons.date_range,
                                        hintText:
                                            AppLocalizations.of(context)!.date,
                                        labelText:
                                            AppLocalizations.of(context)!.date,
                                        onChanged: ((value) {
                                          setState(() {
                                            billInDateController.text = value!;
                                          });
                                        })),
                                  ),
                                  // Supplier
                                  Expanded(
                                    flex: 1,
                                    child: Stack(
                                      children: [
                                        Row(
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.only(
                                                  right: padding,
                                                  left: padding / 2),
                                              child: Text(
                                                  widget.billType == billIn
                                                      ? AppLocalizations.of(
                                                              context)!
                                                          .supplier
                                                      : AppLocalizations.of(
                                                              context)!
                                                          .customer),
                                            ),
                                            Flexible(
                                              child: inputElementTable(
                                                  controller:
                                                      supplierController,
                                                  ontap: (value) {
                                                    setState(() {
                                                      searchVisibility =
                                                          !searchVisibility;
                                                      //listShowObject = [];
                                                      if (widget.billType ==
                                                          billIn) {
                                                        initObjectSearch =
                                                            "Supplier";
                                                        //initObjectSearch = "Supplier";
                                                      } else {
                                                        initObjectSearch =
                                                            "Customer";
                                                        // initObjectSearch = "Customer";
                                                      }
                                                    });
                                                    //searchFunctionConfig();
                                                  },
                                                  onChang: (value) {},
                                                  context: context),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),

                                  // Worker
                                  Expanded(
                                    flex: 1,
                                    child: Stack(
                                      children: [
                                        Row(
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.only(
                                                  right: padding,
                                                  left: padding / 2),
                                              child: Text(
                                                  AppLocalizations.of(context)!
                                                      .recipient),
                                            ),
                                            Flexible(
                                              child: inputElementTable(
                                                  controller: workerController,
                                                  ontap: (value) {
                                                    setState(() {
                                                      searchVisibility =
                                                          !searchVisibility;
                                                      initObjectSearch =
                                                          "Worker";
                                                    });
                                                  },
                                                  onChang: (value) {},
                                                  context: context),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),

                                  // Payment method
                                ],
                              )
                            : Column(
                                children: [
                                  inputElementDateFormField(
                                      controller: billInDateController,
                                      context: context,
                                      padding: padding,
                                      icon: Icons.date_range,
                                      hintText:
                                          AppLocalizations.of(context)!.date,
                                      labelText:
                                          AppLocalizations.of(context)!.date,
                                      onChanged: ((value) {
                                        setState(() {
                                          billInDateController.text = value!;
                                        });
                                      })),
                                  // Supplier
                                  Stack(
                                    children: [
                                      Row(
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.only(
                                                right: padding,
                                                left: padding / 2),
                                            child: Text(widget.billType ==
                                                    billIn
                                                ? AppLocalizations.of(context)!
                                                    .supplier
                                                : AppLocalizations.of(context)!
                                                    .customer),
                                          ),
                                          Flexible(
                                            child: inputElementTable(
                                                controller: supplierController,
                                                ontap: (value) {
                                                  setState(() {
                                                    searchVisibility =
                                                        !searchVisibility;
                                                    //listShowObject = [];
                                                    if (widget.billType ==
                                                        billIn) {
                                                      initObjectSearch =
                                                          "Supplier";
                                                      //initObjectSearch = "Supplier";
                                                    } else {
                                                      initObjectSearch =
                                                          "Customer";
                                                      // initObjectSearch = "Customer";
                                                    }
                                                  });
                                                  //searchFunctionConfig();
                                                },
                                                onChang: (value) {},
                                                context: context),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),

                                  // Worker
                                  Stack(
                                    children: [
                                      Row(
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.only(
                                                right: padding,
                                                left: padding / 2),
                                            child: Text(
                                                AppLocalizations.of(context)!
                                                    .recipient),
                                          ),
                                          Flexible(
                                            child: inputElementTable(
                                                controller: workerController,
                                                ontap: (value) {
                                                  setState(() {
                                                    searchVisibility =
                                                        !searchVisibility;
                                                    initObjectSearch = "Worker";
                                                  });
                                                },
                                                onChang: (value) {},
                                                context: context),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),

                                  // Payment method
                                ],
                              )),
                  ),
                  //title
                  Table(
                    border: TableBorder.all(
                        width: 3,
                        color:
                            Colors.blueAccent.withOpacity(0.1)), //table border
                    children: [
                      titleTableUniqueDepot(context: context),

                      //Input row
                      dataEntryTable(billType: widget.billType),
                      //data bill items
                      for (int i = listShowObjectMainTable.length - 1;
                          i >= 0;
                          i--)
                        inputDataBillInTableUniqueDepot(
                          tagMain: tag,
                          showObject: listShowObjectMainTable[i],
                          index: i,
                          delete: (value) {
                            Log(
                                tag: tag,
                                message: "Ask to delete object index $value");
                            if (listShowObjectMainTable.length > value &&
                                widget.billType == billIn) {
                              Log(
                                  tag: tag,
                                  message: "try to delete object index $value");
                              setState(() {
                                if (listShowObjectMainTable
                                    .contains(listShowObjectMainTable[value])) {
                                  int depotId = itemBillIns[itemBillIns
                                          .indexOf(itemBillIns[value])]
                                      .depotID;
                                  int indexDepot =
                                      searchInDepotList(index: depotId);
                                  if (indexDepot != -1) {
                                    double volumeItems =
                                        listItems[value].volume *
                                            itemBillIns[value].number;
                                    Depot depot = listDepotSelected[indexDepot];
                                    listDepotSelected.remove(depot);
                                    if (volumeItems < depot.availableCapacity) {
                                      Log(
                                          tag: "$tag/UpdatedDepot",
                                          message: "Content depot has updated");
                                      depot.availableCapacity =
                                          depot.availableCapacity - volumeItems;
                                      listDepotSelected.add(depot);
                                    }
                                  }
                                  listShowObjectMainTable
                                      .remove(listShowObjectMainTable[value]);
                                  toTalPrice = toTalPrice -
                                      itemBillIns[value].price *
                                          itemBillIns[value].number;
                                }

                                if (itemBillIns.contains(itemBillIns[value])) {
                                  itemBillIns.remove(itemBillIns[value]);
                                  listSelectedItems
                                      .remove(listSelectedItems[value]);
                                }
                              });
                            } else if (widget.billType == billOut &&
                                listShowObjectMainTable.isNotEmpty) {
                              setState(() {
                                int indexDepotItem = depotItemIndexList[value];
                                Log(
                                    tag: tag,
                                    message:
                                        "try to remove $value bill item, that related with ${depotItemIndexList[value]} depot item");
                                Log(
                                    tag: tag,
                                    message:
                                        "Before remove process, the number of item in depot item is: ${listSelectedItemsDepot[indexDepotItem].number} items");
                                listSelectedItemsDepot[indexDepotItem].number =
                                    listSelectedItemsDepot[indexDepotItem]
                                            .number +
                                        itemBillIns[value].number;
                                depotItemIndexList
                                    .remove(depotItemIndexList[value]);
                                itemBillIns.remove(itemBillIns[value]);
                                listShowObjectMainTable
                                    .remove(listShowObjectMainTable[value]);
                                Log(
                                    tag: tag,
                                    message:
                                        "After remove process, the number of item in depot item is: ${listSelectedItemsDepot[indexDepotItem].number} items");
                              });
                            }
                          },
                        ),
                    ],
                  ),
                  //Bill save and total price
                  Row(
                    //mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                    "Total price: ${toTalPrice.toStringAsFixed(2)}\$ "),
                                IconButton(
                                    icon: const Icon(
                                      Icons.save,
                                      color: Colors.blue,
                                    ),
                                    hoverColor: Colors.blue.shade50,
                                    onPressed: () async {
                                      if (widget.billType == billIn) {
                                        Log(
                                            tag: tag,
                                            message: "Start bill save");
                                        if (listSelectedItems.isNotEmpty &&
                                            selectedSupplier.Id != -1 &&
                                            billInDateController
                                                .text.isNotEmpty &&
                                            listShowObjectMainTable
                                                .isNotEmpty) {
                                          Bill bill = Bill(
                                              ID: 0,
                                              depotId: "",
                                              dateTime: billInDateController
                                                  .text
                                                  .toString(),
                                              outsidePersonId:
                                                  selectedSupplier.Id,
                                              type: widget.billType,
                                              workerId: selectedWorker.Id,
                                              itemBills: "",
                                              totalPrices: toTalPrice);
                                          await addNewBillIn(
                                              bill: bill,
                                              isUniqueDepot: true,
                                              listItemBill: itemBillIns);
                                          setState(() {
                                            itemBillIns.clear();
                                            listShowObjectMainTable.clear();
                                            selectedSupplier =
                                                selectedSupplier.init();
                                            selectedWorker =
                                                selectedWorker.init();

                                            toTalPrice = 0.0;
                                            supplierController.text = "";
                                            workerController.text = "";
                                            billInDateController.text = "";
                                          });

                                          Log(
                                              tag: tag,
                                              message: "Item list isn't null");
                                        }
                                      } else if (widget.billType == billOut) {
                                        Log(
                                            tag: tag,
                                            message:
                                                "Bill type is ${widget.billType}");
                                        if (itemBillIns.isNotEmpty &&
                                            listSelectedItemsDepot.isNotEmpty &&
                                            selectedSupplier.Id != -1 &&
                                            selectedWorker.Id != -1 &&
                                            listShowObjectMainTable
                                                .isNotEmpty) {
                                          Log(
                                              tag: tag,
                                              message:
                                                  "You can start process of add bill out");
                                        }
                                        Bill bill = Bill(
                                            ID: 0,
                                            depotId: "",
                                            dateTime: billInDateController.text
                                                .toString(),
                                            outsidePersonId:
                                                selectedSupplier.Id,
                                            type: widget.billType,
                                            workerId: selectedWorker.Id,
                                            itemBills: "",
                                            totalPrices: toTalPrice);
                                        //listItems
                                        await addNewBillOut(
                                            bill: bill,
                                            listItemOutBill: itemBillIns,
                                            listSelectedItemsDepot:
                                                listSelectedItemsDepot,
                                            selectedDepot: selectedDepot,
                                            depotItemIndexList:
                                                depotItemIndexList,
                                            tagMain: tag);
                                        setState(() {
                                          itemBillIns.clear();
                                          listShowObjectMainTable.clear();
                                          selectedSupplier =
                                              selectedSupplier.init();
                                          selectedWorker =
                                              selectedWorker.init();

                                          toTalPrice = 0.0;
                                          supplierController.text = "";
                                          workerController.text = "";
                                          billInDateController.text = "";
                                          listSelectedItemsDepot.clear();
                                          selectedDepot = selectedDepot.init();

                                          depotItemIndexList.clear();
                                          listShowObject = [];
                                          tableName = depotTableName;
                                          initObjectSearch = "Depot";
                                          //searchFunctionConfig();
                                        });
                                      }
                                    }),
                                IconButton(
                                    icon: const Icon(
                                      Icons.print,
                                      color: Colors.blue,
                                    ),
                                    hoverColor: Colors.blue.shade50,
                                    onPressed: () async {
                                      if (selectedSupplier.Id != -1 &&
                                          selectedWorker.Id != -1 &&
                                          toTalPrice != 0 &&
                                          billInDateController.text != "" &&
                                          listShowObjectMainTable.isNotEmpty) {
                                        Log(
                                            tag: tag,
                                            message: "Try to print invoice");
                                        printInvoice(
                                            totalPrice:
                                                toTalPrice.toStringAsFixed(2),
                                            date: billInDateController.text,
                                            workerName: selectedWorker.name,
                                            outSidePersonnel:
                                                selectedSupplier.name,
                                            listShowObjectMainTable:
                                                listShowObjectMainTable);
                                      }
                                    })
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ))
        ])));
  }

  printInvoice(
      {required String workerName,
      required String date,
      required String outSidePersonnel,
      required String totalPrice,
      required List<ShowObject> listShowObjectMainTable}) {
    Navigator.of(context).push(
      MaterialPageRoute(
          builder: (builder) => PrintInvoice(
                workerName: workerName,
                totalPrice: totalPrice,
                date: date,
                outSidePersonnel: outSidePersonnel,
                listShowObjectMainTable: listShowObjectMainTable,
              )),
    );
  }
}
