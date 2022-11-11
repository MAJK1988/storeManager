class ItemBill {
  late final int id;
  late final int IDItem;
  late final int number;

  late final String productDate;
  late final double win;
  late final double price;

  ItemBill(
      {required this.id,
      required this.IDItem,
      required this.number,
      required this.productDate,
      required this.win,
      required this.price});

  // read ItemBillIn from json object
  ItemBill.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    IDItem = json['IDItem'];
    number = json['number'];
    productDate = json['ManufactureDate'];
    win = json['win'];
    price = json['price'];
  }

  //from json to ItemBillIn object
  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['IDItem'] = IDItem;
    _data['number'] = number;
    _data['productDate'] = productDate;
    _data['win'] = win;
    _data['price'] = price;
    return _data;
  }

  // Create sql table
  String createSqlTable({required String tableName}) {
    return "CREATE TABLE $tableName ("
        "id INTEGER PRIMARY KEY,"
        "IDItem INTEGER,"
        "number INTEGER,"
        "productDate TEXT,"
        "win REAL,"
        "price REAL"
        ")";
  }
}

// Bill bay
class Bill {
  late final int ID;
  late final int depotId;
  late final DateTime dateTime;
  late final String outsidePersonId;
  late final int type;
  late final String workerId;
  late final String itemBills; //name of table
  Bill(
      {required this.ID,
      required this.depotId,
      required this.dateTime,
      required this.outsidePersonId,
      required this.type,
      required this.workerId,
      required this.itemBills});

  // read BillIn from json object
  Bill.fromJson(Map<String, dynamic> json) {
    ID = json['id'];
    depotId = json['depotId'];
    dateTime = json['dateTime'];
    outsidePersonId = json['outsidePersonId'];
    type = json['type'];
    workerId = json['workerId'];
    itemBills = json['itemBills'];
  }
  //from json to ItemBillIn BillIn
  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = ID;
    _data['depotId'] = depotId;
    _data['dateTime'] = dateTime;
    _data['outsidePersonId'] = outsidePersonId;
    _data['type'] = type;
    _data['workerId'] = workerId;
    _data['itemBills'] = itemBills;
    return _data;
  }

  // Create sql table
  String createSqlTable() {
    return "CREATE TABLE Bill ("
        "ID INTEGER NOT NULL PRIMARY KEY,"
        "depotId INTEGER NOT NULL,"
        "dateTime DATE,"
        "outsidePersonId TEXT,"
        "type TEXT,"
        "workerId TEXT,"
        "itemBills TEXT NOT NULL UNIQUE"
        ")";
  }
}

class ItemId {
  late final String ID;
  // read ItemId from json object
  ItemId.fromJson(Map<String, dynamic> json) {
    ID = json['ID'];
  }
  ItemId({required this.ID});
  //from json to ItemId
  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['ID'] = ID;
    return _data;
  }
}

String createColumnTable({required String name}) {
  return "CREATE TABLE $name ("
      "id INTEGER NOT NULL PRIMARY KEY"
      ")";
}

String supplierType = "Supplier",
    customerType = "Customer",
    customerTableName = "Customers",
    supplierTableName = "Suppliers",
    workerTableName = "Workers",
    depotTableName = "DepotTab",
    itemTableName = "ItemsTab";

class Supplier {
  // outSidePerson has twÒo types: Supplier, Customer
  late final int Id;
  late final String registerTime;
  late final String name;
  late final String address;
  late final String phoneNumber;
  late final String email;
  late final String type; // Supplier or customer
  late final String itemId; // name of table, row table has id of item
  late final String billId; // name of table, row table has id of bill

  Supplier(
      {required this.Id,
      required this.registerTime,
      required this.name,
      required this.address,
      required this.phoneNumber,
      required this.email,
      required this.type,
      required this.itemId,
      required this.billId});

