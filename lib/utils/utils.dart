import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:store_manager/utils/objects.dart';
import 'package:intl/intl.dart';
import 'dart:math';

import '../dataBase/sql_object.dart';

late double padding = 16;
Widget inputElementTextFormField(
    {required double padding,
    int minLine = 1,
    TextInputType textInputType = TextInputType.text,
    required IconData icon,
    required String hintText,
    required String labelText,
    required ValueChanged<String?> onChanged}) {
  return Padding(
    padding: EdgeInsets.all(padding),
    child: TextFormField(
      minLines: minLine,
      maxLines: minLine + 4,
      expands: false,
      keyboardType: textInputType,
      decoration: InputDecoration(
        icon: Icon(icon),
        hintText: hintText,
        labelText: labelText,
      ),
      validator: (value) {
        onChanged(value);
        if (value!.isEmpty) {
          return 'Please enter $hintText';
        }
        return null;
      },
    ),
  );
}

Widget inputElementDateFormField(
    {required double padding,
    int minLine = 1,
    TextInputType textInputType = TextInputType.text,
    required IconData icon,
    required String hintText,
    required String labelText,
    required BuildContext context,
    required ValueChanged<String?> onChanged}) {
  return Padding(
    padding: EdgeInsets.all(padding),
    child: TextFormField(
      minLines: minLine,
      maxLines: minLine + 4,
      expands: false,
      keyboardType: textInputType,
      decoration: InputDecoration(
        icon: Icon(icon),
        hintText: hintText,
        labelText: labelText,
      ),
      onTap: () async {
        DateTime? pickedDate = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(1950),
            //DateTime.now() - not to allow to choose before today.
            lastDate: DateTime(2100));

        if (pickedDate != null) {
          //pickedDate output format => 2021-03-10 00:00:00.000
          String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
          //formatted date output using intl package =>  2021-03-16
          onChanged(formattedDate);
        } else {}
      },
      validator: (value) {
        //onChanged(value);
        if (value!.isEmpty) {
          return 'Please enter $hintText';
        }
        return null;
      },
    ),
  );
}
/** async {
                DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(1950),
                    //DateTime.now() - not to allow to choose before today.
                    lastDate: DateTime(2100));
 
                if (pickedDate != null) {
                  print(
                      pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000
                  String formattedDate =
                      DateFormat('yyyy-MM-dd').format(pickedDate);
                  print(
                      formattedDate); //formatted date output using intl package =>  2021-03-16
                  setState(() {
                    dateInput.text =
                        formattedDate; //set output date to TextField value.
                  });
                } else {}
              } */

/// ****************functions used for build UI bil In**************** */
Widget titleElementTable({required String title}) {
  return Container(
    color: Colors.blueAccent.shade100,
    child: Center(
        child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(title,
          style: const TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 18,
              fontStyle: FontStyle.italic)),
    )),
  );
}

Widget inputElementTable(
    {required ValueChanged<String?> onChanged,
    required BuildContext context,
    TextInputType textInputType = TextInputType.text}) {
  return Center(
    child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextFormField(
          keyboardType: textInputType,
          decoration: const InputDecoration(
            border: UnderlineInputBorder(),
          ),
          validator: (value) {
            onChanged(value);
            if (value!.isEmpty) {
              return AppLocalizations.of(context)!.required;
            }
            return null;
          },
        )),
  );
}

TableRow inputDataBillInTable({required ItemBill itemBillIn}) {
  return TableRow(children: [
    TableCell(child: centreText(text: itemBillIn.productDate)),
    TableCell(child: centreText(text: itemBillIn.IDItem.toString())),
    TableCell(child: centreText(text: itemBillIn.price.toString())),
    TableCell(child: centreText(text: itemBillIn.number.toString())),
    TableCell(
        child: centreText(
            text: (itemBillIn.price * itemBillIn.number).toStringAsFixed(2)))
  ]);
}

Widget centreText(
    {required String text,
    TextStyle textStyle = const TextStyle(
      fontSize: 18,
    )}) {
  return Center(
      child: Padding(
    padding: const EdgeInsets.all(8.0),
    child: Text(
      text,
      style: textStyle,
    ),
  ));
}

void Log({required String tag, required String message}) {
  print(tag + ": " + message);
}
/********************************** */

/*********Developer functions **************/
/*This functions is used only to create database for test 
Functions is used to create item in database like supplier, customer, item ....
*/
addSuppliersToDatabase({String type = ""}) async {
  for (int i = 0;
      i < (type == "" ? nameArray.length : nameArrayCus.length);
      i++) {
    Supplier supplier = Supplier(
        Id: 0,
        registerTime: createRandomDate(),
        name: nameArray.elementAt(i),
        address: addressArray.elementAt(i),
        phoneNumber:
            (Random().nextInt(1000000) + 1000000).toString() + i.toString(),
        email: "email$i@mail.eu",
        type: customerType,
        itemId: "null",
        billId: "null");

    int result = await DBProvider.db
        .addNewSupplier(outSidePerson: supplier, type: supplier.type);
    Log(tag: "addNewSupplier ", message: "$result");
  }
}

addWorkersToDatabase({required int workersNumber}) async {
  Log(tag: "addWorkersToDatabase", message: "Start function");

  for (int i = 0; i < workersNumber; i++) {
    int status = (Random().nextInt(4) + 1);
    Worker worker = Worker(
        Id: 0,
        name: "${nameArray.elementAt(i)}Worker",
        address: "${addressArray.elementAt(i)}worker",
        phoneNumber:
            (Random().nextInt(1000000) + 1000000).toString() + i.toString(),
        email: "emailWorker$i@mail.eu",
        startTime: createRandomDate(),
        endTime: "null",
        status: status,
        salary: status * 100);
    int result = await DBProvider.db.addNewWorker(worker: worker);
    Log(tag: "addWorkersToDatabase", message: "$result");
  }
}

addItemToDatabase({required int itemNumber}) async {
  Log(tag: "addWorkersToDatabase", message: "Start function");
  int status = (Random().nextInt(4) + 1);
  for (int i = 0; i < itemNumber; i++) {
    Item item = Item(
        ID: 0,
        name: "name$i",
        soldBy: "Kg",
        barCode:
            (Random().nextInt(1000000) + 1000000).toString() + i.toString(),
        category: (Random().nextInt(29) + 1).toString(),
        description: "description$i",
        prices: "prices$i",
        validityPeriod: (Random().nextInt(35) + 1),
        volume: Random().nextDouble() * (0.5 - 0.1) + 0.1,
        supplierID: "supplierID$i",
        customerID: "customerID$i",
        count: 0);

    int result = await DBProvider.db.addNewItem(item: item);
    Log(tag: " addItemToDatabase", message: "$result");
  }
}

String createRandomDate() {
  int year = 2010 + Random().nextInt(10);
  int month = Random().nextInt(12);
  int day = Random().nextInt(12);
  int hour = Random().nextInt(23);
  int minute = Random().nextInt(59);

  return ('$year-${month < 10 ? "0$month" : month}-${day < 10 ? "0$day" : day} – ${hour < 10 ? "0$hour" : hour}:${minute < 10 ? "0$minute" : minute}');
}