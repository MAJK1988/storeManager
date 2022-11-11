import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:store_manager/utils/objects.dart';

import '../utils/utils.dart';

class DBProvider {
  final String _databaseName = "Store.db";
  final int _databaseVersion = 1;
  DBProvider._();

  static final DBProvider db = DBProvider._();

  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    // if _database is null we instantiate it
    _database = await initDB();
    return _database!;
  }

  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(path,
        version: _databaseVersion,
        onOpen: (db) {},
        onCreate: (Database db, int version) {});
  }

  Future creatTable(String tableName, String query) async {
    int count = -1;
    Database db = await database;
    try {
      count = Sqflite.firstIntValue(
          await db.rawQuery('SELECT COUNT(*) FROM $tableName'))!;
    } catch (e) {}

    if (count < 0) {
      await db.execute(query).then((value) {
        Log(
            tag: "creatTable $tableName",
            message: "$tableName table has been created");
      }).catchError((e) {
        Log(tag: "error in creatTable $tableName: ", message: "$e");
      });
    } else {
      Log(tag: "creatTable $tableName", message: "$tableName is exist");
    }
  }

  addNewSupplier(
      {required Supplier outSidePerson, required String type}) async {
    String tableName =
        type == supplierType ? supplierTableName : customerTableName;
    Log(
        tag: "addNewSupplier",
        message: "table name is $tableName, type is: $type ");
    final db = await database;
    //get the biggest id in the table
    var table;
    bool tableExist = await checkExistTable(tableName: tableName, db: db);
    if (tableExist) {
      table = await db.rawQuery("SELECT MAX(id)+1 as id FROM $tableName");
    } else {
      Log(
          tag: "addNewSupplier",
          message: "table not exist, Try to create table");
      await creatTable(
          tableName, outSidePerson.createSqlTable(tableName: tableName));
      addNewSupplier(outSidePerson: outSidePerson, type: type);
      return -1;
    }
    int id;
    (table.first['id']).toString();
    // ignore: prefer_is_empty
    (table.first.isEmpty)
        ? id = 1
        : (table.first['id'] == null)
            ? id = 1
            : id = int.parse((table.first['id']).toString());
    //insert to the table using the new id
    Log(tag: "Index is: ", message: id.toString());
    var raw = await db.rawInsert(
        "INSERT Into $tableName (id,registerTime,name,address, phoneNumber, email,itemId,billId)"
        " VALUES (?,?,?,?,?,?,?,?)",
        [
          id,
          outSidePerson.registerTime,
          outSidePerson.name,
          outSidePerson.address,
          outSidePerson.phoneNumber,
          outSidePerson.email,
          "${type}Item$id",
          "${type}Bill$id",
        ]);
    return raw;
  }

  addNewWorker({required Worker worker}) async {
    Log(tag: "addNewWorker", message: "Activate Function");
    final db = await database;
    //get the biggest id in the table
    List<Map<String, Object?>> table;

    bool tableExist = await checkExistTable(tableName: workerTableName, db: db);
    if (tableExist) {
      table = await db.rawQuery("SELECT MAX(id)+1 as id FROM $workerTableName");
    } else {
      Log(tag: "addNewWorker", message: "table not exist, Try to create table");
      await creatTable(workerTableName, worker.createSqlTable());
      addNewWorker(worker: worker);
      return -1;
    }

    int id;
    (table.first['id']).toString();
    // ignore: prefer_is_empty
    (table.first.isEmpty)
        ? id = 1
        : (table.first['id'] == null)
            ? id = 1
            : id = int.parse((table.first['id']).toString());
    //insert to the table using the new id
    Log(tag: "Index is: ", message: id.toString());
    var raw = await db.rawInsert(
        "INSERT Into $workerTableName (id,name,address,phoneNumber, email, startTime, endTime,status, salary)"
        " VALUES (?,?,?,?,?,?,?,?,?)",
        [
          id,
          worker.name,
          worker.address,
          worker.phoneNumber,
          worker.email,
          worker.startTime,
          worker.endTime,
          worker.status,
          worker.salary
        ]);
    return raw;
  }

  addNewItem({required Item item}) async {
    Log(tag: "addNewItem", message: "Activate Function");
    String tableName = itemTableName;
    final db = await database;
    //get the biggest id in the table
    List<Map<String, Object?>> table;

    bool tableExist = await checkExistTable(tableName: tableName, db: db);
    if (tableExist) {
      table = await db.rawQuery("SELECT MAX(id)+1 as id FROM $tableName");
    } else {
      Log(tag: "addNewItem", message: "table not exist, Try to create table");
      await creatTable(tableName, item.createSqlTable());
      addNewItem(item: item);
      return -1;
    }

    int id;
    (table.first['id']).toString();
    // ignore: prefer_is_empty
    (table.first.isEmpty)
        ? id = 1
        : (table.first['id'] == null)
            ? id = 1
            : id = int.parse((table.first['id']).toString());
    //insert to the table using the new id
    Log(tag: "Index is: ", message: id.toString());
    var raw = await db.rawInsert(
        "INSERT Into $tableName (id,name,barCode,category,description,prices,validityPeriod,volume,supplierID,customerID,count )"
        " VALUES (?,?,?,?,?,?,?,?,?,?,?)",
        [
          id,
          item.name,
          item.barCode,
          //
          item.category,
          item.description,
          item.prices,
          //
          item.validityPeriod,
          item.volume,
          item.supplierID,
          item.customerID,
          //
          item.count
        ]);
    return raw;
  }

  addNewDepot({required Depot depot}) async {
    Log(tag: "addNewItem", message: "Activate Function");
    String tableName = depotTableName;
    final db = await database;
    //get the biggest id in the table
    List<Map<String, Object?>> table;

    bool tableExist = await checkExistTable(tableName: tableName, db: db);
    if (tableExist) {
      table = await db.rawQuery("SELECT MAX(id)+1 as id FROM $tableName");
    } else {
      Log(tag: "addNewItem", message: "table not exist, Try to create table");
      await creatTable(tableName, depot.createSqlTable());
      addNewDepot(depot: depot);
      return -1;
    }

    int id;
    (table.first['id']).toString();
    // ignore: prefer_is_empty
    (table.first.isEmpty)
        ? id = 1
        : (table.first['id'] == null)
            ? id = 1
            : id = int.parse((table.first['id']).toString());
    //insert to the table using the new id
    Log(tag: "Index is: ", message: id.toString());
    var raw = await db.rawInsert(
        "INSERT Into $tableName (id,name,address, capacity,availableCapacity,historyStorage, depotListItem )"
        " VALUES (?,?,? ,?,?,? ,? )",
        [
          id,
          depot.name,
          depot.address,
          //
          depot.capacity,
          depot.availableCapacity,
          depot.historyStorage,
          //
          "depotListItem$id"
        ]);
    return raw;
  }

  addNewDepotItem(
      {required ItemsDepot itemsDepot, required String tableName}) async {
    Log(tag: "addNewItem", message: "Activate Function");
    final db = await database;
    //get the biggest id in the table
    List<Map<String, Object?>> table;

    bool tableExist = await checkExistTable(tableName: tableName, db: db);
    if (tableExist) {
      table = await db.rawQuery("SELECT MAX(id)+1 as id FROM $tableName");
    } else {
      Log(tag: "addNewItem", message: "table not exist, Try to create table");
      await creatTable(
          tableName, itemsDepot.createSqlTable(tableName: tableName));
      addNewDepotItem(itemsDepot: itemsDepot, tableName: tableName);
      return -1;
    }

    int id;
    (table.first['id']).toString();
    // ignore: prefer_is_empty
    (table.first.isEmpty)
        ? id = 1
        : (table.first['id'] == null)
            ? id = 1
            : id = int.parse((table.first['id']).toString());
    //insert to the table using the new id
    Log(tag: "Index is: ", message: id.toString());
    var raw = await db.rawInsert(
        "INSERT Into $tableName (id,itemId,storageDate, number,billId,productDate, price)"
        " VALUES (?,?,? ,?,?,? ,? )",
        [
          id,
          itemsDepot.itemId,
          itemsDepot.storageDate,
          itemsDepot.number,
          itemsDepot.billId,
          itemsDepot.productDate,
          itemsDepot.price
        ]);
    return raw;
  }

  addNewBillItem(
      {required ItemBill itemBill, required String tableName}) async {
    Log(tag: "addNewItem", message: "Activate Function");
    final db = await database;
    //get the biggest id in the table
    List<Map<String, Object?>> table;

    bool tableExist = await checkExistTable(tableName: tableName, db: db);
    if (tableExist) {
      table = await db.rawQuery("SELECT MAX(id)+1 as id FROM $tableName");
    } else {
      Log(tag: "addNewItem", message: "table not exist, Try to create table");
      await creatTable(
          tableName, itemBill.createSqlTable(tableName: tableName));
      addNewBillItem(itemBill: itemBill, tableName: tableName);
      return -1;
    }

    int id;
    (table.first['id']).toString();
    // ignore: prefer_is_empty
    (table.first.isEmpty)
        ? id = 1
        : (table.first['id'] == null)
            ? id = 1
            : id = int.parse((table.first['id']).toString());
    //insert to the table using the new id
    Log(tag: "Index is: ", message: id.toString());
    var raw = await db.rawInsert(
        "INSERT Into $tableName (id,IDItem,number, productDate,win,price)"
        " VALUES (?,?,? ,?,?,? )",
        [
          id,
          itemBill.IDItem,
          itemBill.number,
          itemBill.productDate,
          itemBill.win,
          itemBill.price
        ]);
    return raw;
  }

  Future<bool> checkExistTable(
      {required String tableName, required Database db}) async {
    String checkExistTable =
        "SELECT * FROM sqlite_master WHERE name ='$tableName' and type='table'";
    var checkExist = await db.rawQuery(checkExistTable);
    Log(
        tag: "checkExistTable",
        message: "Check the $tableName table: ${checkExist.isNotEmpty}");
    return checkExist.isNotEmpty;
  }

  // function used to  delete table data
  deleteTable({required String tableName}) async {
    final db = await database;
    bool tableExist = await checkExistTable(tableName: tableName, db: db);
    if (tableExist) {
      db.rawQuery("DELETE FROM $tableName");
      tableExist = await checkExistTable(tableName: tableName, db: db);
      Log(
          tag: "deleteTable",
          message: "table $tableName is exist: $tableExist");
    } else {
      Log(tag: "deleteTable", message: "table $tableName isn't exist");
    }
  }

  updateObject(
      {required var v, required String tableName, required int id}) async {
    // updateObject is a function that used to update an item in a table "tableName"
    final db = await database;
    var res =
        await db.update(tableName, v.toMap(), where: "id = ?", whereArgs: [id]);
    return res;
  }

  deleteObject(
      {required var v, required String tableName, required int id}) async {
    // updateObject is a function that used to delete an item in a table "tableName"
    final db = await database;
    var res = await db.delete(tableName, where: "id = ?", whereArgs: [id]);
    return res;
  }

  tableHasName({required String tableName, required String name}) async {
    // search if the name is exist in table
    final db = await database;
    String checkExistName =
        "SELECT * FROM $tableName WHERE name LIKE '%$name%'";

    var nameExist = await db.rawQuery(checkExistName);
    Log(
        tag: "tableHasName",
        message: "$tableName has name '$name':  ${nameExist.isNotEmpty}");
    return nameExist;
  }

