import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';

import '../dataBase/sql_object.dart';
import '../utils/objects.dart';
import '../utils/utils.dart';

class AddItem extends StatefulWidget {
  const AddItem({super.key});

  @override
  State<AddItem> createState() => _AddItemState();
}

class Animal {
  final int id;
  final String name;

  Animal({
    required this.id,
    required this.name,
  });
}

class _AddItemState extends State<AddItem> {
  static final List<Animal> _animals = [
    Animal(id: 1, name: "Lion"),
    Animal(id: 2, name: "Flamingo"),
    Animal(id: 3, name: "Hippo"),
    Animal(id: 4, name: "Horse"),
    Animal(id: 5, name: "Tiger"),
    Animal(id: 6, name: "Penguin"),
    Animal(id: 7, name: "Spider"),
    Animal(id: 8, name: "Snake"),
    Animal(id: 9, name: "Bear"),
    Animal(id: 10, name: "Beaver"),
    Animal(id: 11, name: "Cat"),
    Animal(id: 12, name: "Fish"),
    Animal(id: 13, name: "Rabbit"),
    Animal(id: 14, name: "Mouse"),
    Animal(id: 15, name: "Dog"),
    Animal(id: 16, name: "Zebra"),
    Animal(id: 17, name: "Cow"),
    Animal(id: 18, name: "Frog"),
    Animal(id: 19, name: "Blue Jay"),
    Animal(id: 20, name: "Moose"),
    Animal(id: 21, name: "Gecko"),
    Animal(id: 22, name: "Kangaroo"),
    Animal(id: 23, name: "Shark"),
    Animal(id: 24, name: "Crocodile"),
    Animal(id: 25, name: "Owl"),
    Animal(id: 26, name: "Dragonfly"),
    Animal(id: 27, name: "Dolphin"),
  ];
  /*final _items = _animals
      .map((animal) => MultiSelectItem<Animal>(animal, animal.name))
      .toList();*/
  final _formKey = GlobalKey<FormState>();

  FocusNode searchFocusNode = FocusNode();
  FocusNode textFieldFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  final _multiSelectKey = GlobalKey<FormFieldState>();

