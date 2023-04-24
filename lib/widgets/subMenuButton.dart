import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SubMenuButton extends StatefulWidget {
  SubMenuButton({required this.title, this.onPressed, this.disabled = false});
  final Widget title;
  final VoidCallback? onPressed;
  final bool disabled;

  @override
  _SubMenuButtonState createState() => _SubMenuButtonState(title: title, onPressed: onPressed, disabled: disabled);
}

class _SubMenuButtonState extends State<SubMenuButton> {
  _SubMenuButtonState({required this.title, this.onPressed, this.disabled = false});
  final Widget title;
  final VoidCallback? onPressed;
  final bool disabled;

  @override
  Widget build(BuildContext context) {
    var _title = widget.title;
    var _disabled = (widget.disabled == null) ? false : widget.disabled;
    return Padding(
        padding: const EdgeInsets.only(bottom: 8, left: 12, right: 12),
        child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).dialogBackgroundColor,
              padding: const EdgeInsets.all(0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(5)),
              ),
              elevation: 2,
            ),
            onPressed: _disabled ? null : onPressed,
            child: ListTile(
                title: _title,
                trailing: Icon(
                  Icons.arrow_forward,
                  color: Theme.of(context).textTheme.bodyLarge?.color,
                ))));
  }
}
