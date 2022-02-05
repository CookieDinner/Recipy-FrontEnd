
import 'package:flutter/material.dart';
import 'package:recipy/CustomWidgets/CustomTextbox.dart';
import 'package:recipy/Utilities/Constants.dart';
import 'package:recipy/Utilities/CustomTheme.dart';
import 'package:recipy/Utilities/Requests.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:html' as html;

class ChangePasswordPopup{
  void showPopup(BuildContext context){
    String errorText = "";
    bool success = false;
    bool isConfirmButtonDisabled = false;
    bool showError = false;
    final _changePasswordFormKey = GlobalKey<FormState>();
    ChangePassword changePassword = ChangePassword(_changePasswordFormKey);
    showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(
              builder: (context, setState) {
                return AlertDialog(
                  contentPadding: EdgeInsets.zero,
                  backgroundColor: CustomTheme.secondaryBackground,
                  content: SizedBox(
                    height: success ? 300 : 470,
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
                        success ? Container() : Text("Zmień hasło",
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
                            Text("Hasło zostało zmienione",
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
                            key: _changePasswordFormKey,
                            child: Column(
                              children: [
                                changePassword._buildOldPassword(),
                                changePassword._buildNewPassword(),
                                changePassword._buildRepeatNewPassword(),
                                SizedBox(
                                  height: 40,
                                  width: 130,
                                  child: TextButton(
                                      style: TextButton.styleFrom(
                                          backgroundColor: isConfirmButtonDisabled ? Colors.grey : CustomTheme.buttonSecondary
                                      ),
                                      child: Text(
                                          "ZMIEŃ HASŁO",
                                          style: Constants.textStyle(
                                              textStyle: const TextStyle(
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.white
                                              )
                                          )
                                      ),
                                      onPressed: isConfirmButtonDisabled ? null : () async{
                                        if(_changePasswordFormKey.currentState!.validate()){
                                          setState(() {
                                            isConfirmButtonDisabled = true;
                                          });
                                          _changePasswordFormKey.currentState!.save();
                                          String token = await Requests.patchPassword(
                                            password: ChangePassword._oldPassword!,
                                            new_password: ChangePassword._newPassword!
                                          );
                                          if (token != "Good"){
                                            setState((){
                                              showError = true;
                                              errorText = token;
                                            });
                                          }else {
                                            setState((){
                                              success = true;
                                            });
                                          }
                                          setState(() {
                                            isConfirmButtonDisabled = false;
                                          });
                                        }
                                      }
                                  ),
                                ),
                                !showError ? Container() : Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                                  child: Text(errorText, style: TextStyle(color: Colors.redAccent, fontSize: 15),),
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

class ChangePassword{
  ChangePassword(this.formKey);
  GlobalKey<FormState> formKey;
  static String? _oldPassword;
  static String? _newPassword;

  TextEditingController newPasswordController = TextEditingController();

  Widget _buildOldPassword(){
    return CustomTextbox(
        formKey: formKey,
        labelText: "Stare hasło",
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Hasło nie może być puste';
          }
        },
        obscured: true,
        onSaved: (value) => _oldPassword = value
    );
  }

  Widget _buildNewPassword(){
    return CustomTextbox(
        formKey: formKey,
        labelText: "Nowe hasło",
        obscured: true,
        controller: newPasswordController,
        validator: (value){
          if (value == null || value.isEmpty) {
            return 'Hasło nie może być puste';
          }
        },
        onSaved: (value){}
    );
  }

  Widget _buildRepeatNewPassword(){
    return CustomTextbox(
        formKey: formKey,
        labelText: "Powtórz nowe hasło",
        obscured: true,
        validator: (value){
          if (value == null || value.isEmpty) {
            return 'Hasło nie może być puste';
          }
          if (value != newPasswordController.text) {
            return 'Podane nowe hasła muszą się ze sobą zgadzać';
          }
        },
        onSaved: (value) => _newPassword = value
    );
  }
}