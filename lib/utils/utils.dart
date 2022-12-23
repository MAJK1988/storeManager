import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:store_manager/utils/objects.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'dart:math';

import '../dataBase/item_sql.dart';
import '../dataBase/sql_object.dart';

late double padding = 16;
const kPrimaryColor = Color(0xFF1565C0);
const kPrimaryLightColor = Color(0xFFF1E6FF);
Widget inputElementTextFormField(
    {required double padding,
    int minLine = 1,
    TextInputType textInputType = TextInputType.text,
    required IconData icon,
    required String hintText,
    required String labelText,
    TextEditingController? controller = null,
    bool hasValidate = true,
    required ValueChanged<String?> onChanged}) {
  return Padding(
    padding: EdgeInsets.all(padding),
    child: TextFormField(
      controller: controller,
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
        if (hasValidate) {
          if (value!.isEmpty || !isNumeric(value, textInputType)) {
            return 'Please enter $hintText';
          } else {
            onChanged(value);
          }
        }
        return null;
      },
    ),
  );
}

bool isNumeric(String s, TextInputType textInputType) {
  if (textInputType == TextInputType.text) {
    return true;
  }
  if (s == null) {
    return false;
  }
  if (textInputType == TextInputType.number) {
    return double.tryParse(s) != null;
  }
  if (textInputType == TextInputType.emailAddress) {
    return RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(s);
  }

  return true;
}

Widget inputElementDateFormField(
    {double padding = 8,
    int minLine = 1,
    TextInputType textInputType = TextInputType.text,
    bool hasValidate = true,
    IconData icon = Icons.date_range,
    String hintText = "",
    String labelText = "",
    required BuildContext context,
    required TextEditingController? controller,
    required ValueChanged<String?> onChanged}) {
  return Padding(
    padding: EdgeInsets.all(padding),
    child: TextFormField(
      controller: controller,
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
        if (hasValidate) {
          if (value!.isEmpty) {
            return 'Please enter $hintText';
          }
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
    {required ValueChanged<String?> onChang,
    ValueChanged<int>? ontap,
    required BuildContext context,
    required TextEditingController? controller,
    String hintText = "",
    bool needValidation = true,
    TextInputType textInputType = TextInputType.text}) {
  return Center(
      child: Padding(
    padding: const EdgeInsets.all(8.0),
    child: TextFormField(
        onTap: () {
          if (ontap != null) {
            ontap(0);
          }
        },
        controller: controller,
        keyboardType: textInputType,
        decoration: InputDecoration(
            border: const UnderlineInputBorder(
              borderSide: BorderSide(),
            ),
            hintText: hintText),
        validator: (value) {
          if (value!.isEmpty && needValidation) {
            return AppLocalizations.of(context)!.required;
          }
          return null;
        },
        onChanged: (value) {
          onChang(value);
        }),
  ));
}

TableRow inputDataBillInTable(
    {required ShowObject showObject,
    required ValueChanged<int> delete,
    required int index,
    required String type}) {
  String tag = "inputDataBillInTable";
  bool visible = true;
  if (type == billIn) {
    Log(tag: tag, message: "Show row data for input bill");
    return TableRow(children: [
      TableCell(child: centreText(text: showObject.value0)), // name item
      TableCell(child: centreText(text: showObject.value1)), //number
      TableCell(child: centreText(text: showObject.value2)), //Production price
      TableCell(child: centreText(text: showObject.value3)), //Price
      TableCell(child: centreText(text: showObject.value4)), //Depot name
      Stack(children: [
        TableCell(
            child: centreText(text: showObject.value5)), // total price of item
        Positioned(
          top: 0,
          right: 0,
          child: IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                delete(index);
                Log(tag: tag, message: "delete object index: $index ");
              }),
        ),
      ])
    ]);
  } else {
    Log(tag: tag, message: "Show row data for out bill");
    return TableRow(children: [
      TableCell(child: centreText(text: showObject.value0)), // name item
      TableCell(child: centreText(text: showObject.value1)), //number
      TableCell(child: centreText(text: showObject.value2)), //Production price
      TableCell(child: centreText(text: showObject.value3)), //Price
      Stack(children: [
        TableCell(child: centreText(text: showObject.value5)),
        Positioned(
          top: 0,
          right: 0,
          child: IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                delete(index);
                Log(tag: tag, message: "delete object index: $index ");
              }),
        ),
      ])
    ]);
  }
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
  print("$tag  :   $message");
}
/********************************** */

