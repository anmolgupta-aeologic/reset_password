import 'package:flutter/material.dart';
import 'package:reset_password/forgot_password_screen.dart';
import 'auth.dart';

enum AuthMode { SignUp, Login }

class AuthScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(child: AuthCard()),
    );
  }
}

class AuthCard extends StatefulWidget {
  const AuthCard({
    Key key,
  }) : super(key: key);

  @override
  _AuthCardState createState() => _AuthCardState();
}

class _AuthCardState extends State<AuthCard> {
  final GlobalKey<FormState> _formKey = GlobalKey();

  AuthMode _authMode = AuthMode.SignUp;
  Map<String, String> _authData = {
    'email': '',
    'phone': '',
    'password': '',
  };
  var _isLoading = false;
  final _passwordController = TextEditingController();

  Future<void> _submit() async {
    if (!_formKey.currentState.validate()) {
      // Invalid!
      return;
    }
    _formKey.currentState.save();
    setState(() {
      _isLoading = true;
    });
    if (_authMode == AuthMode.Login) {
      // Log user in
      await AuthServices().login(
        _authData['email'],
        _authData['password'],
      );
    } else {
      // Sign user up
      await AuthServices().signUp(
        _authData['email'],
        _authData['password'],
      );
    }

    setState(() {
      _isLoading = false;
    });
  }

  void _switchAuthMode() {
    if (_authMode == AuthMode.SignUp) {
      setState(() {
        _authMode = AuthMode.Login;
      });
    } else {
      setState(() {
        _authMode = AuthMode.SignUp;
      });
    }
  }

  bool obsecure = true;

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Container(
      height: deviceSize.height,
      width: deviceSize.width,
      child: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            Container(
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: _authMode == AuthMode.SignUp ? 70 : 175,
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 8),
                    child: Text(
                      _authMode == AuthMode.SignUp
                          ? 'Welcome !!'
                          : 'Welcome Back!!',
                      style: TextStyle(fontSize: 25, color: Colors.redAccent),
                    ),
                  ),
                  Text(
                      _authMode == AuthMode.SignUp
                          ? 'Create Your Account'
                          : 'Login to Your Account',
                      style: TextStyle(fontSize: 30, color: Colors.indigo))
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: TextFormField(
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.fromLTRB(20, 8, 8, 8),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(50.0)),
                        borderSide: BorderSide(color: Colors.white24)),
                    labelText: 'Email',
                    labelStyle: TextStyle(fontWeight: FontWeight.w500)),
                keyboardType: TextInputType.emailAddress,
                // ignore: missing_return
                validator: (value) {
                  if (value.isEmpty || !value.contains('@')) {
                    return 'Invalid email!';
                    // ignore: missing_return
                  }
                },
                onSaved: (value) {
                  _authData['email'] = value;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
              child: TextFormField(
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.fromLTRB(20, 8, 8, 8),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(50.0)),
                        borderSide: BorderSide(color: Colors.white24)),
                    labelText: 'Password',
                    labelStyle: TextStyle(fontWeight: FontWeight.w500),
                    suffixIcon: IconButton(
                        onPressed: () => setState(() {
                              obsecure = !obsecure;
                            }),
                        icon: Icon(
                          Icons.remove_red_eye,
                          size: 25,
                          color: Colors.black,
                        ))),
                obscureText: obsecure,
                controller: _passwordController,
                // ignore: missing_return
                validator: (value) {
                  if (value.isEmpty || value.length < 5) {
                    return 'Password is too short!';
                  }
                },
                onSaved: (value) {
                  _authData['password'] = value;
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SizedBox(
                    height: 20,
                    child: _authMode == AuthMode.Login
                        ? Padding(
                            padding: const EdgeInsets.fromLTRB(0, 4, 0, 0),
                            child: MaterialButton(
                              onPressed: () => Navigator.of(context).push(
                                  MaterialPageRoute(
                                      builder: (context) => ForgotPassword())),
                              child: Text(
                                'Forgot Password ?',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w400),
                              ),
                            ),
                          )
                        : SizedBox()),
              ],
            ),
            if (_authMode == AuthMode.SignUp)
              Padding(
                padding: const EdgeInsets.fromLTRB(15, 0, 15, 15),
                child: TextFormField(
                  enabled: _authMode == AuthMode.SignUp,
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.fromLTRB(20, 8, 8, 8),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(50.0)),
                          borderSide: BorderSide(color: Colors.white24)),
                      labelText: 'Confirm Password',
                      labelStyle: TextStyle(fontWeight: FontWeight.w500),
                      suffixIcon: IconButton(
                          onPressed: () => setState(() {
                                obsecure = !obsecure;
                              }),
                          icon: Icon(
                            Icons.remove_red_eye,
                            size: 25,
                            color: Colors.black,
                          ))),
                  obscureText: obsecure,
                  validator: _authMode == AuthMode.SignUp
                      // ignore: missing_return
                      ? (value) {
                          // ignore: missing_return
                          if (value != _passwordController.text) {
                            return 'Passwords do not match!';
                          }
                        }
                      : null,
                ),
              ),
            SizedBox(
              height: 20,
            ),
            if (_isLoading)
              CircularProgressIndicator()
            else
              SizedBox(
                height: 40,
                width: 285,
                child: MaterialButton(
                  child: Text(
                      _authMode == AuthMode.Login ? 'LOGIN' : 'Create Account'),
                  onPressed: () {
                    _submit();
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
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(_authMode == AuthMode.Login
                    ? 'Don\'t have an Account?'
                    : 'Already have an Account?'),
                MaterialButton(
                  child: Text(
                      '${_authMode == AuthMode.Login ? 'Create Account ' : 'Login'} '),
                  onPressed: _switchAuthMode,
                  textColor: Theme.of(context).primaryColor,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