/*
  newUser(User newUser) async {
    final db = await database;
    //get the biggest id in the table
    var table = await db.rawQuery("SELECT MAX(id)+1 as id FROM User");
    print(table.first['id']);int id;(table.first['id']).toString();
    // ignore: prefer_is_empty
    table.first.isEmpty ?  id=1: id=int.parse((table.first['id']).toString()) +1;
    //int id =table.first.length+1;
    
   
    
    //insert to the table using the new id
    var raw = await db.rawInsert(
        "INSERT Into User (id,name,email,adresse, age, phoneNumber)"
        " VALUES (?,?,?,?,?,?)",
        [id, newUser.name,newUser.email, newUser.adresse, newUser.age, newUser.phoneNumber]);
    return raw;
  }



  updateUser(User newUser) async {
    final db = await database;
    var res = await db.update("User", newUser.toMap(),
        where: "id = ?", whereArgs: [newUser.id]);
    return res;
  }

  getUser(int id) async {
    final db = await database;
    var res = await db.query("User", where: "id = ?", whereArgs: [id]);
    return res.isNotEmpty ? User.fromMap(res.first) : null;
  }

  /*Future<List<User>> getBlockedUsers() async {
    final db = await database;
    print("works");
    // var res = await db.rawQuery("SELECT * FROM User WHERE blocked=1");
    var res = await db.query("User", where: "blocked = ? ", whereArgs: [1]);
    List<User> list =
        res.isNotEmpty ? res.map((c) => User.fromMap(c)).toList() : [];
    return list;
  }*/

  Future<List<User>> getAllUsers() async {
    final db = await database;
    var res = await db.query("User");
    
      return res.isNotEmpty ?  (res.isNotEmpty ? res.map((c) => User.fromMap(c)).toList() : [])
       : [];
    
  }

  deleteUser(int id) async {
    final db = await database;
    return db.delete("User", where: "id = ?", whereArgs: [id]);
  }

  deleteAll() async {
    final db = await database;
    db.rawDelete("Delete * from User");
  }
 
*/
}

/*Stream<List<User>> getAllDatabaseUsers() async* {
  List<User> userList = await DBProvider.db.getAllUsers();
  StreamController<List<User>> streamController = 
     StreamController();
  userList.map((user){
    List<User> u=[user];
    streamController.add(u);});
    yield* streamController.stream;
}*/