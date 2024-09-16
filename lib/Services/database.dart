import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseService {
  static final DatabaseService _databaseService =
      DatabaseService._privatisedConstructor();
  factory DatabaseService() => _databaseService;

  DatabaseService._privatisedConstructor();

  Future<Database> initDatabase() async {
    final getDirectory = await getApplicationDocumentsDirectory();
    String path = '${getDirectory.path}/pos_db';
    return await openDatabase(path, onCreate: _onCreate, version: 1);
  }

  static Database? _database;
  Future<Database> get getDatabase async {
    if (_database != null) {
      return _database!;
    } else {
      _database = await initDatabase();
      return _database!;
    }
  }
  void _onCreate(Database db, int version) async {
    await db.execute('''
    CREATE TABLE Items(
    name TEXT,
    itemCode INTEGER,
    quantity INTEGER,
    image TEXT
       )
  ''');

  }

  Future<void> deleteTable() async {
    final directory = await getApplicationDocumentsDirectory();
    final path = '${directory.path}/pos_db';
    await deleteDatabase(path);
  }
}
