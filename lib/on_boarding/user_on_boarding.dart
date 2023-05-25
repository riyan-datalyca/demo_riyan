import 'package:flutter/material.dart';
import 'package:untitled/home/home_page.dart';
import 'package:untitled/utils/custom_components.dart';

class UserOnboarding extends StatefulWidget {
  const UserOnboarding({Key? key}) : super(key: key);

  @override
  State<UserOnboarding> createState() => _UserOnboardingState();
}

class _UserOnboardingState extends State<UserOnboarding> {
  _submitUserData() {
    Navigator.pushAndRemoveUntil(context,
        MaterialPageRoute(builder: (builder) => HomePage()), (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedContainerCustom(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                "Welcome",
                textScaleFactor:
                    MediaQuery.of(context).textScaleFactor.clamp(1.0, 1.5),
                style: TextStyle(fontSize: 36),
              ),
              Text(
                  "Looks like you are new here. Tell us a bit about yourself."),
              Form(
                child: Column(
                  children: [TextFormField(), TextFormField()],
                ),
              ),
              ElevatedButton(
                  onPressed: () {
                    _submitUserData();
                  },
                  child: Text("Submit")),
            ],
          ),
        ),
      ),
    );
  }
}
