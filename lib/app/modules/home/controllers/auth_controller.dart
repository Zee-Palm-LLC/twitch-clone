import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:twitch/app/modules/home/models/user_model.dart';
import 'package:twitch/app/modules/home/widgets/loading_dialog.dart';
import 'package:twitch/app/services/db_services.dart';

import '../views/home_screen.dart';

class AuthController extends GetxController {
  FirebaseAuth _auth = FirebaseAuth.instance;
  Rx<User?> _firebaseUser = Rx<User?>(null);
  User? get user => _firebaseUser.value;
  DatabaseServices db = DatabaseServices();

  @override
  void onInit() {
    _firebaseUser.bindStream(_auth.authStateChanges());
    update();
    super.onInit();
  }

  Future<void> signInWithEmailAndPassword(
      {required String email, required String password}) async {
    showLoadingDialog(message: 'Signin ....');
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);

      hideLoadingDialog();
    } on FirebaseAuthException catch (error) {
      hideLoadingDialog();
      Get.snackbar('Login Failed', error.message!,
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 3),
          backgroundColor: Get.theme.snackBarTheme.backgroundColor,
          colorText: Get.theme.snackBarTheme.actionTextColor);
    }
  }

  Future<void> registerWithEmailAndPassword({
    required String email,
    required String password,
    required String name,
  }) async {
    showLoadingDialog(message: 'Creating Account');
    try {
      await _auth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((result) async {
        UserModel newUser = UserModel(
          uid: result.user!.uid,
          email: result.user!.email!,
          username: name,
        );
        await _createUserFirestore(newUser, result.user!);
      });
      hideLoadingDialog();
    } on FirebaseAuthException catch (error) {
      hideLoadingDialog();
      Get.snackbar('Sign up Failed', error.message.toString(),
          snackPosition: SnackPosition.BOTTOM,
          duration: Duration(seconds: 10),
          backgroundColor: Get.theme.snackBarTheme.backgroundColor,
          colorText: Get.theme.snackBarTheme.actionTextColor);
    }
  }

  Future<void> _createUserFirestore(UserModel user, User firebaseUser) async {
    await db.userCollection.doc(firebaseUser.uid).set(user.toMap());
    update();
  }

  Future<void> signOut() async {
    return await _auth.signOut();
  }
}
