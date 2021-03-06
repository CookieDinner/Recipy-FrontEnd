import 'dart:html' as html;

import 'package:flutter/material.dart';
import 'package:recipy/CustomWidgets/CustomTextbox.dart';
import 'package:recipy/Utilities/Constants.dart';
import 'package:recipy/Utilities/CustomRoute.dart';
import 'package:recipy/Utilities/CustomTheme.dart';
import 'package:recipy/Utilities/Requests.dart';
import 'package:recipy/Views/Home.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPopup{
  void showPopup(BuildContext context){
    final _loginFormKey = GlobalKey<FormState>();
    Login login = Login(_loginFormKey);
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
                    height: 390,
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
                                          }else if (token != "connfailed" || token != "conntimeout" || token != "httpexception"){
                                            SharedPreferences prefs = await SharedPreferences.getInstance();
                                            prefs.setString("accessToken", token);
                                            Navigator.pushAndRemoveUntil(
                                              context,
                                              CustomRoute(Home()),
                                              ModalRoute.withName('/'),
                                            );
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
                                  child: Text("U??ytkownik z podanym has??em/loginem nie istnieje", style: TextStyle(color: Colors.redAccent, fontSize: 15),),
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
  Login(this.formKey);
  GlobalKey<FormState> formKey;
  static String? _login;
  static String? _password;

  Widget _buildLogin(){
    return CustomTextbox(
        formKey: formKey,
        labelText: "Login u??ytkownika",
        validator: (value) {
          if(value == null || value.isEmpty) {
            return 'Login nie mo??e by?? pusty';
          }
          if(!RegExp(r"^[a-z0-9]*$").hasMatch(value) || value.length > 19) {
            return 'Tylko ma??e litery i cyfry oraz mniej ni?? 20 znak??w';
          }
          return null;
        },
        onSaved: (value){
          _login = value;
        },
    );
  }

  Widget _buildPassword(){
    return CustomTextbox(
        formKey: formKey,
        labelText: "Has??o u??ytkownika",
        obscured: true,
        validator: (value) {
          if(value == null || value.isEmpty) {
            return 'Has??o nie mo??e by?? puste';
          }
          return null;
        },
        onSaved: (value){
          _password = value;
        }
    );
  }
}
