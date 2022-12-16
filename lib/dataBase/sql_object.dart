import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:store_manager/utils/objects.dart';

import '../utils/utils.dart';
import 'depot_sql.dart';
import 'item_sql.dart';

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

  Future<void> deleteDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    databaseFactory.deleteDatabase(path);
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
    String tag = "addNewSupplier";
    String tableName =
        type == supplierType ? supplierTableName : customerTableName;
    Log(tag: tag, message: "table name is $tableName, type is: $type ");
    final db = await database;
    //get the biggest id in the table

    bool tableExist = await checkExistTable(tableName: tableName);
    if (!tableExist) {
      Log(tag: tag, message: "table not exist, Try to create table");
      await creatTable(
          tableName, outSidePerson.createSqlTable(tableName: tableName));
    }
    var table = await db.rawQuery("SELECT MAX(id)+1 as id FROM $tableName");
    int id;
    // ignore: prefer_is_empty
    (table.first.isEmpty)
        ? id = 0
        : (table.first['id'] == null)
            ? id = 0
            : id = int.parse((table.first['id']).toString());
    //insert to the table using the new id
    Log(tag: tag, message: "Index is: $id");
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
          "${type}Items$id",
          "${type}Bills$id",
        ]);
    return raw;
  }

  addNewWorker({required Worker worker}) async {
    Log(tag: "addNewWorker", message: "Activate Function");
    final db = await database;
    //get the biggest id in the table
    List<Map<String, Object?>> table;

    bool tableExist = await checkExistTable(tableName: workerTableName);
    if (!tableExist) {
      Log(tag: "addNewWorker", message: "table not exist, Try to create table");
      await creatTable(workerTableName, worker.createSqlTable());
    }
    table = await db.rawQuery("SELECT MAX(id)+1 as id FROM $workerTableName");

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
/** */

/**Depot */
  addNewDepot({required Depot depot}) async {
    String tag = "addNewDepot";
    Log(tag: tag, message: "Activate Function");
    String tableName = depotTableName;
    final db = await database;
    //get the biggest id in the table
    List<Map<String, Object?>> table;

    bool tableExist = await checkExistTable(tableName: tableName);
    if (!tableExist) {
      Log(tag: tag, message: "table not exist, Try to create table");
      await creatTable(tableName, depot.createSqlTable());
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
        "INSERT Into $tableName (id,name,address, capacity,availableCapacity,billsID, depotListItem,depotListOutItem)"
        " VALUES (?,?,? ,?,?,? ,?,? )",
        [
          id,
          depot.name,
          depot.address,
          //
          depot.capacity,
          depot.availableCapacity,
          "depotBillsID$id",
          //
          "depotListItem$id",
          "depotListOutItem$id"
        ]);
    return raw;
  }

/**$$$$$$ */

  /*** */

  Future<bool> checkExistTable({required String tableName}) async {
    final db = await database;
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
    bool tableExist = await checkExistTable(tableName: tableName);
    if (tableExist) {
      db.rawQuery("DELETE FROM $tableName");
      tableExist = await checkExistTable(tableName: tableName);
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
    bool existTable = await checkExistTable(tableName: tableName);
    if (existTable) {
      var res = await db
          .update(tableName, v.toJson(), where: "id = ?", whereArgs: [id]);
      return res;
    } else {
      return 0;
    }
  }

  deleteObject({required String tableName, required int id}) async {
    // updateObject is a function that used to delete an item in a table "tableName"
    final db = await database;
    bool existTable = await checkExistTable(tableName: tableName);
    if (existTable) {
      var res = await db.delete(tableName, where: "id = ?", whereArgs: [id]);
      return res;
    } else {
      return 0;
    }
  }

  tableSearchName(
      {required String tableName,
      required String elementSearch,
      required String element}) async {
    // search if the name is exist in table
    final db = await database;
    bool existTable = await checkExistTable(tableName: tableName);
    if (existTable) {
      String checkExistName =
          "SELECT * FROM $tableName WHERE $element LIKE '%$elementSearch%'";

      var res = await db.rawQuery(checkExistName);
      return res;
    } else {
      return [];
    }
  }

  tableSortBy(
      {required String tableName,
      required String element,
      String order = "DESC"}) async {
    // sort table  by element (date)
    final db = await database;
    bool existTable = await checkExistTable(tableName: tableName);
    if (existTable) {
      String checkExistName =
          "SELECT * FROM $tableName ORDER BY $element $order"; //DESC ASC
      var res = await db.rawQuery(checkExistName);
      return res;
    } else {
      return [];
    }
  }

  //SELECT * FROM $tableName WHERE $element <= '2016-03-09' AND $element >= '2019-08-11'

  tableBetweenDates(
      {required String tableName, required String element}) async {
    // sort table  by element (date)
    final db = await database;
    bool existTable = await checkExistTable(tableName: tableName);
    if (existTable) {
      String checkExistName =
          "SELECT * FROM $tableName WHERE $element <= '2019-08-11' c $element >= '2016-03-09'";
      var res = await db.rawQuery(checkExistName);
      return res;
    } else {
      return [];
    }
  }

  getObjectsByDate(
      {required String tableName,
      required String element,
      required String date,
      String date1 = "",
      required String tag}) async {
    final db = await database;
    bool existTable = await checkExistTable(tableName: tableName);
    if (existTable) {
      if (date1.isEmpty) {
        date1 = addDayToDate(date: date);
      }
      Log(tag: tag, message: "date: '$date' date1: '$date1'");

      String checkExistName = //AND  $element <= '$date - 23:59'
          "SELECT * FROM $tableName WHERE $element >= '$date' AND  $element < '$date1' ORDER BY $element DESC";
      var res = await db.rawQuery(checkExistName);

      return res;
    } else {
      Log(tag: tag, message: "table not exist ");
      return [];
    }
  }

  getObjectsByDateMaxNumber(
      {required String tableName,
      required String element,
      required String date,
      String date1 = "",
      required String elementGroup,
      required String elementOrder,
      required String tag}) async {
    final db = await database;
    bool existTable = await checkExistTable(tableName: tableName);
    if (existTable) {
      if (date1.isEmpty) {
        date1 = addDayToDate(date: date);
      }
      Log(tag: tag, message: "date: '$date' date1: '$date1'");

      String checkExistName = //AND  $element <= '$date - 23:59'
          "SELECT * FROM $tableName WHERE $element >= '$date' AND  $element < '$date1' GROUP BY $elementGroup ORDER BY $elementOrder DESC ";
      var res = await db.rawQuery(checkExistName);

      return res;
    } else {
      Log(tag: tag, message: "table not exist ");
      return [];
    }
  }

  getObjectsByDateMaxNumberGroupeElement(
      {required String tableName,
      required String element,
      required String date,
      String date1 = "",
      required String elementGroup,
      required String elementMax,
      String elementMax1 = "",
      required String tag}) async {
    final db = await database;
    bool existTable = await checkExistTable(tableName: tableName);
    if (existTable) {
      if (date1.isEmpty) {
        date1 = addDayToDate(date: date);
      }
      Log(tag: tag, message: "date: '$date' date1: '$date1'");

      String checkExistName = //AND  $element <= '$date - 23:59'
          "SELECT  $elementGroup, SUM($elementMax)AS $elementMax ${elementMax1.isNotEmpty ? ", SUM($elementMax1) AS $elementMax1" : ""}  FROM $tableName WHERE $element >= '$date' AND  $element < '$date1' GROUP BY $elementGroup ORDER BY SUM($elementMax) DESC";
      //"SELECT * FROM $tableName WHERE $element >= '$date' AND  $element < '$date1' ORDER BY $element DESC";
      var res = await db.rawQuery(checkExistName);

      return res;
    } else {
      Log(tag: tag, message: "table not exist ");
      return [];
    }
  }

  getReportDayByObject(
      {required String tableName,
      required String element,
      required String element1,
      required String dateString,
      required String date,
      String date1 = "",
      required String tag}) async {
    final db = await database;
    bool existTable = await checkExistTable(tableName: tableName);
    if (existTable) {
      if (date1.isEmpty) {
        date1 = addDayToDate(date: date);
      }
      Log(tag: tag, message: "date: '$date' date1: '$date1'");

      String checkExistName = //AND  $element <= '$date - 23:59'
          "SELECT SUM($element) AS $element, SUM($element1) AS $element1  FROM $tableName WHERE $dateString >= '$date' AND  $dateString < '$date1'";
      //"SELECT * FROM $tableName WHERE $element >= '$date' AND  $element < '$date1' ORDER BY $element DESC";
      var res = await db.rawQuery(checkExistName);

      return res;
    } else {
      Log(tag: tag, message: "table not exist ");
      return [];
    }
  }

  getObjectsByDateMaxPrice(
      {required String tableName,
      required String element,
      required String date,
      required String id,
      String date1 = "",
      required String elementMax,
      required String tag}) async {
    final db = await database;
    bool existTable = await checkExistTable(tableName: tableName);
    if (existTable) {
      if (date1.isEmpty) {
        date1 = addDayToDate(date: date);
      }

      String queryMax = //AND  $element <= '$date - 23:59'
          "SELECT $id, MAX($elementMax) FROM $tableName  WHERE $element >= '$date' AND  $element < '$date1'";
      var maxValue = await db.rawQuery(queryMax);
      Log(
          tag: tag,
          message:
              "Max value is: ${maxValue.first}, id: ${maxValue.first.values.first}");
      if (maxValue.isEmpty) return [];
      var res = await getObject(id: 18, tableName: tableName);

      return res;
    } else {
      Log(tag: tag, message: "table not exist ");
      return [];
    }
  }

  Future<List<Item>> getAllItems() async {
    // An function that return all item in data base
    bool existTable = await checkExistTable(tableName: itemTableName);
    if (existTable) {
      final db = await database;
      var res = await db.query(itemTableName);
      return res.isNotEmpty
          ? (res.isNotEmpty ? res.map((c) => Item.fromJson(c)).toList() : [])
          : [];
    } else {
      return [];
    }
  }

  Future<List<Item>> getExistItems() async {
    // An function that return all item in data base
    final db = await database;
    bool existTable = await checkExistTable(tableName: itemTableName);
    if (existTable) {
      String checkExistName = "SELECT * FROM $itemTableName WHERE  count > 0 ";
      var res = await db.rawQuery(checkExistName);
      return res.isNotEmpty
          ? (res.isNotEmpty ? res.map((c) => Item.fromJson(c)).toList() : [])
          : [];
    } else {
      return [];
    }
  }

  tableSearchElementItemsTableOut(
      {required String elementSearch, required String element}) async {
    // search if the name is exist in table
    bool existTable = await checkExistTable(tableName: itemTableName);
    if (existTable) {
      final db = await database;
      String checkExistName =
          "SELECT * FROM $itemTableName WHERE $element LIKE '%$elementSearch%' AND count > 0";

      var res = await db.rawQuery(checkExistName);
      return res;
    } else {
      return [];
    }
  }

  tableSearchElementNoEmptyDepots(
      {required String elementSearch, required String element}) async {
    // An function that return all supplier or customer in data base

    final db = await database;
    bool existTable = await checkExistTable(tableName: depotTableName);
    if (existTable) {
      String checkExistName =
          "SELECT * FROM $depotTableName WHERE $element LIKE '%$elementSearch%' AND  availableCapacity > 0";

      var res = await db.rawQuery(checkExistName);

      return res;
    } else {
      return [];
    }
  }

  getAllObjects({required String tableName}) async {
    // An function that return all item in data base
    bool existTable = await checkExistTable(tableName: tableName);
    if (existTable) {
      final db = await database;
      return await db.query(tableName);
    } else {
      return [];
    }
  }

  getAllBillItemForUniqueBill(
      {required String tableName, required int billId}) async {
    // An function that return all item in data base
    bool existTable = await checkExistTable(tableName: tableName);
    if (existTable) {
      final db = await database;

      String query = tableName == billInItemTableName
          ? "SELECT * FROM $tableName WHERE billId = $billId"
          : "SELECT * FROM $tableName WHERE billOutId = $billId"; //billOutId
      return await db.rawQuery(query);
    } else {
      return [];
    }
  }

  getDepotBillOutItem(
      {required String tableName,
      required int billOutId,
      required int billOutItemId,
      required int itemDepotId}) async {
    // An function that return all item in data base
    bool existTable = await checkExistTable(tableName: tableName);
    if (existTable) {
      final db = await database;
      String query =
          "SELECT * FROM $tableName WHERE billOutId = $billOutId AND billOutItemId = $billOutItemId AND itemDepotId = $itemDepotId";
      return await db.rawQuery(query);
    } else {
      return [];
    }
  }

  getDepotBillOutItems(
      {required String tableName, required int itemDepotId}) async {
    // An function that return all item in data base
    bool existTable = await checkExistTable(tableName: tableName);
    if (existTable) {
      final db = await database;
      String query =
          "SELECT * FROM $tableName WHERE itemDepotId = $itemDepotId";
      return await db.rawQuery(query);
    } else {
      return [];
    }
  }

  getDepotItem({
    required String tableName,
    required int billId,
    required int itemBillId,
  }) async {
    // An function that return all item in data base
    bool existTable = await checkExistTable(tableName: tableName);
    if (existTable) {
      final db = await database;
      String query =
          "SELECT * FROM $tableName WHERE billId = $billId AND itemBillId = $itemBillId";
      return await db.rawQuery(query);
    } else {
      return [];
    }
  }

  Future<bool> tableHasObject(
      {required String element,
      required String searchFor,
      String tableName = itemTableName}) async {
    // An function that return all item in data base
    final db = await database;
    bool existTable = await checkExistTable(tableName: tableName);
    if (existTable) {
      var res = await db
          .query(tableName, where: "$element = ?", whereArgs: [searchFor]);
      return res.isNotEmpty;
    } else {
      return false;
    }
  }

  Future<List<Supplier>> getAllSupplier({String type = ""}) async {
    // An function that return all supplier or customer in data base
    final db = await database;
    bool existTable = await checkExistTable(
        tableName: type == "" ? supplierTableName : customerTableName);
    if (existTable) {
      var res =
          await db.query(type == "" ? supplierTableName : customerTableName);
      return res.isNotEmpty
          ? (res.isNotEmpty
              ? res
                  .map((sup) => Supplier.fromJson(
                      sup, type == "" ? supplierType : customerType))
                  .toList()
              : [])
          : [];
    } else {
      return [];
    }
  }

  Future<List<Worker>> getAllWorkers() async {
    // An function that return all supplier or customer in data base
    final db = await database;
    bool existTable = await checkExistTable(tableName: workerTableName);
    if (existTable) {
      var res = await db.query(workerTableName);
      return res.isNotEmpty
          ? (res.isNotEmpty
              ? res.map((worker) => Worker.fromJson(worker)).toList()
              : [])
          : [];
    } else {
      return [];
    }
  }

  Future<List<Depot>> getAllDepots() async {
    // An function that return all supplier or customer in data base
    final db = await database;

    bool existTable = await checkExistTable(tableName: depotTableName);
    if (existTable) {
      var res = await db.query(depotTableName);
      return res.isNotEmpty
          ? (res.isNotEmpty
              ? res.map((depot) => Depot.fromJson(depot)).toList()
              : [])
          : [];
    } else {
      return [];
    }
  }

  Future<List<Depot>> getNoEmptyDepots() async {
    // An function that return all supplier or customer in data base
    final db = await database;
    bool existTable = await checkExistTable(tableName: depotTableName);
    if (existTable) {
      String checkExistName =
          "SELECT * FROM $depotTableName WHERE  availableCapacity > 0";

      var res = await db.rawQuery(checkExistName);

      return res.isNotEmpty
          ? (res.isNotEmpty
              ? res.map((depot) => Depot.fromJson(depot)).toList()
              : [])
          : [];
    } else {
      return [];
    }
  }

  getObject({required int id, required String tableName}) async {
    final db = await database;
    bool existTable = await checkExistTable(tableName: tableName);
    if (existTable) {
      return await db.query(tableName, where: "id = ?", whereArgs: [id]);
    } else {
      return [];
    }
  }
  /* billOutId: id,
                billOutItemId: idBillItem,*/

  getBillItemOut(
      {required int billOutId,
      required int billOutItemId,
      required String tableName}) async {
    final db = await database;
    bool existTable = await checkExistTable(tableName: tableName);
    if (existTable) {
      final db = await database;
      String query =
          "SELECT * FROM $tableName WHERE billOutId = $billOutId AND billOutItemId = $billOutItemId";
      return await db.rawQuery(query);
    } else {
      return [];
    }
  }

  Future<int> getMaxId({required String tableName}) async {
    final db = await database;
    bool tableExist = await DBProvider.db.checkExistTable(tableName: tableName);
    int id = -1;
    if (tableExist) {
      var table = await db.rawQuery("SELECT MAX(id)+1 as id FROM $tableName");
      (table.first['id']).toString();
      // ignore: prefer_is_empty
      (table.first.isEmpty)
          ? id = -1
          : (table.first['id'] == null)
              ? id = -1
              : id = int.parse((table.first['id']).toString());
    }
    return id;
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
