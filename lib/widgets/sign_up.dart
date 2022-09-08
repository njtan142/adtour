import 'package:android_app/widgets/Login.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SignUpWidget extends StatefulWidget {
  const SignUpWidget({Key? key}) : super(key: key);

  @override
  State<SignUpWidget> createState() => _SignUpWidgetState();
}

class _SignUpWidgetState extends State<SignUpWidget> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final firstnameController = TextEditingController();
  final lastnameController = TextEditingController();
  final ageController = TextEditingController();
  final phoneNumberController = TextEditingController();

  Future signUp() async {
    await FirebaseAuth.instance
        .createUserWithEmailAndPassword(
            email: emailController.text.trim(),
            password: passwordController.text.trim())
        .then((user) {
      final configurationData = <String, dynamic>{
        'first_name': firstnameController.text.trim(),
        'last_name': lastnameController.text.trim(),
        'age': ageController.text.trim(),
        'phone_number': phoneNumberController.text.trim(),
      };
      final usersRef = FirebaseFirestore.instance.collection('users');
      usersRef.doc(user.user!.uid).set(configurationData);
    });
  }

  void openLogin() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 50, left: 40, right: 40),
          child: Column(
            children: [
              SvgPicture.asset(
                'assets/adtour_logo.svg',
                height: 200,
              ),
              TextField(
                controller: firstnameController,
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.name,
                decoration: const InputDecoration(
                    hintText: 'First Name', labelText: 'First Name'),
              ),
              TextField(
                controller: lastnameController,
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.name,
                decoration: const InputDecoration(
                    hintText: 'Last Name', labelText: 'Last Name'),
              ),
              TextField(
                controller: ageController,
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.number,
                decoration:
                    const InputDecoration(hintText: 'Age', labelText: 'Age'),
              ),
              TextField(
                controller: phoneNumberController,
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                    hintText: 'Phone Number', labelText: 'Phone Number'),
              ),
              TextField(
                controller: emailController,
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                    hintText: 'Email', labelText: 'Email'),
              ),
              TextField(
                controller: passwordController,
                textInputAction: TextInputAction.next,
                obscureText: true,
                decoration: const InputDecoration(
                    hintText: 'Password', labelText: 'Password'),
              ),
              Row(
                children: [
                  Expanded(
                      child: ElevatedButton(
                          onPressed: signUp, child: const Text("Login")))
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Already have an account?"),
                  TextButton(
                    onPressed: openLogin,
                    child: Text(
                      "Login",
                      style: TextStyle(color: Colors.amber.shade600),
                    ),
                  )
                ],
              ),
              Row(
                children: [
                  Checkbox(
                    value: true,
                    onChanged: (value) {},
                  ),
                  const SizedBox(
                    width: 210,
                    child: Text(
                      "By clicking Continue, you agree to our Terms & Conditions and that you have read our Data Policy",
                      style: TextStyle(fontSize: 13),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
