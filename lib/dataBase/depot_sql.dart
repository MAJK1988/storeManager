import 'package:store_manager/dataBase/sql_object.dart';

import '../utils/objects.dart';
import '../utils/utils.dart';

addNewDepot({required Depot depot}) async {
  Log(tag: "addNewItem", message: "Activate Function");
  String tableName = depotTableName;
  final db = await DBProvider.db.database;
  //get the biggest id in the table
  List<Map<String, Object?>> table;

  bool tableExist = await DBProvider.db.checkExistTable(tableName: tableName);
  if (!tableExist) {
    Log(tag: "addNewItem", message: "table not exist, Try to create table");
    await DBProvider.db.creatTable(tableName, depot.createSqlTable());
  }
  table = await db.rawQuery("SELECT MAX(id)+1 as id FROM $tableName");
  int id;
  (table.first['id']).toString();
  // ignore: prefer_is_empty
  (table.first.isEmpty)
      ? id = 0
      : (table.first['id'] == null)
          ? id = 0
          : id = int.parse((table.first['id']).toString());
  //insert to the table using the new id
  Log(tag: "Index is: ", message: id.toString());
  var raw = await db.rawInsert(
      "INSERT Into $tableName (id,name,address, capacity,availableCapacity,billsID, depotListItem )"
      " VALUES (?,?,?,?,?,?,? )",
      [
        id,
        depot.name,
        depot.address,
        //
        depot.capacity,
        depot.availableCapacity,
        "depotBillsID$id",
        //
        "depotListItem$id"
      ]);
  return raw;
}

addNewDepotItem(
    {required ItemsDepot itemsDepot,
    required String tableName,
    required String tagMain}) async {
  // table name NewDepotItem$DepotId
  String tag = "$tagMain/addNewDepotItem";
  Log(tag: tag, message: "Activate Function");
  final db = await DBProvider.db.database;
  //get the biggest id in the table
  List<Map<String, Object?>> table;

  bool tableExist = await DBProvider.db.checkExistTable(tableName: tableName);
  if (!tableExist) {
    Log(tag: tag, message: "table not exist, Try to create table");
    await DBProvider.db
        .creatTable(tableName, itemsDepot.createSqlTable(tableName: tableName));
  }
  table = await db.rawQuery("SELECT MAX(id)+1 as id FROM $tableName");
  int id;
  (table.first['id']).toString();
  // ignore: prefer_is_empty
  (table.first.isEmpty)
      ? id = 0
      : (table.first['id'] == null)
          ? id = 0
          : id = int.parse((table.first['id']).toString());
  //insert to the table using the new id
  Log(tag: tag, message: "Index is: $id");
  var raw = await db.rawInsert(
      "INSERT Into $tableName (id,itemId,itemBillId, number,billId)"
      " VALUES (?,?,? ,?,?)",
      [
        id,
        itemsDepot.itemId,
        itemsDepot.itemBillId,
        itemsDepot.number,
        itemsDepot.billId
      ]);
  return id;
}

String addDayToDate({required String date, int dayNumber = 1}) {
  DateTime dt = DateTime.parse(date);
  var newDate = DateTime(dt.year, dt.month, dt.day + 1);
  return newDate.toString();
}
