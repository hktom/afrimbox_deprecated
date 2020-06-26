import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoadingSpinner extends StatefulWidget {
  @override
  _LoadingSpinnerState createState() => _LoadingSpinnerState();
}

class _LoadingSpinnerState extends State<LoadingSpinner> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: SpinKitPulse(size: 60, color: Theme.of(context).primaryColor),
    );
  }
}
