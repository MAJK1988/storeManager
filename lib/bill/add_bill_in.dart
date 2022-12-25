import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../AddObject/add_depot.dart';
import '../AddObject/add_supplier.dart';
import '../dataBase/bill_in_sql.dart';
import '../dataBase/sql_object.dart';
import '../utils/drop_down_button_new.dart';
import '../utils/objects.dart';
import '../utils/utils.dart';

class AddBillIn extends StatefulWidget {
  final String billType;
  const AddBillIn({super.key, this.billType = billIn});

  @override
  State<AddBillIn> createState() => _AddBillInState();
}

class _AddBillInState extends State<AddBillIn> {
  TextEditingController dateController = TextEditingController(),
      billInDateController = TextEditingController(),
      itemController = TextEditingController(),
      numberController = TextEditingController(),
      depotController = TextEditingController(),
      supplierController = TextEditingController(),
      workerController = TextEditingController();
  final GlobalKey _widgetKey = GlobalKey();
  late double totalPrice = 0.0;
  late double price = 0.0;
  final _formKey = GlobalKey<FormState>();

  final List<String> names = <String>[
    'Aby',
    'Aish',
    'Ayan',
    'Ben',
    'Bob',
    'Charlie',
    'Cook',
    'Carline'
  ];
  final List<int> msgCount = <int>[2, 0, 10, 6, 52, 4, 0, 2];
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
  late String initObjectSearch = getObjectsNameListAddBillIn().first;
  late List<String> listObjectSearch = getObjectsNameListAddBillIn();
  late String tableName = itemTableName;
  late String titleDialog = "";
  late Widget widgetDialog = SizedBox();
  late String dateProduction = "";
  late int depotItemIndex = -1;
  late List<int> depotItemIndexList = [];

  searchFunctionConfig() {
    setState(() {
      //["Item", "", "Worker", "Depot"];
      if (initObjectSearch == "Worker") {
        initElementSearch = "";
        tableName = workerTableName;
        listSearchElement.clear();
        getElementsWorker().forEach((element) {
          listSearchElement.add(element);
        });
        initElementSearch = listSearchElement.first;
      } else if (initObjectSearch == "Item") {
        initElementSearch = "";
        tableName = itemTableName;
        listSearchElement = getElementsItems();
        initElementSearch = listSearchElement.first;
      } else if (initObjectSearch == "Supplier") {
        initElementSearch = "";
        tableName = supplierTableName;
        listSearchElement = getElementsSupplier();
        initElementSearch = listSearchElement.first;
      } else if (initObjectSearch == "Depot") {
        initElementSearch = "";
        tableName = depotTableName;
        listSearchElement = getElementsDepot();
        initElementSearch = listSearchElement.first;
      } else if (initObjectSearch == "Customer") {
        initElementSearch = "";
        tableName = customerTableName;
        listSearchElement = getElementsSupplier();
        initElementSearch = listSearchElement.first;
      }
      Log(tag: "$tag element item", message: "element: $element");
      activateSearch();
    });
  }

  activateSearch() {
    if (widget.billType == billOut) {
      searchForOutBill();
    } else if (widget.billType == billIn) {
      searchForInBill();
    }
  }

