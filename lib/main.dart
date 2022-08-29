import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:tutorial/firebase_options.dart';
import 'package:package_info/package_info.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.android);
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Future<bool> remoteConfig() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String appVersion = packageInfo.version;
    print(appVersion);
    RemoteConfig remoteConfig = RemoteConfig.instance;
    remoteConfig.setConfigSettings(RemoteConfigSettings(
      fetchTimeout: Duration(seconds: 60),
      minimumFetchInterval: Duration(seconds: 1),
    ));
    await remoteConfig.fetchAndActivate();
    String remoteConfigVersion = remoteConfig.getString('appVersion');
    print(remoteConfigVersion);

    if (remoteConfigVersion.compareTo(appVersion) == 1) {
      return true;
    } else {
      return false;
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Firebase'),
          centerTitle: true,
        ),
        body: FutureBuilder(
          future: remoteConfig(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else {
              return Center(
                child: Text(snapshot.data == true
                    ? 'you need to update'
                    : 'all successful updateed'),
              );
            }
          },
        ),
      ),
    );
  }
}
