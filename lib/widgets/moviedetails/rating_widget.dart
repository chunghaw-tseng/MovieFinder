import 'package:flutter/material.dart';

class RatingWidget extends StatelessWidget {
  final double rating;
  const RatingWidget({Key key, this.rating}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10),
      child: Container(
        child: Card(
          elevation: 2,
          color: Color(0xffbda96b),
          child: ClipPath(
            child: Container(
                width: 60,
                height: 25,
                child: Row(
                  children: [
                    Icon(
                      Icons.star,
                      color: Colors.white,
                    ),
                    Text("$rating")
                  ],
                )),
            clipper: ShapeBorderClipper(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10))),
          ),
        ),
      ),
    );
  }
}
