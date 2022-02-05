import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:recipy/CustomWidgets/CustomTextbox.dart';
import 'package:recipy/Utilities/Constants.dart';
import 'package:recipy/Utilities/CustomTheme.dart';
import 'dart:html' as html;
import 'package:intl/intl.dart';

import 'package:recipy/Utilities/Requests.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegisterPopup{

  void showPopup(BuildContext context){
    String errorText = "";
    bool success = false;
    final _registerFormKey = GlobalKey<FormState>();
    Register register = Register(_registerFormKey);
    bool isRegisterButtonDisabled = false;
    bool showError = false;
    showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(
              builder: (context, setState) {
                return AlertDialog(
                  contentPadding: EdgeInsets.zero,
                  backgroundColor: CustomTheme.secondaryBackground,
                  content: SizedBox(
                    height: success ? 300 : 710,
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
                        success ? Container() : Text("Rejestracja",
                          style: Constants.textStyle(
                              textStyle: TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                  color: CustomTheme.text,
                                  height: 0
                              )
                          ),
                        ),
                        success ? const SizedBox(height: 20,) : const SizedBox(height: 50,),
                        success ? Column(
                          children: [
                            const Icon(Icons.check_circle, size: 120, color: Colors.green,),
                            Text("Konto zostało utworzone",
                              style: Constants.textStyle(
                                  textStyle: TextStyle(
                                      fontSize: 32,
                                      fontWeight: FontWeight.bold,
                                      color: CustomTheme.text,
                                      height: 0
                                  )
                              ),
                            ),
                          ],
                        ) : Form(
                            key: _registerFormKey,
                            child: Column(
                              children: [
                                register._buildLogin(),
                                register._buildUsername(),
                                register._buildEmail(),
                                register._buildPassword(),
                                register._buildConfirmPassword(),
                                register._buildDatePicker(context),
                                SizedBox(
                                  height: 40,
                                  width: 130,
                                  child: TextButton(
                                      style: TextButton.styleFrom(
                                          backgroundColor: isRegisterButtonDisabled ? Colors.grey : CustomTheme.buttonSecondary
                                      ),
                                      child: Text(
                                          "ZAREJESTRUJ",
                                          style: Constants.textStyle(
                                              textStyle: const TextStyle(
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.white
                                              )
                                          )
                                      ),
                                      onPressed: isRegisterButtonDisabled ? null : () async{
                                        if(_registerFormKey.currentState!.validate()){
                                          setState(() {
                                            isRegisterButtonDisabled = true;
                                          });
                                          _registerFormKey.currentState!.save();
                                          String response = await Requests.putRegister(
                                              login: Register._login!,
                                              username: Register._username!,
                                              email: Register._email!,
                                              password: Register._password!,
                                              birth_date: Register._birth_date!);
                                          if (response != "Good"){
                                            setState((){
                                              errorText = response;
                                              showError = true;
                                            });
                                          }else {
                                            setState((){
                                              success = true;
                                            });
                                          }
                                          setState(() {
                                            isRegisterButtonDisabled = false;
                                          });
                                        }
                                      }
                                  ),
                                ),
                                !showError ? Container() : Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                                  child: Text(errorText, style: const TextStyle(color: Colors.redAccent, fontSize: 15),),
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

class Register {
  Register(this.formKey);
  GlobalKey<FormState> formKey;
  static String? _login;
  static String? _password;
  static String? _email;
  static String? _username;
  static String? _birth_date;

  TextEditingController passwordController = TextEditingController();

  Widget _buildLogin(){
    return CustomTextbox(
        formKey: formKey,
        labelText: "Login",
        validator: (value) {
          if(value == null || value.isEmpty) {
            return 'Login nie może być pusty';
          }
          if(!RegExp(r"^[a-z0-9]*$").hasMatch(value) || value.length > 19) {
            return 'Tylko małe litery i cyfry oraz mniej niż 20 znaków';
          }
          return null;
        },
        onSaved: (value) => _login = value
    );
  }
  Widget _buildUsername(){
    return CustomTextbox(
        formKey: formKey,
        labelText: "Pseudonim",
        validator: (value) {
          if(value == null || value.isEmpty) {
            return 'Pseudonim nie może być pusty';
          }
          if(!RegExp(r"^[a-zA-Z0-9]*$").hasMatch(value) || value.length > 11) {
            return 'Tylko litery i cyfry oraz mniej niż 12 znaków';
          }
          return null;
        },
        onSaved: (value) => _username = value
    );
  }
  Widget _buildEmail(){
    return CustomTextbox(
        formKey: formKey,
        labelText: "Adres email",
        validator: (value) {
          if(value == null || value.isEmpty) {
            return 'Email nie może być pusty';
          }
          if(!RegExp(r"(?:[a-z0-9!#$%&'*+=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+=?^_`{|}~-]+)*|)@(?:(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\[(?:(?:(2(5[0-5]|[0-4][0-9])|1[0-9][0-9]|[1-9]?[0-9]))\.){3}(?:(2(5[0-5]|[0-4][0-9])|1[0-9][0-9]|[1-9]?[0-9])|[a-z0-9-]*[a-z0-9]:(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21-\x5a\x53-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])+)\])").hasMatch(value)) {
            return 'Podany email jest niepoprawny';
          }
          return null;
        },
        onSaved: (value) => _email = value
    );
  }
  Widget _buildPassword(){
    return CustomTextbox(
        formKey: formKey,
        labelText: "Hasło",
        obscured: true,
        controller: passwordController,
        validator: (value) {
          if(value == null || value.isEmpty) {
            return 'Hasło nie może być puste';
          }
          return null;
        },
        onSaved: (value){},
    );
  }
  Widget _buildConfirmPassword(){
    return CustomTextbox(
        formKey: formKey,
        labelText: "Powtórz hasło",
        obscured: true,
        validator: (value) {
          if(value == null || value.isEmpty) {
            return 'Hasło nie może być puste';
          }
          if(value != passwordController.text){
            return 'Podane hasła muszą się ze sobą zgadzać';
          }
          return null;
        },
        onSaved: (value) => _password = value
    );
  }
  TextEditingController datePickerController = TextEditingController();
  Widget _buildDatePicker(BuildContext context){
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32.0),
      child: SizedBox(
        height: 80,
        child: TextFormField(
          controller: datePickerController,
          onTap: () => showDatePicker(
              context: context,
              initialEntryMode: DatePickerEntryMode.calendarOnly,
              initialDate: DateTime.now(),
              firstDate: DateTime(1900),
              lastDate: DateTime.now(),
              builder: (context, child){
                return Theme(
                  data: ThemeData().copyWith(
                    colorScheme: ColorScheme.light(
                      primary: CustomTheme.iconSelectedFill,
                    ),
                    dialogBackgroundColor: CustomTheme.secondaryBackground,
                  ),
                  child: child!,
                );
              }
          ).then((value) {
            if(value != null) {
              datePickerController.text = DateFormat('MM-dd-yyyy').format(value).toString();
              formKey.currentState?.validate();
            }
          }),
          readOnly: true,
          decoration: InputDecoration(
              isDense: true,
              labelText: "Data urodzenia",
              labelStyle: TextStyle(
                  color: CustomTheme.art4
              )),
          validator: (value) {
            if(value == null || value.isEmpty){
              return 'Data urodzenia nie może być pusta';
            }
            return null;
          },
          onSaved: (value){
            _birth_date = value;
          },
        ),
      ),
    );
  }
}