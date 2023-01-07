import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:store_manager/AddObject/add_depot.dart';
import 'package:store_manager/AddObject/add_item.dart';
import 'package:store_manager/AddObject/add_supplier.dart';
import 'package:store_manager/bill/add_bill_in.dart';
import 'package:store_manager/bill/bill_in_manager.dart';
import 'package:store_manager/dataBase/search_column.dart';
import 'package:store_manager/dataBase/sql_object.dart';
import 'package:store_manager/report/report.dart';
import 'package:store_manager/report/report_element.dart';
import 'package:store_manager/setting/setting.dart';
import 'package:store_manager/utils/objects.dart';
import 'package:store_manager/utils/utils.dart';

import 'add_bill_unique_store/bill_unique_store_in.dart';
import 'auth/Screens/Login/login_screen.dart';
import 'lang_provider/language_picker_widget.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Visibility getCommand({required bool visibility}) {
    return Visibility(
      visible: visibility,
      child: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Add item
            homeIcon(
              icon: Icons.add,
              onClicked: (value) {
                if (isVisibleItem) {
                  Navigator.pushNamed(context, '/AddItem');
                } else if (isVisibleSupplier) {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => AddSupplier(
                          title: AppLocalizations.of(context)!.add_supplier),
                    ),
                  );
                } else if (isVisibleCustomer) {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => AddSupplier(
                        title: AppLocalizations.of(context)!.add_customer,
                        type: customerType,
                      ),
                    ),
                  );
                } else if (isVisibleWorker) {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => AddSupplier(
                        title: AppLocalizations.of(context)!.add_worker,
                        visible: true,
                        type: workerType,
                      ),
                    ),
                  );
                } else if (isDepotVisible) {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => AddDepot(
                        title: AppLocalizations.of(context)!.add_depot,
                      ),
                    ),
                  );
                }
                setState(() {
                  isVisibleCustomer = false;
                  isVisibleSupplier = false;
                  isVisibleItem = false;
                  isVisibleWorker = false;
                  isDepotVisible = false;
                });
              },
            ),

            // Edit object
            homeIcon(
              icon: Icons.edit,
              onClicked: (value) {
                setState(() {
                  isSearchVisible = true;

                  if (isVisibleItem) {
                    initObjectSearch = "Item";
                  } else if (isVisibleSupplier) {
                    initObjectSearch = supplierType;
                  } else if (isVisibleCustomer) {
                    initObjectSearch = customerType;
                  } else if (isVisibleWorker) {
                    initObjectSearch = workerType;
                  } else if (isDepotVisible) {
                    initObjectSearch = depotType;
                  } else {
                    initObjectSearch = "";
                  }

                  isVisibleCustomer = false;
                  isVisibleSupplier = false;
                  isVisibleItem = false;
                  isVisibleWorker = false;
                  isDepotVisible = false;
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  late bool isVisibleItem = false,
      isVisibleSupplier = false,
      isVisibleWorker = false,
      isVisibleCustomer = false,
      isSearchVisible = false,
      isDepotVisible = false;
  late String tag = "Home", initObjectSearch = "";
  late double width = 0, height = 0;
  late Worker user = initWorker();

  List<AlarmObject> alarmObjectList = [];
  getAlarmList() async {
    var resItemSettingNB =
        await DBProvider.db.getAllObjects(tableName: settingItemNbTableName);
    Log(tag: tag, message: "Activate getAlarmList function");
    if (resItemSettingNB.isNotEmpty) {
      for (var jsonSettingNB in resItemSettingNB) {
        ItemSettingNb itemSettingNb = ItemSettingNb.fromJson(jsonSettingNB);
        var resItem = await DBProvider.db
            .getObject(id: itemSettingNb.itemId, tableName: itemTableName);
        if (resItem.isNotEmpty) {
          Item item = Item.fromJson(resItem.first);
          Log(tag: tag, message: "Check ${item.name}");
          if (item.count < itemSettingNb.countLimit) {
            Log(
                tag: tag,
                message:
                    "${item.name}: count: ${item.count} <=> countLimit: ${itemSettingNb.countLimit}");
            setState(() {
              alarmObjectList.add(AlarmObject(
                  message:
                      '${item.name}: ${item.count} <=> ${itemSettingNb.countLimit}',
                  item: item));
            });
          }
        }
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    () async {
      Log(tag: tag, message: "init");
      SharedPreferences _pref = await SharedPreferences.getInstance();
      String? email = _pref.getString("email");
      Log(tag: tag, message: "email: $email");
      if (email!.isNotEmpty) {
        var userRes = await DBProvider.db.getObjectByElement(
            tableName: workerTableName, value: email, element: "email");
        if (userRes.isNotEmpty) {
          Log(tag: tag, message: "Worker exist");
          setState(() {
            user = Worker.fromJson(userRes.first);
            if (user.userIndex == 1) {
              getAlarmList();
            }
          });
        }
      }
    }();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
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
          title: Text(AppLocalizations.of(context)!.home_page),
          centerTitle: true,
          actions: [
            Visibility(
                visible: alarmObjectList.isNotEmpty, child: popMenuAction())
          ],
        ),
        drawer: Drawer(
          child: ListView(
            // Important: Remove any padding from the ListView.
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: const BoxDecoration(
                  color: Colors.blue,
                ),
                child:
                    Text("${AppLocalizations.of(context)!.name}: ${user.name}"),
              ),
              Visibility(
                visible: user.userIndex == 1 || user.userIndex == 2,
                child: ListTile(
                  leading: const Icon(
                    Icons.settings,
                  ),
                  title: Text(AppLocalizations.of(context)!.settings),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const SettingWidget(),
                      ),
                    );
                  },
                ),
              ),
              ListTile(
                leading: const Icon(
                  Icons.logout,
                ),
                title: Text(AppLocalizations.of(context)!.log_out),
                onTap: () async {
                  await logOut(context: context);
                },
              ),
            ],
          ),
        ),
        body: SingleChildScrollView(
          child: Wrap(
            children: <Widget>[
              Visibility(
                visible: isSearchVisible,
                child: Center(
                  child: SizedBox(
                    width: size.width * 0.95,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 40, bottom: 30),
                      child: Card(
                          child: SearchColumnSTF(
                        initObjectSearch: initObjectSearch,
                        size: size,
                        getElement: (value) {
                          Log(tag: tag, message: "value: $value");
                          setState(() {
                            isSearchVisible = false;
                          });
                          sendToUpdateObjectClass(object: value);
                        },
                      )),
                    ),
                  ),
                ),
              ),
              // item, Supplier and customer
              Visibility(
                visible: user.userIndex == 1,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Add item
                    Column(
                      children: [
                        homeCard(
                            isCliked: isVisibleItem,
                            icon: Icons.precision_manufacturing,
                            height: height,
                            onClicked: (value) {
                              setState(() {
                                isVisibleItem = !isVisibleItem;
                                isVisibleSupplier = false;
                                isVisibleCustomer = false;
                                isVisibleWorker = false;
                                if (isSearchVisible) {
                                  isSearchVisible = !isSearchVisible;
                                }
                              });
                            },
                            text: AppLocalizations.of(context)!.item,
                            width: width),
                        getCommand(visibility: isVisibleItem)
                      ],
                    ),
                    // Add supplier
                    Column(
                      children: [
                        homeCard(
                            isCliked: isVisibleSupplier,
                            icon: Icons.business_center,
                            height: height,
                            onClicked: (value) {
                              setState(() {
                                isVisibleItem = false;
                                isVisibleSupplier = !isVisibleSupplier;
                                isVisibleCustomer = false;
                                isVisibleWorker = false;
                                isDepotVisible = false;
                                if (isSearchVisible) {
                                  isSearchVisible = !isSearchVisible;
                                }
                              });
                            },
                            text: AppLocalizations.of(context)!.supplier,
                            width: width),
                        getCommand(visibility: isVisibleSupplier)
                      ],
                    ),
                    // Add customer
                    Column(
                      children: [
                        homeCard(
                            isCliked: isVisibleCustomer,
                            icon: Icons.verified_user,
                            height: height,
                            onClicked: (value) {
                              setState(() {
                                isVisibleItem = false;
                                isVisibleSupplier = false;
                                isDepotVisible = false;
                                isVisibleWorker = false;
                                isVisibleCustomer = !isVisibleCustomer;
                                if (isSearchVisible) {
                                  isSearchVisible = !isSearchVisible;
                                }
                              });
                            },
                            text: AppLocalizations.of(context)!.customer,
                            width: width),
                        getCommand(visibility: isVisibleCustomer)
                      ],
                    ),
                  ],
                ),
              ),
              //worker
              Visibility(
                visible: user.userIndex == 1,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Add worker
                    Column(
                      children: [
                        homeCard(
                            icon: Icons.engineering,
                            height: height,
                            onClicked: (value) {
                              setState(() {
                                isVisibleItem = false;
                                isVisibleSupplier = false;
                                isVisibleCustomer = false;
                                isDepotVisible = false;

                                isVisibleWorker = !isVisibleWorker;
                                if (isSearchVisible) {
                                  isSearchVisible = !isSearchVisible;
                                }
                              });
                            },
                            text: AppLocalizations.of(context)!.add_worker,
                            width: 1.5 * (width + 8)),
                        getCommand(visibility: isVisibleWorker)
                      ],
                    ),
                    // Add depot
                    Column(
                      children: [
                        homeCard(
                            icon: Icons.business_sharp,
                            height: height,
                            onClicked: (value) {
                              setState(() {
                                isVisibleItem = false;
                                isVisibleSupplier = false;
                                isVisibleCustomer = false;
                                isDepotVisible = !isDepotVisible;

                                isVisibleWorker = false;
                                if (isSearchVisible) {
                                  isSearchVisible = !isSearchVisible;
                                }
                              });
                              /*Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => AddDepot(
                                    title: AppLocalizations.of(context)!.add_depot,
                                  ),
                                ),
                              );*/
                            },
                            text: AppLocalizations.of(context)!.add_depot,
                            width: 1.5 * (width + 8)),
                        getCommand(visibility: isDepotVisible)
                      ],
                    ),
                  ],
                ),
              ),
              //Bill In/Out
              Visibility(
                visible: user.userIndex > 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Add Bill in
                    homeCard(
                        icon: Icons.inventory,
                        height: height,
                        onClicked: (value) {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (context) =>
                                    BillUniqStoreIn(worker: user) //AddBillIn()
                                ),
                          );
                        },
                        text: AppLocalizations.of(context)!.bill_receipt,
                        width: 1.5 * (width + 8)),
                    // Add  Bill out
                    homeCard(
                        icon: Icons.inventory,
                        height: height,
                        onClicked: (value) {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (context) => //const BillUniqStoreIn()
                                    BillUniqStoreIn(
                                      billType: billOut,
                                      worker: user,
                                    )),
                          );
                        },
                        text: AppLocalizations.of(context)!.bill_out,
                        width: 1.5 * (width + 8)),
                  ],
                ),
              ),

              //Bill manager In/out
              Visibility(
                visible: user.userIndex == 1,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Bill In manager in
                    homeCard(
                        icon: Icons.input_sharp,
                        height: height,
                        onClicked: (value) {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const BillInManager(
                                typeBill: billIn,
                              ),
                            ),
                          );
                        },
                        text: AppLocalizations.of(context)!.bill_manager,
                        width: 1.5 * (width + 8)),
                    // Bill In manager Out
                    homeCard(
                        icon: Icons.output_rounded,
                        height: height,
                        onClicked: (value) {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const BillInManager(
                                typeBill: billOut,
                              ), //const Report(),
                            ),
                          );
                        },
                        text: AppLocalizations.of(context)!.bill_manager,
                        width: 1.5 * (width + 8)),
                  ],
                ),
              ),
            ],
          ),
        ));
  }

  PopupMenuButton<String> popMenuAction() {
    return PopupMenuButton<String>(
        icon: const Icon(
          Icons.notification_important_outlined,
          color: Colors.red,
        ),
        itemBuilder: (context) => alarmObjectList
            .map((e) => PopupMenuItem<String>(
                  value: "1",
                  child: TextButton(
                      //Handle button press event
                      onPressed: () {
                        Log(tag: tag, message: "PopupMenuItem call billIn");

                        //alarmList.remove(e);
                        Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (context) => BillUniqStoreIn(
                                    item: e.item,
                                    worker: user,
                                  ) //AddBillIn()
                              ),
                        );
                      },
                      //Contents of the button
                      child: Text(
                        e.message,
                        style: const TextStyle(color: Colors.red),
                      )),
                ))
            .toList());
  }

  void sendToUpdateObjectClass({required dynamic object}) {
    if (object is Item) {
      Navigator.of(context).push(
        MaterialPageRoute(
            builder: (context) => AddItem(
                  item: object,
                )),
      );
    } else if (object is Supplier) {
      if (initObjectSearch == supplierType) {
        Log(
            tag: tag,
            message:
                "Object is $supplierType, type: $initObjectSearch, name: ${object.name}");
        Navigator.of(context).push(
          MaterialPageRoute(
              builder: (context) => AddSupplier(
                  supplier: object,
                  title: AppLocalizations.of(context)!.add_supplier)),
        );
      } else {
        Log(
            tag: tag,
            message: "Object is $supplierType, type: $initObjectSearch");
        Navigator.of(context).push(
          MaterialPageRoute(
              builder: (context) => AddSupplier(
                  supplier: object,
                  type: customerType,
                  title: AppLocalizations.of(context)!.add_customer)),
        );
      }
    } else if (object is Worker) {
      Log(tag: tag, message: "Object is $workerType");
      Navigator.of(context).push(
        MaterialPageRoute(
            builder: (context) => AddSupplier(
                worker: object,
                type: workerType,
                visible: true,
                title: AppLocalizations.of(context)!.add_worker)),
      );
    } else if (object is Depot) {
      Log(tag: tag, message: "Object is $depotType");
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => AddDepot(
            depot: object,
            title: AppLocalizations.of(context)!.add_depot,
          ),
        ),
      );
    }
  }
}

Padding homeCard(
    {required double height,
    required double width,
    required String text,
    required IconData icon,
    required ValueChanged<String?> onClicked,
    bool isCliked = false}) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: !isCliked ? Colors.blue.shade100 : Colors.blue.shade200,
        borderRadius: BorderRadius.circular(8),
      ),
      // Add item
      child: Center(
        child: ListTile(
          leading: Icon(icon),
          title: Text(
            text,
            textScaleFactor: 0.9,
          ),
          selected: true,
          onTap: () {
            onClicked("");
          },
        ),
      ),
    ),
  );
}

Padding homeIcon(
    {required IconData icon, required ValueChanged<String?> onClicked}) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Container(
      decoration: BoxDecoration(
        color: Colors.blue.shade500,
        borderRadius: BorderRadius.circular(8),
      ),
      // Add item
      child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: IconButton(
              onPressed: () {
                onClicked("");
              },
              icon: Icon(icon))),
    ),
  );
}
