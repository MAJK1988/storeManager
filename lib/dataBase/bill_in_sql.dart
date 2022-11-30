import 'package:store_manager/dataBase/item_sql.dart';
import 'package:store_manager/dataBase/sql_object.dart';

import '../utils/objects.dart';
import '../utils/utils.dart';
import 'depot_sql.dart';

addNewBillIn({required Bill bill, required List<ItemBill> listItemBill}) async {
  String tag = "addNewBillIn";
  Log(tag: tag, message: "Activate Function");
  String tableName = BillInTableName;
  final db = await DBProvider.db.database;
  //get the biggest id in the table
  List<Map<String, Object?>> table;

  bool tableExist = await DBProvider.db.checkExistTable(tableName: tableName);
  if (tableExist) {
    table = await db.rawQuery("SELECT MAX(id)+1 as id FROM $tableName");
  } else {
    Log(tag: tag, message: "table not exist, Try to create table");
    await DBProvider.db.creatTable(tableName, bill.createSqlTable());
    addNewBillIn(bill: bill, listItemBill: listItemBill);
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
      "INSERT Into $tableName (id,depotId,dateTime, outsidePersonId,type,workerId, itemBills,totalPrices)"
      " VALUES (?,?,?, ?,?,?, ?,? )",
      [
        id,
        "NewDepotId${bill.type}$id",
        bill.dateTime,
        //
        bill.outsidePersonId,
        bill.type,
        bill.workerId,
        //
        "itemBills$tableName${bill.type}$id",
        bill.totalPrices
      ]);
  int i = 0;
  for (ItemBill itemBill in listItemBill) {
    i = i + 1;
    await addNewBillItem(
        itemBill: itemBill,
        tableName: "itemBills$tableName${bill.type}$id",
        id: i);

    var res = await DBProvider.db
        .getObject(id: itemBill.depotID, tableName: depotTableName);
    var resItem = await DBProvider.db
        .getObject(id: itemBill.IDItem, tableName: itemTableName);
    if (res.isNotEmpty && resItem.isNotEmpty) {
      // Add itemBill to depot
      Depot depot = Depot.fromJson(res.first);
      Item item = Item.fromJson(resItem.first);
      depot.availableCapacity =
          depot.availableCapacity + item.volume * itemBill.number;
      Log(
          tag: tag,
          message:
              "availableCapacity: ${depot.availableCapacity}, capacity: ${depot.capacity}");
      if (depot.availableCapacity < depot.capacity) {
        ItemsDepot itemsDepot = ItemsDepot(
            id: 0,
            itemId: itemBill.IDItem,
            itemBillId: i,
            number: itemBill.number,
            billId: id,
            itemBillIdOut: "");
        String tableName = depot.depotListItem;
        await addNewDepotItem(itemsDepot: itemsDepot, tableName: tableName);

        item.count = item.count + itemBill.number;
        // Update item number
        await DBProvider.db
            .updateObject(v: item, tableName: itemTableName, id: item.ID);
        // Update depot capacity
        await DBProvider.db
            .updateObject(v: depot, tableName: depotTableName, id: depot.Id);

        // update item's depot
        await addNewItemDepot(
            itemDepot: ItemDepot(number: itemBill.number, depotId: depot.Id),
            tableName: item.depotID);
        //Add new supplier to item if it isn't exist
        await addNewItemSupplier(
            itemSupplier: ItemSupplier(supplier: bill.outsidePersonId),
            tableName: item.supplierID);
      }
    }
  }
  return raw;
}

addNewBillItem(
    {required ItemBill itemBill,
    required String tableName,
    required int id}) async {
  // table name  "itemBills${bill.type}$id"
  Log(tag: "addNewBillItem", message: "Activate Function");
  final db = await DBProvider.db.database;
  //get the biggest id in the table
  List<Map<String, Object?>> table;

  bool tableExist = await DBProvider.db.checkExistTable(tableName: tableName);
  if (tableExist) {
    table = await db.rawQuery("SELECT MAX(id)+1 as id FROM $tableName");
  } else {
    Log(tag: "addNewItem", message: "table not exist, Try to create table");
    await DBProvider.db
        .creatTable(tableName, itemBill.createSqlTable(tableName: tableName));
    addNewBillItem(itemBill: itemBill, tableName: tableName, id: id);
    return -1;
  }
  Log(tag: "Index is: ", message: id.toString());
  var raw = await db.rawInsert(
      "INSERT Into $tableName (id,IDItem,number, productDate,win,price, depotID)"
      " VALUES (?,?,? ,?,?,? ,? )",
      [
        id,
        itemBill.IDItem,
        itemBill.number,
        itemBill.productDate,
        itemBill.win,
        itemBill.price,
        itemBill.depotID
      ]);
  return raw;
}
