import 'package:get/get.dart';

import '../../../services/db_services.dart';
import '../models/user_model.dart';
import 'auth_controller.dart';

class UserController extends GetxController {
  DatabaseServices db = DatabaseServices();
  Rx<UserModel?> _user = UserModel(uid: '').obs;
  AuthController authController = Get.find<AuthController>();

  UserModel get user => _user.value!;

  Future<UserModel> getCurrentUser() async {
    return await db.userCollection
        .doc(authController.user!.uid)
        .get()
        .then((doc) {
      return UserModel.fromMap(doc.data() as Map<String, dynamic>);
    });
  }

  @override
  Future<void> onReady() async {
    _user.value = await getCurrentUser();
    print(_user.value!.email);
    super.onReady();
  }
}
