import 'package:flutter/material.dart';
import 'package:store_manager/auth/components/text_field_container.dart';

import '../services/validotrs.dart';

class RoundedInputField extends StatefulWidget {
  final String hintText;
  final ValueChanged<String> onChanged;
  final bool inputText;
  final IconData icon;
  final String controll;
  const RoundedInputField(
      {Key? key,
      required this.hintText,
      required this.onChanged,
      required this.inputText,
      this.icon = Icons.person,
      this.controll = "email"})
      : super(key: key);

  @override
  State<RoundedInputField> createState() => _RoundedInputFieldState();
}

class _RoundedInputFieldState extends State<RoundedInputField> {
  get kPrimaryColor => null;
  late TextEditingController _myController;
  @override
  void initState() {
    super.initState();
    _myController = TextEditingController();
  }

  @override
  void dispose() {
    _myController.dispose();
    super.dispose();
  }

  bool ontapFiled = false;

  @override
  Widget build(BuildContext context) {
    if (!widget.inputText) _myController.clear();
    return TextFieldContainer(
      child: TextField(
        onTap: () {
          setState(() {
            ontapFiled = true;
          });
        },
        controller: _myController,
        onChanged: widget.onChanged,
        cursorColor: kPrimaryColor,
        decoration: InputDecoration(
          errorText: ontapFiled
              ? widget.controll == 'email'
                  ? Validator.validateEmail(email: _myController.value.text)
                  : widget.controll == 'phone'
                      ? Validator.validPhoneNumber(
                          phone: _myController.value.text)
                      : Validator.validateName(name: _myController.value.text)
              : null,
          icon: Icon(
            widget.icon,
            color: kPrimaryColor,
          ),
          hintText: widget.hintText,
          border: InputBorder.none,
        ),
      ),
    );
  }
}
