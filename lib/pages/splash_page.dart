import 'dart:async';

import 'package:check_object/core/local_api_service.dart';
// import 'package:check_object/pages/settings_page.dart';
import 'package:check_object/start_screen.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

import '../core/constants.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  late bool exist;
  Timer? timer;

  @override
  void initState() {
    timer = Timer.periodic(
      const Duration(seconds: 10),
      (_) async {
        exist = await LocalApiService().checkExist(Utility.excelFileName);
        if (exist) {
          timer?.cancel();
        } else {
          late String message;
          final connectivityResult = await Connectivity().checkConnectivity();
          if (connectivityResult == ConnectivityResult.none) {
            message = 'Нет доступа к интернету!';
          } else {
            message = 'Не удалось получить файлы с сервера!';
          }
          final snackBar = SnackBar(
            duration: const Duration(seconds: 9),
            backgroundColor: Colors.red,
            content: Text(message),
            /*action: SnackBarAction(
              label: 'Попробовать еще раз',
              onPressed: () async {
                final Uint8List byteData = await RemoteApiService().getData();
                if(byteData.isNotEmpty) {
                  await LocalApiService().saveFile(byteData: byteData);
                }
                print('ok');
              },
            ),*/
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 0, 70, 70),
        centerTitle: true,
        title: const Text(
          'Контроль',        
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
          ),
        ),
        actions: [
          // IconButton(
          //   icon: const Icon(
          //     Icons.settings, 
          //     color: Colors.white,
          //   ),
          //   onPressed: () {
          //     Navigator.push(
          //       context,
          //       MaterialPageRoute(builder: (context) => const SettingsPage()),
          //     );
          //   },
          // ),
        ],
      ),
      body: const StartScreen());
  }
}
