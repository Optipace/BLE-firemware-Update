import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:tracker_firmware/Const_TermAndFunction/generalMethods.dart';

class DataBase {
  static var database;
  static final dbPath = getDatabasesPath();

  DataBase(db) {
    database = db;
    // deleteDatabase(join(await dbPath, 'epeekDB.db'));
  }

  static Future<void> initializeDatabase() async {
    final db = await openDatabase(join(await dbPath, 'DFI_Trackr.db'),
        version: 1, onCreate: (db, version) async {
      // Define your database schema here if needed
    }, onOpen: (db) {
      printFunc("db Opened");
    });

    // Set the database instance
    setDB(db);
  }

  static void setDB(db) async {
    printFunc("DB Set to database : ${db.runtimeType}");
    database = db;
  }

  static void deleteDB() async {
    await database.deleteDatabase(dbPath);
    await database.close();
  }
}

class DbTableName {
  static const String dfuLogs = "dfuLogs";
}
