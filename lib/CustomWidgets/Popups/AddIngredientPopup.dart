import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:recipy/CustomWidgets/CustomTextbox.dart';
import 'package:recipy/Utilities/Constants.dart';
import 'package:recipy/Utilities/CustomTheme.dart';
import 'package:recipy/Utilities/Requests.dart';


class AddIngredientPopup{
  void showPopup(BuildContext context) {
    String errorText = "";
    bool success = false;
    bool isConfirmButtonDisabled = false;
    bool showError = false;
    final _addIngredientFormKey = GlobalKey<FormState>();

    showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(
              builder: (context, setState) {
                AddIngredient addIngredient = AddIngredient(_addIngredientFormKey, setState);
                return AlertDialog(
                  contentPadding: EdgeInsets.zero,
                  backgroundColor: CustomTheme.secondaryBackground,
                  content: SizedBox(
                    height: success ? 300 : 490,
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
                        success ? Container() : Text("Wniosek o nowy składnik",
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
                            Text("Wniosek został wysłany",
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
                            key: _addIngredientFormKey,
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    addIngredient._buildName(),
                                    addIngredient._buildUnit()
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    addIngredient._buildCalories(),
                                    addIngredient._buildFats()
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    addIngredient._buildCarbs(),
                                    addIngredient._buildProteins()
                                  ],
                                ),
                                const SizedBox(height: 20,),
                                SizedBox(
                                  height: 40,
                                  width: 130,
                                  child: TextButton(
                                      style: TextButton.styleFrom(
                                          backgroundColor: isConfirmButtonDisabled ? Colors.grey : CustomTheme.buttonSecondary
                                      ),
                                      child: Text(
                                          "WYŚLIJ",
                                          style: Constants.textStyle(
                                              textStyle: const TextStyle(
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.white
                                              )
                                          )
                                      ),
                                      onPressed: isConfirmButtonDisabled ? null : () async{
                                        if(_addIngredientFormKey.currentState!.validate()){
                                          setState(() {
                                            isConfirmButtonDisabled = true;
                                          });
                                          _addIngredientFormKey.currentState!.save();
                                          String token = await Requests.putIngredient(
                                              name: AddIngredient._name!,
                                              calories: AddIngredient._calories!,
                                              fats: AddIngredient._fats!,
                                              carbs: AddIngredient._carbs!,
                                              proteins: AddIngredient._proteins!,
                                              unit: AddIngredient._unit!
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

class AddIngredient{
  AddIngredient(this.formKey, this.setState);
  GlobalKey<FormState> formKey;
  Function setState;
  static String? _name;
  static double? _calories;
  static double? _fats;
  static double? _carbs;
  static double? _proteins;
  static String? _unit = "szt";

  final double _smallSize = 180;

  Widget _buildName(){
    return CustomTextbox(
        formKey: formKey,
        padding: const EdgeInsets.fromLTRB(32, 0, 0, 0),
        width: 300,
        maxLength: 30,
        labelText: "Nazwa składnika",
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Nazwa składnika nie może być pusta';
          }
          if(!RegExp(r"^[A-ZĄĆĘŁŃÓŚŹŻ][a-zA-ZąćęłńóśźżĄĆĘŁŃÓŚŹŻ ]*$").hasMatch(value)) {
            return 'Nazwa musi rozpoczynać się od wielkiej litery i nie może zawierać cyfr lub znaków specjalnych.';
          }
        },
        onSaved: (value) => _name = value
    );
  }
  Widget _buildCalories(){
    return CustomTextbox(
        formKey: formKey,
        width: _smallSize,
        maxLength: 16,
        padding: const EdgeInsets.fromLTRB(32, 0, 0, 0),
        labelText: "Ilość kalorii",
        inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))],
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Ilość kalorii nie może być pusta';
          }
          if(double.tryParse(value) == null) {
            return 'Podana ilość kalorii jest niepoprawna';
          }
        },
        onSaved: (value) => _calories = double.parse(value!)
    );
  }

  Widget _buildFats(){
    return CustomTextbox(
        formKey: formKey,
        width: _smallSize,
        maxLength: 16,
        padding: const EdgeInsets.fromLTRB(0, 0, 32, 0),
        labelText: "Ilość tłuszczy",
        inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))],
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Ilość tłuszczy nie może być pusta';
          }
          if(double.tryParse(value) == null) {
            return 'Podana ilość tłuszczy jest niepoprawna';
          }
        },
        onSaved: (value) => _fats = double.parse(value!)
    );
  }

  Widget _buildCarbs(){
    return CustomTextbox(
        formKey: formKey,
        width: _smallSize,
        maxLength: 16,
        padding: const EdgeInsets.fromLTRB(32, 0, 0, 0),
        labelText: "Ilość węglowodanów",
        inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))],
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Ilość węglowodanów nie może być pusta';
          }
          if(double.tryParse(value) == null) {
            return 'Podana ilość węglowodanów jest niepoprawna';
          }
        },
        onSaved: (value) => _carbs = double.parse(value!)
    );
  }

  Widget _buildProteins(){
    return CustomTextbox(
        formKey: formKey,
        width: _smallSize,
        maxLength: 16,
        padding: const EdgeInsets.fromLTRB(0, 0, 32, 0),
        labelText: "Ilość białka",
        inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))],
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Ilość białka nie może być pusta';
          }
          if(double.tryParse(value) == null) {
            return 'Podana ilość białka jest niepoprawna';
          }
        },
        onSaved: (value) => _proteins = double.parse(value!)
    );
  }

  Widget _buildUnit(){
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 32, 0),
      child: DropdownButton<String>(
        value: _unit,
        onChanged: (value) => setState(() => _unit = value!),
        items: ["szt", "mL", "L", "mg", "g", "kg"].map((value){
          return DropdownMenuItem(
            child: Text(value, style: TextStyle(color: CustomTheme.textDark),),
            value: value,
          );
        }).toList(),
        dropdownColor: CustomTheme.secondaryBackground,
        iconSize: 12,
        underline: Container(color: Colors.grey, height: 1,),
        icon: const Icon(Icons.keyboard_arrow_down, color: Colors.grey,),
        hint: Container(
          width: 45,
        ),
      ),
    );
  }
}