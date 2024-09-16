import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  const Button(
      {super.key,
      required this.radiusCorner,
      required this.internalText,
      required this.onTap});
  final int radiusCorner;
  final String internalText;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Container(
            padding: const EdgeInsets.all(50.0),
            decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: radiusCorner == 1
                    ? const BorderRadius.only(
                        topLeft: Radius.circular(20.0),
                        bottomRight: Radius.circular(20.0),
                      )
                    : radiusCorner == 2
                        ? const BorderRadius.only(
                            topRight: Radius.circular(20.0),
                            bottomLeft: Radius.circular(20.0),
                          )
                        : radiusCorner == 3
                            ? const BorderRadius.only(
                                bottomLeft: Radius.circular(20.0),
                                topRight: Radius.circular(20.0))
                            : const BorderRadius.only(
                                bottomRight: Radius.circular(20.0),
                                topLeft: Radius.circular(20.0))),
            child: Center(
              child: Text(
                textAlign: TextAlign.center,
                internalText,
                style: const TextStyle(
                  color: Colors.white,
                ),
              ),
            )),
      ),
    );
  }
}
