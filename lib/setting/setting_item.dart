import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:overlay_loading_progress/overlay_loading_progress.dart';
import 'package:store_manager/dataBase/sql_object.dart';
import 'package:store_manager/utils/objects.dart';
import 'package:store_manager/utils/utils.dart';

import '../dataBase/search_column.dart';

class SettingItem extends StatefulWidget {
  const SettingItem({super.key});

  @override
  State<SettingItem> createState() => _SettingItemState();
}

class _SettingItemState extends State<SettingItem> {
  List<ShowObject> showObjectList = [];
  List<ItemSettingNb> iTemSettingNbList = [];
  TextEditingController countControl = TextEditingController(),
      itemControl = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final String tag = "SettingItem";

  addShowObjectToUI({bool wait = true}) async {
    if (wait) {
      OverlayLoadingProgress.start(context);
    }
    setState(() {
      showObjectList = [];
      iTemSettingNbList = [];
    });
    var resItemSettingCount =
        await DBProvider.db.getAllObjects(tableName: settingItemNbTableName);
    if (resItemSettingCount.isNotEmpty) {
      Log(
          tag: tag,
          message:
              "table setting isn't null, data length is: ${resItemSettingCount.length}");
      for (var json in resItemSettingCount) {
        var itemJson = await DBProvider.db
            .getObject(id: json['itemId'], tableName: itemTableName);
        if (itemJson.isNotEmpty) {
          setState(() {
            iTemSettingNbList.add(ItemSettingNb.fromJson(json));
            showObjectList.add(ShowObject(
                value0: itemJson.first['name'],
                value1: json['countLimit'].toString(),
                value2: itemJson.first['count'].toString()));
          });
        }
      }
    } else {
      Log(tag: tag, message: "Item setting table is empty");
    }
    if (wait) {
      OverlayLoadingProgress.stop();
    }
  }

  @override
  void initState() {
    Log(tag: tag, message: "init data setting");
    // TODO: implement initState
    () async {
      await addShowObjectToUI(wait: false);
    }();

    super.initState();
  }

