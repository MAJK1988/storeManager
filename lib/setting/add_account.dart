import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:overlay_loading_progress/overlay_loading_progress.dart';
import 'package:store_manager/dataBase/sql_object.dart';
import 'package:store_manager/utils/objects.dart';

import '../dataBase/search_column.dart';
import '../utils/utils.dart';

class AddAccount extends StatefulWidget {
  const AddAccount({super.key});

  @override
  State<AddAccount> createState() => _AddAccountState();
}

class _AddAccountState extends State<AddAccount> {
  TextEditingController nameControl = TextEditingController(),
      phoneControl = TextEditingController(),
      emailControl = TextEditingController(),
      passWordControl = TextEditingController(),
      passWord1Control = TextEditingController(),
      addressControl = TextEditingController();
  late String name = "",
      phoneNumber = "",
      email = "",
      address = '',
      password = "",
      password1 = "",
      position = "";
  final String tag = "AddAccount";
  List<String> positionList = [""];
  @override
  void initState() {
    // TODO: implement initState
    setState(() {});
    super.initState();
  }

  late Worker selectedWorker = initWorker();
  bool isSearchWidgetVisible = true, changeColor = false;
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.add_account),
          actions: [popMenuAction()],
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                Visibility(
                  visible: isSearchWidgetVisible,
                  child: SearchColumnSTF(
                    billType: billIn,
                    initObjectSearch: workerType,
                    size: Size(size.width * 0.9, size.height * 0.9),
                    getElement: (value) {
                      Log(tag: tag, message: "value: $value");
                      if (value is Worker) {
                        Log(tag: tag, message: "get new Worker");
                        setState(() {
                          selectedWorker = value;
                          nameControl.text = value.name;
                          emailControl.text = value.email;
                          phoneControl.text = value.phoneNumber;
                          addressControl.text = value.address;
                          isSearchWidgetVisible = false;
                          positionList = [
                            AppLocalizations.of(context)!.director,
                            AppLocalizations.of(context)!.assistant,
                            AppLocalizations.of(context)!.seller
                          ];
                        });
                      }
                    },
                  ),
                ),
                Visibility(
                  visible: !isSearchWidgetVisible,
                  child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          //  name
                          Padding(
                            padding: EdgeInsets.only(
                                right: padding, left: padding, bottom: padding),
                            child: Flexible(
                              child: inputElementTextFormField(
                                  controller: nameControl,
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
                          ),
                          // phone email
                          Padding(
                            padding: EdgeInsets.only(
                                right: padding, left: padding, bottom: padding),
                            child: Row(
                              children: <Widget>[
                                Flexible(
                                  child: inputElementTextFormField(
                                      readOnly: true,
                                      controller: phoneControl,
                                      padding: padding,
                                      textInputType: TextInputType.phone,
                                      icon: Icons.phone,
                                      hintText: AppLocalizations.of(context)!
                                          .phone_text,
                                      labelText:
                                          AppLocalizations.of(context)!.phone,
                                      onChanged: ((value) {
                                        setState(() {
                                          phoneNumber = value!;
                                        });
                                      })),
                                ),
                                Flexible(
                                  child: inputElementTextFormField(
                                      readOnly: true,
                                      controller: emailControl,
                                      padding: padding,
                                      textInputType: TextInputType.emailAddress,
                                      icon: Icons.email,
                                      hintText: AppLocalizations.of(context)!
                                          .email_text,
                                      labelText:
                                          AppLocalizations.of(context)!.email,
                                      onChanged: ((value) {
                                        setState(() {
                                          email = value!;
                                        });
                                      })),
                                ),
                              ],
                            ),
                          ),
                          // address
                          Padding(
                            padding: const EdgeInsets.all(8),
                            child: inputElementTextFormField(
                                readOnly: true,
                                controller: addressControl,
                                padding: padding,
                                icon: Icons.location_on,
                                hintText:
                                    AppLocalizations.of(context)!.address_text,
                                labelText:
                                    AppLocalizations.of(context)!.address,
                                onChanged: ((value) {
                                  setState(() {
                                    address = value!;
                                  });
                                })),
                          ),
                          //PassWord
                          Padding(
                            padding: const EdgeInsets.all(8),
                            child: inputElementTextFormField(
                                controller: passWordControl,
                                padding: padding,
                                icon: Icons.password,
                                hintText:
                                    AppLocalizations.of(context)!.password,
                                labelText:
                                    AppLocalizations.of(context)!.password,
                                onChanged: ((value) {
                                  setState(() {
                                    password = value!;
                                  });
                                })),
                          ),
                          //PassWord
                          Padding(
                            padding: const EdgeInsets.all(8),
                            child: inputElementTextFormField(
                                controller: passWord1Control,
                                padding: padding,
                                icon: Icons.password,
                                hintText:
                                    AppLocalizations.of(context)!.password1,
                                labelText:
                                    AppLocalizations.of(context)!.password1,
                                onChanged: ((value) {
                                  setState(() {
                                    password1 = value!;
                                  });
                                })),
                          ),
                          Row(
                            children: [
                              Padding(
                                padding: EdgeInsets.only(left: padding),
                                child: Text(
                                  '${AppLocalizations.of(context)!.position}: ',
                                  style: TextStyle(
                                      fontWeight: FontWeight.normal,
                                      color: changeColor ? Colors.red : null),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: padding),
                                child: DropdownButton<String>(
                                  dropdownColor:
                                      changeColor ? Colors.red : null,
                                  value: positionList.first,
                                  icon: const Icon(Icons.arrow_downward),
                                  elevation: 16,
                                  style:
                                      const TextStyle(color: Colors.deepPurple),
                                  underline: Container(
                                    height: 2,
                                    color: Colors.deepPurpleAccent,
                                  ),
                                  onChanged: (String? value) {
                                    // This is called when the user selects an item.
                                    setState(() {
                                      position = value!;
                                    });
                                  },
                                  items: positionList
                                      .map<DropdownMenuItem<String>>(
                                          (String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                ),
                              )
                            ],
                          ),

                          Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: SizedBox(
                              height: 30,
                              width: 250,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue,
                                ),
                                onPressed: () async {
                                  if (_formKey.currentState!.validate()) {
                                    if (selectedWorker != initWorker() &&
                                        password == password1 &&
                                        position != "") {
                                      OverlayLoadingProgress.start(context);
                                      Log(
                                          tag: tag,
                                          message:
                                              "Try to update select worker");
                                      selectedWorker.password = password;
                                      selectedWorker.userIndex = position ==
                                              AppLocalizations.of(context)!
                                                  .director
                                          ? 1
                                          : position ==
                                                  AppLocalizations.of(context)!
                                                      .assistant
                                              ? 1
                                              : 2;

                                      await DBProvider.db.updateObject(
                                          v: selectedWorker,
                                          tableName: workerTableName,
                                          id: selectedWorker.Id);
                                      setState(() {
                                        isSearchWidgetVisible = true;
                                        selectedWorker = initWorker();
                                        nameControl.text = "";
                                        emailControl.text = "";
                                        phoneControl.text = "";
                                        addressControl.text = "";
                                      });
                                      Log(
                                          tag: tag,
                                          message:
                                              "Worker ${selectedWorker.name} has been saved");
                                      OverlayLoadingProgress.stop();
                                      Navigator.pop(context);
                                    } else if (position == "") {
                                      setState(() {
                                        changeColor = true;
                                      });
                                    } else {
                                      Log(
                                          tag: tag,
                                          message:
                                              "Passwords aren't equal or it's empty");
                                    }
                                  } else if (position == "") {
                                    setState(() {
                                      changeColor = true;
                                    });
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
                      )),
                )
              ],
            ),
          ),
        ));
  }

  popMenuAction() {
    return PopupMenuButton(
      // add icon, by default "3 dot" icon
      // icon: Icon(Icons.book)
      itemBuilder: (context) {
        return [
          PopupMenuItem<int>(
            value: 1,
            child: Center(
              child: IconButton(
                  color: Colors.blue,
                  iconSize: 20,
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    setState(() {
                      isSearchWidgetVisible = true;
                      selectedWorker = initWorker();
                      nameControl.text = "";
                      emailControl.text = "";
                      phoneControl.text = "";
                      addressControl.text = "";
                    });
                  }),
            ),
          ),
        ];
      },
    );
  }
}
