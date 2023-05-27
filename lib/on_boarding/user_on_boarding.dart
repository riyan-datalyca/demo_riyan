import 'package:flutter/material.dart';
import 'package:untitled/controllers/all_apis.dart';
import 'package:untitled/home/home_page.dart';
import 'package:untitled/ui_popup/popup_snackbar.dart';
import 'package:untitled/utils/custom_components.dart';

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
    widget.loginInformation..userName = userNameController.value.text;
    widget.loginInformation..email = emailController.value.text;
    ApiResponse apiResponse = await PasteApi().addUser(
        apiResponse: widget.apiResponse,
        loginInformation: widget.loginInformation);
    UiPopup.showSnackBar(
        context: context,
        message: apiResponse.response ?? '',
        backgroundColor: apiResponse.status ? Colors.green : Colors.red);
    if (apiResponse.status) {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (builder) => const HomePage()),
          (route) => false);
    }
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
                style: const TextStyle(fontSize: 36),
              ),
              const Text(
                  "Looks like you are new here. Tell us a bit about yourself."),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                        controller: userNameController,
                        validator: (String? value) {
                          RegExp emailPattern = RegExp(r"^[a-zA-Z]+$");
                          if (value == null ||
                              value.isEmpty ||
                              !emailPattern.hasMatch(value)) {
                            return 'Please Enter your name';
                          }
                          return null;
                        }),
                    TextFormField(
                        controller: emailController,
                        validator: (String? value) {
                          RegExp emailPattern =
                              RegExp(r"^[a-zA-Z0-9]+@[a-zA-Z0-9]+\.[a-z]+$");
                          if (value == null ||
                              value.isEmpty ||
                              !emailPattern.hasMatch(value)) {
                            return 'Please Enter valid email address';
                          }
                          return null;
                        })
                  ],
                ),
              ),
              ElevatedButton(
                  onPressed: () {
                    bool? validated = _formKey.currentState?.validate();
                    if(validated != null && validated){
                      _submitUserData();
                    }else{

                    }

                  },
                  child: const Text("Submit")),
            ],
          ),
        ),
      ),
    );
  }
}
