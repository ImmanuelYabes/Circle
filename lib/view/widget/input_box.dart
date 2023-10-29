import 'package:circle/constant/constant_builder.dart';
import 'dart:core';



InputDecoration inputDec(String text, Icon icon, {String? hint, bool isPassword = false, bool? obscure, ValueSetter<bool>? togglePass}) {
    return InputDecoration(
      labelText: text,
      hintText: hint,
      labelStyle: 
        const TextStyle(
          color: fontColor,
          fontSize: 15,
          fontWeight: FontWeight.w500,
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(
            color: appPurple
          )
        ),
        prefixIcon: icon,
        suffixIcon: (isPassword == true) 
        ? IconButton(
          splashRadius: 23,
                icon: Icon(
                  obscure! ? Icons.visibility_off : Icons.visibility,
                  color: Colors.grey,
                ),
                onPressed: () {
                  togglePass!(!obscure);
                },
              )
        : null,
      );
  }