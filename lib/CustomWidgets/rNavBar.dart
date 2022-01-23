import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:recipy/CustomWidgets/LoginPopup.dart';
import 'package:recipy/Utilities/Constants.dart';
import 'package:recipy/Utilities/CustomTheme.dart';
import 'package:recipy/Utilities/Requests.dart';
import 'package:recipy/Utilities/Utilities.dart';
import 'dart:html' as html;
import 'package:shared_preferences/shared_preferences.dart';

class rNavBar extends StatefulWidget {
  const rNavBar({Key? key}) : super(key: key);

  @override
  _rNavBarState createState() => _rNavBarState();
}

class _rNavBarState extends State<rNavBar> {
  // final _loginFormKey = GlobalKey<FormState>();
  // bool isLoginButtonDisabled = false;
  // final _registrationFormKey = GlobalKey<FormState>();
  // bool isRegisterButtonDisabled = false;
  // bool showUserNotFoundError = false;

  Future<String?> getSessionKey() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("sessionKey");
  }
  @override
  Widget build(BuildContext context) {
    final mediaSize = Utilities.getDimensions(context);
    return SizedBox(
      height: 70,
      child: Card(
        elevation: 5,
        color: CustomTheme.secondaryBackground,
        margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
        child: Row(
          children: [
            Padding(
              child: SizedBox(
                width: mediaSize.width * 0.15,
                child: Image.asset('assets/images/logoTight.png')
              ),
              padding: const EdgeInsets.fromLTRB(20, 4, 0, 4),
            ),
            const Spacer(),
            SizedBox(
              width: mediaSize.width * 0.35,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    height: 35,
                    width: mediaSize.width * 0.06,
                    child: TextButton(
                      onPressed: ()=>{},
                      style: TextButton.styleFrom(
                          backgroundColor: CustomTheme.buttonPrimary
                      ),
                      child: Center(
                        child: Text(
                            "O NAS",
                            style: Constants.textStyle(
                                textStyle: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white
                                )
                            )
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 35,
                    width: mediaSize.width * 0.06,
                    child: TextButton(
                      onPressed: ()=>{},
                      style: TextButton.styleFrom(
                          backgroundColor: CustomTheme.buttonPrimary
                      ),
                      child: Center(
                        child: Text(
                            "ARTYKUŁY",
                            style: Constants.textStyle(
                                textStyle: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white
                                )
                            )
                        ),
                      ),
                    ),
                  ),
                  FutureBuilder(
                    future: getSessionKey(),
                    builder: (context, snapshot){
                      if(snapshot.hasData){
                        return SizedBox(
                            height: 35,
                            width: mediaSize.width * 0.06,
                            child: TextButton(
                              onPressed: ()=>{},
                              style: TextButton.styleFrom(
                                  backgroundColor: CustomTheme.buttonPrimary
                              ),
                              child: Center(
                                child: Text(
                                    "MOJE PRZEPISY",
                                    style: Constants.textStyle(
                                        textStyle: const TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.white
                                        )
                                    )
                                ),
                              ),
                            ),
                          );
                      }else{
                        return SizedBox(
                          height: 35,
                          width: mediaSize.width * 0.06,
                          child: TextButton(
                            onPressed: ()=>{},
                            style: TextButton.styleFrom(
                                backgroundColor: CustomTheme.buttonPrimary
                            ),
                            child: Center(
                              child: Text(
                                  "ZAREJESTRUJ",
                                  style: Constants.textStyle(
                                      textStyle: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.white
                                      )
                                  )
                              ),
                            ),
                          ),
                        );}}
                  ),
                  FutureBuilder(
                    future: getSessionKey(),
                    builder: (context, snapshot){
                      if(snapshot.hasData){
                        return SizedBox(
                          height: 35,
                          width: mediaSize.width * 0.06,
                          child: TextButton(
                            onPressed: ()=> {},
                            style: TextButton.styleFrom(
                                backgroundColor: CustomTheme.buttonSecondary
                            ),
                            child: Center(
                              child: Text(
                                  "USERNAME",
                                  style: Constants.textStyle(
                                      textStyle: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.white
                                      )
                                  )
                              ),
                            ),
                          ),
                        );
                      }else{
                        return SizedBox(
                            height: 35,
                            width: mediaSize.width * 0.06,
                            child: TextButton(
                            onPressed: ()=> LoginPopup().showPopup(context),
                            style: TextButton.styleFrom(
                                backgroundColor: CustomTheme.buttonSecondary
                            ),
                            child: Center(
                              child: Text(
                                  "ZALOGUJ",
                                  style: Constants.textStyle(
                                      textStyle: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.white
                                      )
                                  )
                              ),
                            ),
                          ),
                          );}}
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Login {
  Login();
  static String? _login;
  static String? _password;

  static Widget _buildLogin(){
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32.0),
      child: SizedBox(
        height: 80,
        child: TextFormField(
          decoration: InputDecoration(
            isDense: true,
            labelText: "Login użytkownika",
            labelStyle: TextStyle(
            color: CustomTheme.art4
          )),
          validator: (value) {
            if(value == null || value.isEmpty) {
              return 'Login nie może być pusty';
            }
            if(!RegExp(r"^[a-z0-9]*$").hasMatch(value)) {
              return 'Login może zawierać tylko małe litery i cyfry';
            }
            return null;
          },
          onSaved: (value){
            _login = value;
          },
        ),
      ),
    );
  }
  static Widget _buildPassword(){
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32.0),
      child: SizedBox(
        height: 80,
        child: TextFormField(
          obscureText: true,
          decoration: InputDecoration(
              isDense: true,
              labelText: "Hasło użytkownika",
              labelStyle: TextStyle(
              color: CustomTheme.art4
          )),
          validator: (value) {
            if(value == null || value.isEmpty) {
              return 'Hasło nie może być puste';
            }
            return null;
          },
          onSaved: (value){
            _password = value;
          },
        ),
      ),
    );
  }
}
