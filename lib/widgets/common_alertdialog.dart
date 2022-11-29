import 'package:flutter/material.dart';

class CommonAlertDialog extends StatelessWidget {
  // final Image _image;
  final String _textName;
  final Icon _icon;
  const CommonAlertDialog({
    Key? key,
    required Icon icon,
    required String textName,
  })  : _icon = icon,
        _textName = textName,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _icon,
          const SizedBox(height: 16.0),
          Text(
            _textName,
            style: Theme.of(context).textTheme.headline5,
          ),
        ],
      ),
    );
  }
}
