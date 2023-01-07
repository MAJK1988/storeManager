import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:overlay_loading_progress/overlay_loading_progress.dart';
import 'package:store_manager/dataBase/sql_object.dart';
import 'package:store_manager/utils/objects.dart';

import '../AddObject/add_supplier.dart';
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
  Map<int, String> positionMap = {};
  @override
  void initState() {
    // TODO: implement initState
    setState(() {});
    super.initState();
  }

  late Worker selectedWorker = initWorker();
  bool isSearchWidgetVisible = true, changeColor = false, isWorkerUser = false;
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
                          isWorkerUser = value.userIndex != 0;
                          positionList = [
                            AppLocalizations.of(context)!.director,
                            AppLocalizations.of(context)!.assistant,
                            AppLocalizations.of(context)!.seller
                          ];
                          positionMap = {
                            0: AppLocalizations.of(context)!.worker,
                            1: AppLocalizations.of(context)!.director,
                            2: AppLocalizations.of(context)!.assistant,
                            3: AppLocalizations.of(context)!.seller,
                          };
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
                          // Position
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
                                  setState(() {});
                                })),
                          ),
                          // if worker is user
                          Visibility(
                              visible: isWorkerUser &&
                                  !isSearchWidgetVisible &&
                                  selectedWorker.userIndex != 1,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.all(padding),
                                    child: SizedBox(
                                      height: 30,
                                      width: 150,
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.blue,
                                        ),
                                        onPressed: () async {
                                          setState(() {
                                            selectedWorker.password = "";
                                            selectedWorker.userIndex = 0;
                                          });
                                          await addAccount();
                                        },
                                        child: Text(
                                          AppLocalizations.of(context)!
                                              .delete_account,
                                          style: const TextStyle(fontSize: 16),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(padding),
                                    child: SizedBox(
                                      height: 30,
                                      width: 160,
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.blue,
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            isWorkerUser = false;
                                          });
                                        },
                                        child: Text(
                                          AppLocalizations.of(context)!
                                              .update_account,
                                          style: const TextStyle(fontSize: 16),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              )),
                          //PassWord
                          Visibility(
                            visible: !isWorkerUser && !isSearchWidgetVisible,
                            child: Padding(
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
                          ),
                          //PassWord
                          Visibility(
                            visible: !isWorkerUser && !isSearchWidgetVisible,
                            child: Padding(
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
                          ),
                          Visibility(
                            visible: !isWorkerUser && !isSearchWidgetVisible,
                            child: Row(
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
                                    value: position,
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
                                        position = value!;
                                        Log(
                                            tag: tag,
                                            message: "position: $position");
                                      });
                                    },
                                    items: [
                                      "",
                                      AppLocalizations.of(context)!.assistant,
                                      AppLocalizations.of(context)!.seller,
                                      AppLocalizations.of(context)!.worker
                                    ].map<DropdownMenuItem<String>>(
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
                          ),

                          Visibility(
                            visible: !isWorkerUser && !isSearchWidgetVisible,
                            child: Padding(
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
                                        setState(() {
                                          selectedWorker.password = password;
                                          selectedWorker.userIndex = position ==
                                                  AppLocalizations.of(context)!
                                                      .director
                                              ? 1
                                              : position ==
                                                      AppLocalizations.of(
                                                              context)!
                                                          .assistant
                                                  ? 2
                                                  : position ==
                                                          AppLocalizations.of(
                                                                  context)!
                                                              .seller
                                                      ? 3
                                                      : 0;
                                        });
                                        await addAccount();
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
                          ),
                        ],
                      )),
                )
              ],
            ),
          ),
        ));
  }

  addAccount() async {
    OverlayLoadingProgress.start(context);
    Log(tag: tag, message: "Try to update select worker");

    await DBProvider.db.updateObject(
        v: selectedWorker, tableName: workerTableName, id: selectedWorker.Id);
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
            "Worker ${selectedWorker.name} has been saved, user position: ${selectedWorker.userIndex}");
    OverlayLoadingProgress.stop();
    Navigator.pop(context);
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
          PopupMenuItem<int>(
            value: 1,
            child: Center(
              child: IconButton(
                  color: Colors.blue,
                  iconSize: 20,
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => AddSupplier(
                          title: AppLocalizations.of(context)!.add_worker,
                          type: workerType,
                          visible: true,
                        ),
                      ),
                    );
                  }),
            ),
          ),
        ];
      },
    );
  }
}
