import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:trip_folder/trip.dart';


class TripsDatabase {
  static final TripsDatabase instance = TripsDatabase._init();

  static Database? _database;

  TripsDatabase._init();

  Future<Database> get database async {
    if(_database != null){
      return _database!;
    }

    _database = await _initDB('trips.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 4, onCreate: _createDB, onUpgrade: _onUpgrade);
  }

  Future _onUpgrade(Database db, int version, int newVersion) async {
    _createDB(db, newVersion);
  }
  
  Future deleteTripsTable() async {

    final db = await instance.database;
    
    db.rawDelete("DROP TABLE IF EXISTS $tableTrips");
  }

  Future _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';
    const textTypeNullable = 'TEXT';

  await db.execute('''
  CREATE TABLE $tableTrips (
    ${TripFields.tripId} $idType,
    ${TripFields.title} $textType,
    ${TripFields.description} $textType,
    ${TripFields.price} $textType,
    ${TripFields.creationDate} $textType,
    ${TripFields.startingDate} $textTypeNullable,
    ${TripFields.finishingDate} $textTypeNullable,
    ${TripFields.state} $textType
  )
  ''');
  }

  Future<Trip> create(Trip trip) async{
    final db = await instance.database;

    final id = await db.insert(tableTrips, trip.toJson());

    return trip.copy(id: id);
  }

  Future<Trip> readTrip(int id) async{
    final db = await instance.database;

    final maps = await db.query(
      tableTrips,
      columns: TripFields.values,
      where: '${TripFields.tripId} = ?',
      whereArgs: [id],
    );

    if(maps.isNotEmpty){
      return Trip.fromJson(maps.first);
    }
    else{
      throw Exception('ID $id not found');
    }
  }

  Future<List<Trip>> readAllTrips() async{
    final db = await instance.database;

    final result = await db.query(tableTrips);

    return result.map((json) => Trip.fromJson(json)).toList();
  }


  Future<int> update(Trip trip) async{
    final db = await instance.database;

    return db.update(
      tableTrips,
      trip.toJson(),
      where: '${TripFields.tripId} = ?',
      whereArgs: [trip.tripId]
    );
  }

  Future<int> delete(int? id) async{
    final db = await instance.database;

    return db.delete(
        tableTrips,
        where: '${TripFields.tripId} = ?',
        whereArgs: [id]
    );
  }

  Future close() async {
    final db = await instance.database;

    db.close();
  }
}