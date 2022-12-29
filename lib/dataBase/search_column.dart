import 'package:flutter/material.dart';
import 'package:store_manager/dataBase/sql_object.dart';

import '../utils/drop_down_button_new.dart';
import '../utils/objects.dart';
import '../utils/utils.dart';

class SearchColumnSTF extends StatefulWidget {
  final Size size;
  final ValueChanged<dynamic> getElement;
  final ValueChanged<int>? getIndex;
  final String initObjectSearch;
  final String? billType;

  const SearchColumnSTF(
      {super.key,
      required this.size,
      required this.getElement,
      this.initObjectSearch = "",
      this.billType,
      this.getIndex});

  @override
  State<SearchColumnSTF> createState() => _SearchColumnSTFState();
}

class _SearchColumnSTFState extends State<SearchColumnSTF> {
  late String tag = "SearchColumnSTF";
  late String searchFor = "", elementSearch = "", element = '', object = '';
  late List<String> listSearchElement = getElementsItems();
  late String initElementSearch = getElementsItems().first;
  late String initObjectSearch = getObjectsNameListAddBillIn().first;
  late List<String> listObjectSearch = getObjectsNameListAddBillIn();
  late List<ShowObject> listShowObject = [];
  late String tableName = itemTableName, billType = billIn;

  late List<Item> listItem = [];
  late List<Worker> listWorker = [];
  late List<Depot> listDepot = [];
  late List<Supplier> listSupplier = [];
  late Depot selectedDepot = initDepot();
  late List<ItemsDepot> listItemsDepot = [];
  late List<ItemsDepot> listSelectedItemsDepot = [];
  late List<Item> listItems = [];
  late List<ShowObject> listShowObjectMainTable = [];

  activateSearch() {
    if (widget.billType == billIn) {
      searchForInBill();
    } else {
      searchForOutBill();
    }
  }

  searchForOutBill() async {
    Log(
        tag: tag,
        message:
            "Start searchForOutBill, tableName: $tableName, itemTableName: $itemTableName");

    if (tableName == itemTableName) {
      Log(
          tag: tag,
          message:
              "selectedDepot.depotListItem: ${selectedDepot.depotListItem}");
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
                "Search Bill out, ItemsDepot list length is: ${listItems.length}");
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
          listShowObject = listShowObjectIn;
          Log(
              tag: tag,
              message:
                  "length of listShowObject is : ${listShowObject.length}");
          listItems = listItemsIn;
        });
      } else {
        setState(() {
          listShowObject = [];
          listItems == [];
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
          listShowObject = listShowObjectIn;
          listWorker = listWorkerIn;
          Log(
              tag: tag,
              message:
                  "length of listShowObject is : ${listShowObject.length}");
        });
      } else {
        setState(() {
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
          listShowObject = listShowObjectIn;
          listSupplier = listSupplierIn;
          Log(
              tag: tag,
              message:
                  "length of listShowObject is : ${listShowObject.length}");
        });
      } else {
        setState(() {
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
          listShowObject = listShowObjectIn;
          listDepot = listDepotIn;
          Log(
              tag: tag,
              message:
                  "length of listShowObject is : ${listShowObject.length}");
        });
      } else {
        setState(() {
          listShowObject = [];
          Log(tag: tag, message: "Search $tableName is null");
        });
      }
    }
  }

  searchFunctionConfig() {
    setState(() {
      //["Item", "", "Worker", "Depot"];
      if (initObjectSearch == workerType) {
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
      } else if (initObjectSearch == supplierType) {
        initElementSearch = "";
        tableName = supplierTableName;
        listSearchElement = getElementsSupplier();
        initElementSearch = listSearchElement.first;
      } else if (initObjectSearch == depotType) {
        initElementSearch = "";
        tableName = depotTableName;
        listSearchElement = getElementsDepot();
        initElementSearch = listSearchElement.first;
      } else if (initObjectSearch == customerType) {
        initElementSearch = "";
        tableName = customerTableName;
        listSearchElement = getElementsSupplier();
        initElementSearch = listSearchElement.first;
      }
      Log(tag: "$tag element item", message: "element: $element");
      activateSearch();
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    if (widget.initObjectSearch != "") {
      setState(() {
        initObjectSearch = widget.initObjectSearch;
      });
      searchFunctionConfig();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        SizedBox(
          width: widget.size.width * 0.95,
          child: Card(
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
                              await activateSearch();
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
                            listItem == [];
                            Log(
                                tag: "$tag element item",
                                message: "element: $value");
                          });
                        }
                      }),
                  Visibility(
                    visible: widget.initObjectSearch == "",
                    child: DropdownButtonNew(
                        initValue: initObjectSearch,
                        flex: 1,
                        items: listObjectSearch,
                        icon: Icons.search,
                        onSelect: (value) {
                          setState(() {
                            initObjectSearch = value!;
                            listShowObject = [];
                            listItem == [];
                            //["Item", "", "Worker", "Depot"];
                          });
                          searchFunctionConfig();
                        }),
                  ),
                ],
              ),
            ),
          ),
        ),
        Visibility(
          visible: listShowObject.isNotEmpty,
          child: Expanded(
              // result of search
              child: SizedBox(
            width: widget.size.width * 0.95,
            height: widget.size.height * 0.35,
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
                          if (tableName == itemTableName) {
                            widget.getElement(listItems[index]);
                            if (widget.billType == billOut) {
                              widget.getIndex!(index);
                            }
                            setState(() {
                              listItems = [];
                            });
                          } else if (tableName == workerTableName) {
                            widget.getElement(listWorker[index]);
                            setState(() {
                              listWorker = [];
                            });
                          } else if (tableName == supplierTableName) {
                            widget.getElement(listSupplier[index]);
                            setState(() {
                              listSupplier = [];
                            });
                          } else if (tableName == depotTableName) {
                            widget.getElement(listDepot[index]);
                            setState(() {
                              listDepot = [];
                            });
                          } else if (tableName == customerTableName) {
                            widget.getElement(listSupplier[index]);
                            setState(() {
                              listSupplier = [];
                            });
                          }
                          setState(() {
                            listShowObject = [];
                          });
                        });
                  }),
            ),
          )),
        )
      ],
    );
  }
}