/*********Developer functions **************/
/*This functions is used only to create database for test 
Functions is used to create item in database like supplier, customer, item ....
*/
addSuppliersToDatabase({String type = ""}) async {
  String tag = "addNewSupplier";
  for (int i = 0;
      i < (type == "" ? nameArray.length : nameArrayCus.length);
      i++) {
    Supplier supplier = Supplier(
        Id: 0,
        registerTime: createRandomDate(),
        name: type == "" ? "SupplierName$i" : "Customer$i",
        address: addressArray[i],
        phoneNumber:
            (Random().nextInt(1000000) + 1000000).toString() + i.toString(),
        email: "email$i${((Random().nextInt(35) + 1))}@mail.eu",
        type: type == "" ? supplierType : customerType,
        itemId: "null",
        billId: "null");

    int result = await DBProvider.db
        .addNewSupplier(outSidePerson: supplier, type: supplier.type);
    if (result == -1) {
      await DBProvider.db
          .addNewSupplier(outSidePerson: supplier, type: supplier.type);
    }
    Log(tag: tag, message: "object index $i");
  }
}

addWorkersToDatabase({required int workersNumber}) async {
  String tag = "addWorker";
  Log(tag: tag, message: "Start function");

  for (int i = 0; i < workersNumber; i++) {
    int status = (Random().nextInt(4) + 1);
    Worker worker = Worker(
        Id: 0,
        name: "WorkerName$i",
        password: "password$i",
        address: "${addressArray.elementAt(i)}worker",
        phoneNumber:
            (Random().nextInt(1000000) + 1000000).toString() + i.toString(),
        email: "emailWorker$i$status@mail.eu",
        startTime: createRandomDate(),
        endTime: "null",
        status: status,
        salary: status * 100);
    int result = await DBProvider.db.addNewWorker(worker: worker);
    if (result == -1) {
      await DBProvider.db.addNewWorker(worker: worker);
    }
    Log(tag: tag, message: "object index $i");
  }
}

addItemToDatabase({required int itemNumber}) async {
  Log(tag: "addWorkersToDatabase", message: "Start function");
  int status = (Random().nextInt(4) + 1);
  for (int i = 0; i < itemNumber; i++) {
    Item item = Item(
      ID: 0,
      name: "ItemName$i",
      soldBy: ((Random().nextInt(35) + 1) > 16) ? "Kg" : "unit",
      madeIn: ((Random().nextInt(35) + 1) > 16) ? "China" : "France",
      barCode: (Random().nextInt(1000000) + 1000000).toString() + i.toString(),
      category: (Random().nextInt(29) + 1).toString(),
      description: "description$i",
      prices: "prices$i",
      actualPrice: Random().nextDouble() * (20 - 0.1) + 0.1,
      actualWin: Random().nextDouble() * (0.2 - 0.1) + 0.1,
      validityPeriod: (Random().nextInt(35) + 1),
      volume: Random().nextDouble() * (0.2 - 0.01) + 0.01,
      supplierID: "supplierID$i",
      customerID: "customerID$i",
      depotID: "depotID$i",
      count: 0,
      //image: ""
    );

    int result = await addNewItem(item: item);
    if (result == -1) {
      await addNewItem(item: item);
    }
    Log(tag: " addItemToDatabase", message: "$result");
  }
}

addDepotToDatabase({required int depotNumber}) async {
  String tag = "addDepot";
  Log(tag: tag, message: "Start function");
  for (int i = 0; i < depotNumber; i++) {
    Depot depot = Depot(
        Id: 0,
        name: "DepotName$i",
        address: "adrress$i",
        capacity: Random().nextDouble() * (150 - 100) + 100,
        availableCapacity: 0,
        billsID: "",
        depotListItem: "",
        depotListOutItem: ""

        // soldBy: ((Random().nextInt(35) + 1) > 16) ? "Kg" : "unit",
        );

    int result = await DBProvider.db.addNewDepot(depot: depot);
    if (result == -1) {
      DBProvider.db.addNewDepot(depot: depot);
    }
    Log(tag: tag, message: "object index $i");
  }
}

