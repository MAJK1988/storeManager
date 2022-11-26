class ItemBill {
  late final int id;
  late final int IDItem;
  late final double number;

  late final String productDate;
  late final double win;
  late final double price;
  late final int depotID;

  ItemBill(
      {required this.id,
      required this.IDItem,
      required this.number,
      required this.productDate,
      required this.win,
      required this.price,
      required this.depotID});

  // read ItemBillIn from json object
  ItemBill.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    IDItem = json['IDItem'];
    number = json['number'];
    productDate = json['ManufactureDate'];
    win = json['win'];
    price = json['price'];
    depotID = json['depotID'];
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
    _data['depotID'] = depotID;
    return _data;
  }

  // Create sql table
  String createSqlTable({required String tableName}) {
    return "CREATE TABLE $tableName ("
        "id INTEGER PRIMARY KEY,"
        "IDItem INTEGER,"
        "number REAL,"
        "productDate TEXT,"
        "win REAL,"
        "price REAL,"
        "depotID INTEGER"
        ")";
  }
}

// Bill bay
class Bill {
  late final int ID;
  late final String depotId;
  late final String dateTime;
  late final int outsidePersonId;
  late final String type;
  late final int workerId;
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
    return "CREATE TABLE $BillInTableName ("
        "id INTEGER NOT NULL PRIMARY KEY,"
        "depotId INTEGER NOT NULL,"
        "dateTime DATE,"
        "outsidePersonId INTEGER,"
        "type TEXT,"
        "workerId INTEGER,"
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

const String supplierType = "Supplier",
    customerType = "Customer",
    customerTableName = "CustomersTable",
    supplierTableName = "SuppliersTable",
    workerTableName = "WorkersTable",
    depotTableName = "DepotsTable",
    BillInTableName = "BillInTableName",
    itemTableName = "ItemsTableDSC1";

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
  Supplier.fromJson(Map<String, dynamic> json, String typeIn) {
    Id = json['id'];
    registerTime = json['registerTime'];
    name = json['name'];
    address = json['address'];
    phoneNumber = json['phoneNumber'];
    email = json['email'];
    type = typeIn;
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

  Supplier init() {
    return Supplier(
        Id: -1,
        registerTime: "",
        name: "",
        address: "",
        phoneNumber: "",
        email: "",
        type: "",
        itemId: "",
        billId: "");
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

/// Items object */
class Item {
  late final int ID;
  late final String name;
  late final String barCode;

  late final String category;
  late final String description;
  late final String soldBy;

  late final String madeIn;
  late String prices; // name of table,  table has change of item price&win
  late double validityPeriod;

  late final double volume;
  late double actualPrice;
  late double actualWin;
  late final String
      supplierID; // name of table, row table has id of item supplier
  late final String
      customerID; // name of table, row table has id of item customer
  late final String depotID; // name of table, row table has id of item customer
  late double count;
  //late String image;

  Item({
    required this.ID,
    required this.name,
    required this.barCode,
    required this.category,
    required this.description,
    required this.soldBy,
    required this.madeIn,
    required this.prices,
    required this.validityPeriod,
    required this.volume,
    required this.actualPrice,
    required this.actualWin,
    required this.supplierID,
    required this.customerID,
    required this.depotID,
    required this.count,
    // required this.image
  });

  // read BillIn from json object
  Item.fromJson(Map<String, dynamic> json) {
    ID = json['id'];
    name = json['name'];
    barCode = json['barCode'];

    category = json['category'];
    description = json['description'];
    soldBy = json['soldBy'];

    madeIn = json['madeIn'];
    prices = json['prices'];
    validityPeriod = json['validityPeriod'];

    volume = json['volume'];
    actualPrice = json['actualPrice'];
    actualWin = json['actualWin'];
    supplierID = json['supplierID'];
    customerID = json['customerID'];
    depotID = json['depotID'];
    count = json['count'];
    //image = json['image'];
  }
  //from json to ItemBillIn BillIn
  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = ID;
    _data['name'] = name;
    _data['barCode'] = barCode;

    _data['category'] = category;
    _data['soldBy'] = soldBy;
    _data['madeIn'] = madeIn;

    _data['description'] = description;
    _data['prices'] = prices;
    _data['validityPeriod'] = validityPeriod;

    _data['volume'] = volume;
    _data['actualPrice'] = actualPrice;
    _data['actualWin'] = actualWin;
    _data['supplierID'] = supplierID;
    _data['customerID'] = customerID;
    _data['depotID'] = depotID;
    _data['count'] = count;
    // _data['image'] = image;

    return _data;
  }

  // Create sql table
  String createSqlTable() {
    return "CREATE TABLE $itemTableName ("
        "id INTEGER PRIMARY KEY,"
        "name TEXT,"
        "barCode TEXT NOT NULL UNIQUE,"
        "category TEXT,"
        //
        "soldBy TEXT,"
        "madeIn TEXT,"
        "description TEXT,"
        "prices REAL,"
        "validityPeriod REAL,"
        "volume REAL,"
        "actualPrice REAL,"
        "actualWin REAL,"
        "supplierID TEXT NOT NULL UNIQUE,"
        "customerID TEXT NOT NULL UNIQUE,"
        "depotID TEXT NOT NULL UNIQUE,"
        "count REAL"
        // "image TEXT"
        ")";
  }
}

class ItemDepot {
  //table name: ItemDepot$idItem
  late double number;
  late final int depotId;
  ItemDepot({required this.number, required this.depotId});

  // read BillIn from json object
  ItemDepot.fromJson(Map<String, dynamic> json) {
    number = json['number'];
    depotId = json['id'];
  }
  updateNumber({required newNumber}) {
    number = newNumber;
  }

  //from json to ItemBillIn BillIn
  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['number'] = number;
    _data['id'] = depotId;

    return _data;
  }

  // Create sql table
  String createSqlTable({required String tableName}) {
    return "CREATE TABLE $tableName ("
        "id INTEGER NOT NULL PRIMARY KEY,"
        "number REAL NOT NULL"
        ")";
  }
}

class ItemSupplier {
  //table name: ItemSupplier$idItem
  late final int supplier;
  ItemSupplier({required this.supplier});

