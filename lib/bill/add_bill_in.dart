import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../dataBase/sql_object.dart';
import '../utils/objects.dart';
import '../utils/utils.dart';

class AddBillIn extends StatefulWidget {
  const AddBillIn({super.key});

  @override
  State<AddBillIn> createState() => _AddBillInState();
}

class _AddBillInState extends State<AddBillIn> {
  final GlobalKey _widgetKey = GlobalKey();
  late double totalPrice = 0.0;
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
  late final List<ItemBill> itemBillIns = [
    ItemBill(
        id: 0,
        IDItem: 0,
        productDate: "barCode",
        number: 3,
        win: 0.2,
        price: 4.02,
        depotID: -1)
  ];

  void addItemBillIns() {
    setState(() {
      itemBillIns.add(ItemBill(
          id: 0,
          IDItem: itemBillIns.last.IDItem + 1,
          productDate: "barCode",
          number: 3,
          win: 0.2,
          price: 4.02,
          depotID: -1));
    });
  }

  late List<Item> listItems = [];
  @override
  void initState() {
    // TODO: implement initState
    () async {
      List<Item> listItemsIn = await DBProvider.db.getAllItems();
      setState(() {
        listItems = listItemsIn;
      });
    }();

    super.initState();
  }

  late String searchFor = "", elementSearch = "", element = '';
  late final String tag = "AddBillIn";
  late Future<List<Item>> futureBuild = DBProvider.db.getAllItems();
  Stream<int> generateNumbers = (() async* {
    await Future<void>.delayed(Duration(seconds: 2));

    for (int i = 1; i <= 10; i++) {
      await Future<void>.delayed(Duration(seconds: 1));
      yield i;
    }
  })();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.add_item),
          centerTitle: true,
        ),
        body: Form(
          key: _formKey,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Flexible(
                flex: 7,
                child: Column(
                  // mainAxisAlignment: MainAxisAlignment.center,
                  //crossAxisAlignment: CrossAxisAlignment.stretch,
                  //crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Date and supplier and recipient " worker"
                    Card(
                      child: Padding(
                        padding: EdgeInsets.only(
                            right: padding, left: padding, bottom: padding),
                        child: Flex(
                          direction: Axis.horizontal,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Expanded(
                              flex: 1,
                              child: inputElementDateFormField(
                                  controller: null,
                                  context: context,
                                  padding: padding,
                                  icon: Icons.date_range,
                                  hintText: AppLocalizations.of(context)!.date,
                                  labelText: AppLocalizations.of(context)!.date,
                                  onChanged: ((value) {})),
                            ),
                            // Supplier
                            Expanded(
                              flex: 1,
                              child: Row(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(
                                        right: padding, left: padding / 2),
                                    child: Text(
                                        AppLocalizations.of(context)!.supplier),
                                  ),
                                  Flexible(
                                    child: DropdownButton<String>(
                                      value: "Mahmoud KADDOUR",
                                      icon: const Icon(Icons.arrow_downward),
                                      elevation: 16,
                                      style: const TextStyle(
                                          color: Colors.deepPurple),
                                      underline: Container(
                                        height: 2,
                                        color: Colors.deepPurpleAccent,
                                      ),
                                      isExpanded: true,
                                      onTap: () {
                                        setState(() {
                                          searchFor = "Supplier";
                                        });
                                      },
                                      onChanged: (String? value) {
                                        // This is called when the user selects an item.
                                      },
                                      items: ["Mahmoud KADDOUR", "two", "three"]
                                          .map<DropdownMenuItem<String>>(
                                              (String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(value,
                                              overflow: TextOverflow.ellipsis),
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // Worker
                            Expanded(
                              flex: 1,
                              child: Row(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(
                                        right: padding, left: padding / 2),
                                    child: Text(AppLocalizations.of(context)!
                                        .recipient),
                                  ),
                                  Flexible(
                                    child: DropdownButton<String>(
                                      value: "Mahmoud KADDOUR",
                                      icon: const Icon(Icons.arrow_downward),
                                      elevation: 16,
                                      isExpanded: true,
                                      style: const TextStyle(
                                          color: Colors.deepPurple),
                                      underline: Container(
                                        height: 2,
                                        color: Colors.deepPurpleAccent,
                                      ),
                                      onTap: () {
                                        setState(() {
                                          searchFor = "Worker";
                                        });
                                      },
                                      onChanged: (String? value) {
                                        // This is called when the user selects an item.
                                      },
                                      items: ["Mahmoud KADDOUR", "two", "three"]
                                          .map<DropdownMenuItem<String>>(
                                              (String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(value,
                                              overflow: TextOverflow.ellipsis),
                                        );
                                      }).toList(),
                                    ),
                                  ),
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
                                        right: padding, left: padding / 2),
                                    child: Text(AppLocalizations.of(context)!
                                        .payment_method),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: DropdownButton<String>(
                                      value: "Mahmoud KADDOUR",
                                      icon: const Icon(Icons.arrow_downward),
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
                                      items: ["Mahmoud KADDOUR", "two", "three"]
                                          .map<DropdownMenuItem<String>>(
                                              (String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(value,
                                              overflow: TextOverflow.ellipsis),
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

                    // item list
                    SingleChildScrollView(
                      child: Padding(
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
                                TableRow(children: [
                                  //title
                                  TableCell(
                                      child: titleElementTable(
                                          title: AppLocalizations.of(context)!
                                              .bar_code)),
                                  TableCell(
                                      child: titleElementTable(
                                          title: AppLocalizations.of(context)!
                                              .name)),
                                  TableCell(
                                      child: titleElementTable(
                                          title: AppLocalizations.of(context)!
                                              .price)),
                                  TableCell(
                                      child: titleElementTable(
                                          title: AppLocalizations.of(context)!
                                              .number)),
                                  TableCell(
                                      child: titleElementTable(
                                          title: AppLocalizations.of(context)!
                                              .total_price)),
                                ]),
                                //Input row
                                TableRow(children: [
                                  TableCell(
                                      child: Card(
                                    child: Row(
                                      children: [
                                        Flexible(
                                          child: inputElementTable(
                                              onChang: (value) {},
                                              context: context),
                                        ),
                                        IconButton(
                                          icon: const Icon(Icons.search),
                                          onPressed: () {
                                            setState(() {
                                              searchFor = "item";
                                            });
                                          },
                                        ),
                                      ],
                                    ),
                                  )),
                                  Card(
                                    child: TableCell(
                                        child: Row(
                                      children: [
                                        Flexible(
                                          child: inputElementTable(
                                              onChang: (value) {},
                                              context: context),
                                        ),
                                        IconButton(
                                          icon: const Icon(Icons.search),
                                          onPressed: () {
                                            setState(() {
                                              searchFor = "item";
                                              Log(
                                                  tag: " $tag Add_bill_in",
                                                  message:
                                                      "Search for: $searchFor");
                                            });
                                          },
                                        ),
                                      ],
                                    )),
                                  ),
                                  Card(
                                    child: TableCell(
                                        child: inputElementTable(
                                            onChang: (value) {},
                                            context: context,
                                            textInputType:
                                                TextInputType.number)),
                                  ),
                                  Card(
                                    child: TableCell(
                                        child: inputElementTable(
                                            onChang: (value) {},
                                            context: context,
                                            textInputType:
                                                TextInputType.number)),
                                  ),
                                  Card(
                                    child: TableCell(
                                        child: Center(
                                      child: Padding(
                                        padding: EdgeInsets.all(padding),
                                        child: Text(
                                          '$totalPrice \$',
                                          style: const TextStyle(fontSize: 18),
                                        ),
                                      ),
                                    )),
                                  )
                                ]),
                                //data
                                for (ItemBill itemBillIn in itemBillIns)
                                  inputDataBillInTable(itemBillIn: itemBillIn),
                              ],
                            ),
                            // Save Item
                            Positioned(
                              top: 10,
                              right: 10,
                              child: IconButton(
                                  icon: const Icon(Icons.save),
                                  onPressed: () {
                                    addItemBillIns();
                                  }),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Flexible(
                  key: _widgetKey,
                  flex: 4,
                  child: Column(
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
                                          hintText: searchFor,
                                          onChang: (value) {
                                            setState(() {
                                              elementSearch = value!;
                                              Log(
                                                  tag: "$tag elementSearch",
                                                  message:
                                                      "elementSearch: $elementSearch");
                                            });
                                          },
                                          context: context),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.search),
                                      onPressed: () async {
                                        if (elementSearch != "") {
                                          String tableName = itemTableName;
                                          if (element == "") {
                                            element = "name";
                                          }
                                          Log(
                                              tag: tag,
                                              message:
                                                  "search $elementSearch in $element, table name is: $tableName");
                                          // Search query
                                          var res = await DBProvider.db
                                              .tableSearchName(
                                                  tableName: tableName,
                                                  elementSearch: elementSearch,
                                                  element: element);
                                          // convert json to item array
                                          List<Item> listItemsIn = (res
                                                  .isNotEmpty
                                              ? (res.isNotEmpty
                                                  ? res
                                                      .map<Item>((item) =>
                                                          Item.fromJson(item))
                                                      .toList()
                                                  : [])
                                              : []) as List<Item>;
                                          setState(() {
                                            listItems = listItemsIn;
                                          });
                                        } else {
                                          Log(
                                              tag: tag,
                                              message: "elementSearch is null");
                                        }
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              DropdownButtonNew(
                                  flex: 1,
                                  items: getElementsItems(),
                                  icon: Icons.precision_manufacturing,
                                  onSelect: (value) {
                                    setState(() {
                                      element = value!;
                                      Log(
                                          tag: "$tag element item",
                                          message: "element: $element");
                                    });
                                  }),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: Card(
                          child: ListView.builder(
                            scrollDirection: Axis.vertical,
                            //shrinkWrap: true,
                            itemCount: listItems.length,
                            itemBuilder: (BuildContext context, int index) {
                              final RenderBox renderBox =
                                  _widgetKey.currentContext?.findRenderObject()
                                      as RenderBox;

                              final Size size = renderBox.size;
                              return ListTile(
                                  leading:
                                      const Icon(Icons.precision_manufacturing),
                                  title: Text("Name ${listItems[index].name}"),
                                  subtitle: Text(
                                      "Description ${listItems[index].description}"),
                                  enabled: true,
                                  onTap: () {
                                    /* react to the tile being tapped */
                                  });
                              /*ListItemUser(
                                      item: snapshot.data![index],
                                      size: renderBox.size);*/
                            },
                          ),
                        ),
                      )
                    ],
                  )),
            ],
          ),
        ));
  }
}

class DropdownButtonNew extends StatefulWidget {
  final List<String> items;
  final ValueChanged<String?> onSelect;
  final IconData icon;
  final int flex;

  const DropdownButtonNew(
      {super.key,
      required this.items,
      required this.onSelect,
      required this.icon,
      required this.flex});

  @override
  State<DropdownButtonNew> createState() => _DropdownButtonNewState();
}

class _DropdownButtonNewState extends State<DropdownButtonNew> {
  late String valueShow;
  @override
  void initState() {
    // TODO: implement initState
    setState(() {
      valueShow = widget.items.first;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: widget.flex,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: DropdownButton<String>(
          value: valueShow,
          icon: Icon(widget.icon),
          elevation: 16,
          style: const TextStyle(color: Colors.deepPurple),
          underline: Container(
            height: 2,
            color: Colors.deepPurpleAccent,
          ),
          isExpanded: true,
          onTap: () {},
          onChanged: (String? value) {
            widget.onSelect(value);
            setState(() {
              valueShow = value!;
            });
          },
          items: widget.items.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value, overflow: TextOverflow.ellipsis),
            );
          }).toList(),
        ),
      ),
    );
  }
}
