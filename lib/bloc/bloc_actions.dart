import 'package:flutter/foundation.dart' show immutable;
import 'package:learning_bloc1/bloc/person.dart';
// import '../ignore.dart';

// enum PersonUrl {
//   persons1,
//   persons2,
// }

// extension UrlString on PersonUrl {
//   String get urlString {
//     switch (this) {
//       case PersonUrl.persons1:
//TODO: Only works with my IP address (Only on Emulator)
// and should tick in this in Live Server's settings
// Live Server > Settings: Use Local Ip
// Use Local Ip as Host
//         return address1;
//       case PersonUrl.persons2:
//         return address2;
//     }
//   }
// }

typedef PersonsLoader = Future<Iterable<Person>> Function(String url);

@immutable
abstract class LoadAction {
  const LoadAction();
}

@immutable
class LoadPersonsAction implements LoadAction {
  final String url;
  final PersonsLoader loader;

  const LoadPersonsAction({required this.url, required this.loader}) : super();
}
