import 'package:sqflite/sqflite.dart' as sql;

class DBHelper {
  static Future<void> createTables(sql.Database database) async {
    await database.execute(
        'CREATE TABLE myNotes(id INTEGER PRIMARY KEY, title TEXT, description TEXT)');
  }

  static Future<sql.Database> database() async {
    return sql.openDatabase(
      'myNotes.db',
      version: 1,
      onCreate: (sql.Database database, int version) async {
        // debug statement
        print('..Creating tables');
        await createTables(database);
      },
    );
  }

  static Future<int> insertMyNote(String title, String? description) async {
    final sql.Database db = await DBHelper.database();

    final data = {
      'title': title,
      'description': description,
    };
    final id = await db.insert('myNotes', data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
    print('..Inserted $id');
    return id;
  }

  static Future<List<Map<String, dynamic>>> getMyNotes() async {
    final sql.Database db = await DBHelper.database();
    final notes = await db.query('myNotes');
    print('..Got ${notes.length} rows');
    return notes;
  }

  // getMyNotesById widgets.id
  static Future<List<Map<String, dynamic>>> getMyNotesById(int id) async {
    final sql.Database db = await DBHelper.database();
    final notes = await db.query('myNotes', where: 'id = ?', whereArgs: [id]);
    print('..Got ${notes.length} rows');
    return notes;
  }

  static Future<int> updateMyNote(
      int id, String title, String? description) async {
    final sql.Database db = await DBHelper.database();
    final data = {
      'title': title,
      'description': description,
    };
    final count =
        await db.update('myNotes', data, where: 'id = ?', whereArgs: [id]);
    print('..Updated $count rows');
    return count;
  }

  static Future<int> deleteMyNote(int id) async {
    final sql.Database db = await DBHelper.database();
    final count = await db.delete('myNotes', where: 'id = ?', whereArgs: [id]);
    print('..Deleted $count rows');
    return count;
  }

  // search
  static Future<List<Map<String, dynamic>>> searchMyNotes(String query) async {
    final sql.Database db = await DBHelper.database();
    final notes = await db.query('myNotes',
        where: 'title LIKE ? OR description LIKE ?',
        whereArgs: ['%$query%', '%$query%']);
    print('..Got ${notes.length} rows');
    return notes;
  }
}
