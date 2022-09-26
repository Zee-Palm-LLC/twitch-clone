import 'package:get/get.dart';
import 'package:twitch/app/modules/home/controllers/user_controller.dart';

import '../controllers/auth_controller.dart';
import '../controllers/livestream_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AuthController>(() => AuthController(), fenix: true);
    Get.lazyPut<UserController>(() => UserController(), fenix: true);
    Get.lazyPut<LiveStreamController>(() => LiveStreamController());
  }
}
