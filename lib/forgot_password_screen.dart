import 'package:reset_password/update_password_screen.dart';
import 'package:flutter/material.dart';
import 'package:email_auth/email_auth.dart';

enum AuthMode { forgot, verify }

class ForgotPassword extends StatefulWidget {
  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  bool submitValid = false;
  AuthMode _authMode = AuthMode.forgot;
  final TextEditingController _otpController = TextEditingController();

  final TextEditingController _emailController = TextEditingController();

  void initState() {
    super.initState();
  }

  void verify() {
    EmailAuth.validate(
        receiverMail: _emailController.value.text,
        userOTP: _otpController.value.text);
  }

  void sendOtp() async {
    EmailAuth.sessionName = "Company Name";
    bool result =
        await EmailAuth.sendOtp(receiverMail: _emailController.value.text);
    if (result) {
      setState(() {
        submitValid = true;
      });
    }
  }

  void _switchAuthMode() {
    if (_authMode == AuthMode.forgot) {
      setState(() {
        _authMode = AuthMode.verify;
      });
    } else {
      setState(() {
        _authMode = AuthMode.forgot;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 100,),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                _authMode == AuthMode.forgot
                    ? 'Forgot Your Password?'
                    : 'Verify Your Email',
                style: TextStyle(
                    color: Colors.indigo,
                    fontSize: 25,
                    fontWeight: FontWeight.w500),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Text(
                _authMode == AuthMode.forgot
                    ? 'Enter the Email address associated with'
                    : 'Please enter the 6 digit code sent to',
                style: TextStyle(fontSize: 17),
              ),
            ),
            Text(
                _authMode == AuthMode.forgot
                    ? 'your account'
                    : _emailController.text,
                style: TextStyle(fontSize: 17)),
            Padding(
              padding: const EdgeInsets.fromLTRB(30, 30, 30, 0),
              child: _authMode == AuthMode.forgot
                  ? TextFormField(
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.fromLTRB(20, 8, 8, 8),
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(50.0)),
                            borderSide: BorderSide(color: Colors.white24)),
                        labelText: 'Email',
                        labelStyle: TextStyle(fontWeight: FontWeight.w500),
                      ),
                      controller: _emailController,
                      // ignore: missing_return
                    )
                  : (submitValid)
                      ? TextFormField(
                          controller: _otpController,
                        )
                      : Container(),
            ),
            SizedBox(
              height: _authMode == AuthMode.forgot ? 50 : 30,
            ),
            if (_authMode == AuthMode.verify)
              MaterialButton(
                  onPressed: sendOtp,
                  child: Text(
                    'Resend Code',
                    style: TextStyle(
                      fontSize: 17,
                      letterSpacing: 1,
                      shadows: [
                        Shadow(color: Colors.indigo, offset: Offset(0, -5))
                      ],
                      color: Colors.transparent,
                      decoration: TextDecoration.underline,
                      decorationColor: Colors.indigo,
                      decorationThickness: 2,
                      decorationStyle: TextDecorationStyle.solid,
                    ),
                  )),
            SizedBox(
              height: 40,
              width: 285,
              child: MaterialButton(
                child: Text(_authMode == AuthMode.forgot
                    ? 'Verify Email'
                    : 'Confirm'),
                onPressed: () {
                  if (_authMode == AuthMode.forgot) {
                    sendOtp();
                    _switchAuthMode();
                  } else {
                    verify();
                    _otpController.clear();
                    Navigator.of(context).pop();
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => UpdatePassword()));
                    //getCurrentUser();
                  }
                },
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                padding:
                    EdgeInsets.symmetric(horizontal: 30.0, vertical: 8.0),
                color: Colors.indigo.shade600,
                textColor: Theme.of(context).primaryTextTheme.button.color,
              ),
            ),
            SizedBox(
              height: 90,
            ),
          ],
        ),
      ),
    );
  }
}
