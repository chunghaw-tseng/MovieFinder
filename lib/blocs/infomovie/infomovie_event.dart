import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

abstract class InfoMovieEvent extends Equatable {
  const InfoMovieEvent();
}

class InfoMovieRequested extends InfoMovieEvent {
  final int id;

  const InfoMovieRequested({@required this.id}) : assert(id != null);

  @override
  List<Object> get props => [id];
}
