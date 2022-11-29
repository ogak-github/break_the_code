import 'package:flutter/material.dart';

class CommonCard extends StatelessWidget {
  final String _title;
  const CommonCard({Key? key, required String title})
      : _title = title,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Center(
          child: Text(
            _title,
          ),
        ),
      ),
    );
  }
}
