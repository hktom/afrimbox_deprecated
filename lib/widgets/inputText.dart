import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class InputText extends StatefulWidget {
  String field;
  IconData fieldIcon;
  String fieldHint;
  bool enabled;
  bool password;
  bool autofocus;
  bool confirmPassword;
  String initialValue;
  TextInputType type;

  InputText(
      {Key key,
      this.type: TextInputType.text,
      this.initialValue = "",
      this.field,
      this.fieldIcon,
      this.fieldHint,
      this.enabled = true,
      this.password = false,
      this.confirmPassword = true,
      this.autofocus = false})
      : super(key: key);

  @override
  _InputTextState createState() => _InputTextState();
}

class _InputTextState extends State<InputText> {
  void _addUserInfo(text) {
    //Provider.of<LoginProvider>(context, listen: false).addUserInfo(field:widget.field, info: text);
  }

  String _confirmPassword(password2) {
    //String password=Provider.of<LoginProvider>(context, listen: false).userInfo['password'];

    // if(password==password2){
    //     return null;
    // }
    // else
    // {
    //   return "ce mot de passe ne correspond pas au premier";
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 3),
      child: TextFormField(
        initialValue: widget.initialValue,
        onChanged: (text) {
          //widget.field = text.trim();
          _addUserInfo(text.trim());
        },
        style: TextStyle(color: Colors.white),
        obscureText: widget.password,
        keyboardType: widget.type,
        decoration: InputDecoration(
          //hasFloatingPlaceholder: true,
          prefixIcon: Icon(
            widget.fieldIcon,
            color: Theme.of(context).hintColor,
          ),
          filled: true,
          fillColor: Color.fromRGBO(255, 255, 255, 0.3),
          border: InputBorder.none,
          hintText: widget.fieldHint,
          contentPadding: EdgeInsets.only(left: 14.0, bottom: 10.0, top: 10.0),
        ),
        enabled: widget.enabled,
        autofocus: widget.autofocus,
        enableSuggestions: true,
        validator: (value) {
          if (value.isEmpty) {
            return "${widget.field} ne peut pas rester vide";
          } else {
            if (widget.confirmPassword) {
              _confirmPassword(value);
            } else {
              return null;
            }
          }
        },
      ),
    );
  }
}