  List<Animal?> _selectedAnimals3 = [];
  final String tag = "AddItem";
  late String name = '',
      codeBar = '',
      madeIn = '',
      description = '',
      category = '',
      soldBy = '';
  late double validityPeriod = 0.0, volume = 0.0, price = 0.0, win = 0.0;

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
                // name and code bar
                Padding(
                  padding: EdgeInsets.only(
                      right: padding, left: padding, bottom: padding),
                  child: Row(
                    children: <Widget>[
                      Flexible(
                        child: inputElementTextFormField(
                            padding: padding,
                            icon: Icons.bar_chart,
                            hintText:
                                AppLocalizations.of(context)!.bar_code_text,
                            labelText: AppLocalizations.of(context)!.bar_code,
                            onChanged: ((value) {
                              setState(() {
                                codeBar = value!;
                              });
                            })),
                      ),
                      Flexible(
                        child: inputElementTextFormField(
                            padding: padding,
                            icon: Icons.edit_note,
                            hintText: AppLocalizations.of(context)!.name_text,
                            labelText: AppLocalizations.of(context)!.name,
                            onChanged: ((value) {
                              setState(() {
                                name = value!;
                              });
                            })),
                      ),
                    ],
                  ),
                ),
                // Supplier and factory
                /*Padding(
                  padding: EdgeInsets.only(
                      left: padding * 3, right: padding * 2, bottom: padding),
                  child: Row(
                    children: [
                      Flexible(
                        flex: 1,
                        child: MultiSelectBottomSheetField<Animal?>(
                          key: _multiSelectKey,
                          initialChildSize: 0.7,
                          maxChildSize: 0.95,
                          title: Text(AppLocalizations.of(context)!.supplier),
                          buttonText:
                              Text(AppLocalizations.of(context)!.supplier_text),
                          items: _animals
                              .map((animal) =>
                                  MultiSelectItem<Animal>(animal, animal.name))
                              .toList(),
                          searchable: true,
                          validator: (values) {
                            if (values == null || values.isEmpty) {
                              return AppLocalizations.of(context)!.required;
                            }
                            return null;
                          },
                          onConfirm: (values) {
                            setState(() {
                              _selectedAnimals3 = values;
                            });
                            _multiSelectKey.currentState!.validate();
                          },
                          chipDisplay: MultiSelectChipDisplay(
                            onTap: (item) {
                              setState(() {
                                _selectedAnimals3.remove(item);
                              });
                              _multiSelectKey.currentState!.validate();
                            },
                          ),
                        ),
                      ),
                       Flexible(
                        child: inputElementTextFormField(
                            padding: padding,
                            textInputType: TextInputType.number,
                            icon: Icons.north_east_rounded,
                            hintText: AppLocalizations.of(context)!.ratio_text,
                            labelText: AppLocalizations.of(context)!.ratio,
                            onChanged: ((value) {})),
                      ),
                    ],
                  ),
                ),*/
                // volume and factory
                Padding(
                  padding: EdgeInsets.only(
                      right: padding, left: padding, bottom: padding),
                  child: Row(
                    children: <Widget>[
                      Flexible(
                        child: inputElementTextFormField(
                            padding: padding,
                            textInputType: TextInputType.number,
                            icon: Icons.view_in_ar_outlined,
                            hintText: AppLocalizations.of(context)!.volume,
                            labelText:
                                AppLocalizations.of(context)!.volume_text,
                            onChanged: ((value) {
                              setState(() {
                                volume = double.parse(value!);
                              });
                            })),
                      ),
                      Flexible(
                        child: inputElementTextFormField(
                            padding: padding,
                            icon: Icons.factory,
                            hintText:
                                AppLocalizations.of(context)!.factory_text,
                            labelText: AppLocalizations.of(context)!.factory,
                            onChanged: ((value) {
                              setState(() {
                                madeIn = value!;
                              });
                            })),
                      ),
                    ],
                  ),
                ),
                // price and win
                Padding(
                  padding: EdgeInsets.only(
                      right: padding, left: padding, bottom: padding),
                  child: Row(
                    children: <Widget>[
                      Flexible(
                        child: inputElementTextFormField(
                            padding: padding,
                            textInputType: TextInputType.number,
                            icon: Icons.price_check,
                            hintText: AppLocalizations.of(context)!.price,
                            labelText: AppLocalizations.of(context)!.price_text,
                            onChanged: ((value) {
                              setState(() {
                                price = double.parse(value!);
                              });
                            })),
                      ),
                      Flexible(
                        child: inputElementTextFormField(
                            padding: padding,
                            textInputType: TextInputType.number,
                            icon: Icons.airline_stops_rounded,
                            hintText: AppLocalizations.of(context)!.win,
                            labelText: AppLocalizations.of(context)!.win_text,
                            onChanged: ((value) {
                              setState(() {
                                win = double.parse(value!);
                              });
                            })),
                      ),
                    ],
                  ),
                ),

