import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:store_manager/utils/objects.dart';

import '../dataBase/sql_object.dart';
import '../utils/utils.dart';

class AddDepot extends StatefulWidget {
  final String title;
  const AddDepot({super.key, required this.title});

  @override
  State<AddDepot> createState() => _AddDepotState();
}

class _AddDepotState extends State<AddDepot> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController nameControl = TextEditingController(),
      capacityControl = TextEditingController(),
      addressControl = TextEditingController();

  late String tag = "AddSupplier", name = "", address = "";
  late double capacity = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          centerTitle: true,
        ),
        body: Center(
          child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Row(
                    children: <Widget>[
                      Flexible(
                        child: inputElementTextFormField(
                            controller: nameControl,
                            padding: padding,
                            icon: Icons.edit_note,
                            hintText: AppLocalizations.of(context)!.name_text,
                            labelText: AppLocalizations.of(context)!.name,
                            onChanged: ((value) {
                              Log(tag: tag, message: "String date: $value");
                              setState(() {
                                name = value!;
                              });
                            })),
                      ),
                      Flexible(
                        child: inputElementTextFormField(
                            controller: capacityControl,
                            textInputType: TextInputType.number,
                            padding: padding,
                            icon: Icons.crop_square,
                            hintText:
                                AppLocalizations.of(context)!.capacity_text,
                            labelText: AppLocalizations.of(context)!.capacity,
                            onChanged: ((value) {
                              setState(() {
                                capacity = double.parse(value!);
                              });
                            })),
                        /**/
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: inputElementTextFormField(
                        controller: addressControl,
                        padding: padding,
                        icon: Icons.location_on,
                        hintText: AppLocalizations.of(context)!.address_text,
                        labelText: AppLocalizations.of(context)!.address,
                        onChanged: ((value) {
                          setState(() {
                            address = value!;
                          });
                        })),
                  ),
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
                          if (_formKey.currentState!.validate()) {
                            Log(tag: tag, message: "Form is validate");

                            // add depot to dataBase

                            bool hasName = await DBProvider.db.tableHasObject(
                                element: "name",
                                searchFor: name,
                                tableName: depotTableName);
                            if (!(hasName)) {
                              Depot depot = Depot(
                                  Id: 0,
                                  address: address,
                                  name: name,
                                  capacity: capacity,
                                  availableCapacity: 0,
                                  billsID: " ",
                                  depotListItem: " ");
                              int result =
                                  await DBProvider.db.addNewDepot(depot: depot);

                              Log(
                                  tag: tag,
                                  message:
                                      "add supplier to Database result: $result");
                              setState(() {
                                addressControl.text = "";
                                capacityControl.text = "";
                                nameControl.text = "";
                              });
                              // ignore: use_build_context_synchronously
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                      content: Text(
                                // ignore: use_build_context_synchronously
                                AppLocalizations.of(context)!.object_add,
                              )));
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
              )),
        ));
  }
}
