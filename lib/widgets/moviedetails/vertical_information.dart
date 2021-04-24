import 'package:flutter/material.dart';

class VerticalInformation extends StatelessWidget {
  final String label;
  final String info;
  const VerticalInformation({Key key, this.label, this.info}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text("$label"),
          Text(
            "$info",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          )
        ],
      ),
    );
  }
}
