import 'package:moviefinder/models/models.dart';
import 'package:sqflite/sqflite.dart';
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
    String dbPath = await getDatabasesPath();
    String path = join(dbPath, "MovieFinder.db");
    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
      await db.execute('''CREATE TABLE Favorites (
          movie_id INTEGER PRIMARY KEY,
          title TEXT,
          poster_path TEXT,
          genres TEXT,
          vote_average DOUBLE,
          release_date TEXT
          )''');
    });
  }

  newFavoriteMovie(Movie newMovie) async {
    final db = await database;
    print("${newMovie.genresToString()}");
    await db.insert("Favorites", {
      "movie_id": newMovie.id,
      "title": newMovie.title,
      "genres": newMovie.genresToString(),
      "poster_path": newMovie.posterPath,
      "vote_average": newMovie.voteAverage,
      "release_date": newMovie.releaseDate,
    });
    return getallFavoriteMovies();
  }

  getallFavoriteMovies() async {
    final db = await database;
    var res = await db.query("Favorites");
    List<Movie> list =
        res.isNotEmpty ? res.map((c) => Movie.fromMap(c)).toList() : [];
    return list;
  }

  deleteFavoriteMovie(int id) async {
    final db = await database;
    await db.delete("Favorites", where: "movie_id = ?", whereArgs: [id]);
    return getallFavoriteMovies();
  }
}
