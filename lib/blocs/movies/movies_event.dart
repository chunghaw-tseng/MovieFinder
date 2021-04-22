import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

abstract class MoviesEvent extends Equatable {
  const MoviesEvent();
}

class MoviesRequested extends MoviesEvent {
  final String query;

  const MoviesRequested({@required this.query}) : assert(query != null);

  @override
  List<Object> get props => [query];
}

class NextPageRequested extends MoviesEvent {
  final String query;
  const NextPageRequested({@required this.query}) : assert(query != null);

  @override
  List<Object> get props => [query];
}
