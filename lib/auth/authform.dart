import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AuthForm extends StatefulWidget {
  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  final auth = FirebaseAuth.instance;
  var _email = '';
  var _password = '';
  var _username = '';
  bool isLoginPage = false;

  _startauthentication() {
    final validity = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();

    if (validity) {
      _formKey.currentState!.save();

      submitform(_email.trim(), _password.trim(), _username.trim());
    }
  }

  submitform(String email, String password, String username) async {
    UserCredential authResult;

    try {
      if (isLoginPage) {
        authResult = await auth.signInWithEmailAndPassword(
            email: email, password: password);
      } else {
        authResult = await auth.createUserWithEmailAndPassword(
            email: email, password: password);

        await FirebaseFirestore.instance
            .collection('users')
            .doc(authResult.user!.uid)
            .set({'username': username, 'email': email});
      }
    
    } on FirebaseAuthException catch (err) {
      String? message = 'An error occured';
      if (err.message != null) {
        message = err.message;
      }
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text(message!),
        backgroundColor: Colors.red,
      ));
    } catch (err) {
      print(err);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: ListView(
        children: [
          Container(
            margin: const EdgeInsets.all(30),
            height: 200,
            child: Image.asset('assets/todo.jpg'),
          ),
          Container(
            padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (!isLoginPage)
                    TextFormField(
                      keyboardType: TextInputType.text,
                      key: const ValueKey('username'),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Incorrect UserName';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _username = value!;
                      },
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide: const BorderSide()),
                          labelText: "Enter UserName",
                          labelStyle: GoogleFonts.roboto()),
                    ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    key: const ValueKey('email'),
                    validator: (value) {
                      if (value!.isEmpty || !value.contains('@')) {
                        return 'Incorrect Email';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _email = value!;
                    },
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide:  const BorderSide()),
                        labelText: "Enter Email",
                        labelStyle: GoogleFonts.roboto()),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    obscureText: true,
                    keyboardType: TextInputType.text,
                    key: const ValueKey('password'),
                    validator: (value) {
                      if (value!.isEmpty || value.length <= 8) {
                        return 'Password should be atleast 8  ';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _password = value!;
                    },
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius:BorderRadius.circular(8.0),
                            borderSide: const BorderSide()),
                        labelText: "Enter Password",
                        labelStyle: GoogleFonts.roboto()),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    padding: const EdgeInsets.only(top: 5),
                    width: double.infinity,
                    height: 70,
                    child: ElevatedButton(
                      child: isLoginPage
                          ? Text('Login',
                              style: GoogleFonts.roboto(fontSize: 16))
                          : Text('SignUp',
                              style: GoogleFonts.roboto(fontSize: 16)),
                      onPressed: _startauthentication,
                      style: ElevatedButton.styleFrom(
                          primary: Theme.of(context).primaryColor),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    child: TextButton(
                        onPressed: () {
                          setState(() {
                            isLoginPage = !isLoginPage;
                          });
                        },
                        child: isLoginPage
                            ? Text(
                                'Not a Member?',
                                style: GoogleFonts.roboto(
                                    fontSize: 16, color: Colors.white),
                              )
                            : Text(
                                'Already a Member?',
                                style: GoogleFonts.roboto(
                                    fontSize: 16, color: Colors.white),
                              )),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
