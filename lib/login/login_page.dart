import 'package:flutter/material.dart';
import 'package:pin_input_text_field/pin_input_text_field.dart';
import 'package:untitled/controllers/all_apis.dart';
import 'package:untitled/home/home_page.dart';
import 'package:untitled/on_boarding/user_on_boarding.dart';
import 'package:untitled/ui_popup/popup_snackbar.dart';
import 'package:untitled/utils/design_one.dart';

enum OTPResponse { success, error }

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.only(top: 64.0),
        decoration: DesignOne.gradientBackground(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            DesignOne().circularLogo(),
            const LoginComponent()
          ],
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
          ),
        ),
      );
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
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.symmetric(horizontal: 8),
            decoration: DesignOne.inputFieldDecoration(),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IntrinsicWidth(
                  child: TextFormField(
                    readOnly: true,
                    controller: TextEditingController(text: countryCode),
                    decoration: DesignOne.inputDecoration,
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: TextFormField(
                    controller: phoneNumber,
                    decoration: DesignOne.inputDecoration.copyWith(
                      hintText: "Enter Phone Number",
                      counterText: "",
                    ),
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
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all(Colors.transparent),
                ),
                onPressed: () {
                  _loginButtonClick();
                },
                child: const Text("Continue")),
          ),
        ],
      ),
    );
  }
}

class OTPPage extends StatefulWidget {
  final LoginInformation loginInformation;

  const OTPPage({Key? key, required this.loginInformation}) : super(key: key);

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
    widget.loginInformation.otp = pinController.value.text;
    ApiResponse response = await PasteApi().verifyOTP(
        loginInformation: widget.loginInformation,
        apiResponse: verifiedInformation);
    response = ApiResponse(status: true, profileExists: false, jwt: 'jwt1234');
    if (response.status && context.mounted) {
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
            DesignOne().circularLogo(),
            Text(
              "Enter OTP",
              style: DesignOne.boldMont,
            ),
            Text(
              "OTP has been sent to $fullNumber",
              style: DesignOne.boldMont,
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: PinInputTextField(
                controller: pinController,
                pinLength: 6,
                decoration: DesignOne.customPinDecoration(context),
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
    );
  }
}
