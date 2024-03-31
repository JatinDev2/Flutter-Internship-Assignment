import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:quantmhill_assignment/App%20Constants/ColorsManager.dart';
import 'package:quantmhill_assignment/Models/employee_model.dart';
import 'package:quantmhill_assignment/Providers/auth_provider.dart';
import 'package:quantmhill_assignment/Providers/employee_provider.dart';
import 'package:quantmhill_assignment/Providers/profile_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:quantmhill_assignment/Screens/splash_screen.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await GetStorage.init('LoginData');
//   final appDocumentDir = await path_provider.getApplicationDocumentsDirectory();
//   Hive.init(appDocumentDir.path);
//   await Hive.openBox('employeesBox');
//
//   await Firebase.initializeApp();
//   runApp(const MyApp());
// }

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init('LoginData');
  final appDocumentDir = await path_provider.getApplicationDocumentsDirectory();
  Hive.init(appDocumentDir.path);
  Hive.registerAdapter(EmployeeAdapter());
  await Hive.openBox('employeesBox');
  await Firebase.initializeApp();
  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => EmployeeProvider()),
        ChangeNotifierProvider(create: (_) => FirebaseAuthProvider()),
        ChangeNotifierProvider(create: (_) => FirestoreUserProvider()),
      ],
      child: MaterialApp(
        title: 'Employee App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: ColorsManager.primaryGreen,
          appBarTheme: const AppBarTheme(
            backgroundColor: ColorsManager.primaryGreen,
            iconTheme: IconThemeData(color: ColorsManager.textLight),
          ),
          buttonTheme: const ButtonThemeData(
            buttonColor: ColorsManager.primaryGreen,
            textTheme: ButtonTextTheme.primary,
          ),

          useMaterial3: true,
        ),
        home: const SplashScreen(),
      ),
    );
  }
}
