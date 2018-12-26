import 'dart:async';
import 'model.dart';
import 'package:rxdart/rxdart.dart';

class MovieBloc {
  final API api;
  // Create empty streems
  Stream<List<Movie>> _results = Stream.empty();
  Stream<String> _log = Stream.empty();
  // This subject allows sending data, error and done events to the listener.
  ReplaySubject<String> _query = ReplaySubject<String>();

  // getters for getting streems in outher world :)
  Stream<String> get log => _log;
  Stream<List<Movie>> get result => _results;
  Sink<String> get query => _query;

  // bloc constructor
  MovieBloc(this.api) {
    // distinct this is like a debounce.
    _results = _query.distinct().asyncMap(api.get).asBroadcastStream();
    _log = Observable(_results)
      .withLatestFrom(_query.stream, (_, query) => 'Results for $query')
      .asBroadcastStream();
  }

  // closing streem
  void dispose() {
    _query.close();
  }
}
