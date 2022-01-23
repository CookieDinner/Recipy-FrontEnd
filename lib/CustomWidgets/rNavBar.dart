import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:recipy/CustomWidgets/CustomDropdown.dart';
import 'package:recipy/CustomWidgets/LoginPopup.dart';
import 'package:recipy/CustomWidgets/RegisterPopup.dart';
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
  StreamController<bool> registerButtonStreamController = StreamController<bool>();
  StreamController<String> loginButtonStreamController = StreamController<String>();

  Future<String?> getAccessToken() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString("accessToken");
    return accessToken;
  }
  Future<String?> getUserData() async{
    String userData = await Requests.getUserData();
    return userData;
  }

  @override
  void initState() {
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) async {
      String? accessToken = await getAccessToken();
      if (accessToken != null){
        String? userData = await getUserData();
        String username = jsonDecode(userData!)["username"];
        loginButtonStreamController.add(username);
        registerButtonStreamController.add(true);
      }
    });
    super.initState();
  }
  @override
  void dispose() {
    registerButtonStreamController.close();
    loginButtonStreamController.close();
    super.dispose();
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
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: SizedBox(
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
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: SizedBox(
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
                  ),
                  StreamBuilder(
                    stream: registerButtonStreamController.stream,
                    builder: (context, snapshot){
                      if(snapshot.hasData){
                        return const SizedBox.shrink();
                      }else{
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: SizedBox(
                            height: 35,
                            width: mediaSize.width * 0.06,
                            child: TextButton(
                              onPressed: ()=> RegisterPopup().showPopup(context),
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
                          ),
                        );}}
                  ),
                  StreamBuilder(
                    stream: loginButtonStreamController.stream,
                    builder: (context, snapshot){
                      if(snapshot.hasData){
                        return Padding(
                          padding: const EdgeInsets.fromLTRB(20, 0, 40, 0),
                          child: Container(
                            height: 35,
                            width: mediaSize.width * 0.06,
                            decoration: BoxDecoration(
                              color: CustomTheme.buttonSecondary,
                              borderRadius: const BorderRadius.all(Radius.circular(4))
                            ),
                            child: CustomDropdown.buildDropdown(mediaSize, snapshot)
                          ),
                        );
                      }else{
                        return Padding(
                          padding: const EdgeInsets.fromLTRB(20, 0, 40, 0),
                          child: SizedBox(
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
                          ),
                        );
                      }
                    }
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

