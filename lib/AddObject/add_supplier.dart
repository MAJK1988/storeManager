import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';

import '../dataBase/sql_object.dart';
import '../utils/objects.dart';
import '../utils/utils.dart';

class AddSupplier extends StatefulWidget {
  final String title;
  final bool visible;
  const AddSupplier({super.key, required this.title, this.visible = false});

  @override
  State<AddSupplier> createState() => _AddSupplierState();
}

class _AddSupplierState extends State<AddSupplier> {
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Center(
              child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // name and address
                Padding(
                  padding: EdgeInsets.only(
                      right: padding, left: padding, bottom: padding),
                  child: Row(
                    children: <Widget>[
                      Flexible(
                        child: inputElementTextFormField(
                            padding: padding,
                            icon: Icons.edit_note,
                            hintText: AppLocalizations.of(context)!.name_text,
                            labelText: AppLocalizations.of(context)!.name,
                            onChanged: ((value) {})),
                      ),
                      Flexible(
                        child: inputElementTextFormField(
                            padding: padding,
                            icon: Icons.location_on,
                            hintText:
                                AppLocalizations.of(context)!.address_text,
                            labelText: AppLocalizations.of(context)!.address,
                            onChanged: ((value) {})),
                      ),
                    ],
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
                            padding: padding,
                            textInputType: TextInputType.phone,
                            icon: Icons.phone,
                            hintText: AppLocalizations.of(context)!.phone_text,
                            labelText: AppLocalizations.of(context)!.phone,
                            onChanged: ((value) {})),
                      ),
                      Flexible(
                        child: inputElementTextFormField(
                            padding: padding,
                            textInputType: TextInputType.emailAddress,
                            icon: Icons.email,
                            hintText: AppLocalizations.of(context)!.email_text,
                            labelText: AppLocalizations.of(context)!.email,
                            onChanged: ((value) {})),
                      ),
                    ],
                  ),
                ),
                // Start and end time
                Visibility(
                  visible: widget.visible,
                  child: Padding(
                    padding: EdgeInsets.only(
                        right: padding, left: padding, bottom: padding),
                    child: Row(
                      children: <Widget>[
                        Flexible(
                          child: inputElementDateFormField(
                              padding: padding,
                              context: context,
                              icon: Icons.date_range,
                              hintText:
                                  AppLocalizations.of(context)!.start_time_text,
                              labelText:
                                  AppLocalizations.of(context)!.start_time,
                              onChanged: ((value) {})),
                        ),
                        Flexible(
                          child: inputElementDateFormField(
                              padding: padding,
                              context: context,
                              icon: Icons.date_range,
                              hintText:
                                  AppLocalizations.of(context)!.end_time_text,
                              labelText: AppLocalizations.of(context)!.end_time,
                              onChanged: ((value) {})),
                        ),
                      ],
                    ),
                  ),
                ),
                // Salary and position => show if visibility is true
                Visibility(
                  visible: widget.visible,
                  child: Padding(
                    padding: EdgeInsets.only(
                        right: padding, left: padding, bottom: padding),
                    child: Row(
                      children: <Widget>[
                        Flexible(
                          child: inputElementTextFormField(
                              padding: padding,
                              textInputType: TextInputType.number,
                              icon: Icons.money_sharp,
                              hintText:
                                  AppLocalizations.of(context)!.salary_text,
                              labelText: AppLocalizations.of(context)!.salary,
                              onChanged: ((value) {})),
                        ),
                        Padding(
                          padding: EdgeInsets.only(right: 2 * padding),
                          child: Text(AppLocalizations.of(context)!.position),
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
                              setState(() {});
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
                        /*// Function that add 10 suppliers to dataBase
                        addSuppliersToDatabase();
                        // Function that add 10 customers to dataBase
                        addSuppliersToDatabase(type: "Customer");
                        // Function that add worker to dataBase
                        addWorkersToDatabase( workersNumber:3);
                        await DBProvider.db
                            .deleteTable(tableName: workerTableName);
                        
                        // addSuppliersToDatabase(type: "Customer");

                        var res = await DBProvider.db.tableHasName(
                            tableName: supplierTableName, name: 'Mahmoud');
                        if (res.isNotEmpty) {
                          Log(
                              tag: "add_supplier",
                              message:
                                  "Search function return value: ${res.length}");

                          for (Map<String, dynamic> sj in res) {
                            Supplier s = Supplier.fromJson(sj, supplierType);

                            Log(
                                tag: "Search result",
                                message: "name: ${s.name}, email: ${s.email} ");

                          }
                        }*/
                        addItemToDatabase(itemNumber: 300);
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
