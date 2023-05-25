
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/services.dart';

import '../Static.dart';
import 'API/api_service.dart';
import 'package:flutter/material.dart';
import 'HomePage.dart';
import 'connexion_page.dart';
class MyHttpOverrides extends HttpOverrides{
  @override
  HttpClient create_HttpClient(SecurityContext context){
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port)=> true;
  }
}
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (Platform.isAndroid) {
    print('L\'application est en cours d\'exécution sur Android.');
    ByteData data = await PlatformAssetBundle().load('assets/ca/lets-encrypt-r3.pem');
    SecurityContext.defaultContext.setTrustedCertificatesBytes(data.buffer.asUint8List());
  } else if (Platform.isIOS) {
    print('L\'application est en cours d\'exécution sur iOS.');
    ByteData data = await PlatformAssetBundle().load('assets/ca/lets-encrypt-r3.pem');
    SecurityContext.defaultContext.setTrustedCertificatesBytes(data.buffer.asUint8List());
  } else if (Platform.isWindows) {
    print('L\'application est en cours d\'exécution sur Windows.');

  } else if (Platform.isMacOS) {
    print('L\'application est en cours d\'exécution sur macOS.');
  } else if (Platform.isLinux) {
    print('L\'application est en cours d\'exécution sur Linux.');
  } else {
    print('La plateforme actuelle n\'est pas reconnue par Flutter.');
  }
   MongoDatabase.connect();
  runApp(MyApp());
  sessionA = await MongoDatabase.getAgentSession();
}

class MyApp extends StatelessWidget {
  MyApp({super.key});


  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GGC & PARTENAIRES',
      debugShowCheckedModeBanner: false,
      color: primaryColor,
      theme: ThemeData(
          useMaterial3: true,
          fontFamily: "UnifrakturCook",
          textTheme: ThemeData.light()
              .textTheme
              .copyWith(headline2: TextStyle(fontFamily: 'UnifrakturCook'))),
      home: sessionA?const HomePage():ConnexionPage()
    );
  }
}
