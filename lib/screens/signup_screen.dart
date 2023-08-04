import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_app/resources/auth_methods.dart';
import 'package:instagram_app/responsive/mobile_screen_layout.dart';
import 'package:instagram_app/responsive/responsive_layout_screen.dart';
import 'package:instagram_app/responsive/web_screen_layout.dart';
import 'package:instagram_app/screens/login_screen.dart';
import 'package:instagram_app/utils/utils.dart';
import 'package:instagram_app/widgets/text_field_input.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  Uint8List? _image;
  bool _isLoading = false;

  void selectImage() async {
    Uint8List image = await pickImage(ImageSource.gallery);
    setState(() {
      _image = image;
    });
  }

  void signUpUser() async {
    setState(() {
      _isLoading = true;
    });
    String res = await AuthMethods().signUpUser(
        email: _emailController.text,
        password: _passwordController.text,
        username: _usernameController.text,
        bio: _bioController.text,
        file: _image!);

    setState(() {
      _isLoading = false;
    });
    if (res != 'Success') {
      showSnackBar(context, res);
    } else {
      // do nothing
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const ResponsiveLayout(
            webScreenLayout: WebScreenLayout(),
            mobileScreenLayout: MobileScreenLayout(),
          ),
        ),
      );
    }
  }

  void navigateToLogin() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => LoginScreen()));
  }

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _bioController.dispose();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Container(
        padding: EdgeInsets.symmetric(horizontal: 32),
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Flexible(child: Container(), flex: 2),
            Image.asset('images/logo.png'),
            // const SizedBox(height: 64),
            Stack(
              children: [
                _image != null
                    ? CircleAvatar(
                        radius: 64,
                        backgroundImage: MemoryImage(_image!),
                      )
                    : const CircleAvatar(
                        radius: 64,
                        backgroundImage: NetworkImage(
                            'https://cdn141.picsart.com/357697367045201.jpg'),
                      ),
                Positioned(
                  bottom: -10,
                  left: 80,
                  child: IconButton(
                    onPressed: selectImage,
                    icon: const Icon(Icons.add_a_photo),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            // Container(
            //   child: Image.asset('images/pfpic.jpg'),
            // ),
            TextFieldInput(
              hintText: "Enter your username",
              textInputType: TextInputType.text,
              textEditingController: _usernameController,
            ),
            const SizedBox(height: 15),
            TextFieldInput(
              hintText: "Enter your email",
              textInputType: TextInputType.emailAddress,
              textEditingController: _emailController,
            ),
            const SizedBox(height: 15),
            TextFieldInput(
              hintText: "Enter your password",
              textInputType: TextInputType.emailAddress,
              textEditingController: _passwordController,
              isPass: true,
            ),
            const SizedBox(height: 15),
            TextFieldInput(
              hintText: "Enter your bio",
              textInputType: TextInputType.text,
              textEditingController: _bioController,
            ),

            const SizedBox(height: 15),
            InkWell(
              onTap: signUpUser,
              child: Container(
                child: _isLoading
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: Colors.white,
                        ),
                      )
                    : Text('Sign up'),
                width: double.infinity,
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: const ShapeDecoration(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(4))),
                  color: Colors.blue,
                ),
              ),
            ),

            const SizedBox(height: 4),
            Flexible(child: Container(), flex: 2),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  child: Text("Already have an account?"),
                  padding: const EdgeInsets.symmetric(vertical: 8),
                ),
                GestureDetector(
                    onTap: navigateToLogin,
                    child: Container(
                      child: Text(
                        "Login",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      padding: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 6),
                    )),
              ],
            )
          ],
        ),
      )),
    );
  }
}
