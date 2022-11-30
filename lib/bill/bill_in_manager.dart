import 'package:flutter/material.dart';
import 'package:store_manager/utils/objects.dart';

import '../dataBase/sql_object.dart';
import '../utils/drop_down_button_new.dart';
import '../utils/utils.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class BillInManager extends StatefulWidget {
  const BillInManager({super.key});

  @override
  State<BillInManager> createState() => _BillInManagerState();
}

class _BillInManagerState extends State<BillInManager> {
  late String searchFor = "Search for";
  late List<Bill> bills = [];
  late List<Worker> works = [];
  late List<Supplier> suppliers = [];
  late List<ShowObject> showObject = [];
  late String tag = "BillInManager";
  @override
  void initState() {
    // TODO: implement initState
    () async {
      Log(tag: tag, message: "read all bill in");
      var res = await DBProvider.db.getAllObjects(tableName: BillInTableName);

      if (res.isNotEmpty) {
        for (var b in res) {
          Bill bill = Bill.fromJson(b);
          //get bill worker
          var resW = await DBProvider.db
              .getObject(id: bill.workerId, tableName: workerTableName);
          //get bill supplier
          var resS = await DBProvider.db.getObject(
              id: bill.outsidePersonId, tableName: supplierTableName);

          if (resS.isNotEmpty && resW.isNotEmpty) {
            setState(() {
              bills.add(bill);
              Supplier s = Supplier.fromJson(resS.first, supplierType);
              Worker w = Worker.fromJson(resW.first);
              suppliers.add(s);
              works.add(w);
              showObject.add(ShowObject(
                  value0: bill.dateTime,
                  value1: s.name,
                  value2: w.name,
                  value3: bill.totalPrices.toStringAsFixed(2)));
            });
          }
        }

        Log(
            tag: tag,
            message:
                "Bill table isn't empty, Bill number is: ${bills.length}, Worker number is: ${works.length},"
                "suppliers number is: ${suppliers.length}");
      } else {
        Log(tag: tag, message: "Bill table is empty");
      }
    }();
    super.initState();
  }

  late List<String> listSearchElement = getElementsBill();
  late String initElementSearch = getElementsBill().first;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.bill_manager),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          children: [
            Row(
              children: [
                Flexible(
                  child: inputElementTable(
                      controller: null,
                      hintText: searchFor,
                      onChang: (value) {},
                      context: context),
                ),
                IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {},
                ),
                DropdownButtonNew(
                    initValue: initElementSearch,
                    flex: 1,
                    items: listSearchElement,
                    icon: Icons.fact_check,
                    onSelect: (value) {
                      if (value!.isNotEmpty) {
                        setState(() {});
                      }
                    }),
              ],
            ),
            Expanded(
                child: Card(
              child: ListView.builder(
                itemCount: showObject.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListTile(
                        leading: Text(
                            '${AppLocalizations.of(context)!.date}: ${showObject[index].value0}'),
                        title: Text(
                            '${AppLocalizations.of(context)!.supplier}: ${showObject[index].value1}'),
                        subtitle: Text(
                            '${AppLocalizations.of(context)!.worker}: ${showObject[index].value2}'),
                        trailing: Text(
                          '${AppLocalizations.of(context)!.price}: ${showObject[index].value3} \$',
                        )),
                  );
                },
              ),
            )),
          ],
        ),
      ),
    );
  }
}
