import 'package:flutter/material.dart';
import 'package:pin_input_text_field/pin_input_text_field.dart';
import 'package:untitled/home/home_page.dart';
import 'package:untitled/on_boarding/user_on_boarding.dart';
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

class LoginInformation {
  String? countryCode;
  String? phoneNumber;
  String? token;
  String? name;
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
    if (!validatedPhoneNumber) {
      LoginInformation _loginInformation = LoginInformation();
      _loginInformation
        ..countryCode = countryCode
        ..phoneNumber = phoneNumber.value.text;
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (builder) => OTPPage(
                    loginInformation: _loginInformation,
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
                      maxLength: 6,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter some text';
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

  @override
  void initState() {
    fullNumber =
        '${widget.loginInformation.countryCode}${widget.loginInformation.phoneNumber}';
    super.initState();
  }

  _verifyOTP() {
    if (!disableVerifyButton) {
      //  TODO API call to check if OTP is correct
      Future<http.Response> getOTP() {
        return http
            .get(Uri.parse(' https://test-otp-api.7474224.xyz/sendotp.php'));
      }

      //TODO check if new User
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (builder) => UserOnboarding()),
          (route) => false);
      return;
      //TODO check if old user
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (builder) => HomePage()),
          (route) => false);
    }
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
              CircleAvatar(),
              Text("Enter OTP"),
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
                  child: Text("Verify"))
            ],
          ),
        ),
      ),
    );
  }
}