  searchForInBill() async {
    Log(
        tag: tag,
        message:
            "Start searchForInBill, elementSearch: $elementSearch, element: $element");
    var res;
    if (elementSearch.isNotEmpty) {
      res = await DBProvider.db.tableSearchName(
          tableName: tableName, elementSearch: elementSearch, element: element);
    } else {
      res = await DBProvider.db.getAllObjects(tableName: tableName);
    }

    if (tableName == itemTableName) {
      if (res.isNotEmpty)
      // convert json to item array
      {
        List<Item> listItemsIn = (res.isNotEmpty
            ? (res.isNotEmpty
                ? res.map<Item>((item) => Item.fromJson(item)).toList()
                : [])
            : []); //as List<Item>;
        // convert json to item array
        List<ShowObject> listShowObjectIn = (res.isNotEmpty
            ? (res.isNotEmpty
                ? res
                    .map<ShowObject>((item) => ShowObject.fromJsonItem(item))
                    .toList()
                : [])
            : []) as List<ShowObject>;
        setState(() {
          listItems = listItemsIn;
          listShowObject = listShowObjectIn;
          Log(
              tag: tag,
              message:
                  "length of listShowObject is : ${listShowObject.length}");
        });
      } else {
        setState(() {
          listItems = [];
          listShowObject = [];
          Log(tag: tag, message: "Search $tableName is null");
        });
      }
    } else if (tableName == workerTableName) {
      if (res.isNotEmpty) {
        // convert json to item array
        List<Worker> listWorkerIn = (res.isNotEmpty
            ? (res.isNotEmpty
                ? res.map<Worker>((item) => Worker.fromJson(item)).toList()
                : [])
            : []) as List<Worker>;
        // convert json to item array
        List<ShowObject> listShowObjectIn = (res.isNotEmpty
            ? (res.isNotEmpty
                ? res
                    .map<ShowObject>(
                        (worker) => ShowObject.fromJsonWorker(worker))
                    .toList()
                : [])
            : []) as List<ShowObject>;
        setState(() {
          listWorkers = listWorkerIn;
          listShowObject = listShowObjectIn;
          Log(
              tag: tag,
              message:
                  "length of listShowObject is : ${listShowObject.length}");
        });
      } else {
        setState(() {
          listWorkers = [];
          listShowObject = [];
          Log(tag: tag, message: "Search $tableName is null");
        });
      }
    } else if (tableName == supplierTableName ||
        tableName == customerTableName) {
      if (res.isNotEmpty) {
        // convert json to item array
        List<Supplier> listSupplierIn = (res.isNotEmpty
            ? (res.isNotEmpty
                ? res
                    .map<Supplier>(
                        (item) => Supplier.fromJson(item, supplierType))
                    .toList()
                : [])
            : []) as List<Supplier>;
        // convert json to item array
        List<ShowObject> listShowObjectIn = (res.isNotEmpty
            ? (res.isNotEmpty
                ? res
                    .map<ShowObject>(
                        (supplier) => ShowObject.fromJsonSupplier(supplier))
                    .toList()
                : [])
            : []) as List<ShowObject>;
        setState(() {
          listSupplier = listSupplierIn;
          listShowObject = listShowObjectIn;
          Log(
              tag: tag,
              message:
                  "length of listShowObject is : ${listShowObject.length}");
        });
      } else {
        setState(() {
          listSupplier = [];
          listShowObject = [];
          Log(tag: tag, message: "Search $tableName is null");
        });
      }
    } else if (tableName == depotTableName) {
      if (res.isNotEmpty) {
        // convert json to item array
        List<Depot> listDepotIn = (res.isNotEmpty
            ? (res.isNotEmpty
                ? res.map<Depot>((depot) => Depot.fromJson(depot)).toList()
                : [])
            : []) as List<Depot>;
        // convert json to item array
        List<ShowObject> listShowObjectIn = (res.isNotEmpty
            ? (res.isNotEmpty
                ? res
                    .map<ShowObject>((depot) => ShowObject.fromJsonDepot(depot))
                    .toList()
                : [])
            : []) as List<ShowObject>;
        setState(() {
          listDepot = listDepotIn;
          listShowObject = listShowObjectIn;
          Log(
              tag: tag,
              message:
                  "length of listShowObject is : ${listShowObject.length}");
        });
      } else {
        setState(() {
          listDepot = [];
          listShowObject = [];
          Log(tag: tag, message: "Search $tableName is null");
        });
      }
    }
  }

