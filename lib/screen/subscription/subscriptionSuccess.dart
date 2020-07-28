import 'package:afrimbox/helpers/tex.dart';
import 'package:flutter/material.dart';

class SubscriptionSuccess extends StatefulWidget {
  final int amount;
  final String transactionId;

  SubscriptionSuccess({Key key, this.amount, this.transactionId});

  @override
  _SubscriptionSuccessState createState() => _SubscriptionSuccessState();
}

class _SubscriptionSuccessState extends State<SubscriptionSuccess> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: Tex(
          content: "Abonnement réussi",
          color: Colors.white,
          size: 'h4',
          bold: FontWeight.bold,
        ),
      ),
      body: Container(
        child: Center(
          child: Tex(
            content: widget.amount.toString(),
            size: 'h1',
          ),
        ),
      ),
    );
  }
}