  // read OutsidePerson from json object
  Supplier.fromJson(Map<String, dynamic> json, String type) {
    Id = json['id'];
    registerTime = json['registerTime'];
    name = json['name'];
    address = json['address'];
    phoneNumber = json['phoneNumber'];
    email = json['email'];
    type = type;
    itemId = json['itemId'];
    billId = json['billId'];
  }
  //from json to ItemBillIn BillIn
  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = Id;
    _data['registerTime'] = registerTime;
    _data['name'] = name;
    _data['address'] = address;
    _data['phoneNumber'] = phoneNumber;
    _data['email'] = email;
    _data['type'] = type;
    _data['itemId'] = itemId;
    _data['billId'] = billId;
    return _data;
  }

  // Create sql table
  String createSqlTable({required String tableName}) {
    return "CREATE TABLE $tableName ("
        "id INTEGER PRIMARY KEY,"
        "registerTime DATE,"
        "name TEXT NOT NULL,"
        "address TEXT,"
        "phoneNumber TEXT NOT NULL UNIQUE,"
        "email TEXT NOT NULL UNIQUE,"
        "itemId TEXT NOT NULL UNIQUE,"
        "billId TEXT NOT NULL UNIQUE"
        ")";
  }
}

class Price {
  late final double price, win, minWin;
  late DateTime dateTime;
  Price(
      {required this.price,
      required this.win,
      required this.minWin,
      required this.dateTime});
  // read price from json object
  Price.fromJson(Map<String, dynamic> json) {
    price = json['price'];
    win = json['win'];
    minWin = json['minWin'];
    dateTime = json['dateTime'];
  }
  //from json to price object
  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['price'] = price;
    _data['win'] = win;
    _data['minWin'] = minWin;
    _data['dateTime'] = dateTime;
    return _data;
  }

  // Create sql table
  String createSqlTable({required String tableName}) {
    return "CREATE TABLE $tableName ("
        "dateTime DATE NOT NULL PRIMARY KEY,"
        "price REAL,"
        "win REAL,"
        "minWin REAL"
        ")";
  }
}

class Item {
  late final int ID;
  late final String name;
  late final String barCode;
  late final String category;
  late final String description;
  late final String soldBy;
  late final String prices; // name of table,  table has change of item price
  late final double validityPeriod;
  late final double volume;
  late final String
      supplierID; // name of table, row table has id of item supplier
  late final String
      customerID; // name of table, row table has id of item customer
  late final int count;

  Item(
      {required this.ID,
      required this.name,
      required this.barCode,
      required this.category,
      required this.description,
      required this.soldBy,
      required this.prices,
      required this.validityPeriod,
      required this.volume,
      required this.supplierID,
      required this.customerID,
      required this.count});
  // read BillIn from json object
  Item.fromJson(Map<String, dynamic> json) {
    ID = json['id'];
    name = json['name'];
    barCode = json['barCode'];
    category = json['category'];
    description = json['description'];
    soldBy = json['soldBy'];
    prices = json['prices'];
    validityPeriod = json['validityPeriod'];
    volume = json['volume'];
    supplierID = json['supplierID'];
    customerID = json['customerID'];
    count = json['count'];
  }
  //from json to ItemBillIn BillIn
  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = ID;
    _data['name'] = name;
    _data['barCode'] = barCode;
    _data['category'] = category;
    _data['soldBy'] = soldBy;
    _data['description'] = description;
    _data['prices'] = prices;
    _data['validityPeriod'] = validityPeriod;
    _data['volume'] = volume;
    _data['supplierID'] = supplierID;
    _data['customerID'] = customerID;
    _data['count'] = count;
    return _data;
  }

  // Create sql table
  String createSqlTable() {
    return "CREATE TABLE $itemTableName ("
        "id INTEGER PRIMARY KEY,"
        "name TEXT,"
        "barCode TEXT NOT NULL UNIQUE,"
        "category TEXT,"
        "description TEXT,"
        "prices REAL,"
        "validityPeriod TEXT,"
        "volume REAL,"
        "supplierID TEXT NOT NULL UNIQUE,"
        "customerID TEXT NOT NULL UNIQUE,"
        "count INT"
        ")";
  }
}

class Worker {
  late final int Id;
  late final String name;
  late final String address;
  late final String phoneNumber;
  late final String email;
  late final String startTime;
  late final String endTime;
  late final int status;
  late final double salary;

