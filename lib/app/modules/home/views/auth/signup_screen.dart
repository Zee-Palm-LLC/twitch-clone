import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:twitch/app/data/constants/constants.dart';
import 'package:twitch/app/modules/home/controllers/auth_controller.dart';

import '../../widgets/custom_button.dart';
import '../../widgets/custom_textformfield.dart';
import '../../widgets/responsive.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  var ac = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Sign Up',
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
                  'Username',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: TextFieldInput(
                    textEditingController: _usernameController,
                    hintText: 'Username',
                    textInputType: TextInputType.name,
                    isPass: false,
                    validator: (e) {
                      if (e!.isEmpty) {
                        return 'Please Enter a Name';
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
                        return 'Please Enter a Password';
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
                    await ac.registerWithEmailAndPassword(
                        email: _emailController.text.trim(),
                        password: _passwordController.text.trim(),
                        name: _usernameController.text.trim());
                  },
                  child: Text('Signup', style: CustomTextStyle.kBold18),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
