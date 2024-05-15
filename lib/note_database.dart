import 'package:note_app/note.dart';
import 'package:sqflite/sqflite.dart' as sql;
import 'package:sqflite/sql.dart';
import 'package:sqflite/sqlite_api.dart';

class NoteDatabase {
  static Future<void> createTable(sql.Database database) async {
    await database.execute(
      """
      CREATE TABLE note(
         id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
         title TEXT NOT NULL,
         desc TEXT NOT NULL,
         time TEXT NOT NULL,
         color_id INTEGER NOT NULL
      )
      """
    );
  }
  static Future<sql.Database> db() async {
    return sql.openDatabase( // database yaratilishi
      "note.db", // database nomi
      version: 1, // database versiyasi
      onCreate: (database, version) async {
        return createTable(database); // table yaratilishi
      }
    );
  }
  static Future<void> saveNote(Note note) async { // note -> import qil
    final database = await db();
    await database.insert('note', note.toJson(),conflictAlgorithm: ConflictAlgorithm.ignore);
  }
  static Future<List<Note>> getAllNotes() async {
    final database = await db(); // database
    final List<Note> notes = []; // list of notes
    final maps = await database.query("note", orderBy: "id");
    for(var s in maps) {
      notes.add(Note.fromJson(s)); // map to note class
    }
    return notes; // return note list
  }
  static Future<void> deleteNote(int? id)async {
    final database = await db();
    await database.delete('note',where: "id = ?", whereArgs: [id]);
  }
}