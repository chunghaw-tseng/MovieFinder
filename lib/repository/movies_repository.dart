import 'package:flutter/material.dart';
import 'package:moviefinder/models/models.dart';
import 'package:moviefinder/repository/repositories.dart';

class MoviesRepository {
  final TMDBApi apiClient;

  MoviesRepository({@required this.apiClient}) : assert(apiClient != null);

  Future<MovieSearch> getMovies(String query, int page) async {
    debugPrint("Getting Movies for $query");
    var results;
    if (query != "") {
      results = await apiClient.searchMovieByKeyword(query, page);
    } else {
      results = await apiClient.discoverMovies(page);
    }
    debugPrint("JSON Finished");
    return results;
  }

  Future<Movie> getMovieData(int movieId) async {
    debugPrint("Getting Movie info for $movieId");
    var movieData = await apiClient.fetchMovie(movieId);
    return movieData;
  }
}
