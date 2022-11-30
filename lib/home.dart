import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:store_manager/AddObject/add_depot.dart';
import 'package:store_manager/AddObject/add_supplier.dart';
import 'package:store_manager/bill/add_bill_in.dart';
import 'package:store_manager/bill/bill_in_manager.dart';
import 'package:store_manager/utils/objects.dart';

import 'lang_provider/language_picker_widget.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.home_page),
        centerTitle: true,
        actions: [
          LanguagePickerWidget(),
          const SizedBox(width: 12),
        ],
      ),
      body: Center(
        child: SizedBox(
          width: size.width / 2,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // Add item
              ListTile(
                leading: const Icon(Icons.precision_manufacturing),
                title: Text(
                  AppLocalizations.of(context)!.add_item,
                  textScaleFactor: 1.5,
                ),
                selected: true,
                onTap: () {
                  Navigator.pushNamed(context, '/AddItem');
                },
              ),
              // Add supplier
              ListTile(
                leading: const Icon(Icons.business_center),
                title: Text(
                  AppLocalizations.of(context)!.add_supplier,
                  textScaleFactor: 1.5,
                ),
                selected: true,
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => AddSupplier(
                          title: AppLocalizations.of(context)!.add_supplier),
                    ),
                  );
                  //Navigator.pushNamed(context, '/AddItem');
                },
              ),
              // Add customer
              ListTile(
                leading: const Icon(Icons.verified_user),
                title: Text(
                  AppLocalizations.of(context)!.add_customer,
                  textScaleFactor: 1.5,
                ),
                selected: true,
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => AddSupplier(
                        title: AppLocalizations.of(context)!.add_customer,
                        type: customerType,
                      ),
                    ),
                  );
                  //Navigator.pushNamed(context, '/AddItem');
                },
              ),
              // Add worker
              ListTile(
                leading: const Icon(Icons.engineering),
                title: Text(
                  AppLocalizations.of(context)!.add_worker,
                  textScaleFactor: 1.5,
                ),
                selected: true,
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => AddSupplier(
                        title: AppLocalizations.of(context)!.add_worker,
                        visible: true,
                      ),
                    ),
                  );
                  //Navigator.pushNamed(context, '/AddItem');
                },
              ),
              // Add Depot
              ListTile(
                leading: const Icon(Icons.business_sharp),
                title: Text(
                  AppLocalizations.of(context)!.add_depot,
                  textScaleFactor: 1.5,
                ),
                selected: true,
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => AddDepot(
                        title: AppLocalizations.of(context)!.add_depot,
                      ),
                    ),
                  );
                  //Navigator.pushNamed(context, '/AddItem');
                },
              ),

              // Add Bill in
              ListTile(
                leading: const Icon(Icons.inventory),
                title: Text(
                  AppLocalizations.of(context)!.bill_receipt,
                  textScaleFactor: 1.5,
                ),
                selected: true,
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const AddBillIn()),
                  );
                  //Navigator.pushNamed(context, '/AddItem');
                },
              ),

              // Add  Bill out
              ListTile(
                leading: const Icon(Icons.inventory),
                title: Text(
                  AppLocalizations.of(context)!.bill_out,
                  textScaleFactor: 1.5,
                ),
                selected: true,
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (context) => const AddBillIn(
                              billType: billOut,
                            )),
                  );
                  //Navigator.pushNamed(context, '/AddItem');
                },
              ),

              // Bill In manager
              ListTile(
                leading: const Icon(Icons.business_sharp),
                title: Text(
                  AppLocalizations.of(context)!.bill_manager,
                  textScaleFactor: 1.5,
                ),
                selected: true,
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const BillInManager(),
                    ),
                  );
                  //Navigator.pushNamed(context, '/AddItem');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
