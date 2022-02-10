import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:rongpurapp/constants.dart';
import 'package:rongpurapp/screens/home_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  
  String _registerEmail = "";
  String _registerPassword = "";

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isVisible = true;

  Future<void> _alertDialogBuilder(String error) async {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            title: Text("Error"),
            content: Container(
              child: Text(error),
            ),
            actions: [
              FlatButton(
                child: Text("Close Dialog"),
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            ],
          );
        });
  }

  Future<String> _createAccount() async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _registerEmail, password: _registerPassword);
      return null;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        return 'The account already exists for that email.';
      }
      return e.message;
    } catch (e) {
      return e.toString();
    }
  }

  void _submitForm() async {
    String _createAccountFeedback = await _createAccount();
    if (_createAccountFeedback != null) {
      _alertDialogBuilder(_createAccountFeedback);
    } else {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
        return HomePage();
      }));
    }
  }

  Future<void> _googleSignUp() async {
    try {
      final GoogleSignIn _googleSignIn = GoogleSignIn(
        scopes: ['email'],
      );
      final FirebaseAuth _auth = FirebaseAuth.instance;

      final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      final User user = (await _auth.signInWithCredential(credential)).user;
      return user;
    } catch (e) {
      print(e.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.only(
                  top: 24.0,
                ),
                child: Text(
                  "Log in or Signup Page",
                  textAlign: TextAlign.center,
                  style: Constants.boldHeading,
                ),
              ),
              Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                      right: 15,
                      left: 15,
                    ),
                    child: TextField(
                      controller: emailController,
                      onChanged: (value) {
                        setState(() {
                          _registerEmail = value;
                        });
                      },
                      decoration: InputDecoration(
                          // icon: Icon(Icons.mail),
                          prefixIcon: Icon(Icons.mail),
                          suffixIcon: emailController.text.isEmpty
                              ? Text('')
                              : GestureDetector(
                                  onTap: () {
                                    emailController.clear();
                                  },
                                  child: Icon(Icons.close)),
                          hintText: 'example@mail.com',
                          labelText: 'Email',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide:
                                  BorderSide(color: Colors.red, width: 1))),
                    ),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      right: 15,
                      left: 15,
                    ),
                    child: TextField(
                      obscureText: isVisible,
                      controller: passwordController,
                      onChanged: (value) {
                        _registerPassword = value;
                      },
                      decoration: InputDecoration(
                          // icon: Icon(Icons.mail),
                          prefixIcon: Icon(Icons.lock),
                          suffixIcon: GestureDetector(
                              onTap: () {
                                isVisible = !isVisible;
                                setState(() {});
                              },
                              child: Icon(isVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off)),
                          hintText: 'type your password',
                          labelText: 'Password',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide:
                                  BorderSide(color: Colors.red, width: 1))),
                    ),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  IconButton(
                      onPressed: ()  {
                         _submitForm();
                      },
                      icon: Icon(Icons.app_registration_rounded)),
                  Text('Sign up !')
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(
                  bottom: 60,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SignInButton(
                      Buttons.Google,
                      text: "Sign in with Google",
                      onPressed: () async {
                        await _googleSignUp().then(
                          (value) => Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (context) => HomePage(),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
