import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SubMenuButton extends StatefulWidget {
  SubMenuButton({@required this.title, this.onPressed});
  Widget title;
  Function onPressed;

  @override
  _SubMenuButtonState createState() => _SubMenuButtonState(title: title, onPressed: onPressed);
}

class _SubMenuButtonState extends State<SubMenuButton> {
  _SubMenuButtonState({@required this.title, this.onPressed});
  Widget title;
  Function onPressed;

  @override
  Widget build(BuildContext context) {
    var _title = widget.title;
    return Padding(
        padding: const EdgeInsets.only(bottom: 8, left: 12, right: 12),
        child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: Colors.white,
              padding: const EdgeInsets.all(0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(5)),
              ),
              elevation: 2,
            ),
            onPressed: onPressed,
            child: ListTile(title: _title, trailing: Icon(Icons.arrow_forward))));
  }
}
