

import 'package:sqflite/sqflite.dart';
import 'package:tracker_firmware/Const_TermAndFunction/dataBase/dbSetUp.dart';
import 'package:tracker_firmware/Const_TermAndFunction/generalMethods.dart';

Future<bool> createLogTable() async {
  final treeTableExists = await DataBase.database
      .rawQuery('SELECT * FROM sqlite_master WHERE type="table" AND name="${DbTableName.dfuLogs}";')
      .then((result) => result.isNotEmpty);
  printFunc("createing master");
  if (!treeTableExists) {
    printFunc('treeTableExists table is not created. Creating it now...');

// Create the "flower" table if it doesn't exist
//     await DataBase.database.execute("DROP TABLE IF EXISTS ${DbTableName.dfuLogs}");
    await DataBase.database.execute(
      ''' CREATE TABLE IF NOT EXISTS ${DbTableName.dfuLogs} (
      mobileDeviceId TEXT,
      employeeId TEXT,
      motherboardId TEXT,
      actionTimestamp TEXT,
      softwareVersion TEXT,
      status TEXT,
      message TEXT,
      PRIMARY KEY (mobileDeviceId, motherboardId, actionTimestamp)
      
    )''',
    );

    printFunc('Database created. treeMaster');
  }
  return true;
}
/// Insert log entry
Future<void> insertIntoLogs(Map<String, dynamic> body) async {
if (DataBase.database == null) {
throw Exception("Database not initialized. Call initializeDatabase() first.");
}

await DataBase.database.insert(
DbTableName.dfuLogs,
body,
conflictAlgorithm: ConflictAlgorithm.replace, // avoids duplicate crashes
);
}

 Future<List<Map<String, dynamic>>> getAllLogs() async {
if (DataBase.database == null) {
throw Exception("Database not initialized. Call initializeDatabase() first.");
}

return await DataBase.database!.query(DbTableName.dfuLogs);
}
 Future<bool> hasLogs() async {
if (DataBase.database == null) {
throw Exception("Database not initialized. Call initializeDatabase() first.");
}

final result = await DataBase.database!.rawQuery(
"SELECT COUNT(*) as count FROM ${DbTableName.dfuLogs}",
);

int count = Sqflite.firstIntValue(result) ?? 0;
return count > 0; // true if table has data, false if empty
}
 Future<void> deleteFromLogs(Map<String, dynamic> body) async {
if (DataBase.database == null) {
throw Exception("Database not initialized. Call initializeDatabase() first.");
}

await DataBase.database!.delete(
DbTableName.dfuLogs,
where: "mobileDeviceId = ? AND motherboardId = ? AND actionTimestamp = ?",
whereArgs: [
body["mobileDeviceId"],
body["motherboardId"],
body["actionTimestamp"],
],
);
}
