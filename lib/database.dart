import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

Database? database;

Future<void> _createDb() async {
  String dbPath = await getDatabasesPath();
  String path = join(dbPath, 'cityList.db');
  database = await openDatabase(path, version: 1,
      onCreate: (Database db, int version) async {
    await db.execute('''
      CREATE TABLE locations (
        id INTEGER PRIMARY KEY,
        cityName TEXT AUTOINCREMENT,
      )
     ''');
  });
}

Future<void> insertDb(Database database, dynamic cityName) async {
  await database.insert('locations', {'cityName': cityName});
}

Future<void> deleteData(Database database, dynamic cityName) async {
  await database
      .delete('locations', where: 'cityName = ?', whereArgs: [cityName]);
}

Future<void> selectCityName(Database database, dynamic cityName) async {
  await database.rawQuery(
      'SELECT cityName FROM "locations" WHERE cityName  = ${cityName}');
}
