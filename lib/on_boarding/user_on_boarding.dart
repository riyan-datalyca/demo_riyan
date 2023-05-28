import 'package:flutter/material.dart';
import 'package:untitled/controllers/all_apis.dart';
import 'package:untitled/home/home_page.dart';
import 'package:untitled/utils/design_one.dart';

class UserOnboarding extends StatefulWidget {
  final LoginInformation loginInformation;
  final ApiResponse apiResponse;

  const UserOnboarding(
      {Key? key, required this.loginInformation, required this.apiResponse})
      : super(key: key);

  @override
  State<UserOnboarding> createState() => _UserOnboardingState();
}

class _UserOnboardingState extends State<UserOnboarding> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController userNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  _submitUserData() async {
    widget.loginInformation.userName = userNameController.value.text;
    widget.loginInformation.email = emailController.value.text;
    ApiResponse apiResponse = await PasteApi().addUser(
        apiResponse: widget.apiResponse,
        loginInformation: widget.loginInformation);
    if (apiResponse.status && context.mounted) {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (builder) => const HomePage()),
          (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(16),
        decoration: DesignOne.gradientBackground(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              "Welcome",
              textScaleFactor:
                  MediaQuery.of(context).textScaleFactor.clamp(1.0, 1.5),
              style: DesignOne.boldMont
                  .copyWith(fontWeight: FontWeight.bold, fontSize: 36),
            ),
            Text(
              "Looks like you are new here. Tell us a bit about yourself.",
              style: DesignOne.boldMont,
            ),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.all(8),
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    decoration: DesignOne.inputFieldDecoration(),
                    child: TextFormField(
                        controller: userNameController,
                        decoration: DesignOne.inputDecoration
                            .copyWith(hintText: 'Name'),
                        validator: (String? value) {
                          RegExp emailPattern = RegExp(r"^[a-zA-Z]+$");
                          if (value == null ||
                              value.isEmpty ||
                              !emailPattern.hasMatch(value)) {
                            return 'Please Enter your name';
                          }
                          return null;
                        }),
                  ),
                  Container(
                    margin: const EdgeInsets.all(8),
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    decoration: DesignOne.inputFieldDecoration(),
                    child: TextFormField(
                        controller: emailController,
                        decoration: DesignOne.inputDecoration
                            .copyWith(hintText: 'Email'),
                        validator: (String? value) {
                          RegExp emailPattern =
                              RegExp(r"^[a-zA-Z0-9]+@[a-zA-Z0-9]+\.[a-z]+$");
                          if (value == null ||
                              value.isEmpty ||
                              !emailPattern.hasMatch(value)) {
                            return 'Please Enter valid email address';
                          }
                          return null;
                        }),
                  )
                ],
              ),
            ),
            ElevatedButton(
                onPressed: () {
                  bool? validated = _formKey.currentState?.validate();
                  if (validated != null && validated) {
                    _submitUserData();
                  } else {}
                },
                child: const Text("Submit")),
          ],
        ),
      ),
    );
  }
}