                //expiration and category and sale by
                Padding(
                  padding: EdgeInsets.only(
                      right: padding, left: padding, bottom: padding),
                  child: Row(
                    children: <Widget>[
                      Flexible(
                        flex: 3,
                        child: inputElementTextFormField(
                            padding: padding,
                            textInputType: TextInputType.number,
                            icon: Icons.timelapse,
                            hintText:
                                AppLocalizations.of(context)!.expiration_text,
                            labelText: AppLocalizations.of(context)!.expiration,
                            onChanged: ((value) {
                              setState(() {
                                validityPeriod = double.parse(value!);
                              });
                            })),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: padding),
                        child:
                            Text(AppLocalizations.of(context)!.item_category),
                      ),
                      Flexible(
                        child: DropdownButton<String>(
                          value: "one",
                          icon: const Icon(Icons.arrow_downward),
                          elevation: 16,
                          style: const TextStyle(color: Colors.deepPurple),
                          underline: Container(
                            height: 2,
                            color: Colors.deepPurpleAccent,
                          ),
                          onChanged: (String? value) {
                            // This is called when the user selects an item.
                            setState(() {
                              category = value!;
                            });
                          },
                          items: ["one", "two", "three"]
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(right: 2 * padding),
                        child: Text(AppLocalizations.of(context)!.sale_by),
                      ),
                      Flexible(
                        child: DropdownButton<String>(
                          value: "one",
                          icon: const Icon(Icons.arrow_downward),
                          elevation: 16,
                          style: const TextStyle(color: Colors.deepPurple),
                          underline: Container(
                            height: 2,
                            color: Colors.deepPurpleAccent,
                          ),
                          onChanged: (String? value) {
                            // This is called when the user selects an item.
                            setState(() {
                              soldBy = value!;
                            });
                          },
                          items: ["one", "two", "three"]
                              .map<DropdownMenuItem<String>>((String value) {
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
                //description
                Padding(
                  padding: EdgeInsets.only(
                      right: padding, left: padding, bottom: padding),
                  child: inputElementTextFormField(
                      padding: padding,
                      minLine: 3,
                      icon: Icons.description,
                      hintText: AppLocalizations.of(context)!.description_text,
                      labelText: AppLocalizations.of(context)!.description,
                      onChanged: ((value) {
                        setState(() {
                          description = value!;
                        });
                      })),
                ),
                //Button save
                Padding(
                  padding: EdgeInsets.only(bottom: 4 * padding),
                  child: SizedBox(
                    height: 30,
                    width: 250,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                      ),
                      onPressed: () async {
                        // It returns true if the form is valid, otherwise returns false
                        if (_formKey.currentState!.validate()) {
                          // If the form is valid, display a Snackbar.
                          Log(tag: tag, message: "the form is valid");

                          Log(tag: tag, message: "name: $name");
                          Log(tag: tag, message: "codeBar: $codeBar");
                          Log(tag: tag, message: "madeIn: $madeIn");
                          Log(tag: tag, message: "description: $description");
                          Log(tag: tag, message: "category: $category");
                          Log(tag: tag, message: "soldBy: $soldBy");
                          Log(
                              tag: tag,
                              message: "validityPeriod: $validityPeriod");
                          Log(tag: tag, message: "volume: $volume");

                          bool hasCodeBar = await DBProvider.db
                              .tableHasObject(element: "name", searchFor: name);
                          bool hasName = await DBProvider.db.tableHasObject(
                              element: "barCode", searchFor: codeBar);
                          Log(
                              tag: tag,
                              message: "table items has codeBar: $hasCodeBar");
                          Log(tag: tag, message: "table items has name: $name");
                          if (!hasCodeBar) {
                            Item item = Item(
                                ID: 0,
                                name: name,
                                soldBy: soldBy,
                                madeIn: madeIn,
                                barCode: codeBar,
                                category: category,
                                description: description,
                                prices: " ",
                                validityPeriod: validityPeriod,
                                volume: volume,
                                actualPrice: price,
                                actualWin: win,
                                supplierID: " ",
                                customerID: " ",
                                depotID: " ",
                                count: 0);
                            int result =
                                await DBProvider.db.addNewItem(item: item);
                            Log(
                                tag: tag,
                                message: "addItemToDatabase result: $result");
                            // ignore: use_build_context_synchronously
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text(
                              // ignore: use_build_context_synchronously
                              AppLocalizations.of(context)!.object_add,
                            )));
                          } else {
                            Log(tag: tag, message: "Item is exist in dataBase");
                            // ignore: use_build_context_synchronously
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text(
                              // ignore: use_build_context_synchronously
                              AppLocalizations.of(context)!.object_exist,
                            )));
                          }
                        }
                      },
                      child: Text(
                        AppLocalizations.of(context)!.save,
                        style: const TextStyle(fontSize: 20),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )),
        ));
  }
}
