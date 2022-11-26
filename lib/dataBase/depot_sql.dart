import 'package:store_manager/dataBase/sql_object.dart';

import '../utils/objects.dart';
import '../utils/utils.dart';

addNewDepot({required Depot depot}) async {
  Log(tag: "addNewItem", message: "Activate Function");
  String tableName = depotTableName;
  final db = await DBProvider.db.database;
  //get the biggest id in the table
  List<Map<String, Object?>> table;

  bool tableExist =
      await DBProvider.db.checkExistTable(tableName: tableName, db: db);
  if (tableExist) {
    table = await db.rawQuery("SELECT MAX(id)+1 as id FROM $tableName");
  } else {
    Log(tag: "addNewItem", message: "table not exist, Try to create table");
    await DBProvider.db.creatTable(tableName, depot.createSqlTable());
    addNewDepot(depot: depot);
    return -1;
  }

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
    {required ItemsDepot itemsDepot, required String tableName}) async {
  // table name NewDepotItem$DepotId
  Log(tag: "addNewDepotItem", message: "Activate Function");
  final db = await DBProvider.db.database;
  //get the biggest id in the table
  List<Map<String, Object?>> table;

  bool tableExist =
      await DBProvider.db.checkExistTable(tableName: tableName, db: db);
  if (tableExist) {
    table = await db.rawQuery("SELECT MAX(id)+1 as id FROM $tableName");
  } else {
    Log(tag: "addNewItem", message: "table not exist, Try to create table");
    await DBProvider.db
        .creatTable(tableName, itemsDepot.createSqlTable(tableName: tableName));
    addNewDepotItem(itemsDepot: itemsDepot, tableName: tableName);
    return -1;
  }

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
      "INSERT Into $tableName (id,itemId,itemBillId, number,billId,itemBillIdOut)"
      " VALUES (?,?,? ,?,?,?)",
      [
        id,
        itemsDepot.itemId,
        itemsDepot.itemBillId,
        itemsDepot.number,
        itemsDepot.billId,
        "itemBillIdOut$id${itemsDepot.itemBillId}${itemsDepot.billId}"
      ]);
  return raw;
}
