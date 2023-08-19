import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:learning_bloc1/bloc/bloc_actions.dart';
import 'package:learning_bloc1/bloc/person.dart';
import 'package:learning_bloc1/bloc/persons_bloc.dart';

//TODO: IMPORTANT for TESTING => 2:19:00

// Remember to run "flutter test" and NOT "flutter pub run test"

// Naming should be always end up with "...test.dart"
const mockedPersons1 = [
  Person(name: 'Foo', age: 20),
  Person(name: 'Bar', age: 30),
];

const mockedPersons2 = [
  Person(name: 'Foo', age: 20),
  Person(name: 'Bar', age: 30),
];

Future<Iterable<Person>> mockGetPersons1(String _) => Future.value(mockedPersons1);
Future<Iterable<Person>> mockGetPersons2(String _) => Future.value(mockedPersons2);

void main() {
  group('Testing bloc', () {
    // Write our tests
    late PersonsBloc bloc;

    setUp(() {
      bloc = PersonsBloc();
    });

    //TODO: TEST 1

    // The [PersonsBloc] should be [null] at the beginning.
    blocTest<PersonsBloc, FetchResult?>(
      'Test initial state',
      build: () => bloc,
      //
      // expect(bloc.state, null ) => INSTEAD [null] you can write
      // "const FetchResult(persons: [], isRetrievedFromCache: false)"
      // and the going to be FAILED (-1)
      verify: (bloc) => expect(bloc.state, null),
    );

    //TODO: TEST 2

    // Fetch mock data (persons1) and compare it with FetchResult
    blocTest(
      'Mock retrieving persons from first iterable',
      build: () => bloc,
      act: (bloc) {
        bloc.add(
          const LoadPersonsAction(
            url: 'dummy_url_1',
            loader: mockGetPersons1,
          ),
        );
        bloc.add(
          const LoadPersonsAction(
            url: 'dummy_url_1',
            loader: mockGetPersons1,
          ),
        );
      },
      expect: () => [
        const FetchResult(persons: mockedPersons1, isRetrievedFromCache: false),
        const FetchResult(persons: mockedPersons1, isRetrievedFromCache: true),
      ],
    );

    //TODO: TEST 3

    // Fetch mock data (persons2) and compare it with FetchResult
    blocTest(
      'Mock retrieving persons from second iterable',
      build: () => bloc,
      act: (bloc) {
        bloc.add(
          const LoadPersonsAction(
            url: 'dummy_url_2',
            loader: mockGetPersons2,
          ),
        );
        bloc.add(
          const LoadPersonsAction(
            url: 'dummy_url_2',
            loader: mockGetPersons2,
          ),
        );
      },
      expect: () => [
        const FetchResult(persons: mockedPersons2, isRetrievedFromCache: false),
        const FetchResult(persons: mockedPersons2, isRetrievedFromCache: true),
      ],
    );
  });
}
