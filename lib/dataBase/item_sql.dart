import 'package:store_manager/dataBase/sql_object.dart';

import '../utils/objects.dart';
import '../utils/utils.dart';

addNewItem({required Item item}) async {
  Log(tag: "addNewItem", message: "Activate Function");
  String tableName = itemTableName;
  final db = await DBProvider.db.database;
  //get the biggest id in the table
  List<Map<String, Object?>> table;

  bool tableExist = await DBProvider.db.checkExistTable(tableName: tableName);
  if (!tableExist) {
    Log(tag: "addNewItem", message: "table not exist, Try to create table");
    await DBProvider.db.creatTable(tableName, item.createSqlTable());
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
      "INSERT Into $tableName (id,name,barCode, category,description,soldBy, madeIn,prices,validityPeriod, volume,actualPrice,actualWin, supplierID,customerID,depotID,count)" //, image )"
      " VALUES (?,?,? ,?,?,? ,?,?,? ,?,?,?, ?,?,?,?)",
      [
        id,
        item.name,
        item.barCode,
        //
        item.category,
        item.description,
        item.soldBy,
        //
        item.madeIn,
        "prices$id",
        item.validityPeriod,
        //
        item.volume,
        item.actualPrice,
        item.actualWin,
        //
        "customerID$id",
        "supplierID$id",
        "depotID$id",
        item.count
        //item.image
      ]);
  return raw;
}

addNewItemDepot(
    {required ItemDepot itemDepot, required String tableName}) async {
  // table name: NewItemDepot$ItemID
  // table related to item
  String tag = "addNewItemDepot";
  Log(tag: tag, message: "Activate Function");
  final db = await DBProvider.db.database;
  //get the biggest id in the table
  List<Map<String, Object?>> table;

  bool tableExist = await DBProvider.db.checkExistTable(tableName: tableName);
  if (!tableExist) {
    Log(tag: tag, message: "table not exist, Try to create table");
    await DBProvider.db
        .creatTable(tableName, itemDepot.createSqlTable(tableName: tableName));
  }
  var res = await DBProvider.db
      .getObject(id: itemDepot.depotId, tableName: tableName);
  if (res.isEmpty) {
    // depot not exist
    Log(tag: tag, message: "Add new depot");
    var raw = await db.rawInsert(
        /*late final int number;
  late final int depotId;*/
        "INSERT Into $tableName (id,number )"
        " VALUES (?,?)",
        [itemDepot.depotId, itemDepot.number]);
    return raw;
  } else {
    // depot exist
    Log(tag: tag, message: "depot exist!!!");
    ItemDepot itemDepotUp = ItemDepot.fromJson(res.first);
    if (itemDepotUp.depotId == itemDepot.depotId) {
      itemDepotUp.updateNumber(
          newNumber: itemDepotUp.number + itemDepot.number);
      var up = await DBProvider.db.updateObject(
          v: itemDepotUp, tableName: tableName, id: itemDepotUp.depotId);
      Log(tag: tag, message: "depot has been updated");
    }
    return 0;
  }
}

addNewItemSupplier(
    {required ItemSupplier itemSupplier, required String tableName}) async {
  // table name: NewItemSupplier$ItemID
  // table related to item
  Log(tag: "addNewItemSupplier", message: "Activate Function");
  final db = await DBProvider.db.database;
  bool tableExist = await DBProvider.db.checkExistTable(tableName: tableName);
  if (!tableExist) {
    Log(
        tag: "addNewItemSupplier",
        message: "table not exist, Try to create table");
    await DBProvider.db.creatTable(
        tableName, itemSupplier.createSqlTable(tableName: tableName));
  }
  var res = await DBProvider.db
      .getObject(id: itemSupplier.supplier, tableName: tableName);
  if (!res.isEmpty) {
    Log(tag: "addNewItemSupplier", message: "Supplier isn't exist");
    var raw = await db.rawInsert(
        "INSERT Into $tableName (id )"
        " VALUES (?)",
        [itemSupplier.supplier]);
    return raw;
  }
  Log(tag: "addNewItemSupplier", message: "Supplier is exist");
  return -1;
}
