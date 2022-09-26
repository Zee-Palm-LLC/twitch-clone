import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:twitch/app/data/constants/constants.dart';
import 'package:twitch/app/modules/home/controllers/auth_controller.dart';
import 'package:twitch/app/modules/home/widgets/custom_textformfield.dart';

import '../../widgets/custom_button.dart';
import '../../widgets/responsive.dart';

class LoginScreen extends StatefulWidget {
  static const String routeName = '/login';
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  var ac = Get.find<AuthController>();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Login',
        ),
      ),
      body: Responsive(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: size.height * 0.1),
                const Text(
                  'Email',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: TextFieldInput(
                    textEditingController: _emailController,
                    hintText: 'Email',
                    textInputType: TextInputType.emailAddress,
                    isPass: false,
                    validator: (e) {
                      if (e!.isEmpty) {
                        return 'Please Enter a Email';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  'Password',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: TextFieldInput(
                    textEditingController: _passwordController,
                    hintText: 'Password',
                    textInputType: TextInputType.visiblePassword,
                    isPass: true,
                    validator: (e) {
                      if (e!.isEmpty) {
                        return ' Please enter a password';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                CustomButton(
                    onPressed: () async {
                      await ac.signInWithEmailAndPassword(
                          email: _emailController.text.trim(),
                          password: _passwordController.text.trim());
                    },
                    child: Text(
                      'Login',
                      style: CustomTextStyle.kBold18,
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
