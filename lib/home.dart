import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:store_manager/AddObject/add_depot.dart';
import 'package:store_manager/AddObject/add_supplier.dart';
import 'package:store_manager/bill/add_bill_in.dart';
import 'package:store_manager/bill/bill_in_manager.dart';
import 'package:store_manager/dataBase/search_column.dart';
import 'package:store_manager/report/report.dart';
import 'package:store_manager/report/report_element.dart';
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
  logOut() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      pref.setString("email", "");
      pref.setString("password", "");
    });

    Navigator.pushReplacement<void, void>(
      context,
      MaterialPageRoute<void>(
        builder: (BuildContext context) => const LoginScreenApp(),
      ),
    );
  }

  late bool isVisibleItem = false,
      isVisibleSupplier = false,
      isVisibleCustomer = false;
  late String tag = "Home";
  late double width = 0, height = 0;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    Log(
        tag: tag,
        message: " size width: ${size.width}, size height: ${size.height}");
    if (size.width < 700 && size.width > 420) {
      width = 120;
      height = 70;
    } else if (size.width < 420 && size.width > 295) {
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
            LanguagePickerWidget(),
            const SizedBox(width: 12),
          ],
        ),
        drawer: Drawer(
          child: ListView(
            // Important: Remove any padding from the ListView.
            padding: EdgeInsets.zero,
            children: [
              const DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.blue,
                ),
                child: Text('Drawer Header'),
              ),
              ListTile(
                leading: const Icon(
                  Icons.home,
                ),
                title: const Text('Page 1'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.train,
                ),
                title: const Text('Page 2'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.logout,
                ),
                title: const Text('Log out'),
                onTap: () async {
                  await logOut();
                },
              ),
            ],
          ),
        ),
        body: SingleChildScrollView(
          child: Wrap(
            children: <Widget>[
              Center(
                child: SizedBox(
                  width: size.width * 0.95,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 40, bottom: 30),
                    child: Card(
                        child: SearchColumnSTF(
                      size: size,
                      getElement: (value) {
                        Log(tag: tag, message: "value: $value");
                        Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (context) =>
                                  ReportElement(element: value, tableName: "")),
                        );
                      },
                    )),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Add item
                  homeCard(
                      isCliked: isVisibleItem,
                      icon: Icons.precision_manufacturing,
                      height: height,
                      onClicked: (value) {
                        setState(() {
                          isVisibleItem = !isVisibleItem;
                          isVisibleSupplier = false;
                          isVisibleCustomer = false;
                        });
                      },
                      text: AppLocalizations.of(context)!.item,
                      width: width),
                  // Add supplier
                  homeCard(
                      isCliked: isVisibleSupplier,
                      icon: Icons.business_center,
                      height: height,
                      onClicked: (value) {
                        setState(() {
                          isVisibleItem = false;
                          isVisibleSupplier = !isVisibleSupplier;
                          isVisibleCustomer = false;
                        });
                      },
                      text: AppLocalizations.of(context)!.supplier,
                      width: width),
                  // Add customer
                  homeCard(
                      isCliked: isVisibleCustomer,
                      icon: Icons.verified_user,
                      height: height,
                      onClicked: (value) {
                        setState(() {
                          isVisibleItem = false;
                          isVisibleSupplier = false;
                          isVisibleCustomer = !isVisibleCustomer;
                        });
                      },
                      text: AppLocalizations.of(context)!.customer,
                      width: width),
                ],
              ),
              //Item list
              Visibility(
                visible:
                    isVisibleItem || isVisibleSupplier || isVisibleCustomer,
                child: Row(
                  mainAxisAlignment: isVisibleItem
                      ? MainAxisAlignment.start
                      : isVisibleSupplier
                          ? MainAxisAlignment.center
                          : MainAxisAlignment.end,
                  children: [
                    // Add item
                    homeIcon(
                      icon: Icons.add,
                      onClicked: (value) {
                        if (isVisibleItem) {
                          setState(() {
                            isVisibleItem = !isVisibleItem;
                          });

                          Navigator.pushNamed(context, '/AddItem');
                        } else if (isVisibleSupplier) {
                          setState(() {
                            isVisibleSupplier = !isVisibleSupplier;
                          });

                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => AddSupplier(
                                  title: AppLocalizations.of(context)!
                                      .add_supplier),
                            ),
                          );
                        } else if (isVisibleCustomer) {
                          setState(() {
                            isVisibleCustomer = !isVisibleCustomer;
                          });

                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => AddSupplier(
                                title:
                                    AppLocalizations.of(context)!.add_customer,
                                type: customerType,
                              ),
                            ),
                          );
                        }
                      },
                    ),

                    // Edit object
                    homeIcon(
                      icon: Icons.edit,
                      onClicked: (value) {},
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Add worker
                  homeCard(
                      icon: Icons.engineering,
                      height: height,
                      onClicked: (value) {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => AddSupplier(
                              title: AppLocalizations.of(context)!.add_worker,
                              visible: true,
                            ),
                          ),
                        );
                      },
                      text: AppLocalizations.of(context)!.add_worker,
                      width: 1.5 * (width + 8)),
                  // Add depot
                  homeCard(
                      icon: Icons.business_sharp,
                      height: height,
                      onClicked: (value) {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => AddDepot(
                              title: AppLocalizations.of(context)!.add_depot,
                            ),
                          ),
                        );
                      },
                      text: AppLocalizations.of(context)!.add_depot,
                      width: 1.5 * (width + 8)),
                ],
              ),
              Row(
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
                                  const BillUniqStoreIn() //AddBillIn()
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
                              builder: (context) => const AddBillIn(
                                    billType: billOut,
                                  )),
                        );
                      },
                      text: AppLocalizations.of(context)!.bill_out,
                      width: 1.5 * (width + 8)),
                ],
              ),

              // Add  Bill out
              Row(
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
                            builder: (context) => const Report(),
                          ),
                        );
                      },
                      text: AppLocalizations.of(context)!.bill_manager,
                      width: 1.5 * (width + 8)),
                ],
              ),
            ],
          ),
        ));
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
