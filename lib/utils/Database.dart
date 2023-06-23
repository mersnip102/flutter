import 'dart:io';

import 'package:m_expense_app/models/Trip%20Model/trip_entity.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:path/path.dart';

import '../models/TripModel.dart';

class DBProvider {
  DBProvider._(); 
  static final  DBProvider db = DBProvider._(); //Tạo một private constructor chỉ có thể được sử dụng bên trong class

  
  // DBProvider._privateConstructor();
  // static final DBProvider instance = DBProvider._privateConstructor();

  static Database? _database; //Tạo một biến database
  // tạo database object và cung cấp cho nó một getter
  Future<Database> get database async {
    if (_database != null) return _database!; //Nếu database đã tồn tại thì trả về database đó
    _database = await _initDB(); //Nếu database chưa tồn tại thì gọi hàm initDB để tạo database
    return _database!;
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
      String path = join(documentsDirectory.path, "TripDB.db");
      return await openDatabase(path, version: 8, onOpen: (db) {}, 
      // 'TripDB.db', //Tên database
      // version: 1, //Version của database
      // onOpen: (db) {}, //Hàm được gọi khi database được mở
      onCreate: (Database db, int version) async {
        await db.execute(
          "CREATE TABLE IF NOT EXISTS Trip ("
          "id INTEGER PRIMARY KEY AUTOINCREMENT,"
          "name TEXT NOT NULL, "
          "destination TEXT NOT NULL, "
          "startDate TEXT NOT NULL, "
          "endDate TEXT NOT NULL, "
          "risk TEXT NOT NULL, " 
          "description TEXT, "
          "vehicle TEXT NOT NULL, "
          "contribute TEXT NOT NULL, "
          "location TEXT, "
          "image TEXT)");
      });
  }
  
  // Define a function that inserts trips into the database
  Future<void> newTrip(TripEntity trip) async {
  // Get a reference to the database.
  final db = await database;
  print("trip: $trip" );

  // Insert the Trip into the correct table. You might also specify the
  // `conflictAlgorithm` to use in case the same trip is inserted twice.
  // conflictAlgorithm để xử lý trường hợp trùng lặp dữ liệu khi thêm vào database (thêm vào 1 dữ liệu đã tồn tại)
  //
  // In this case, replace any previous data. - Trong trường hợp này, hãy thay thế mọi dữ liệu trước đó.
  await db.insert(
    'Trip',
    trip.toMap(),
    conflictAlgorithm: ConflictAlgorithm.replace,
  );
}

  //GET TRIP BY ID
  getTrip(int id) async {
    final db = await database;
    var res =await  db.query("Trip", where: "id = ?", whereArgs: [id]);
    return res.isNotEmpty ? TripEntity.fromMap(res.first) : Null ;
  }

  // A method that retrieves all the trips from the trips table.
Future<List<TripEntity>> getAllTrips() async {
  // Get a reference to the database.
  final db = await database;
  print("DB: $db");

  // Query the table for all The Trip.
  final List<Map<String, dynamic>> maps = await db.query('Trip');

  print("dữ liệu trip: ");
  print(maps);

  // Convert the List<Map<String, dynamic> into a List<Dog>.
  return List.generate(maps.length, (i) {
    return TripEntity(
      maps[i]['id'],
      maps[i]['name'],
      maps[i]['destination'],
      maps[i]['startDate'],
      maps[i]['endDate'],
      maps[i]['risk'],
      maps[i]['description'],
      maps[i]['vehicle'],
      maps[i]['contribute'],
      maps[i]['location'],
      maps[i]['image'],
    );
  });
}

  //update trip from database
  updateTrip(int id, TripEntity newTrip) async {
    final db = await database;
    var res = await db.update("Trip", newTrip.toMap(),
        where: "id = ?", whereArgs: [id]);
    return res;
  }

  //delete trip from database
  deleteTrip(int id) async {
    final db = await database;
    db.delete("Trip", where: "id = ?", whereArgs: [id.toString()]);
  }

  //delete all trips from database
  deleteAllTrip() async {
    final db = await database;
    db.rawDelete("DELETE FROM Trip");
  }


}



