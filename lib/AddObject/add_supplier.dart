import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';

import '../dataBase/sql_object.dart';
import '../utils/objects.dart';
import '../utils/utils.dart';

class AddSupplier extends StatefulWidget {
  final String title;
  final String type;
  final bool visible;
  const AddSupplier(
      {super.key,
      required this.title,
      this.visible = false,
      this.type = supplierType});

  @override
  State<AddSupplier> createState() => _AddSupplierState();
}

class _AddSupplierState extends State<AddSupplier> {
  TextEditingController registerDate = TextEditingController(),
      startDateControl = TextEditingController(),
      endDateControl = TextEditingController(),
      nameControl = TextEditingController(),
      phoneControl = TextEditingController(),
      emailControl = TextEditingController(),
      addressControl = TextEditingController(),
      salaryControl = TextEditingController(),
      positionControl = TextEditingController(); //Salary and position

  late String tag = "AddSupplier";
  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    // TODO: implement initState
    tag = "$tag/${widget.type}";
    super.initState();
  }

  late String registerTime = "",
      name = "",
      phoneNumber = "",
      email = "",
      address = "",
      startDate = "",
      endDate = "";
  late double salary = 0;
  int status = 0;
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
                // register date and name
                Padding(
                  padding: EdgeInsets.only(
                      right: padding, left: padding, bottom: padding),
                  child: Row(
                    children: <Widget>[
                      Flexible(
                        child: inputElementDateFormField(
                            controller: registerDate,
                            context: context,
                            padding: padding,
                            icon: Icons.date_range,
                            hintText: AppLocalizations.of(context)!.date,
                            labelText: AppLocalizations.of(context)!.date,
                            onChanged: ((value) {
                              Log(tag: tag, message: "String date: $value");
                              setState(() {
                                registerDate.text = value!;
                                registerTime = value;
                              });
                            })),
                      ),
                      Flexible(
                        child: inputElementTextFormField(
                            controller: nameControl,
                            padding: padding,
                            icon: Icons.edit_note,
                            hintText: AppLocalizations.of(context)!.name_text,
                            labelText: AppLocalizations.of(context)!.name,
                            onChanged: ((value) {
                              setState(() {
                                name = value!;
                              });
                            })),
                        /**/
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
                            controller: phoneControl,
                            padding: padding,
                            textInputType: TextInputType.phone,
                            icon: Icons.phone,
                            hintText: AppLocalizations.of(context)!.phone_text,
                            labelText: AppLocalizations.of(context)!.phone,
                            onChanged: ((value) {
                              setState(() {
                                phoneNumber = value!;
                              });
                            })),
                      ),
                      Flexible(
                        child: inputElementTextFormField(
                            controller: emailControl,
                            padding: padding,
                            textInputType: TextInputType.emailAddress,
                            icon: Icons.email,
                            hintText: AppLocalizations.of(context)!.email_text,
                            labelText: AppLocalizations.of(context)!.email,
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
                              controller: startDateControl,
                              padding: padding,
                              context: context,
                              icon: Icons.date_range,
                              hintText:
                                  AppLocalizations.of(context)!.start_time_text,
                              labelText:
                                  AppLocalizations.of(context)!.start_time,
                              onChanged: ((value) {
                                Log(tag: tag, message: "start time: $value");
                                setState(() {
                                  startDateControl.text = value!;
                                  startDate = value;
                                });
                              })),
                        ),
                        Flexible(
                          child: inputElementDateFormField(
                              hasValidate: false,
                              controller: endDateControl,
                              padding: padding,
                              context: context,
                              icon: Icons.date_range,
                              hintText:
                                  AppLocalizations.of(context)!.end_time_text,
                              labelText: AppLocalizations.of(context)!.end_time,
                              onChanged: ((value) {
                                Log(tag: tag, message: "end time: $value");
                                setState(() {
                                  endDateControl.text = value!;
                                  endDate = value;
                                });
                              })),
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
                              controller: salaryControl,
                              padding: padding,
                              textInputType: TextInputType.number,
                              icon: Icons.money_sharp,
                              hintText:
                                  AppLocalizations.of(context)!.salary_text,
                              labelText: AppLocalizations.of(context)!.salary,
                              onChanged: ((value) {
                                Log(tag: tag, message: "salary: $value");
                                setState(() {
                                  salary = double.parse(value!);
                                });
                              })),
                        ),
                        Padding(
                          padding: EdgeInsets.only(right: 2 * padding),
                          child: Text(AppLocalizations.of(context)!.position),
                        ),
                        Flexible(
                          child: DropdownButton<String>(
                            value: "1",
                            icon: const Icon(Icons.arrow_downward),
                            elevation: 16,
                            style: const TextStyle(color: Colors.deepPurple),
                            underline: Container(
                              height: 2,
                              color: Colors.deepPurpleAccent,
                            ),
                            onChanged: (String? value) {
                              // This is called when the user selects an item.
                              setState(() {
                                status = int.parse(value!);
                              });
                            },
                            items: ["1", "2", "3"]
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
                        if (_formKey.currentState!.validate()) {
                          Log(tag: tag, message: "Form is validate");
                          if (widget.type == supplierType ||
                              widget.type == customerType) {
                            // add supplier or customer to dataBase
                            bool hasEmail = await DBProvider.db.tableHasObject(
                                element: "email",
                                searchFor: email,
                                tableName: (widget.type == supplierType
                                    ? supplierTableName
                                    : customerTableName));
                            bool hasPhoneNumber = await DBProvider.db
                                .tableHasObject(
                                    element: "phoneNumber",
                                    searchFor: phoneNumber,
                                    tableName: (widget.type == supplierType
                                        ? supplierTableName
                                        : customerTableName));
                            if (!(hasPhoneNumber || hasEmail)) {
                              Supplier supplier = Supplier(
                                  Id: 0,
                                  registerTime: registerTime,
                                  name: name,
                                  address: address,
                                  phoneNumber: phoneNumber,
                                  email: email,
                                  type: widget.type,
                                  itemId: " ",
                                  billId: "");
                              int result = await DBProvider.db.addNewSupplier(
                                  outSidePerson: supplier, type: supplier.type);

                              Log(
                                  tag: tag,
                                  message:
                                      "add supplier to Database result: $result");
                              setState(() {
                                addressControl.text = "";
                                emailControl.text = "";
                                phoneControl.text = "";
                                startDateControl.text = "";
                                endDateControl.text = "";
                                registerDate.text = "";
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
                          } else {
                            bool hasEmail = await DBProvider.db.tableHasObject(
                                element: "email",
                                searchFor: email,
                                tableName: workerTableName);
                            bool hasPhoneNumber = await DBProvider.db
                                .tableHasObject(
                                    element: "phoneNumber",
                                    searchFor: phoneNumber,
                                    tableName: workerTableName);
                            if (!(hasPhoneNumber || hasEmail)) {
                              Worker worker = Worker(
                                  Id: 0,
                                  name: name,
                                  address: address,
                                  phoneNumber: phoneNumber,
                                  email: email,
                                  startTime: startDate,
                                  endTime: endDate,
                                  status: status,
                                  salary: salary);
                              int result = await DBProvider.db
                                  .addNewWorker(worker: worker);

                              Log(
                                  tag: tag,
                                  message:
                                      "add worker to Database result: $result");
                              setState(() {
                                addressControl.text = "";
                                emailControl.text = "";
                                phoneControl.text = "";
                                startDateControl.text = "";
                                endDateControl.text = "";
                                registerDate.text = "";
                                nameControl.text = "";
                                startDateControl.text = "";
                                endDateControl.text = "";
                                salaryControl.text = "";
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
                        }
                        // Function that add 10 suppliers to dataBase
                        //addSuppliersToDatabase();
                        // Function that add 10 customers to dataBase
                        //addSuppliersToDatabase(type: "Customer");
                        // Function that add worker to dataBase
                        //addWorkersToDatabase(workersNumber: 3);
                        // Function that add depot to dataBase
                        //addDepotToDatabase(depotNumber: 3);
                        // Function that add 300 item
                        addItemToDatabase(itemNumber: 30);

                        /*List<Item> items = await DBProvider.db.getAllItems();
                        for (Item item in items) {
                          Log(tag: "Get Item name", message: item.name);
                        }
                        List<Supplier> suppliers = await DBProvider.db
                            .getAllSupplier(type: customerType);
                        for (Supplier supplier in suppliers) {
                          Log(
                              tag: "Get Item name ${supplier.type}",
                              message: supplier.name);
                        }
                        List<Worker> workers =
                            await DBProvider.db.getAllWorkers();
                        for (Worker worker in workers) {
                          Log(tag: "Get Item name ", message: worker.name);
                        }
                        var res = await DBProvider.db.tableBetweenDates(
                            tableName: customerTableName,
                            element: "registerTime");
                        Log(
                            tag: "Check search ",
                            message: "res isn't null? : ${res.isNotEmpty}");
                        if (res.isNotEmpty) {
                          List<Supplier> objects = (res.isNotEmpty
                              ? (res.isNotEmpty
                                  ? res
                                      .map<Supplier>((depot) =>
                                          Supplier.fromJson(
                                              depot, customerType))
                                      .toList()
                                  : [])
                              : []) as List<Supplier>;

                          for (Supplier object in objects) {
                            Log(
                                tag: "Get object name ",
                                message: object.registerTime);
                          }
                        }*/
                        /* DBProvider.db.deleteTable(tableName: itemTableName);
                        DBProvider.db.deleteTable(tableName: supplierTableName);
                        DBProvider.db.deleteTable(tableName: depotTableName);*/
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
