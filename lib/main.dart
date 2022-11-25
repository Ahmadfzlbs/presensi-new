import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:smk1c/app/controllers/page_index_controller.dart';
import 'firebase_options.dart';
import 'package:get/get.dart';
import 'app/routes/app_pages.dart';
import 'package:timezone/data/latest.dart' as tz;


late var timeNow;
late DateTime now;
DateTime? timeServer;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  tz.initializeTimeZones();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  final pageC = Get.put(PageIndexController(), permanent: true);

  runApp(
    StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if(snapshot.connectionState == ConnectionState.waiting){
          return MaterialApp(
            home: Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          );
        }
        return GetMaterialApp(
          localizationsDelegates: [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: [
            const Locale('id', 'ID')
          ],
          debugShowCheckedModeBanner: false,
          title: "Application",
          initialRoute: snapshot.data != null ? Routes.HOME : Routes.LOGIN,
          getPages: AppPages.routes,
        );
      }
    ),
  );
}
