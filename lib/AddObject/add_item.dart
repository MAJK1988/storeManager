import 'dart:io';

import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:image_picker/image_picker.dart';

import '../dataBase/item_sql.dart';
import '../dataBase/sql_object.dart';
import '../utils/image_pros.dart';
import '../utils/objects.dart';
import '../utils/utils.dart';
import 'dart:io';
import 'dart:async';

class AddItem extends StatefulWidget {
  final Item? item;
  const AddItem({super.key, required this.item});

  @override
  State<AddItem> createState() => _AddItemState();
}

class _AddItemState extends State<AddItem> {
  /*final _items = _animals
      .map((animal) => MultiSelectItem<Animal>(animal, animal.name))
      .toList();*/
  final _formKey = GlobalKey<FormState>();

  FocusNode searchFocusNode = FocusNode();
  FocusNode textFieldFocusNode = FocusNode();
  TextEditingController controllerName = TextEditingController(),
      controllerCodeBar = TextEditingController(),
      controllerMadeIn = TextEditingController(),
      controllerDescription = TextEditingController(),
      controllerCategory = TextEditingController(),
      controllerSoldBy = TextEditingController(),
      controllerValidityPeriod = TextEditingController(),
      controllerVolume = TextEditingController(),
      controllerPrice = TextEditingController(),
      controllerWin = TextEditingController(),
      categoryControl = TextEditingController();

  initCategoryList() async {
    setState(() {
      categoryList = [""];
    });
    var resCategoryList =
        await DBProvider.db.getAllObjects(tableName: itemCategoryTableName);
    if (resCategoryList.isNotEmpty) {
      for (var resCategory in resCategoryList) {
        setState(() {
          categoryList.add(resCategory['name']);
        });
      }
    }
  }

