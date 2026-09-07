import 'package:flutter/material.dart';

class ErrorScreen extends StatelessWidget {
  final  buttonText;
  final  imageAssets ;
  final  onPressed;
  bool?  btnAvaiable;

  ErrorScreen({
    required this.buttonText,
    required this.imageAssets,
    required this.onPressed,
    required this.btnAvaiable,
    Key? key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            imageAssets,
            fit: BoxFit.cover,
          ),





          Positioned(
            bottom: 100,
            left: 30,
            child:
            TextButton(
              style: TextButton.styleFrom(
                padding: const EdgeInsets.all(16.0),
                foregroundColor: Colors.white,
                textStyle: const TextStyle(fontSize: 20),
                shape:  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50)),
              ),
              onPressed:  onPressed, child: Text(buttonText.toUpperCase()),
            ),
          )
        ],
      ),
    );
  }
}
