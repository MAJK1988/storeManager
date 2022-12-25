import 'dart:math';

import 'package:store_manager/dataBase/item_sql.dart';
import 'package:store_manager/dataBase/sql_object.dart';

import '../utils/objects.dart';
import '../utils/utils.dart';
import 'depot_sql.dart';

addNewBillIn(
    {required Bill bill,
    required List<ItemBill> listItemBill,
    required bool isUniqueDepot}) async {
  String tag = "addNewBillIn";
  Log(tag: tag, message: "Activate Function");
  String tableName = billInTableName;
  final db = await DBProvider.db.database;
  //get the biggest id in the table
  List<Map<String, Object?>> table;
  bool tableExist = await DBProvider.db.checkExistTable(tableName: tableName);
  if (!tableExist) {
    Log(tag: tag, message: "table not exist, Try to create table");
    await DBProvider.db
        .creatTable(tableName, bill.createSqlTable(tableName: tableName));
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
    Log(tag: tag, message: "Add new BillItem, id: $i");
    itemBill.billId = id;
    int itemBillId = await addNewBillItem(
      itemBill: itemBill,
      type: billIn,
    );

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
      if (depot.availableCapacity < depot.capacity || isUniqueDepot) {
        ItemsDepot itemsDepot = ItemsDepot(
            id: 0,
            itemId: itemBill.IDItem,
            itemBillId: itemBillId,
            number: itemBill.number,
            billId: id);
        String tableName = depot.depotListItem;
        Log(tag: tag, message: "Add itemsDepot object ");
        await addNewDepotItem(
            itemsDepot: itemsDepot, tableName: tableName, tagMain: tag);

        item.count = item.count + itemBill.number;
        // Update item number
        Log(tag: tag, message: "Update item ${item.name} count");
        await DBProvider.db
            .updateObject(v: item, tableName: itemTableName, id: item.ID);
        // Update depot capacity
        Log(tag: tag, message: "Update depot ${depot.name} availableCapacity");
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

addNewBillOut(
    {required Bill bill,
    required List<ItemBill> listItemOutBill,
    required List<ItemsDepot> listSelectedItemsDepot,
    required List<int> depotItemIndexList,
    required Depot selectedDepot,
    required String tagMain,
    bool devMode = false}) async {
  String tag = "$tagMain/addNewBillOut"; //listItemBill
  Log(tag: tag, message: "Activate Function, : ${listItemOutBill.length}");
  if (devMode) {
    for (int i = 0; i < listItemOutBill.length; i++) {
      Log(
          tag: tag,
          message:
              "Is item depot and bill item have same item id: ${(listItemOutBill[i].IDItem == listSelectedItemsDepot[depotItemIndexList[i]].itemId)}");
    }
    return;
  }

  String tableName = billIOutTableName;
  final db = await DBProvider.db.database;
  //get the biggest id in the table
  List<Map<String, Object?>> table;
  bool tableExist = await DBProvider.db.checkExistTable(tableName: tableName);
  if (!tableExist) {
    Log(tag: tag, message: "table not exist, Try to create table");
    await DBProvider.db
        .creatTable(tableName, bill.createSqlTable(tableName: tableName));
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
  //ItemBill itemBill in listItemBill
  Log(
      tag: tag,
      message: "length of list item bill : ${listItemOutBill.length}");
  for (int i = 0; i < listItemOutBill.length; i++) {
    Log(
        tag: tag,
        message:
            "Is item depot and bill item have same item id: ${(listItemOutBill[i].IDItem == listSelectedItemsDepot[depotItemIndexList[i]].itemId)}");

    var resItem = await DBProvider.db
        .getObject(id: listItemOutBill[i].IDItem, tableName: itemTableName);
    if (resItem.isNotEmpty) {
      Item item = Item.fromJson(resItem.first);

      if (item.count - listItemOutBill[i].number >= 0) {
        Log(
            tag: tag,
            message: "Try to update item number, number is: ${item.count}");
        item.count = item.count - listItemOutBill[i].number;
        Log(tag: tag, message: "Count has been update: ${item.count}");
        // update Item number
        await DBProvider.db
            .updateObject(v: item, tableName: itemTableName, id: item.ID);

        Log(tag: tag, message: "Try to update itemDepot");
        var resItemDepot = await DBProvider.db
            .getObject(id: listItemOutBill[i].depotID, tableName: item.depotID);
        if (resItemDepot.isNotEmpty) {
          ItemDepot itemDepot = ItemDepot.fromJson(resItemDepot.first);
          itemDepot.number = itemDepot.number - listItemOutBill[i].number;
          if (itemDepot.number > 0) {
            Log(tag: tag, message: "Update depot item");
            await DBProvider.db.updateObject(
                v: itemDepot,
                tableName: item.depotID,
                id: listItemOutBill[i].depotID);
          } else {
            Log(tag: tag, message: "delete depot item");
            await DBProvider.db.deleteObject(
                tableName: item.depotID, id: listItemOutBill[i].depotID);
          }
        }

        listItemOutBill[i].billId = id;
        Log(tag: tag, message: "Index is: $id");
        // Add item bill
        Log(tag: tag, message: "Add new bill item");
        ItemBillOut itemBillOut = ItemBillOut(
            id: listItemOutBill[i].id,
            IDItem: listItemOutBill[i].IDItem,
            number: listItemOutBill[i].number,
            productDate: listItemOutBill[i].productDate,
            date: bill.dateTime,
            win: listItemOutBill[i].win,
            price: listItemOutBill[i].price,
            depotID: listItemOutBill[i].depotID,
            billOutId: id,
            billIntId: listSelectedItemsDepot[depotItemIndexList[i]].billId,
            billInItemId:
                listSelectedItemsDepot[depotItemIndexList[i]].itemBillId,
            depotItemId: listSelectedItemsDepot[depotItemIndexList[i]].id);
        int idBillItem =
            await addNewBillOutItem(itemBillOut: itemBillOut, tagIn: tag);
        // update depot item
        Log(
            tag: tag,
            message:
                "Update depot item in table name ${selectedDepot.depotListItem}");
        if (listSelectedItemsDepot[depotItemIndexList[i]].number > 0) {
          await DBProvider.db.updateObject(
              v: listSelectedItemsDepot[depotItemIndexList[i]],
              tableName: selectedDepot.depotListItem,
              id: listSelectedItemsDepot[depotItemIndexList[i]].id);
          await addNewBillOutDepot(
              billOutDepot: BillOutDepot(
                  id: id,
                  billOutId: id,
                  billOutItemId: idBillItem,
                  number: listItemOutBill[i].number,
                  itemDepotId:
                      listSelectedItemsDepot[depotItemIndexList[i]].id),
              tableName: selectedDepot.depotListOutItem);
        } else {
          Log(
              tag: tag,
              message:
                  "Item depot is empty, number item is ${listSelectedItemsDepot[depotItemIndexList[i]].number}. Delete itemDepot!!!");
          await DBProvider.db.deleteObject(
              tableName: selectedDepot.depotListItem,
              id: listSelectedItemsDepot[depotItemIndexList[i]].id);
          var billOutDepotItems = await DBProvider.db.getDepotBillOutItems(
              tableName: selectedDepot.depotListOutItem,
              itemDepotId: listSelectedItemsDepot[depotItemIndexList[i]].id);
          if (billOutDepotItems.isNotEmpty) {
            for (var jsonDepotOut in billOutDepotItems) {
              Log(tag: tag, message: "Delete BillOutDepot!!");
              BillOutDepot billOutDepot = BillOutDepot.fromJson(jsonDepotOut);
              await DBProvider.db.deleteObject(
                  tableName: selectedDepot.depotListOutItem,
                  id: billOutDepot.id);
            }
          }
        }
        //add new BillOutDepot
        Log(
            tag: tag,
            message:
                "App new BillOut Depot item in table name ${selectedDepot.depotListOutItem}");
        selectedDepot.availableCapacity = selectedDepot.availableCapacity -
            listItemOutBill[i].number * item.volume;
        Log(tag: tag, message: "Update depots capacity");
        await DBProvider.db.updateObject(
            v: selectedDepot, tableName: depotTableName, id: selectedDepot.Id);
      }
    }

    // update Item depot
  }
  return raw;
}

addNewBillItem({required ItemBill itemBill, required String type}) async {
  // table name  "itemBills${bill.type}$id"
  Log(tag: "addNewBillItem", message: "Activate Function");
  String tableName =
      (type == billIn ? billInItemTableName : billIOutItemTableName);
  final db = await DBProvider.db.database;
  //get the biggest id in the table
  List<Map<String, Object?>> table;

  bool tableExist = await DBProvider.db.checkExistTable(tableName: tableName);
  if (!tableExist) {
    Log(tag: "addNewItem", message: "table not exist, Try to create table");
    await DBProvider.db
        .creatTable(tableName, itemBill.createSqlTable(tableName: tableName));
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

  table = await db.rawQuery("SELECT MAX(id)+1 as id FROM $tableName");
  Log(tag: "Index is: ", message: id.toString());
  var raw = await db.rawInsert(
      "INSERT Into $tableName (id,IDItem,number, productDate,date,win,price, depotID, billId)"
      " VALUES (?,?,? ,?,?,?,? ,?,? )",
      [
        id,
        itemBill.IDItem,
        itemBill.number,
        itemBill.productDate,
        itemBill.date,
        itemBill.win,
        itemBill.price,
        itemBill.depotID,
        itemBill.billId
      ]);
  return id;
}

addNewBillOutItem(
    {required ItemBillOut itemBillOut, required String tagIn}) async {
  // table name  "itemBills${bill.type}$id"
  String tag = "$tagIn/addNewBillOutItem";
  Log(tag: tag, message: "Activate Function");
  String tableName = billIOutItemTableName;
  final db = await DBProvider.db.database;
  //get the biggest id in the table
  List<Map<String, Object?>> table;

  bool tableExist = await DBProvider.db.checkExistTable(tableName: tableName);
  if (!tableExist) {
    Log(tag: tag, message: "table not exist, Try to create table");
    await DBProvider.db.creatTable(
        tableName, itemBillOut.createSqlTable(tableName: tableName));
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

  table = await db.rawQuery("SELECT MAX(id)+1 as id FROM $tableName");
  Log(tag: tag, message: "Index is: ${id.toString()}");

  var raw = await db.rawInsert(
      "INSERT Into $tableName (id,IDItem,number, productDate,date,win,price, depotID,billIntId,billOutId, billInItemId,depotItemId)"
      " VALUES (?,?,? ,?,?,?,? ,?,?,? ,?,? )",
      [
        id,
        itemBillOut.IDItem,
        itemBillOut.number,
        itemBillOut.productDate,
        itemBillOut.date,
        itemBillOut.win,
        itemBillOut.price,
        itemBillOut.depotID,
        itemBillOut.billIntId,
        itemBillOut.billOutId,
        itemBillOut.billInItemId,
        itemBillOut.depotItemId
      ]);
  return id;
}

addNewBillOutDepot(
    {required BillOutDepot billOutDepot, required String tableName}) async {
  String tag = "addNewBillOutDepot";
  // table name  "itemBills${bill.type}$id"
  Log(tag: tag, message: "Activate Function");
  final db = await DBProvider.db.database;
  //get the biggest id in the table
  List<Map<String, Object?>> table;

  bool tableExist = await DBProvider.db.checkExistTable(tableName: tableName);
  if (!tableExist) {
    Log(tag: "addNewItem", message: "table not exist, Try to create table");
    await DBProvider.db.creatTable(
        tableName, billOutDepot.createSqlTable(tableName: tableName));
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

  Log(tag: tag, message: "Index is:  $id");
  var raw = await db.rawInsert(
      "INSERT Into $tableName (id,billOutId,billOutItemId, number,itemDepotId)"
      " VALUES (?,?,? ,?,?)",
      [
        id,
        billOutDepot.billOutId,
        billOutDepot.billOutItemId,
        billOutDepot.number,
        billOutDepot.itemDepotId
      ]);
  return raw;
}

deleteBillOut({required Bill bill, required String tagMain}) async {
  String tag = " $tagMain/deleteBillOut";
  if (bill.type == billOut) {
    Log(tag: tag, message: "Start function, try to get bill out items");
    var resItemBillOuts = await DBProvider.db.getAllBillItemForUniqueBill(
        tableName: billIOutItemTableName, billId: bill.ID);

    Log(tag: tag, message: "number of bill item: ${resItemBillOuts.length}");
    for (var json in resItemBillOuts) {
      ItemBillOut itemBillOut = ItemBillOut.fromJson(json);
      Log(tag: tag, message: "try to get depot and item");
      var resDepot = await DBProvider.db
          .getObject(id: itemBillOut.depotID, tableName: depotTableName);
      var reItem = await DBProvider.db
          .getObject(id: itemBillOut.IDItem, tableName: itemTableName);
      if (resDepot.isNotEmpty && reItem.isNotEmpty) {
        Item item = Item.fromJson(reItem.first);
        Depot depot = Depot.fromJson(resDepot.first);
        Log(
            tag: tag,
            message:
                "Item name: ${item.name}, depot name: ${depot.name}, try to get depot Item out ");

        var resItemDepotOut = await DBProvider.db.getBillItemOut(
            tableName: depot.depotListOutItem,
            billOutId: bill.ID,
            billOutItemId: itemBillOut.id);
        if (resItemDepotOut.isNotEmpty) {
          Log(tag: tag, message: "Try to get depot DepotBillOutItem ");
          BillOutDepot billOutDepot =
              BillOutDepot.fromJson(resItemDepotOut.first);
          var resItemDepot = await DBProvider.db.getObject(
              tableName: depot.depotListItem, id: billOutDepot.itemDepotId);
          if (resItemDepot.isNotEmpty) {
            ItemsDepot itemDepot = ItemsDepot.fromJson(resItemDepot.first);

            Log(tag: tag, message: "Try to get depot itemDepot ");
            Log(
                tag: tag,
                message: "All object has ready!!! delete BillOutDepot item");
            await DBProvider.db.deleteObject(
                tableName: depot.depotListOutItem, id: billOutDepot.id);
            Log(tag: tag, message: "Delete item bill out");
            await DBProvider.db.deleteObject(
                tableName: billIOutItemTableName, id: itemBillOut.id);
            Log(tag: tag, message: "Update depot available capacity");
            depot.availableCapacity =
                depot.availableCapacity + itemBillOut.number * item.volume;
            await DBProvider.db.updateObject(
                v: depot, tableName: depotTableName, id: depot.Id);
            Log(tag: tag, message: "Update item count");
            item.count = item.count + itemBillOut.number;
            await DBProvider.db
                .updateObject(v: item, tableName: itemTableName, id: item.ID);
            Log(tag: tag, message: "Update item Depot");
            itemDepot.number = itemDepot.number + itemBillOut.number;
            await DBProvider.db.updateObject(
                v: itemDepot, tableName: depot.depotListItem, id: itemDepot.id);
          }
        } else {
          Log(
              tag: tag,
              message:
                  "Item depot is null!! All items have been sold out. Create depot item");
          ItemsDepot itemsDepot = ItemsDepot(
              id: 0,
              itemId: item.ID,
              itemBillId: itemBillOut.billInItemId,
              number: itemBillOut.number,
              billId: itemBillOut.billIntId);
          Log(tag: tag, message: "Add depot item to data base");
          await addNewDepotItem(
              itemsDepot: itemsDepot,
              tableName: depot.depotListItem,
              tagMain: tag);
          Log(tag: tag, message: "Delete item bill out");
          await DBProvider.db.deleteObject(
              tableName: billIOutItemTableName, id: itemBillOut.id);
          Log(tag: tag, message: "Update depot available capacity");
          depot.availableCapacity =
              depot.availableCapacity + itemBillOut.number * item.volume;
          await DBProvider.db
              .updateObject(v: depot, tableName: depotTableName, id: depot.Id);
          Log(tag: tag, message: "Update item count");
          item.count = item.count + itemBillOut.number;
          await DBProvider.db
              .updateObject(v: item, tableName: itemTableName, id: item.ID);
        }
      }
    }
    Log(tag: tag, message: "Delete bill out!!");
    DBProvider.db.deleteObject(tableName: billIOutTableName, id: bill.ID);
  } else {
    Log(tag: tag, message: "bill type is ${bill.type}");
  }
}

deleteBillIn({required Bill bill, required String tagMain}) async {
  String tag = "$tagMain/deleteBillIn";
  if (bill.type == billIn) {
    bool deleteBill = true;
    double totalPrice = 0;
    Log(tag: tag, message: "Start function, try to get bill items");
    var resBillItem = await DBProvider.db.getAllBillItemForUniqueBill(
        tableName: billInItemTableName, billId: bill.ID);
    if (resBillItem.isNotEmpty) {
      for (var json in resBillItem) {
        ItemBill itemBill = ItemBill.fromJson(json);
        Log(tag: tag, message: "try to get depot and item");
        var resItem = await DBProvider.db
            .getObject(tableName: itemTableName, id: itemBill.IDItem);
        var resDepot = await DBProvider.db
            .getObject(id: itemBill.depotID, tableName: depotTableName);
        if (resItem.isNotEmpty && resDepot.isNotEmpty) {
          Item item = Item.fromJson(resItem.first);
          Depot depot = Depot.fromJson(resDepot.first);
          Log(tag: tag, message: "try to get depot item");
          var resDepotItem = await DBProvider.db.getDepotItem(
              tableName: depot.depotListItem,
              billId: bill.ID,
              itemBillId: itemBill.id);
          if (resDepotItem.isNotEmpty) {
            ItemsDepot itemDepot = ItemsDepot.fromJson(resDepotItem.first);
            Log(tag: tag, message: "Try to get bill out depot");
            var resBillOutDepot = await DBProvider.db.getDepotBillOutItems(
                tableName: depot.depotListOutItem, itemDepotId: itemDepot.id);
            if (resBillOutDepot.isNotEmpty) {
              Log(
                  tag: tag,
                  message: "BillOutDepot isn't empty!!!! delete itemDepot");
              deleteBill = false;
              double number = 0;
              for (var jsonOut in resBillOutDepot) {
                BillOutDepot billOutDepot = BillOutDepot.fromJson(jsonOut);
                number = number + billOutDepot.number;
              }
              await DBProvider.db.deleteObject(
                  tableName: depot.depotListItem, id: itemDepot.id);
              Log(tag: tag, message: "Update itemBill $number");
              itemBill.number = number;
              await DBProvider.db.updateObject(
                  v: itemBill, tableName: billInItemTableName, id: itemBill.id);
              Log(tag: tag, message: "Update depot available capacity");
              depot.availableCapacity =
                  depot.availableCapacity - item.volume * itemDepot.number;
              await DBProvider.db.updateObject(
                  v: depot, tableName: depotTableName, id: depot.Id);
              Log(tag: tag, message: "Update Item count");
              item.count = item.count - itemDepot.number;
              await DBProvider.db
                  .updateObject(v: item, tableName: itemTableName, id: item.ID);
              totalPrice = totalPrice + number * itemBill.price;
            } else {
              Log(
                  tag: tag,
                  message: "BillOutDepot is empty!!!! delete itemDepot");
              await DBProvider.db.deleteObject(
                  tableName: depot.depotListItem, id: itemDepot.id);
              Log(tag: tag, message: "delete itemBill");
              await DBProvider.db.deleteObject(
                  tableName: billInItemTableName, id: itemBill.id);
              Log(tag: tag, message: "Update depot available capacity");
              depot.availableCapacity =
                  depot.availableCapacity - item.volume * itemDepot.number;
              await DBProvider.db.updateObject(
                  v: depot, tableName: depotTableName, id: depot.Id);
              Log(tag: tag, message: "Update Item count");
              item.count = item.count - itemDepot.number;
              await DBProvider.db
                  .updateObject(v: item, tableName: itemTableName, id: item.ID);
            }
          } else {
            Log(
                tag: tag,
                message: "Item depot is null!! All items have been sold out");
            deleteBill = false;
            totalPrice = totalPrice + itemBill.number * itemBill.price;
          }
        }
      }
      if (deleteBill) {
        Log(tag: tag, message: "delete bill in!!");
        await DBProvider.db
            .deleteObject(tableName: billInTableName, id: bill.ID);
      } else {
        Log(tag: tag, message: "Update bill in!!");
        bill.totalPrices = totalPrice;
        await DBProvider.db
            .updateObject(v: bill, tableName: billInTableName, id: bill.ID);
      }
    }
  } else {
    Log(tag: tag, message: "Error, bill type is billOut");
  }
}

generateBillIn({required int year, required int month}) async {
  String tag = "generateBillIn";
  Log(tag: tag, message: "Start function");
  int supplierIdMax =
      await DBProvider.db.getMaxId(tableName: supplierTableName);
  if (supplierIdMax >= 0) {
    int supplierId = (Random().nextInt(supplierIdMax));
    var resSupplier = await DBProvider.db
        .getObject(id: supplierId, tableName: supplierTableName);
    if (resSupplier.isNotEmpty) {
      Log(tag: tag, message: "Select supplier");
      Supplier supplier = Supplier.fromJson(resSupplier.first, supplierType);
      int workerIdMax =
          await DBProvider.db.getMaxId(tableName: workerTableName);
      if (workerIdMax >= 0) {
        int workerId = (Random().nextInt(workerIdMax));
        var resWorkerId = await DBProvider.db
            .getObject(id: workerId, tableName: workerTableName);
        if (resWorkerId.isNotEmpty) {
          Log(tag: tag, message: "Select Worker");
          Worker worker = Worker.fromJson(resWorkerId.first);
          String date = createRandomDate(year: year, month: month);
          int itemNumber = (Random().nextInt(10));
          Log(tag: tag, message: "Number of item is: $itemNumber");
          List<ItemBill> listItemBill = [];
          List<Depot> listDepot = [];
          int itemIdMax =
              await DBProvider.db.getMaxId(tableName: itemTableName);
          int depotIdMax =
              await DBProvider.db.getMaxId(tableName: depotTableName);

          if (itemIdMax >= 0 && depotIdMax >= 0) {
            var resDepots =
                await DBProvider.db.getAllObjects(tableName: depotTableName);
            if (resDepots.isNotEmpty) {
              for (var jsonDepot in resDepots) {
                listDepot.add(Depot.fromJson(jsonDepot));
              }
              double totalPrice = 0.0;
              for (int i = 0; i <= itemNumber; i++) {
                int itemId = (Random().nextInt(itemIdMax));
                int depotId = (Random().nextInt(depotIdMax));
                var resItem = await DBProvider.db
                    .getObject(id: itemId, tableName: itemTableName);
                if (resItem.isNotEmpty) {
                  Item item = Item.fromJson(resItem.first);
                  Depot depot = listDepot.elementAt(depotId);

                  double itemNumber = Random().nextDouble() *
                          ((depot.capacity - depot.availableCapacity) /
                              (item.volume * 20)) +
                      1;
                  Log(tag: tag, message: "itemNumber: $itemNumber");
                  if ((depot.availableCapacity + item.volume * itemNumber) <=
                      depot.capacity) {
                    String dateItemBill = createRandomDate(year: 2019);
                    totalPrice = totalPrice + itemNumber * item.actualPrice;
                    Log(
                        tag: tag,
                        message: "Add new item bill, depot: ${depot.name}");

                    depot.availableCapacity =
                        depot.availableCapacity + item.volume + itemNumber;
                    listDepot.remove(listDepot.elementAt(depotId));
                    listDepot.add(depot);
                    listItemBill.add(ItemBill(
                        id: 0,
                        date: date,
                        IDItem: item.ID,
                        number: itemNumber,
                        productDate: dateItemBill,
                        win: item.actualWin * itemNumber,
                        price: item.actualPrice *
                            (1 + item.actualWin) *
                            itemNumber,
                        depotID: depot.Id,
                        billId: 0));
                  }
                }
              }
              if (listItemBill.isNotEmpty) {
                Log(
                    tag: tag,
                    message: "listItemBill isn't null, add new billIn");
                Bill bill = Bill(
                    ID: 0,
                    depotId: "depo",
                    dateTime: date,
                    outsidePersonId: supplier.Id,
                    type: billIn,
                    workerId: worker.Id,
                    itemBills: "",
                    totalPrices: totalPrice);
                await addNewBillIn(
                    bill: bill,
                    listItemBill: listItemBill,
                    isUniqueDepot: false);
              }
            }
          } else {
            Log(
                tag: tag,
                message:
                    "No items in data base? ${itemIdMax >= 0}, No depot in data base? ${depotIdMax >= 0}, ");
          }
        }
      }
    }
  }
}

generateBillOut(
    {required int year, required int month, required int day}) async {
  String tag = "generateBillOut";
  Log(tag: tag, message: "Start function");
  List<Depot> listDepot = await DBProvider.db.getNoEmptyDepots();
  int indexWorkerMax = await DBProvider.db.getMaxId(tableName: workerTableName);
  int indexCustomerMax =
      await DBProvider.db.getMaxId(tableName: customerTableName);
  if (listDepot.isNotEmpty && indexWorkerMax >= 0 && indexCustomerMax >= 0) {
    Log(tag: tag, message: "list depot isn't empty");
    int depotIndexMax = listDepot.length - 1;
    Depot depot = listDepot.elementAt((Random().nextInt(depotIndexMax)));
    Log(tag: tag, message: "get depot!!");
    var varListDepotItem =
        await DBProvider.db.getAllObjects(tableName: depot.depotListItem);
    if (varListDepotItem.isNotEmpty) {
      List<ItemsDepot> listItemDepot = [];
      Log(tag: tag, message: "det item depot!!");
      for (var jsonDepotItem in varListDepotItem) {
        listItemDepot.add(ItemsDepot.fromJson(jsonDepotItem));
      }
      if (listItemDepot.isNotEmpty) {
        Log(
            tag: tag,
            message: "Item depot is not empty ${listItemDepot.length}");
        int depotItemIndexMax = listItemDepot.length - 1;
        int itemBillItemOut = (Random().nextInt(10) + 1);
        List<int> depotItemIndexList = [];
        List<ItemBill> listItemOutBill = [];
        double totalPrice = 0.0;
        String billDate = createRandomDate(year: year, month: month, day: day);
        for (int i = 0; i < itemBillItemOut; i++) {
          int indexItem = (Random().nextInt(depotItemIndexMax));
          ItemsDepot itemsDepot = listItemDepot.elementAt(indexItem);
          var itemBillVar = await DBProvider.db.getObject(
              id: itemsDepot.itemBillId, tableName: billInItemTableName);
          var itemVar = await DBProvider.db
              .getObject(id: itemsDepot.itemId, tableName: itemTableName);
          Log(
              tag: tag,
              message:
                  "test: itemBillVar: ${itemBillVar.isNotEmpty}, itemVar: ${itemVar.isNotEmpty}");
          double itemNumber = Random().nextDouble() * itemsDepot.number;
          if (itemNumber > 0 && itemBillVar.isNotEmpty && itemVar.isNotEmpty) {
            ItemBill itemBill = ItemBill.fromJson(itemBillVar.first);
            Item item = Item.fromJson(itemVar.first);
            depotItemIndexList.add(indexItem);
            Log(tag: tag, message: "Build item bill $i !!");
            listItemOutBill.add(ItemBill(
                id: 0,
                IDItem: itemsDepot.itemId,
                number: itemNumber,
                productDate: itemBill.productDate,
                date: billDate,
                win: item.actualWin * item.actualPrice * itemNumber,
                price: item.actualPrice * itemNumber * (1 + item.actualWin),
                depotID: depot.Id,
                billId: itemsDepot.billId));
            itemsDepot.number = itemsDepot.number - itemNumber;
            listItemDepot[indexItem] = itemsDepot;
            totalPrice = totalPrice +
                itemNumber * (item.actualPrice * (1 + item.actualWin));
          }
        }
        if (listItemOutBill.isNotEmpty) {
          Log(tag: tag, message: "listItemOutBill is not null add bill out");
          await addNewBillOut(
              bill: Bill(
                  ID: 0,
                  depotId: "depot.Id",
                  dateTime: billDate,
                  outsidePersonId: Random().nextInt(indexCustomerMax),
                  type: billOut,
                  workerId: Random().nextInt(indexWorkerMax),
                  itemBills: "",
                  totalPrices: totalPrice),
              listItemOutBill: listItemOutBill,
              listSelectedItemsDepot: listItemDepot,
              depotItemIndexList: depotItemIndexList,
              selectedDepot: depot,
              tagMain: tag);
        }
      }
    }
  } else {
    Log(tag: tag, message: "Depot list is null");
  }
}

generateBillOutMonth({required int month, required year}) async {
  for (int j = 0; j < 30; j++) {
    for (int i = 0; i < (Random().nextInt(15) + 8); i++) {
      await generateBillOut(month: month, year: year, day: j);
    }
  }
}
