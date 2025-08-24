import 'dart:async';
import 'package:check_object/main.dart';
import 'package:flutter_background_service/flutter_background_service.dart';

class StartBackground {
  Future<void> initializeService() async {
    final service = FlutterBackgroundService();

    await service.configure(
      androidConfiguration: AndroidConfiguration(
        onStart: onStart,
        autoStart: true,
        isForegroundMode: false, 
        notificationChannelId: '',
        initialNotificationTitle: '',
        initialNotificationContent: '',
      ),
      iosConfiguration: IosConfiguration(
        autoStart: true,
        onForeground: onStart,
        onBackground: onIosBackground,
      ),
    );

    service.startService();
  }
}