import 'dart:io';


import 'package:m_expense_app/models/Expense%20Model/expense_entity.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:path/path.dart';


class DBProvider2 {
  DBProvider2._(); 
  static final  DBProvider2 db = DBProvider2._(); //Tạo một private constructor chỉ có thể được sử dụng bên trong class

 
  // DBProvider._privateConstructor();
  // static final DBProvider instance = DBProvider._privateConstructor();

  static Database? _database2; //Tạo một biến database, ? là biến có thể null

  // tạo database object và cung cấp cho nó một getter
  Future<Database> get database2 async {
    if (_database2 != null) return _database2!; //Nếu database đã tồn tại thì trả về database đó
    _database2 = await _initDB(); //Nếu database chưa tồn tại thì gọi hàm initDB để tạo database
    return _database2!;
  }
    // if (_database != null) return await_database; //Nếu database đã tồn tại thì trả về database đó

  //    static Database? _database;
  // Future<Database> get database async =>
  //     _database ??= await _initiateDatabase();
  // The ??= operator will check if _database is null and set it to the value of await _initiateDatabase() if that is the case and then return the new value of _database.
  // If _database already has a value, it will just be returned.

    // _database = await initDB(); //Nếu database chưa tồn tại thì tạo database mới
    // return _database;
  
  _initDB() async {
      // var databasesPath = await getDatabasesPath();
      // String path = join(databasesPath, 'TripDB.db');
      Directory documentsDirectory = await getApplicationDocumentsDirectory();
      String path = join(documentsDirectory.path, "ExpenseDB.db");
      return await openDatabase(path, version: 6, onOpen: (db) {

      },
      // 'ExpenseDB.db', //Tên database
      // version: 1, //Version của database
      // onOpen: (db) {}, //Hàm được gọi khi database được mở
      onCreate: (Database db, int version) async {
        await db.execute(
          "CREATE TABLE IF NOT EXISTS Expense ("
          "id INTEGER PRIMARY KEY AUTOINCREMENT,"
          "type TEXT NOT NULL,"
          "amount INTEGER NOT NULL,"
          "date TEXT NOT NULL,"
          "comments TEXT,"
          "trip INTEGER NOT NULL,"
          "FOREIGN KEY (trip) REFERENCES Trip(id))");
      });
  }

  // Define a function that inserts trips into the database
  Future<void> newExpense(ExpenseEntity expense) async {
  // Get a reference to the database.
  final db = await database2;
  print("expense: $expense" );

  // Insert the Trip into the correct table. You might also specify the
  // `conflictAlgorithm` to use in case the same trip is inserted twice.
  // conflictAlgorithm để xử lý trường hợp trùng lặp dữ liệu khi thêm vào database (thêm vào 1 dữ liệu đã tồn tại)
  //
  // In this case, replace any previous data. - Trong trường hợp này, hãy thay thế mọi dữ liệu trước đó.
  await db.insert(
    'Expense',
    expense.toMap(),
    conflictAlgorithm: ConflictAlgorithm.replace,
  );
}

  //GET Expense BY ID
  getExpense(int id) async {
    final db = await database2;
    var res =await  db.query("Expense", where: "id = ?", whereArgs: [id]);
    return res.isNotEmpty ? ExpenseEntity.fromMap(res.first) : Null ;
  }

  //get all expenses from the database
  Future<List<ExpenseEntity>> getAllExpensesFromDatabase() async {
    final db = await database2;
    var res = await db.query("Expense");
    List<ExpenseEntity> list =
        res.isNotEmpty ? res.map((c) => ExpenseEntity.fromMap(c)).toList() : [];
    return list;
  }


  //A method take expenses by trip
  Future<List<ExpenseEntity>> getExpensesByTrip(int tripId) async {
    final db = await database2;
    final List<Map<String, dynamic>> maps = await db.query('Expense');

  print("số lượng expense là: $maps");

  

    // final List<Map<String, dynamic>> maps = await db.query("Expense", where: "trip = ?", whereArgs: [tripId.toString()]);

  // Query expense where trip.
  // Convert the List<Map<String, dynamic> into a List<ExpenseEntity>.
  // Convert the List<Map<String, dynamic> into a List<Dog>.
  return List.generate(maps.length, (i) {
    return ExpenseEntity(
      maps[i]['id'],
      maps[i]['type'],
      maps[i]['amount'],
      maps[i]['date'],
      maps[i]['comments'],
      maps[i]['trip'],
    );
  });
  }

  //get all expenses from a tripId
  Future<List<ExpenseEntity>> getAllExpenses(int tripId) async {
    final db = await database2;
    final List<Map<String, dynamic>> maps = await db.query('Expense', where: "trip = ?", whereArgs: [tripId.toString()]);



  print("dữ liệu expense: ");
  print(maps);
    // final List<Map<String, dynamic>> maps = await db.query("Expense", where: "trip = ?", whereArgs: [tripId.toString()]);
    return List.generate(maps.length, (i) {
      return ExpenseEntity(
        maps[i]['id'],
        maps[i]['type'],
        maps[i]['amount'],
        maps[i]['date'],
        maps[i]['comments'],
        maps[i]['trip'],
      );
    });
  }

  // update Expense from database
   Future<void> updateExpense (ExpenseEntity oldExpense, ExpenseEntity newExpense) async {
    final db = await database2;
    await db.update("Expense", newExpense.toMap(),
        where: "id = ?", whereArgs: [oldExpense.id]);
  }

  //delete Expense from database
  deleteExpense(int id) async {
    final db = await database2;
    db.delete("Expense", where: "id = ?", whereArgs: [id]);
  }

  //delete all Expenses from database
  deleteAllExpense() async {
    final db = await database2;
    db.rawDelete("DELETE FROM Expense");
  }


}
