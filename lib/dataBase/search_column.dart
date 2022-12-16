import 'package:flutter/material.dart';
import 'package:store_manager/dataBase/sql_object.dart';

import '../utils/drop_down_button_new.dart';
import '../utils/objects.dart';
import '../utils/utils.dart';

class SearchColumnSTF extends StatefulWidget {
  const SearchColumnSTF({super.key});

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

  activateSearch() {
    searchForInBill();
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
        });
      } else {
        setState(() {
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
          listShowObject = listShowObjectIn;
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

  @override
  Widget build(BuildContext context) {
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
                            await searchForInBill();
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
        Visibility(
          visible: listShowObject.isNotEmpty,
          child: Expanded(
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
                      onTap: () {});
                }),
          )),
        )
      ],
    );
  }
}