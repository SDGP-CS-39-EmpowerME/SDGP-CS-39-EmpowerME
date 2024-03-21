import 'dart:async';
import 'dart:ui';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';
import 'dart:io';

@pragma('vm:entry-point')
void onStart(ServiceInstance service) async {
  DartPluginRegistrant.ensureInitialized();
  if (service is AndroidServiceInstance){
    service.on('setAsForeground').listen((event){
      service.setAsForegroundService();
    });
    service.on('setAsBackground').listen((event){
      service.setAsBackgroundService();
    });
  }
  service.on('stopService').listen((event){
    service.stopSelf();
  });
  Timer.periodic(const Duration(seconds: 1), (timer) async{
    if (service is AndroidServiceInstance){
      if (await service.isForegroundService()){
        service.setForegroundNotificationInfo(title: "Current services", content: "Freeing memory");
      }
    }
    //performs some operations in the background which is not noticeable to the user
    /*print("background service running");
    service.invoke('update');*/
  });
}

Future <void> initializeService() async {
  final service = FlutterBackgroundService();
  await service.configure(
    androidConfiguration: AndroidConfiguration(
        onStart: onStart,
        isForegroundMode: true,
        autoStart: true
    ),
    iosConfiguration: IosConfiguration(
      //autoStart: true,
      //onForeground: onStart,
      //onBackground: onIosBackground,
    ),
  );
  await service.startService();
}