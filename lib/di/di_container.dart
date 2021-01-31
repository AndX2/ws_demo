import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:ws_demo/di/di_container.config.dart';

final getIt = GetIt.instance;

@InjectableInit()
Future initDi() async => await $initGetIt(getIt);
