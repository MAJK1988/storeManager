import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:store_manager/AddObject/add_depot.dart';
import 'package:store_manager/AddObject/add_supplier.dart';
import 'package:store_manager/bill/add_bill_in.dart';
import 'package:store_manager/bill/bill_in_manager.dart';
import 'package:store_manager/dataBase/search_column.dart';
import 'package:store_manager/utils/objects.dart';
import 'package:store_manager/utils/utils.dart';

import 'lang_provider/language_picker_widget.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
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
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Center(
              child: SizedBox(
                width: size.width * 0.95,
                child: const Padding(
                  padding: EdgeInsets.only(top: 40, bottom: 50),
                  child: Card(child: SearchColumnSTF()),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Add item
                homeCard(
                    icon: Icons.precision_manufacturing,
                    height: height,
                    onClicked: (value) {
                      Navigator.pushNamed(context, '/AddItem');
                    },
                    text: AppLocalizations.of(context)!.add_item,
                    width: width),
                // Add supplier
                homeCard(
                    icon: Icons.business_center,
                    height: height,
                    onClicked: (value) {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => AddSupplier(
                              title:
                                  AppLocalizations.of(context)!.add_supplier),
                        ),
                      );
                    },
                    text: AppLocalizations.of(context)!.add_supplier,
                    width: width),
                // Add customer
                homeCard(
                    icon: Icons.verified_user,
                    height: height,
                    onClicked: (value) {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => AddSupplier(
                            title: AppLocalizations.of(context)!.add_customer,
                            type: customerType,
                          ),
                        ),
                      );
                    },
                    text: AppLocalizations.of(context)!.add_customer,
                    width: width),
              ],
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
                            builder: (context) => const AddBillIn()),
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
                          builder: (context) => const BillInManager(
                            typeBill: billOut,
                          ),
                        ),
                      );
                    },
                    text: AppLocalizations.of(context)!.bill_manager,
                    width: 1.5 * (width + 8)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

Padding homeCard(
    {required double height,
    required double width,
    required String text,
    required IconData icon,
    required ValueChanged<String?> onClicked}) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: Colors.blue.shade100,
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
