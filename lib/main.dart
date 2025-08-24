import 'dart:async';
import 'dart:typed_data';
import 'dart:ui';
import 'package:camera/camera.dart';
import 'package:check_object/core/constants.dart';
import 'package:check_object/model/persistence/first_run_storage.dart';
import 'package:check_object/pages/splash_page.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service_platform_interface/flutter_background_service_platform_interface.dart';
import 'package:check_object/core/local_api_service.dart';
import 'package:check_object/core/remote_api_service.dart';
import 'package:check_object/core/start_background.dart';
import 'package:check_object/model/selected_item.dart';
import 'package:check_object/providers/multi_select_provider.dart';
import 'package:check_object/providers/house_objects.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

List<CameraDescription> cameras = [];

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final SharedPreferences prefs = await SharedPreferences.getInstance();

  if (FirstRunStorage(prefs).getIsFirstRun()) {
    print('First app start');
    final connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult != ConnectivityResult.none) {
      final Uint8List byteData = await RemoteApiService().getData();
      if (byteData.isNotEmpty) {
        await LocalApiService().saveFile(byteData: byteData);
        FirstRunStorage(prefs).setIsFirstRun(value: false);
      }
    }
  }

  try {
    cameras = await availableCameras();
  } catch (e) {}

  if (!kIsWeb) {
    await StartBackground().initializeService();
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => MultiSelectProvider()),
        ChangeNotifierProvider(create: (_) => HouseObjects()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          fontFamily: 'Montserrat Bold',
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF004646),
            brightness: Brightness.light,
          ),
        ),
        home: const SplashPage(),
      ),
    );
  }
}

@pragma('vm:entry-point')
Future<bool> onIosBackground(ServiceInstance service) async {
  WidgetsFlutterBinding.ensureInitialized();
  DartPluginRegistrant.ensureInitialized();
  return true;
}

@pragma('vm:entry-point')
void onStart(ServiceInstance service) async {
  DartPluginRegistrant.ensureInitialized();

  service.on('stopService').listen((event) {
    service.stopSelf();
  });

  Timer.periodic(const Duration(seconds: 60), (timer) async {
    final exist = await LocalApiService().checkExist(Utility.excelFileName);
    if (!exist) {
      final connectivityResult = await Connectivity().checkConnectivity();
      if (connectivityResult != ConnectivityResult.none) {
        final Uint8List byteData = await RemoteApiService().getData();
        if (byteData.isNotEmpty) {
          await LocalApiService().saveFile(byteData: byteData);
        }
      }
    }
  });

  Timer.periodic(const Duration(seconds: 30), (timer) async {
    final connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult != ConnectivityResult.none) {
      final List<SelectedItem> selectedItems =
          await LocalApiService().fromFile(FileTypeApi.json);

      if (selectedItems.isNotEmpty) {
        final SelectedItem selectedItem = selectedItems.last;

        try {
          final metadata = {
            "object_name": selectedItem.data.join("_"),
            "timestamp": DateTime.now().millisecondsSinceEpoch,
            "selected_data": selectedItem.data,
          };

          await RemoteApiService().sendDataToS3(
            selectedItem.pointFile.path,
            metadata,
            selectedItem.data.join("_"),
          );

          final List<SelectedItem> newSelectedItems =
              await LocalApiService().fromFile(FileTypeApi.json);

          newSelectedItems.removeWhere((element) =>
              element.pointFile.fileName == selectedItem.pointFile.fileName);

          await LocalApiService().toFile(
            data: SelectedItems(selectedItems: newSelectedItems),
          );

          print('Данные успешно загружены в S3');
        } catch (e) {
          print("Ошибка отправки данных в S3: $e");
        }
      }
    }

    service.invoke(
      'update',
      {
        "current_date": DateTime.now().toIso8601String(),
      },
    );
  });
}