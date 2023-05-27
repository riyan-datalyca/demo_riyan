import 'package:flutter/material.dart';
import 'package:pin_input_text_field/pin_input_text_field.dart';
import 'package:untitled/controllers/all_apis.dart';
import 'package:untitled/home/home_page.dart';
import 'package:untitled/on_boarding/user_on_boarding.dart';
import 'package:untitled/ui_popup/popup_snackbar.dart';
import 'package:untitled/utils/custom_components.dart';
import 'package:http/http.dart' as http;

enum OTPResponse { success, error }

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: ElevatedContainerCustom(
          child: Wrap(
            children: [
              CircleAvatar(
                backgroundColor: Colors.grey,
              ),
              SizedBox(
                width: 5001,
                child: LoginComponent(),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class LoginComponent extends StatefulWidget {
  const LoginComponent({Key? key}) : super(key: key);

  @override
  State<LoginComponent> createState() => _LoginComponentState();
}

class _LoginComponentState extends State<LoginComponent> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController phoneNumber = TextEditingController();
  String countryCode = '+91';

  _loginButtonClick() {
    bool validatedPhoneNumber = _formKey.currentState?.validate() ?? false;
    if (validatedPhoneNumber) {
      LoginInformation loginInformation = LoginInformation();
      loginInformation
        ..countryCode = countryCode
        ..phoneNumber = phoneNumber.value.text;
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (builder) => OTPPage(
                    loginInformation: loginInformation,
                  )));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  IntrinsicWidth(
                    child: TextFormField(
                      readOnly: true,
                      controller: TextEditingController(text: countryCode),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: TextFormField(
                      controller: phoneNumber,
                      maxLength: 10,
                      keyboardType: TextInputType.phone,
                      validator: (value) {
                        RegExp numberPattern = RegExp(r"^[0-9]+$");
                        if (value == null ||
                            value.isEmpty ||
                            value.length != 10 ||
                            !numberPattern.hasMatch(value)) {
                          return 'Please enter your 10 digit phone number';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
            ),
            ElevatedButton(
                onPressed: () {
                  _loginButtonClick();
                },
                child: const Text("Continue"))
          ],
        ));
  }
}

class OTPPage extends StatefulWidget {
  final LoginInformation loginInformation;

  OTPPage({Key? key, required this.loginInformation}) : super(key: key);

  @override
  State<OTPPage> createState() => _OTPPageState();
}

class _OTPPageState extends State<OTPPage> {
  String fullNumber = '';
  bool disableVerifyButton = true;
  TextEditingController pinController = TextEditingController();
  late ApiResponse verifiedInformation;

  @override
  void initState() {
    fullNumber =
        '${widget.loginInformation.countryCode}${widget.loginInformation.phoneNumber}';
    _sendOTP();
    super.initState();
  }

  _verifyOTP() async {
    widget.loginInformation..otp = pinController.value.text;
    ApiResponse response = await PasteApi().verifyOTP(
        loginInformation: widget.loginInformation,
        apiResponse: verifiedInformation);
    response = ApiResponse(status: true, profileExists: false, jwt: 'jwt1234');
    if (response.status) {
      if (response.profileExists ?? false) {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (builder) => const HomePage()),
            (route) => false);
      } else {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
                builder: (builder) => UserOnboarding(
                      loginInformation: widget.loginInformation,
                  apiResponse: response,
                    )),
            (route) => false);
      }
    } else {
      UiPopup.showSnackBar(
          context: context,
          message: response.response ?? '',
          backgroundColor: Colors.red);
    }
  }

  _sendOTP() async {
    verifiedInformation =
        await PasteApi().sendOTP(inputInformation: widget.loginInformation);
    UiPopup.showSnackBar(
        context: context,
        message: verifiedInformation.response ?? 'No response form server.',
        backgroundColor:
            verifiedInformation.status ? Colors.green : Colors.red);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedContainerCustom(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const CircleAvatar(),
              const Text("Enter OTP"),
              Text("OTP has been sent to $fullNumber"),
              PinInputTextField(
                controller: pinController,
                pinLength: 6,
                decoration: UnderlineDecoration(
                  textStyle: Theme.of(context).textTheme.bodyText1!.copyWith(
                        color: Colors.grey[400],
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                  bgColorBuilder: PinListenColorBuilder(
                      Theme.of(context).scaffoldBackgroundColor,
                      Theme.of(context).scaffoldBackgroundColor),
                  colorBuilder:
                      PinListenColorBuilder(Colors.black, Colors.black),
                ),
                textInputAction: TextInputAction.go,
                enabled: true,
                autoFocus: true,
                keyboardType: TextInputType.number,
                onChanged: (pin) {
                  if (pin.length == 6) {
                    disableVerifyButton = false;
                  } else {
                    disableVerifyButton = true;
                  }
                  setState(() {});
                },
                cursor: Cursor(enabled: true, color: Colors.black, width: 1.0),
                enableInteractiveSelection: true,
              ),
              ElevatedButton(
                  style: ButtonStyle(backgroundColor:
                      MaterialStateProperty.resolveWith((states) {
                    if (disableVerifyButton) {
                      return Colors.grey;
                    }
                    return null;
                  })),
                  onPressed: () {
                    _verifyOTP();
                  },
                  child: const Text("Verify"))
            ],
          ),
        ),
      ),
    );
  }
}