String createRandomDate(
    {int year = 0, int month = 0, int day = 0, int hour = 0, int minute = 0}) {
  (year == 0) ? year = 2010 + Random().nextInt(10) : year = year;
  (month == 0) ? month = Random().nextInt(12) : month = month;
  (day == 0) ? day = Random().nextInt(12) : day = day;
  (hour == 0) ? hour = Random().nextInt(23) : hour = hour;
  (minute == 0) ? minute = Random().nextInt(59) : minute = minute;

  return ('$year-${month < 10 ? "0$month" : month}-${day < 10 ? "0$day" : day} – ${hour < 10 ? "0$hour" : hour}:${minute < 10 ? "0$minute" : minute}');
}

/** Plot functions */
Visibility getCircularChart(
    {required double width,
    required String title,
    required List<ChartData> data,
    required String xTitle,
    required String yTitle,
    required TooltipBehavior tooltipBehavior,
    bool showColumnSeries = true}) {
  return Visibility(
    visible: data.isNotEmpty,
    child: Center(
        child: Padding(
      padding: const EdgeInsets.all(10.0),
      child: SizedBox(
          width: width,
          child: SfCircularChart(
              borderWidth: 2.0,
              borderColor: Colors.blue,
              title: ChartTitle(
                  text: title,
                  // Aligns the chart title to left
                  alignment: ChartAlignment.center,
                  textStyle: const TextStyle(
                    color: Color.fromARGB(255, 72, 73, 75),
                    fontFamily: 'Roboto',
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  )),
              // Enables the tooltip for all the series in chart
              tooltipBehavior: tooltipBehavior,
              series: [
                // Initialize line series
                PieSeries<ChartData, String>(
                    // Enables the tooltip for individual series
                    enableTooltip: true,
                    animationDuration: 4000,
                    dataSource: data,
                    xValueMapper: (ChartData data, _) => data.x,
                    yValueMapper: (ChartData data, _) => data.y)
              ])),
    )),
  );
}

SizedBox reportIcon(
    {required String title, required String data, required IconData iconData}) {
  return SizedBox(
    width: 225,
    height: 100,
    child: Center(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListTile(
            leading: Icon(
              iconData,
              color: Colors.blue,
              size: 56,
            ),
            title: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(title,
                  style: TextStyle(
                      color: Colors.blue.shade900,
                      fontFamily: 'Roboto',
                      fontSize: 16,
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.bold)),
            ),
            subtitle: Text(data,
                style: const TextStyle(
                    color: Colors.blue,
                    fontFamily: 'Roboto',
                    fontSize: 18,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.w300)),
            isThreeLine: true,
          ),
        ),
      ),
    ),
  );
}

Align analyseSectionTitle({required String title}) {
  return Align(
    alignment: Alignment.centerLeft,
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        child: SizedBox(
          width: 150,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(title,
                style: TextStyle(
                    color: Colors.blue.shade900,
                    fontFamily: 'Roboto',
                    fontSize: 16,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.bold)),
          ),
        ),
      ),
    ),
  );
}

Visibility getChart(
    {required double width,
    required String title,
    required List<ChartData> data,
    required String xTitle,
    required String yTitle,
    required TooltipBehavior tooltipBehavior,
    bool showColumnSeries = true}) {
  return Visibility(
    visible: data.isNotEmpty,
    child: Center(
      child: SizedBox(
        width: width,
        child: SfCartesianChart(
            title: ChartTitle(
                text: title,
                //backgroundColor: Colors.lightGreen,
                //borderColor: Colors.blue,
                // borderWidth: 2,
                // Aligns the chart title to left
                alignment: ChartAlignment.center,
                textStyle: const TextStyle(
                  color: Color.fromARGB(255, 72, 73, 75),
                  fontFamily: 'Roboto',
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                )),
            primaryXAxis: CategoryAxis(),
            tooltipBehavior: tooltipBehavior,
            series: <CartesianSeries>[
              // Render column prices
              showColumnSeries
                  ? ColumnSeries<ChartData, String>(
                      enableTooltip: true,
                      animationDuration: 2000,
                      animationDelay: 100,
                      dataSource: data,
                      xValueMapper: (ChartData data, _) => data.x,
                      yValueMapper: (ChartData data, _) => data.y)
                  : ColumnSeries<ChartData, String>(
                      enableTooltip: true,
                      dataSource: <ChartData>[],
                      xValueMapper: (ChartData data, _) => data.x,
                      yValueMapper: (ChartData data, _) => data.y),
              LineSeries<ChartData, String>(
                  animationDuration: 4500,
                  animationDelay: 100,
                  dataSource: data,
                  xValueMapper: (ChartData data, _) => data.x,
                  yValueMapper: (ChartData data, _) => data.y),
            ]),
      ),
    ),
  );
}
