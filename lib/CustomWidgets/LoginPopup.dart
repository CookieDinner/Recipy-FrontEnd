import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:recipy/Utilities/Constants.dart';
import 'package:recipy/Utilities/CustomTheme.dart';
import 'dart:html' as html;

import 'package:recipy/Utilities/Requests.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPopup{

  void showPopup(BuildContext context){
    Login login = Login();
    final _loginFormKey = GlobalKey<FormState>();
    bool isLoginButtonDisabled = false;
    bool showUserNotFoundError = false;
    showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(
              builder: (context, setState) {
                return AlertDialog(
                  contentPadding: EdgeInsets.zero,
                  backgroundColor: CustomTheme.secondaryBackground,
                  content: SizedBox(
                    height: 450,
                    width: 450,
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(
                              onPressed: (){
                                Navigator.of(context).pop();
                              },
                              padding: EdgeInsets.zero,
                              icon: Icon(Icons.close, color: CustomTheme.textDark,),
                            ),
                          ],
                        ),
                        Text("Logowanie",
                          style: Constants.textStyle(
                              textStyle: TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                  color: CustomTheme.text,
                                  height: 0
                              )
                          ),
                        ),
                        SizedBox(height: 50,),
                        Form(
                            key: _loginFormKey,
                            child: Column(
                              children: [
                                login._buildLogin(),
                                login._buildPassword(),
                                SizedBox(
                                  height: 40,
                                  width: 130,
                                  child: TextButton(
                                      style: TextButton.styleFrom(
                                          backgroundColor: isLoginButtonDisabled ? Colors.grey : CustomTheme.buttonSecondary
                                      ),
                                      child: Text(
                                          "ZALOGUJ",
                                          style: Constants.textStyle(
                                              textStyle: const TextStyle(
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.white
                                              )
                                          )
                                      ),
                                      onPressed: isLoginButtonDisabled ? null : () async{
                                        if(_loginFormKey.currentState!.validate()){
                                          setState(() {
                                            isLoginButtonDisabled = true;
                                          });
                                          _loginFormKey.currentState!.save();
                                          String token = await Requests.postLogin(Login._login!, Login._password!);
                                          if (token == "NotFound"){
                                            setState((){
                                              showUserNotFoundError = true;
                                            });
                                          }else {
                                            SharedPreferences prefs = await SharedPreferences.getInstance();
                                            prefs.setString("accessToken", token);
                                            html.window.location.reload();
                                          }
                                          setState(() {
                                            isLoginButtonDisabled = false;
                                          });
                                        }
                                      }
                                  ),
                                ),
                                !showUserNotFoundError ? Container() : const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 16.0),
                                  child: Text("Użytkownik z podanym hasłem/loginem nie istnieje", style: TextStyle(color: Colors.redAccent, fontSize: 15),),
                                )
                              ],
                            )
                        )
                      ],
                    ),
                  ),
                );}
          );
        });
  }
}

class Login {
  Login();
  static String? _login;
  static String? _password;

  Widget _buildLogin(){
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
            if(!RegExp(r"^[a-z0-9]*$").hasMatch(value) || value.length > 19) {
              return 'Tylko małe litery i cyfry oraz mniej niż 20 znaków';
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
  Widget _buildPassword(){
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