  searchForOutBill() async {
    Log(tag: tag, message: "Start searchForOutBill");

    if (tableName == itemTableName && selectedDepot.Id != -1) {
      var res = await DBProvider.db
          .getAllObjects(tableName: selectedDepot.depotListItem);
      if (res.isNotEmpty)
      // convert json to item array
      {
        List<ItemsDepot> listItemsDepotIn = (res.isNotEmpty
            ? (res.isNotEmpty
                ? res
                    .map<ItemsDepot>((item) => ItemsDepot.fromJson(item))
                    .toList()
                : [])
            : []); //as List<Item>;
        setState(() {
          if (listSelectedItemsDepot.isEmpty) {
            listItemsDepot = listItemsDepotIn;
            listSelectedItemsDepot = listItemsDepotIn;
          }
        });
        List<ShowObject> listShowObjectIn = [];
        List<Item> listItemIn = [];

        for (ItemsDepot itemsDepot in listItemsDepotIn) {
          var resItem = await DBProvider.db
              .getObject(id: itemsDepot.itemId, tableName: itemTableName);
          var resBill = await DBProvider.db
              .getObject(id: itemsDepot.billId, tableName: billInTableName);
          if (resItem.isNotEmpty && resBill.isNotEmpty) {
            Item item = Item.fromJson(resItem.first);
            Bill bill = Bill.fromJson(resBill.first);
            Log(
                tag: tag,
                message:
                    "get item and bill data, bill id id: ${bill.ID}, itemsDepot bill id is: ${itemsDepot.billId}");
            bool existTable = await DBProvider.db
                .checkExistTable(tableName: billInItemTableName);

            if (existTable) {
              var resItemBill = await DBProvider.db.getObject(
                  id: itemsDepot.itemBillId, tableName: billInItemTableName);

              if (resItemBill.isNotEmpty) {
                Log(tag: tag, message: "get itemBill data");
                ItemBill itemBill = ItemBill.fromJson(resItemBill.first);
                ShowObject showObject = ShowObject(
                    value0: item.name,
                    value1: item.count.toStringAsFixed(2),
                    value3: itemBill.productDate,
                    value2: itemsDepot.number.toString());
                listShowObjectIn.add(showObject);
                listItemIn.add(item);
              } else {
                Log(tag: tag, message: "itemBill isn't exist");
              }
            } else {
              Log(tag: tag, message: "table ${bill.itemBills} isn't exist");
            }
          }
          setState(() {
            listShowObject = listShowObjectIn;
            listItems = listItemIn;
          });
        }
        Log(
            tag: tag,
            message:
                "Search Bill out, ItemsDepot list length is: ${listItemsDepotIn.length}");
      } else {
        setState(() {
          listItems = [];
          listShowObject = [];
          Log(tag: tag, message: "Search $tableName is null");
        });
      }
    } else if (tableName == depotTableName &&
        elementSearch != "" &&
        element != "") {
      var res = await DBProvider.db.tableSearchElementNoEmptyDepots(
          elementSearch: elementSearch, element: element);
      if (res.isNotEmpty) {
        setState(() {
          listSelectedItemsDepot = [];
          listShowObjectMainTable = [];
          selectedDepot = selectedDepot.init();
        });
        // convert json to item array
        List<Depot> listDepotIn = (res.isNotEmpty
            ? (res.isNotEmpty
                ? res.map<Depot>((depot) => Depot.fromJson(depot)).toList()
                : [])
            : []) as List<Depot>;
        // convert json to item array
        List<ShowObject> listShowObjectIn = (res.isNotEmpty
            ? (res.isNotEmpty
                ? res
                    .map<ShowObject>((depot) => ShowObject.fromJsonDepot(depot))
                    .toList()
                : [])
            : []) as List<ShowObject>;
        setState(() {
          listDepot = listDepotIn;
          listShowObject = listShowObjectIn;
          Log(
              tag: tag,
              message:
                  "length of listShowObject is : ${listShowObject.length}");
        });
      } else {
        setState(() {
          listDepot = [];
          listShowObject = [];
          Log(tag: tag, message: "Search $tableName is null");
        });
      }
    } else if (tableName != itemTableName) {
      searchForInBill();
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
                  listShowObject = [];
                  tableName = itemTableName;
                  initObjectSearch = "Item";
                });
                searchFunctionConfig();
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
        Card(
          child: TableCell(
              child: inputElementDateFormField(
                  context: context,
                  controller: dateController,
                  onChanged: ((value) {
                    setState(() {
                      dateController.text = value!;
                    });
                  }))),
        ),
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
        Card(
          child: Stack(
            children: [
              TableCell(
                  child: inputElementTable(
                      controller: depotController,
                      ontap: (value) {
                        setState(() {
                          listShowObject = [];
                          tableName = depotTableName;
                          initObjectSearch = "Depot";
                        });
                        searchFunctionConfig();
                      },
                      onChang: (value) {},
                      context: context)),
              Positioned(
                  top: -10,
                  right: -10,
                  child: IconButton(
                      icon: const Icon(
                        Icons.add,
                        color: Colors.blue,
                      ),
                      onPressed: () {
                        Navigator.of(context)
                            .restorablePush(dialogBuilderDepot);
                      }))
            ],
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
                        if (newAvailableCapacity < selectedDepot.capacity &&
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
                                date: dateController.text,
                                id: 0,
                                IDItem: selectedItem.ID,
                                number: double.parse(numberController.text),
                                productDate: dateController.text,
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
                                value2: dateController.text,
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
                          dateController.text = "";
                          numberController.text = "";
                          depotController.text = "";
                          price = 0.0;
                          dateController.text = "";
                          totalPrice = 0.0;
                          Log(tag: tag, message: "form key is validate");
                        } else if (newAvailableCapacity >
                                selectedDepot.capacity &&
                            widget.billType == billIn) {
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
                  listShowObject = [];
                  tableName = itemTableName;
                  initObjectSearch = "Item";
                });
                searchFunctionConfig();
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
        Card(
          child: TableCell(
              child: Padding(
            padding: EdgeInsets.all(padding),
            child: Text(
              dateProduction,
              style: const TextStyle(fontSize: 18),
            ),
          )),
        ),

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
                      int index = -1;
                      // searchInListItemDepot(number: double.parse(numberController.text));
                      if (listSelectedItemsDepot.contains(selectedItemsDepot)) {
                        index =
                            listSelectedItemsDepot.indexOf(selectedItemsDepot);
                        Log(
                            tag: tag,
                            message:
                                " listItemsDepot[index].number: ${listSelectedItemsDepot[index].number}, number: ${numberController.text}");
                        availableItem = listSelectedItemsDepot[index].number -
                            double.parse(numberController.text);
                      } else {
                        Log(
                            tag: tag,
                            message:
                                "listItemsDepot didn't contain  selectedItemsDepot");
                      }

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
                        if (listSelectedItemsDepot
                            .contains(selectedItemsDepot)) {
                          int index = listSelectedItemsDepot
                              .indexOf(selectedItemsDepot);
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
                              listSelectedItemsDepot[index] =
                                  itemDepot; //itemBillIns listShowObjectMainTable listSelectedItemsDepot
                              selectedItemsDepot = itemDepot;

                              Log(
                                  tag: tag,
                                  message:
                                      "Update itemDepot, number is: ${itemDepot.number}, Index: $index, listItemsDepot length: ${listItemsDepot.length}");

                              listSelectedItems.add(selectedItem);
                              depotItemIndexList.add(depotItemIndex);
                              itemBillIns.add(ItemBill(
                                  id: 0,
                                  IDItem: selectedItem.ID,
                                  number: double.parse(numberController.text),
                                  productDate: dateProduction,
                                  date: dateController.text,
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
                                  value3: selectedItem.actualPrice
                                      .toStringAsFixed(2),
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
                    }
                    //addItemBillIns();
                  }),
            ),
          ]),
        )
      ]);
    }
  }

  // InitState
  @override
  void initState() {
    // TODO: implement initState
    if (widget.billType == billOut) {
      setState(() {
        initObjectSearch = getObjectsNameListAddBillOut().first;
        listObjectSearch = getObjectsNameListAddBillOut();
      });
    }
    () async {
      List<Item> listItemsIn = (widget.billType == billIn)
          ? await DBProvider.db.getAllItems()
          : await DBProvider.db.getExistItems();

      setState(() {
        if (listItemsIn.isNotEmpty) {
          listItems = listItemsIn;
          listShowObject = (listItemsIn.isNotEmpty
              ? (listItemsIn.isNotEmpty
                  ? listItemsIn
                      .map<ShowObject>(
                          (item) => ShowObject.fromJsonItem(item.toJson()))
                      .toList()
                  : [])
              : []) as List<ShowObject>;
        }
      });
    }();

    super.initState();
  }

  late String searchFor = "", elementSearch = "", element = '', object = '';
  late final String tag = "AddBillIn";
  late Future<List<Item>> futureBuild = DBProvider.db.getAllItems();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.billType == billIn
              ? AppLocalizations.of(context)!.bill_receipt
              : AppLocalizations.of(context)!.bill_out),
          centerTitle: true,
        ),
        body: Form(
          key: _formKey,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Flexible(
                flex: 7,
                child: Stack(
                  children: [
                    SingleChildScrollView(
                      child: Column(
                        children: [
                          // Date and supplier and recipient " worker"
                          Card(
                            child: Padding(
                              padding: EdgeInsets.only(
                                  right: padding,
                                  left: padding,
                                  bottom: padding),
                              child: Flex(
                                direction: Axis.horizontal,
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
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
                                                      listShowObject = [];
                                                      if (widget.billType ==
                                                          billIn) {
                                                        tableName =
                                                            supplierTableName;
                                                        initObjectSearch =
                                                            "Supplier";
                                                      } else {
                                                        tableName =
                                                            customerTableName;
                                                        initObjectSearch =
                                                            "Customer";
                                                      }
                                                    });
                                                    searchFunctionConfig();
                                                  },
                                                  onChang: (value) {},
                                                  context: context),
                                            ),
                                          ],
                                        ),
                                        Positioned(
                                            top: 0,
                                            right: 0,
                                            child: IconButton(
                                                icon: const Icon(
                                                  Icons.add,
                                                  color: Colors.blue,
                                                ),
                                                onPressed: () {
                                                  widget.billType == billIn
                                                      ? Navigator.of(context)
                                                          .restorablePush(
                                                              dialogBuilderSupplier)
                                                      : Navigator.of(context)
                                                          .restorablePush(
                                                              dialogBuilderCustomer);
                                                }))
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
                                                      listShowObject = [];
                                                      tableName =
                                                          workerTableName;
                                                      initObjectSearch =
                                                          "Worker";
                                                    });
                                                    searchFunctionConfig();
                                                  },
                                                  onChang: (value) {},
                                                  context: context),
                                            ),
                                          ],
                                        ),
                                        Positioned(
                                            top: 0,
                                            right: 0,
                                            child: IconButton(
                                                icon: const Icon(
                                                  Icons.add,
                                                  color: Colors.blue,
                                                ),
                                                onPressed: () {
                                                  Navigator.of(context)
                                                      .restorablePush(
                                                          dialogBuilderWorker);
                                                }))
                                      ],
                                    ),
                                  ),

                                  // Payment method
                                  Expanded(
                                    flex: 1,
                                    child: Row(
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(
                                              right: padding,
                                              left: padding / 2),
                                          child: Text(
                                              AppLocalizations.of(context)!
                                                  .payment_method),
                                        ),
                                        Expanded(
                                          flex: 2,
                                          child: DropdownButton<String>(
                                            value: "Mahmoud KADDOUR",
                                            icon: const Icon(
                                                Icons.arrow_downward),
                                            elevation: 16,
                                            style: const TextStyle(
                                                color: Colors.deepPurple),
                                            underline: Container(
                                              height: 2,
                                              color: Colors.deepPurpleAccent,
                                            ),
                                            isExpanded: true,
                                            onChanged: (String? value) {
                                              // This is called when the user selects an item.
                                              setState(() {});
                                            },
                                            items: [
                                              "Mahmoud KADDOUR",
                                              "two",
                                              "three"
                                            ].map<DropdownMenuItem<String>>(
                                                (String value) {
                                              return DropdownMenuItem<String>(
                                                value: value,
                                                child: Text(value,
                                                    overflow:
                                                        TextOverflow.ellipsis),
                                              );
                                            }).toList(),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          //if bill is out => show depot
                          Visibility(
                              visible: widget.billType == billOut,
                              child: //Depot
                                  Stack(
                                children: [
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Expanded(
                                          flex: 1, child: SizedBox()),
                                      Expanded(
                                        flex: 1,
                                        child: Card(
                                          child: Row(
                                            children: [
                                              Expanded(
                                                flex: 1,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Text(
                                                    '${AppLocalizations.of(context)!.depot} : ',
                                                    style: const TextStyle(
                                                        fontSize: 18),
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                flex: 3,
                                                child: inputElementTable(
                                                    controller: depotController,
                                                    ontap: (value) {
                                                      setState(() {
                                                        listShowObject = [];
                                                        tableName =
                                                            depotTableName;
                                                        initObjectSearch =
                                                            "Depot";
                                                      });
                                                      searchFunctionConfig();
                                                    },
                                                    onChang: (value) {},
                                                    context: context),
                                              ),
                                            ],
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                  Positioned(
                                      top: 0,
                                      right: 0,
                                      child: IconButton(
                                          icon: const Icon(
                                            Icons.add,
                                            color: Colors.blue,
                                          ),
                                          onPressed: () {
                                            Navigator.of(context)
                                                .restorablePush(
                                                    dialogBuilderDepot);
                                          }))
                                ],
                              )),
                          // item list, item, number production date, price, depot and total Price
                          Padding(
                            padding: EdgeInsets.all(padding),
                            child: Stack(
                              children: [
                                Table(
                                  border: TableBorder.all(
                                      width: 3,
                                      color: Colors.blueAccent
                                          .withOpacity(0.1)), //table border
                                  children: [
                                    //title
                                    titleTable(
                                        context: context,
                                        billType: widget.billType),
                                    //Input row
                                    dataEntryTable(billType: widget.billType),
                                    //data bill items
                                    for (int i =
                                            listShowObjectMainTable.length - 1;
                                        i >= 0;
                                        i--)
                                      inputDataBillInTable(
                                        type: widget.billType,
                                        showObject: listShowObjectMainTable[i],
                                        index: i,
                                        delete: (value) {
                                          Log(
                                              tag: tag,
                                              message:
                                                  "Ask to delete object index $value");
                                          if (listShowObjectMainTable.length >
                                                  value &&
                                              widget.billType == billIn) {
                                            Log(
                                                tag: tag,
                                                message:
                                                    "try to delete object index $value");
                                            setState(() {
                                              if (listShowObjectMainTable
                                                  .contains(
                                                      listShowObjectMainTable[
                                                          value])) {
                                                int depotId = itemBillIns[
                                                        itemBillIns.indexOf(
                                                            itemBillIns[value])]
                                                    .depotID;
                                                int indexDepot =
                                                    searchInDepotList(
                                                        index: depotId);
                                                if (indexDepot != -1) {
                                                  double volumeItems =
                                                      listItems[value].volume *
                                                          itemBillIns[value]
                                                              .number;
                                                  Depot depot =
                                                      listDepotSelected[
                                                          indexDepot];
                                                  listDepotSelected
                                                      .remove(depot);
                                                  if (volumeItems <
                                                      depot.availableCapacity) {
                                                    Log(
                                                        tag:
                                                            "$tag/UpdatedDepot",
                                                        message:
                                                            "Content depot has updated");
                                                    depot.availableCapacity =
                                                        depot.availableCapacity -
                                                            volumeItems;
                                                    listDepotSelected
                                                        .add(depot);
                                                  }
                                                }
                                                listShowObjectMainTable.remove(
                                                    listShowObjectMainTable[
                                                        value]);
                                                toTalPrice = toTalPrice -
                                                    itemBillIns[value].price *
                                                        itemBillIns[value]
                                                            .number;
                                              }

                                              if (itemBillIns.contains(
                                                  itemBillIns[value])) {
                                                itemBillIns
                                                    .remove(itemBillIns[value]);
                                                listSelectedItems.remove(
                                                    listSelectedItems[value]);
                                              }
                                            });
                                          } else if (widget.billType ==
                                                  billOut &&
                                              listShowObjectMainTable
                                                  .isNotEmpty) {
                                            setState(() {
                                              int indexDepotItem =
                                                  depotItemIndexList[value];
                                              Log(
                                                  tag: tag,
                                                  message:
                                                      "try to remove $value bill item, that related with ${depotItemIndexList[value]} depot item");
                                              Log(
                                                  tag: tag,
                                                  message:
                                                      "Before remove process, the number of item in depot item is: ${listSelectedItemsDepot[indexDepotItem].number} items");
                                              listSelectedItemsDepot[
                                                          indexDepotItem]
                                                      .number =
                                                  listSelectedItemsDepot[
                                                              indexDepotItem]
                                                          .number +
                                                      itemBillIns[value].number;
                                              depotItemIndexList.remove(
                                                  depotItemIndexList[value]);
                                              itemBillIns
                                                  .remove(itemBillIns[value]);
                                              listShowObjectMainTable.remove(
                                                  listShowObjectMainTable[
                                                      value]);
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
                                // Save Item
                              ],
                            ),
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
                                                if (listSelectedItems
                                                        .isNotEmpty &&
                                                    selectedSupplier.Id != -1 &&
                                                    selectedDepot.Id != -1 &&
                                                    billInDateController
                                                        .text.isNotEmpty &&
                                                    listDepot.isNotEmpty &&
                                                    listShowObjectMainTable
                                                        .isNotEmpty) {
                                                  Bill bill = Bill(
                                                      ID: 0,
                                                      depotId: "",
                                                      dateTime:
                                                          billInDateController
                                                              .text
                                                              .toString(),
                                                      outsidePersonId:
                                                          selectedSupplier.Id,
                                                      type: widget.billType,
                                                      workerId:
                                                          selectedWorker.Id,
                                                      itemBills: "",
                                                      totalPrices: toTalPrice);
                                                  await addNewBillIn(
                                                      bill: bill,
                                                      listItemBill: itemBillIns,
                                                      isUniqueDepot: false);
                                                  setState(() {
                                                    itemBillIns.clear();
                                                    listShowObjectMainTable
                                                        .clear();
                                                    selectedSupplier =
                                                        selectedSupplier.init();
                                                    selectedWorker =
                                                        selectedWorker.init();
                                                    dateController.text = "";
                                                    toTalPrice = 0.0;
                                                    supplierController.text =
                                                        "";
                                                    workerController.text = "";
                                                    billInDateController.text =
                                                        "";
                                                  });

                                                  Log(
                                                      tag: tag,
                                                      message:
                                                          "Item list isn't null");
                                                }
                                              } else if (widget.billType ==
                                                  billOut) {
                                                Log(
                                                    tag: tag,
                                                    message:
                                                        "Bill type is ${widget.billType}");
                                                if (itemBillIns.isNotEmpty &&
                                                    listSelectedItemsDepot
                                                        .isNotEmpty &&
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
                                                    dateTime:
                                                        billInDateController
                                                            .text
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
                                                    listItemOutBill:
                                                        itemBillIns,
                                                    listSelectedItemsDepot:
                                                        listSelectedItemsDepot,
                                                    selectedDepot:
                                                        selectedDepot,
                                                    depotItemIndexList:
                                                        depotItemIndexList,
                                                    tagMain: tag);
                                                setState(() {
                                                  itemBillIns.clear();
                                                  listShowObjectMainTable
                                                      .clear();
                                                  selectedSupplier =
                                                      selectedSupplier.init();
                                                  selectedWorker =
                                                      selectedWorker.init();
                                                  dateController.text = "";
                                                  toTalPrice = 0.0;
                                                  supplierController.text = "";
                                                  workerController.text = "";
                                                  billInDateController.text =
                                                      "";
                                                  listSelectedItemsDepot
                                                      .clear();
                                                  selectedDepot =
                                                      selectedDepot.init();
                                                  depotController.text = "";
                                                  depotItemIndexList.clear();
                                                  listShowObject = [];
                                                  tableName = depotTableName;
                                                  initObjectSearch = "Depot";
                                                  searchFunctionConfig();
                                                });
                                              }
                                            }),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              //search column
              Flexible(key: _widgetKey, flex: 4, child: searchColumn())
            ],
          ),
        ));
  }

  static Route<Object?> dialogBuilderDepot(
      BuildContext context, Object? arguments) {
    return DialogRoute<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context)!.add_depot),
          content: const DepotWidget(),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Disable'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        );
      },
    );
  }

  static Route<Object?> dialogBuilderSupplier(
      BuildContext context, Object? arguments) {
    return DialogRoute<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context)!.add_supplier),
          content: const SupplierWidget(
            type: supplierType,
            visible: false,
          ),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Disable'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        );
      },
    );
  }