  // read BillIn from json object
  ItemSupplier.fromJson(Map<String, dynamic> json) {
    supplier = json['id'];
  }
  //from json to ItemBillIn BillIn
  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = supplier;

    return _data;
  }

  // Create sql table
  String createSqlTable({required String tableName}) {
    return "CREATE TABLE $tableName ("
        "id INTEGER NOT NULL PRIMARY KEY"
        ")";
  }
}

/// *********** */
List<String> getElementsItems() {
  return ["name", "barCode", "category", "soldBy", "madeIn", "prices"];
}

List<String> getElementsDepot() {
  return ["name", "address", "Volume"];
}

List<String> getElementsSupplier() {
  return ["name", "address", "Email", "Phone", "address"];
}

List<String> getElementsWorker() {
  return ["name", "address", "Email", "Phone", "address", "Position"];
}

List<String> getObjectsNameListAddBillIn() {
  return ["Item", "Supplier", "Worker", "Depot"];
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

  Worker init() {
    return Worker(
        Id: -1,
        name: "",
        address: "",
        phoneNumber: "",
        email: "",
        startTime: "",
        endTime: "",
        status: 0,
        salary: 0);
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
  late final String billsID; // table name,
  late final String depotListItem; // table name

  Depot(
      {required this.Id,
      required this.address,
      required this.name,
      required this.capacity,
      required this.availableCapacity,
      required this.billsID,
      required this.depotListItem});

  // read Depot from json object
  Depot.fromJson(Map<String, dynamic> json) {
    Id = json['id'];
    name = json['name'];
    address = json['address'];

    capacity = json['capacity'];
    availableCapacity = json['availableCapacity'];
    billsID = json['billsID'];

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
    _data['billsID'] = billsID;

    _data['depotListItem'] = depotListItem;

    return _data;
  }

  Depot init() {
    return Depot(
        Id: -1,
        address: "",
        name: "",
        capacity: 0,
        availableCapacity: 0,
        billsID: "",
        depotListItem: "");
  }

  // Create sql table
  String createSqlTable() {
    return "CREATE TABLE $depotTableName ("
        "id INTEGER PRIMARY KEY,"
        "name TEXT,"
        "address TEXT,"
        "capacity REAL,"
        "availableCapacity REAL,"
        "billsID TEXT,"
        "depotListItem TEXT"
        ")";
  }
}

class ItemsDepot {
  late final int id;
  late final int itemId;
  late final double number;

  late final int billId;
  late final int itemBillId;
  late final String itemBillIdOut;

  ItemsDepot(
      {required this.id,
      required this.itemId,
      required this.itemBillId,
      required this.number,
      required this.billId,
      required this.itemBillIdOut});

  // read ItemsDepot from json object
  ItemsDepot.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    itemId = json['itemId'];
    itemBillId = json['itemBillId'];

    number = json['number'];
    billId = json['billId'];
    itemBillIdOut = json['itemBillIdOut'];
  }
  //from json to ItemsDepot
  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['itemId'] = itemId;
    _data['itemBillId'] = itemBillId;

    _data['number'] = number;
    _data['billId'] = billId;
    _data['itemBillIdOut'] = itemBillIdOut;
    return _data;
  }

  // Create sql table
  String createSqlTable({required String tableName}) {
    return "CREATE TABLE $tableName ("
        "id INTEGER PRIMARY KEY,"
        "itemId INTEGER,"
        "itemBillId INTEGER,"
        "number INTEGER,"
        "billId INTEGER,"
        "itemBillIdOut TEXT"
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

// an object user to show data
class ShowObject {
  late final String value0;
  late final String value1;
  late final String value2;
  late final String value3;
  late final String value4;
  late final String value5;
  ShowObject(
      {required this.value0,
      this.value1 = "",
      this.value2 = "",
      this.value3 = "",
      this.value4 = "",
      this.value5 = ""});
  ShowObject.fromJson(Map<String, dynamic> json) {
    value0 = json['value0'];
    value1 = json['value1'];
    value2 = json['value2'];
    value3 = json['value3'];
  }
  ShowObject.fromJsonItem(Map<String, dynamic> json) {
    value0 = json['name'];
    value1 = json['actualPrice'].toStringAsFixed(2);
    value2 = json['category'];
    value3 = json['madeIn'];
  }
  ShowObject.fromJsonWorker(Map<String, dynamic> json) {
    value0 = json['name'];
    value1 = json['address'];
    value2 = json['phoneNumber'];
    value3 = json['email'];
  } //"name", "address", "Email", "Phone", "address"
  ShowObject.fromJsonSupplier(Map<String, dynamic> json) {
    value0 = json['name'];
    value1 = json['address'];
    value2 = json['phoneNumber'];
    value3 = json['email'];
  }
  ShowObject.fromJsonDepot(Map<String, dynamic> json) {
    value0 = json['name'];
    value1 = json['address'];
    value2 = json['capacity'].toString();
    value3 = json['availableCapacity'].toString();
  }
  //from json to Worker
  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['value0'] = value0;
    _data['value1'] = value1;

    _data['value2'] = value2;
    _data['value3'] = value3;

    return _data;
  }
}