  late bool isSearchVisible = false;
  late Item selectedItem;
  late double count = 0.0;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    late double width = 0, height = 0;
    Log(
        tag: tag,
        message: " size width: ${size.width}, size height: ${size.height}");
    if (size.width < 700 && size.width > 420) {
      width = 120;
      height = 70;
    } else if (size.width <= 420 && size.width > 295) {
      width = 80;
      height = 70;
    } else if (size.width < 295) {
      width = 60;
      height = 70;
    } else {
      width = 200;
      height = 70;
    }
    return Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.item),
        ),
        body: SingleChildScrollView(
            child: Wrap(children: <Widget>[
          Visibility(
            visible: isSearchVisible,
            child: Center(
              child: SizedBox(
                width: size.width * 0.95,
                child: Padding(
                  padding: const EdgeInsets.only(top: 40, bottom: 30),
                  child: Card(
                      child: SearchColumnSTF(
                    billType: billIn,
                    initObjectSearch: itemType,
                    size: size,
                    getElement: (value) {
                      Log(tag: tag, message: "value: $value");
                      if (value is Item) {
                        Log(tag: tag, message: "get new item");
                        setState(() {
                          isSearchVisible = false;
                          selectedItem = value;
                          itemControl.text = value.name;
                        });
                      }
                    },
                  )),
                ),
              ),
            ),
          ),
          Center(
            child: SizedBox(
              width: size.width * 0.8,
              child: Form(
                key: _formKey,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                      flex: 2,
                      child: Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                                right: padding, left: padding / 2),
                            child:
                                Text("${AppLocalizations.of(context)!.item}: "),
                          ),
                          Flexible(
                            child: inputElementTable(
                                readOnly: true,
                                controller: itemControl,
                                ontap: (value) {
                                  if (itemControl.text.isEmpty) {
                                    setState(() {
                                      isSearchVisible = true;
                                    });
                                  } else {
                                    setState(() {
                                      isSearchVisible = !isSearchVisible;
                                    });
                                  }
                                },
                                onChang: (value) {},
                                context: context),
                          ),
                        ],
                      ),
                    ),
                    Flexible(
                      flex: 2,
                      child: inputElementTextFormField(
                        controller: countControl,
                        textInputType: TextInputType.number,
                        hintText: AppLocalizations.of(context)!.threshold,
                        icon: Icons.data_thresholding,
                        labelText: AppLocalizations.of(context)!.threshold,
                        onChanged: (String? value) {
                          if (value!.isNotEmpty) {
                            countControl.text = value;
                          }
                        },
                        padding: 8,
                      ),
                    ),
                    Flexible(
                        flex: 1,
                        child: IconButton(
                          icon: Icon(
                            Icons.save,
                            color: (countControl.text == "")
                                ? Colors.blue
                                : Colors.blueGrey,
                          ),
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              Log(
                                  tag: tag,
                                  message: "Try to save item setting!!");
                              var hasItem = await DBProvider.db.getObject(
                                  id: selectedItem.ID,
                                  tableName: settingItemNbTableName);
                              if (hasItem.isEmpty) {
                                Log(
                                    tag: tag,
                                    message: "Item exist update it!!");
                                await DBProvider.db.addNewItemNbSetting(
                                    itemSettingNb: ItemSettingNb(
                                        itemId: selectedItem.ID,
                                        countLimit:
                                            double.parse(countControl.text)));
                              } else {
                                Log(
                                    tag: tag,
                                    message: "Add new item to setting table");
                                await DBProvider.db.updateObject(
                                    v: ItemSettingNb(
                                        itemId: selectedItem.ID,
                                        countLimit:
                                            double.parse(countControl.text)),
                                    tableName: settingItemNbTableName,
                                    id: selectedItem.ID);
                              }
                              await addShowObjectToUI();
                              setState(() {
                                itemControl.text = "";
                                countControl.text = "";
                                isSearchVisible = false;
                              });
                            }
                          },
                        ))
                  ],
                ),
              ),
            ),
          ),
          Center(
            child: SizedBox(
                width: size.width * 0.8,
                height: size.height * 0.7,
                child: ListView.builder(
                    itemCount: showObjectList.length,
                    itemBuilder: (context, index) {
                      Color textColors = double.parse(
                                  showObjectList[index].value1) > //'countLimit'
                              double.parse(
                                  showObjectList[index].value2) // item count
                          ? Colors.red
                          : Colors.black;
                      return Card(
                          color: double.parse(showObjectList[index]
                                      .value1) > //'countLimit'
                                  double.parse(showObjectList[index]
                                      .value2) // item count
                              ? Colors.red.shade50
                              : null,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ListTile(
                              /*leading: Text(
                                  '${AppLocalizations.of(context)!.item}: ${showObjectList[index].value0}'),*/
                              title: Text(
                                  '${AppLocalizations.of(context)!.item}: ${showObjectList[index].value0}'),
                              subtitle: Wrap(
                                children: [
                                  Text(
                                      style: TextStyle(color: textColors),
                                      '${AppLocalizations.of(context)!.threshold}: ${showObjectList[index].value1}'),
                                  const Text(' <=> '),
                                  Text(
                                      style: TextStyle(color: textColors),
                                      '${AppLocalizations.of(context)!.count}: ${showObjectList[index].value2}'),
                                ],
                              ),
                              trailing: Wrap(
                                children: [
                                  IconButton(
                                      iconSize: 20,
                                      icon: const Icon(Icons.delete),
                                      onPressed: () async {
                                        Log(
                                            tag: tag,
                                            message:
                                                "Try to delete item setting ");
                                        show_Dialog(
                                            context: context,
                                            title: AppLocalizations.of(context)!
                                                .delete,
                                            message:
                                                AppLocalizations.of(context)!
                                                    .delete_message,
                                            response: ((value) async {
                                              if (value) {
                                                OverlayLoadingProgress.start(
                                                    context);

                                                Log(
                                                    tag: tag,
                                                    message:
                                                        "Delete item setting ");
                                                ItemSettingNb itemSettingNb =
                                                    iTemSettingNbList[index];
                                                await DBProvider.db.deleteObject(
                                                    tableName:
                                                        settingItemNbTableName,
                                                    id: itemSettingNb.itemId);
                                                await addShowObjectToUI();

                                                OverlayLoadingProgress.stop();
                                              }
                                            }));
                                      }),
                                  IconButton(
                                      iconSize: 20,
                                      icon: const Icon(Icons.edit),
                                      onPressed: () async {
                                        Log(
                                            tag: tag,
                                            message:
                                                "Try to edit item setting ");
                                        var itemRes = await DBProvider.db
                                            .getObject(
                                                id: iTemSettingNbList[index]
                                                    .itemId,
                                                tableName: itemTableName);
                                        if (itemRes.isNotEmpty) {
                                          show_Dialog(
                                              context: context,
                                              title:
                                                  AppLocalizations.of(context)!
                                                      .edit,
                                              message:
                                                  AppLocalizations.of(context)!
                                                      .edit_message,
                                              response: ((value) async {
                                                if (value) {
                                                  Log(
                                                      tag: tag,
                                                      message:
                                                          "Edit process started!!! ");
                                                  Item item = Item.fromJson(
                                                      itemRes.first);
                                                  setState(() {
                                                    selectedItem = item;
                                                    itemControl.text =
                                                        item.name;
                                                    countControl.text =
                                                        iTemSettingNbList[index]
                                                            .countLimit
                                                            .toString();
                                                  });
                                                }
                                              }));
                                        }
                                      }),
                                ],
                              ),
                              onTap: () async {},
                            ),
                          ));
                    })),
          ),
        ])));
  }
}
