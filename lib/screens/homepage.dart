import 'package:flutter/material.dart';

class Homepage extends StatelessWidget {
  String tk;
  Homepage(this.tk);
  Widget build(context) {
    return Scaffold(
      body: Center(child: Text("${tk}"))
    );
  }
} 