  Worker(
      {required this.Id,
      required this.name,
      required this.address,
      required this.phoneNumber,
      required this.email,
      required this.startTime,
      required this.endTime,
      required this.status,
      required this.salary});
  // read worker from json object
  Worker.fromJson(Map<String, dynamic> json) {
    Id = json['id'];
    name = json['name'];
    address = json['address'];
    phoneNumber = json['phoneNumber'];
    email = json['email'];
    startTime = json['startTime'];
    endTime = json['endTime'];
    status = json['status'];
    salary = json['salary'];
  }
  //from json to Depot
  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = Id;
    _data['name'] = name;
    _data['address'] = address;
    _data['phoneNumber'] = phoneNumber;
    _data['email'] = email;
    _data['startTime'] = startTime;
    _data['endTime'] = endTime;
    _data['status'] = status;
    _data['salary'] = salary;
    return _data;
  }

  // Create sql table
  String createSqlTable() {
    return "CREATE TABLE $workerTableName ("
        "id INTEGER PRIMARY KEY,"
        "name TEXT,"
        "address TEXT,"
        "phoneNumber TEXT NOT NULL UNIQUE,"
        "email TEXT NOT NULL UNIQUE,"
        "startTime DATE NOT NULL,"
        "endTime DATE,"
        "status INTEGER,"
        "salary REAL"
        ")";
  }
}

class Depot {
  late final int Id;
  late final String address;
  late final String name;
  late final double capacity;
  late final double availableCapacity;
  late final String historyStorage; // table name, historyStorage$Id
  late final String depotListItem; // table name, depotListItem$Id

  Depot(
      {required this.Id,
      required this.address,
      required this.name,
      required this.capacity,
      required this.availableCapacity,
      required this.historyStorage,
      required this.depotListItem});

  // read Depot from json object
  Depot.fromJson(Map<String, dynamic> json) {
    Id = json['id'];
    name = json['name'];
    address = json['address'];

    capacity = json['capacity'];
    availableCapacity = json['availableCapacity'];
    historyStorage = json['historyStorage'];

    depotListItem = json['depotListItem'];
  }
  //from json to Worker
  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = Id;
    _data['name'] = name;
    _data['address'] = address;

    _data['capacity'] = capacity;
    _data['availableCapacity'] = availableCapacity;
    _data['historyStorage'] = historyStorage;

    _data['depotListItem'] = depotListItem;

    return _data;
  }

  // Create sql table
  String createSqlTable() {
    return "CREATE TABLE $depotTableName ("
        "id INTEGER PRIMARY KEY,"
        "name TEXT,"
        "address TEXT,"
        "capacity REAL,"
        "availableCapacity REAL,"
        "historyStorage TEXT,"
        "depotListItem TEXT,"
        ")";
  }
}

class ItemsDepot {
  late final int id;
  late final int itemId;
  late final String storageDate;
  late final int number;

  late final int billId;
  late final String productDate;
  late final double price;

  ItemsDepot(
      {required this.id,
      required this.itemId,
      required this.storageDate,
      required this.number,
      required this.billId,
      required this.productDate,
      required this.price});

  // read ItemsDepot from json object
  ItemsDepot.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    itemId = json['itemId'];
    storageDate = json['storageDate'];
    number = json['number'];

    billId = json['billId'];
    productDate = json['productDate'];
    price = json['price'];
  }
  //from json to ItemsDepot
  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['itemId'] = itemId;
    _data['storageDate'] = storageDate;
    _data['number'] = number;

    _data['billId'] = billId;
    _data['productDate'] = productDate;
    _data['price'] = price;
    return _data;
  }

  // Create sql table
  String createSqlTable({required String tableName}) {
    return "CREATE TABLE $tableName ("
        "id INTEGER PRIMARY KEY,"
        "itemId INTEGER,"
        "storageDate TEXT,"
        "number int,"
        "billId INTEGER,"
        "productDate DATE NOT NULL,"
        "price REAL"
        ")";
  }
}

List<String> nameArray = [
  'Mahmoud kaddour',
  'zahraa ZAKARIA',
  'Ahmad KADDOUR',
  'razane ZAKARIA',
  'kassem saher',
  'bilal ZAKARIA',
  'gorege WASOUF',
  'wael KHEFOURY',
  'taha KADDOUR',
  'amer KADDOUR'
];
List<String> nameArrayCus = [
  'Mahmoud kaddourCus',
  'zahraa ZAKARIACus',
  'Ahmad KADDOURCus',
  'razane ZAKARIACus',
  'kassem saherCus',
  'bilal ZAKARIACus',
  'gorege WASOUFCus',
  'wael KHEFOURYCus',
  'taha KADDOURCus',
  'amer KADDOURCus'
];
List<String> addressArray = [
  'FR Paris',
  'FR Metz',
  'LB AKKAR',
  'LB Tekrit',
  'IRAQ bagedad',
  'LB Tekrit',
  'LB Bayrouth',
  'LB Bayrouth',
  'LB Akkar al Atika',
  'LB Akkar al Atika'
];