//dialogBuilderCustomer
  static Route<Object?> dialogBuilderCustomer(
      BuildContext context, Object? arguments) {
    return DialogRoute<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context)!.add_customer),
          content: const SupplierWidget(
            type: customerType,
            visible: false,
          ),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Disable'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        );
      },
    );
  }

  static Route<Object?> dialogBuilderWorker(
      BuildContext context, Object? arguments) {
    return DialogRoute<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context)!.add_worker),
          content: const SupplierWidget(
            type: supplierType,
            visible: true,
          ),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Disable'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        );
      },
    );
  }

  double searchInListItemDepot({required double number}) {
    double retVal = -1.1;
    Log(
        tag: tag,
        message:
            "sTART searchInListItemBill function number is: $number, and exist number: ${selectedItemsDepot.number}");
    for (int i = 0; i < listItemsDepot.length; i++) {
      if (listItemsDepot[i].id == selectedItemsDepot.id) {
        Log(
            tag: tag,
            message:
                "return searchInListItemBill function is: ${selectedItemsDepot.number - number}");
        return (listItemsDepot[i].number - number);
      }
    }
    Log(tag: tag, message: "return searchInListItemBill function is: $retVal");
    return retVal;
  }

  searchColumn() {
    return Column(
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Flex(
              direction: Axis.horizontal,
              children: [
                Expanded(
                  flex: 4,
                  child: Row(
                    children: [
                      Flexible(
                        child: inputElementTable(
                            needValidation: false,
                            controller: null,
                            hintText: searchFor,
                            onChang: (value) {
                              setState(() {
                                elementSearch = value!;
                                Log(
                                    tag: "$tag elementSearch",
                                    message: "elementSearch: $elementSearch");
                              });
                            },
                            context: context),
                      ),
                      IconButton(
                          icon: const Icon(Icons.search),
                          onPressed: () async {
                            setState(() {
                              if (element == "") {
                                element = listSearchElement.first;
                              }
                              if (tableName == "") {
                                tableName = itemTableName;
                              }
                            });

                            Log(
                                tag: tag,
                                message:
                                    "search $elementSearch in $element, table name is: $tableName");
                            // Search query
                            if (widget.billType == billIn) {
                              Log(tag: tag, message: "Search for bill in");
                              await searchForInBill();
                            } else {
                              Log(tag: tag, message: "Search for bill out");
                              await searchForOutBill();
                            }
                          }),
                    ],
                  ),
                ),
                DropdownButtonNew(
                    initValue: initElementSearch,
                    flex: 1,
                    items: listSearchElement,
                    icon: Icons.precision_manufacturing,
                    onSelect: (value) {
                      if (value!.isNotEmpty) {
                        setState(() {
                          initElementSearch = value;
                          listShowObject = [];
                          Log(
                              tag: "$tag element item",
                              message: "element: $value");
                        });
                      }
                    }),
                DropdownButtonNew(
                    initValue: initObjectSearch,
                    flex: 1,
                    items: listObjectSearch,
                    icon: Icons.search,
                    onSelect: (value) {
                      setState(() {
                        initObjectSearch = value!;
                        listShowObject = [];
                        //["Item", "", "Worker", "Depot"];
                      });
                      searchFunctionConfig();
                    }),
              ],
            ),
          ),
        ),
        Expanded(
          // result of search
          child: Card(
            child: ListView.builder(
              scrollDirection: Axis.vertical,
              //shrinkWrap: true,
              itemCount: listShowObject.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                    leading: const Icon(Icons.precision_manufacturing),
                    title: Text(listShowObject[index].value0),
                    subtitle: Text(listShowObject[index].value1),
                    enabled: true,
                    onTap: () {
                      setState(() {
                        if (tableName == itemTableName) {
                          itemController.text = listShowObject[index].value0;
                          if (widget.billType == billIn) {
                            price = listItems[index].actualPrice;
                          } else {
                            price = listItems[index].actualPrice *
                                (1 + listItems[index].actualWin);
                          }
                          if (widget.billType == billOut) {
                            setState(() {
                              dateProduction = listShowObject[index].value3;
                            });
                          }
                          totalPrice = price * itemNumber;

                          selectedItem = listItems[index];
                          if (widget.billType == billOut) {
                            //Used in bill out
                            selectedItemsDepot = listItemsDepot[index];
                            depotItemIndex = index;
                          }
                        } else if (tableName == workerTableName) {
                          workerController.text = listShowObject[index].value0;
                          selectedWorker = listWorkers[index];
                        } else if (tableName == supplierTableName ||
                            tableName == customerTableName) {
                          supplierController.text =
                              listShowObject[index].value0;
                          selectedSupplier = listSupplier[index];
                        } else if (tableName == depotTableName) {
                          depotController.text = listShowObject[index].value0;
                          selectedDepot = listDepot[index];
                          if (widget.billType == billOut) {
                            listShowObjectMainTable.clear();
                            listItemsDepot.clear();
                            dateController.text = "";
                            toTalPrice = 0.0;
                            listSelectedItems.clear();
                            itemController.text = "";
                            numberController.text = "";
                            price = 0;
                            toTalPrice = 0;
                            totalPrice = 0;

                            itemBillIns.clear();
                          }
                        }
                      });
                      Log(
                          tag: tag,
                          message:
                              "item name is: ${listShowObject[index].value0}");
                    });
              },
            ),
          ),
        )
      ],
    );
  }
}
