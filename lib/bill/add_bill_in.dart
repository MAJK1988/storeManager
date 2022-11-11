import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../utils/objects.dart';
import '../utils/utils.dart';

class AddBillIn extends StatefulWidget {
  const AddBillIn({super.key});

  @override
  State<AddBillIn> createState() => _AddBillInState();
}

class _AddBillInState extends State<AddBillIn> {
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
        price: 4.02)
  ];

  void addItemBillIns() {
    setState(() {
      itemBillIns.add(ItemBill(
          id: 0,
          IDItem: itemBillIns.last.IDItem + 1,
          productDate: "barCode",
          number: 3,
          win: 0.2,
          price: 4.02));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.add_item),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Center(
              child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
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
                                  style:
                                      const TextStyle(color: Colors.deepPurple),
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

                        // Worker
                        Expanded(
                          flex: 1,
                          child: Row(
                            children: [
                              Padding(
                                padding: EdgeInsets.only(
                                    right: padding, left: padding / 2),
                                child: Text(
                                    AppLocalizations.of(context)!.recipient),
                              ),
                              Flexible(
                                child: DropdownButton<String>(
                                  value: "Mahmoud KADDOUR",
                                  icon: const Icon(Icons.arrow_downward),
                                  elevation: 16,
                                  isExpanded: true,
                                  style:
                                      const TextStyle(color: Colors.deepPurple),
                                  underline: Container(
                                    height: 2,
                                    color: Colors.deepPurpleAccent,
                                  ),
                                  onChanged: (String? value) {
                                    // This is called when the user selects an item.
                                    setState(() {});
                                  },
                                  items: ["Mahmoud KADDOUR", "two", "three"]
                                      .map<DropdownMenuItem<String>>(
                                          (String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
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
                                  style:
                                      const TextStyle(color: Colors.deepPurple),
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
                                      child: Text(value),
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
                          TableRow(children: [
                            //title
                            TableCell(
                                child: titleElementTable(
                                    title: AppLocalizations.of(context)!
                                        .bar_code)),
                            TableCell(
                                child: titleElementTable(
                                    title: AppLocalizations.of(context)!.name)),
                            TableCell(
                                child: titleElementTable(
                                    title:
                                        AppLocalizations.of(context)!.price)),
                            TableCell(
                                child: titleElementTable(
                                    title:
                                        AppLocalizations.of(context)!.number)),
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
                                        onChanged: (value) {},
                                        context: context),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.search),
                                    onPressed: () {},
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
                                        onChanged: (value) {},
                                        context: context),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.search),
                                    onPressed: () {},
                                  ),
                                ],
                              )),
                            ),
                            Card(
                              child: TableCell(
                                  child: inputElementTable(
                                      onChanged: (value) {},
                                      context: context,
                                      textInputType: TextInputType.number)),
                            ),
                            Card(
                              child: TableCell(
                                  child: inputElementTable(
                                      onChanged: (value) {},
                                      context: context,
                                      textInputType: TextInputType.number)),
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
                )
              ],
            ),
          )),
        ));
  }
}
