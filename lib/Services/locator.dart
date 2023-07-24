import 'package:get_it/get_it.dart';
import 'package:public_tax/Services/Apiservices.dart';
import 'package:public_tax/Services/Preferenceservices.dart';

GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton(() => ApiServices());
  locator.registerLazySingleton(() => PreferenceService());
}
