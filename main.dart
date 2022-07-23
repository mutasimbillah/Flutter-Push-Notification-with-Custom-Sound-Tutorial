import 'package:aanza_user/app/core/theme/app_theme.dart';
import 'package:aanza_user/app/data/services/api/api_service.dart';
import 'package:aanza_user/app/data/services/fcm_service.dart';
import 'package:aanza_user/app/data/services/storage_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'app/routes/app_pages.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  //FCM
  await Get.putAsync(() => FcmService().init());
  Get.put(() => FcmService().handleBackground());
  //
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (child) {
        return GetMaterialApp(
          title: "My App",
          initialRoute: AppPages.INITIAL,
          getPages: AppPages.routes,
          debugShowCheckedModeBanner: false,
          theme: AppTheme().lightTheme,
        );
      },
    );
  }
}
