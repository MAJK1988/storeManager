import 'package:store_manager/dataBase/sql_object.dart';

import '../../../utils/objects.dart';

class LoginCtr {
//insertion
  Future<int> saveUser(Worker worker) async {
    int res = await DBProvider.db.addNewWorker(worker: worker);

    return res;
  }

  //deletion
  Future<int> deleteUser(Worker worker) async {
    int res = await DBProvider.db
        .deleteObject(tableName: workerTableName, id: worker.Id);
    return res;
  }

  Future<Worker?> getLogin(String email, String password) async {
    String query =
        "SELECT * FROM $workerTableName WHERE email LIKE '$email' AND password LIKE '$password' ";

    var res = await DBProvider.db
        .executeQuery(tableName: workerTableName, query: query);
    if (res.isNotEmpty) {
      Worker worker = Worker.fromJson(res.first);
      if (worker.userIndex > 0) {
        return worker;
      }
    }
    return null;
  }

  Future<List<Worker>> getAllUser() async {
    var res = await DBProvider.db.getAllObjects(tableName: workerTableName);

    List<Worker> list =
        res.isNotEmpty ? res.map((c) => Worker.fromJson(c)).toList() : null;

    return list;
  }
}
