import 'package:flutter/material.dart';
import 'package:moviefinder/models/models.dart';
import 'package:moviefinder/repository/apiprovider_service.dart';

class TMDBApi {
  final ApiProviderService apiProvider;
  TMDBApi({@required this.apiProvider}) : assert(apiProvider != null);

  /// Repository call should probably return a list of movies
  Future<MovieSearch> searchMovieByKeyword(String keyword, int page) async {
    debugPrint("Search by keyword $keyword");
    final response = await apiProvider.getWithParams(
        "/3/search/movie", {"page": page.toString(), "query": keyword});
    print(response);
    return MovieSearch.fromJson(response);
  }

  Future<Movie> fetchMovie(int movieId) async {
    final movieJson = await apiProvider.get('/3/movie/$movieId');
    print(movieJson);
    return Movie.fromJson(movieJson);
  }
}
