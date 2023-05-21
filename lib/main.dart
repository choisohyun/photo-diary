import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:photodiary/pages/auth_page.dart';
// import 'package:photodiary/pages/firestore_page.dart';
// import 'package:photodiary/pages/storage_page.dart';

import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // await FirebaseRemoteConfig.instance.setConfigSettings(RemoteConfigSettings(
  //   fetchTimeout: const Duration(minutes: 1),
  //   minimumFetchInterval: const Duration(minutes: 1),
  // ));
  // await FirebaseRemoteConfig.instance
  //     .setDefaults(const {"platformString": "Hello!"});

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _State();
}

class _State extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text("Flutter Firebase Demo"),
        ),
      ),
      body: Center(
        child: ListView(
          children: [
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (context) => const AuthPage()),
                      );
                    },
                    child: const Text("Authentication"))),
            // Container(height: 10),
            // Padding(
            //     padding: const EdgeInsets.symmetric(horizontal: 12),
            //     child: ElevatedButton(
            //         onPressed: () {
            //           Navigator.of(context).push(MaterialPageRoute(
            //               builder: (context) => const FirestorePage()));
            //         },
            //         child: const Text("Cloud Firestore"))),
            // Container(height: 10),
            // Padding(
            //     padding: const EdgeInsets.symmetric(horizontal: 12),
            //     child: ElevatedButton(
            //         onPressed: () {
            //           Navigator.of(context).push(MaterialPageRoute(
            //               builder: (context) => const StoragePage()));
            //         },
            //         child: const Text("Storage"))),
          ],
        ),
      ),
    );
  }
}