  @override
  void initState() {
    if (widget.item != null) {
      setState(() {
        name = widget.item!.name;
        controllerName.text = name;
        codeBar = widget.item!.barCode;
        controllerCodeBar.text = codeBar;
        madeIn = widget.item!.madeIn;
        controllerMadeIn.text = madeIn;
        description = widget.item!.description;
        controllerDescription.text = description;

        category = widget.item!.category;

        soldBy = widget.item!.soldBy;

        validityPeriod = widget.item!.validityPeriod;
        controllerValidityPeriod.text = validityPeriod.toString();
        volume = widget.item!.volume;
        controllerVolume.text = volume.toString();
        price = widget.item!.actualPrice;
        controllerPrice.text = price.toString();
        win = widget.item!.actualWin;
        controllerWin.text = win.toString();
      });
    }
    () async {
      await initCategoryList();
    }();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  final _multiSelectKey = GlobalKey<FormFieldState>();

  final String tag = "AddItem";
  late String name = '',
      codeBar = '',
      madeIn = '',
      description = '',
      category = "",
      soldBy = '';
  late double validityPeriod = 0.0,
      volume = 0.0,
      price = 0.0,
      win = 0.0,
      width = 660.0,
      height = 711.0,
      limitedWidth = 536;
  File? image;
  final ImagePicker _picker = ImagePicker();
  List<String> categoryList = [""];

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    Log(tag: tag, message: "width : ${size.width}");
    return Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.add_item),
          centerTitle: true,
        ),
        body: Center(
          child: SizedBox(
            width: width,
            height: height,
            child: SingleChildScrollView(
              child: Center(
                  child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  //crossAxisAlignment: CrossAxisAlignment.stretch,
                  //crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //Image
                    /* Padding(
                        padding: EdgeInsets.only(
                            right: padding, left: padding, bottom: padding),
                        child: IconButton(
                          icon: const Icon(Icons.add),
                          onPressed: () {
                            setImage();
                          },
                        )),*/
                    // name and code bar
                    Padding(
                      padding: EdgeInsets.only(
                          right: padding, left: padding, bottom: padding),
                      child: Row(
                        children: <Widget>[
                          Flexible(
                            child: inputElementTextFormField(
                                controller: controllerCodeBar,
                                padding: padding,
                                icon: Icons.bar_chart,
                                hintText:
                                    AppLocalizations.of(context)!.bar_code_text,
                                labelText:
                                    AppLocalizations.of(context)!.bar_code,
                                onChanged: ((value) {
                                  setState(() {
                                    codeBar = value!;
                                  });
                                })),
                          ),
                          Flexible(
                            child: inputElementTextFormField(
                                controller: controllerName,
                                padding: padding,
                                icon: Icons.edit_note,
                                hintText:
                                    AppLocalizations.of(context)!.name_text,
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

                    // volume and factory
                    Padding(
                      padding: EdgeInsets.only(
                          right: padding, left: padding, bottom: padding),
                      child: Row(
                        children: <Widget>[
                          Flexible(
                            child: inputElementTextFormField(
                                controller: controllerVolume,
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
                                controller: controllerMadeIn,
                                padding: padding,
                                icon: Icons.factory,
                                hintText:
                                    AppLocalizations.of(context)!.factory_text,
                                labelText:
                                    AppLocalizations.of(context)!.factory,
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
                                controller: controllerPrice,
                                padding: padding,
                                textInputType: TextInputType.number,
                                icon: Icons.price_check,
                                hintText: AppLocalizations.of(context)!.price,
                                labelText:
                                    AppLocalizations.of(context)!.price_text,
                                onChanged: ((value) {
                                  setState(() {
                                    price = double.parse(value!);
                                  });
                                })),
                          ),
                          Flexible(
                            child: inputElementTextFormField(
                                controller: controllerWin,
                                padding: padding,
                                textInputType: TextInputType.number,
                                icon: Icons.airline_stops_rounded,
                                hintText: AppLocalizations.of(context)!.win,
                                labelText:
                                    AppLocalizations.of(context)!.win_text,
                                onChanged: ((value) {
                                  setState(() {
                                    win = double.parse(value!);
                                  });
                                })),
                          ),
                        ],
                      ),
                    ),

                    //expiration
                    Padding(
                      padding: EdgeInsets.only(
                          right: padding, left: padding, bottom: padding),
                      child: inputElementTextFormField(
                          controller: controllerValidityPeriod,
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
                    //category and sale by
                    Center(
                      child: Padding(
                        padding: EdgeInsets.only(
                            right: padding, left: 2 * padding, bottom: padding),
                        child: Flex(
                          direction: size.width > limitedWidth
                              ? Axis.horizontal
                              : Axis.vertical,
                          children: <Widget>[
                            //category
                            SizedBox(
                              width: size.width > width
                                  ? width / 2 * 0.9
                                  : size.width > limitedWidth
                                      ? (size.width) / 2 * 0.9
                                      : (size.width), //
                              child: Row(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(left: padding),
                                    child: Text(AppLocalizations.of(context)!
                                        .item_category),
                                  ),
                                  DropdownButton<String>(
                                    value: category,
                                    icon: const Icon(Icons.arrow_downward),
                                    elevation: 16,
                                    style: const TextStyle(
                                        color: Colors.deepPurple),
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
                                    items: categoryList
                                        .map<DropdownMenuItem<String>>(
                                            (String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value),
                                      );
                                    }).toList(),
                                  ),
                                  //Add category
                                  IconButton(
                                      color: Colors.blue,
                                      iconSize: 20,
                                      icon: const Icon(Icons.add),
                                      onPressed: () {
                                        show_Widget(
                                            context: context,
                                            title: AppLocalizations.of(context)!
                                                .item_category,
                                            widget: Row(
                                              children: [
                                                Flexible(
                                                    flex: 3,
                                                    child:
                                                        inputElementTextFormField(
                                                      controller:
                                                          categoryControl,
                                                      textInputType:
                                                          TextInputType.number,
                                                      hintText:
                                                          AppLocalizations.of(
                                                                  context)!
                                                              .item_category,
                                                      icon: Icons.category,
                                                      labelText:
                                                          AppLocalizations.of(
                                                                  context)!
                                                              .item_category,
                                                      onChanged:
                                                          (String? value) {
                                                        if (value!.isNotEmpty) {
                                                          categoryControl.text =
                                                              value;
                                                        }
                                                      },
                                                      padding: 8,
                                                    )),
                                                Flexible(
                                                  child: IconButton(
                                                      color: Colors.blue,
                                                      iconSize: 20,
                                                      icon: const Icon(
                                                          Icons.save_alt),
                                                      onPressed: () async {
                                                        if (categoryControl
                                                                .text !=
                                                            "") {
                                                          await DBProvider.db
                                                              .addNewItemCategory(
                                                                  itemCategory:
                                                                      ItemCategory(
                                                                          id: 0,
                                                                          name:
                                                                              categoryControl.text));
                                                          categoryControl.text =
                                                              "";
                                                          await initCategoryList();
                                                        }
                                                      }),
                                                )
                                              ],
                                            ),
                                            response: (value) {});
                                      }),
                                ],
                              ),
                            ),

                            //SoldBy
                            SizedBox(
                                width: size.width > width
                                    ? width / 2 * 0.9
                                    : size.width > limitedWidth
                                        ? (size.width) / 2 * 0.9
                                        : (size.width),
                                child: Row(
                                  children: [
                                    Padding(
                                      padding:
                                          EdgeInsets.only(left: 2 * padding),
                                      child: Text(AppLocalizations.of(context)!
                                          .sale_by),
                                    ),
                                    DropdownButton<String>(
                                      value: "one",
                                      icon: const Icon(Icons.arrow_downward),
                                      elevation: 16,
                                      style: const TextStyle(
                                          color: Colors.deepPurple),
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
                                          .map<DropdownMenuItem<String>>(
                                              (String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(value),
                                        );
                                      }).toList(),
                                    ),
                                  ],
                                ))
                          ],
                        ),
                      ),
                    ),
                    //description
                    Padding(
                      padding: EdgeInsets.only(
                          right: padding, left: padding, bottom: padding),
                      child: inputElementTextFormField(
                          controller: controllerDescription,
                          padding: padding,
                          minLine: 3,
                          icon: Icons.description,
                          hintText:
                              AppLocalizations.of(context)!.description_text,
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
                              Log(
                                  tag: tag,
                                  message: "description: $description");
                              Log(tag: tag, message: "category: $category");
                              Log(tag: tag, message: "soldBy: $soldBy");
                              Log(
                                  tag: tag,
                                  message: "validityPeriod: $validityPeriod");
                              Log(tag: tag, message: "volume: $volume");

                              bool hasCodeBar = await DBProvider.db
                                  .tableHasObject(
                                      element: "name", searchFor: name);
                              bool hasName = await DBProvider.db.tableHasObject(
                                  element: "barCode", searchFor: codeBar);
                              Log(
                                  tag: tag,
                                  message:
                                      "table items has codeBar: $hasCodeBar");
                              Log(
                                  tag: tag,
                                  message: "table items has name: $name");
                              if (!hasCodeBar) {
                                Item item = Item(
                                  ID: widget.item == null ? 0 : widget.item!.ID,
                                  name: name,
                                  soldBy: soldBy,
                                  madeIn: madeIn,
                                  barCode: codeBar,
                                  category: category,
                                  description: description,
                                  prices: widget.item == null
                                      ? " "
                                      : widget.item!.prices,
                                  validityPeriod: validityPeriod,
                                  volume: volume,
                                  actualPrice: price,
                                  actualWin: win,
                                  supplierID: widget.item == null
                                      ? " "
                                      : widget.item!.supplierID,
                                  customerID: widget.item == null
                                      ? " "
                                      : widget.item!.customerID,
                                  depotID: widget.item == null
                                      ? " "
                                      : widget.item!.depotID,
                                  count: widget.item == null
                                      ? 0
                                      : widget.item!.count,
                                  // image: ""
                                );
                                if (widget.item == null) {
                                  int result = addNewItem(item: item);
                                  Log(
                                      tag: tag,
                                      message:
                                          "addItemToDatabase result: $result");
                                  // ignore: use_build_context_synchronously
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(SnackBar(
                                          content: Text(
                                    // ignore: use_build_context_synchronously
                                    AppLocalizations.of(context)!.object_add,
                                  )));
                                  clearInputText();
                                } else if (widget.item != null) {
                                  int result = await DBProvider.db.updateObject(
                                      v: item,
                                      tableName: itemTableName,
                                      id: widget.item!.ID);
                                  Log(
                                      tag: tag,
                                      message: "update item result: $result");
                                  // ignore: use_build_context_synchronously
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(SnackBar(
                                          content: Text(
                                    // ignore: use_build_context_synchronously
                                    AppLocalizations.of(context)!.update_object,
                                  )));
                                  clearInputText();
                                }
                              } else {
                                Log(
                                    tag: tag,
                                    message: "Item is exist in dataBase");
                                // ignore: use_build_context_synchronously
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
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
            ),
          ),
        ));
  }

  void clearInputText() {
    setState(() {
      name = "";
      controllerName.text = name;
      codeBar = "";
      controllerCodeBar.text = codeBar;
      madeIn = "";
      controllerMadeIn.text = madeIn;
      description = "";
      controllerDescription.text = description;

      category = "";

      soldBy = "";

      validityPeriod = 0;
      controllerValidityPeriod.text = "";
      volume = 0;
      controllerVolume.text = "";
      price = 0;
      controllerPrice.text = "";
      win = 0;
      controllerWin.text = "";
    });
  }
}
