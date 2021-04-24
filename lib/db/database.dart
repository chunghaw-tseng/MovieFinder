import 'dart:io';
import 'package:moviefinder/models/models.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

class DBProvider {
  DBProvider._();
  static final DBProvider db = DBProvider._();

  static Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;

    // if _database is null we instantiate it
    _database = await initDB();
    return _database;
  }

  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "MovieFinder.db");
    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
      await db.execute('''CREATE TABLE Favorites (
          movie_id INTEGER PRIMARY KEY,
          title TEXT,
          poster_path TEXT,
          vote_average DOUBLE
          )''');
    });
  }

  /// Using Raw insert
  newFavoriteMovie(Movie newMovie) async {
    final db = await database;
    await db.insert("Favorites", {
      "movie_id": newMovie.id,
      "title": newMovie.title,
      "poster_path": newMovie.posterPath,
      "vote_average": newMovie.voteAverage
    });
    return getallFavoriteMovies();
  }

  findFavoriteMovie(int id) async {
    final db = await database;
    var result =
        await db.rawQuery('SELECT * FROM Favorites WHERE movie_id=?', [id]);
    List<Movie> list =
        result.isNotEmpty ? result.map((c) => Movie.fromMap(c)).toList() : [];
    return list;
  }

  /// Get All
  getallFavoriteMovies() async {
    final db = await database;
    var res = await db.query("Favorites");
    List<Movie> list =
        res.isNotEmpty ? res.map((c) => Movie.fromMap(c)).toList() : [];
    return list;
  }

  deleteFavoriteMovie(int id) async {
    final db = await database;
    db.delete("Movie", where: "id = ?", whereArgs: [id]);
    return getallFavoriteMovies();
  }
}
