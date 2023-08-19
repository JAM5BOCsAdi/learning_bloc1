import 'package:flutter/foundation.dart' show immutable;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_bloc1/bloc/bloc_actions.dart';
import 'package:learning_bloc1/bloc/person.dart';

extension IsEqualIgnoringOrdering<T> on Iterable<T> {
  bool isEqualIgnoringOrdering(Iterable<T> other) =>
      length == other.length && {...this}.intersection({...other}).length == length;
}

@immutable
class FetchResult {
  // This is the OutPut
  final Iterable<Person> persons;
  final bool isRetrievedFromCache;

  const FetchResult({
    required this.persons,
    required this.isRetrievedFromCache,
  });

  @override
  String toString() => 'FetchResult (isRetrievedFromCache = $isRetrievedFromCache, persons = $persons)';

  @override
  bool operator ==(covariant FetchResult other) =>
      persons.isEqualIgnoringOrdering(other.persons) && isRetrievedFromCache == other.isRetrievedFromCache;

  @override
  int get hashCode => Object.hash(
        persons,
        isRetrievedFromCache,
      );
}

class PersonsBloc extends Bloc<LoadAction, FetchResult?> {
  final Map<String, Iterable<Person>> _cache = {};

  //TODO: TEST 1

  // This line is what we are testing in persons_bloc_test.dart:
  // The [PersonsBloc] should be [null] at the beginning.
  PersonsBloc() : super(null) {
    on<LoadPersonsAction>(
      (event, emit) async {
        // Cache-ing: If we fetched the person's url, we are not going to fetch it the next time again.
        // If we already have the results like fetched and parse,
        // then we are going to store them in some sort of cache and once you ask for that same data again,
        // than we are going to fetch that result from the catch.
        final url = event.url;
        if (_cache.containsKey(url)) {
          final cachedPersons = _cache[url]!;
          final result = FetchResult(
            persons: cachedPersons,
            isRetrievedFromCache: true,
          );
          emit(result);
        } else {
          final loader = event.loader;
          final persons = await loader(url);
          _cache[url] = persons;
          final result = FetchResult(
            persons: persons,
            isRetrievedFromCache: false,
          );
          emit(result);
        }
      },
    );
  }
}
