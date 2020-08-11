import 'package:afrimbox/components/progressModal.dart';
import 'package:afrimbox/controller/firestoreController.dart';
import 'package:afrimbox/helpers/tex.dart';
import 'package:afrimbox/provider/userProvider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class SubscriptionSuccess extends StatefulWidget {
  final int amount;
  final String transactionId;

  SubscriptionSuccess({Key key, this.amount, this.transactionId});

  @override
  _SubscriptionSuccessState createState() => _SubscriptionSuccessState();
}

class _SubscriptionSuccessState extends State<SubscriptionSuccess> {
  FireStoreController fireStoreController = new FireStoreController();
  //show dialog
  Future<void> progressModal() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return ProgressModal(
          title: "Activation en cours",
        );
      },
    );
  }

  Future<void> activationSubscription() async {
    //progressModal();
    var duration = 0;
    switch (widget.amount) {
      case 500:
        duration = 2;
        break;

      case 1000:
        duration = 4;
        break;

      case 2500:
        duration = 10;
        break;

      default:
    }

    var model = Provider.of<UserProvider>(context, listen: false);
    Map<String, dynamic> dataUser = model.currentUser[0];

    if (model.subscriptionRemainDays() > 0) {
      await incrementSubscription(user: dataUser, duration: duration);
    } else {
      await newSubscription(user: dataUser, duration: duration);
    }
    //refresh dataUser
    await model.getCurrentUser([dataUser]);

    Get.offAllNamed('/routeStack');
  }

  Future<void> newSubscription({user, duration}) async {
    var today = new DateTime.now();
    var endData = today.add(new Duration(days: duration));
    user['subscription'] = {
      'duration': duration,
      'debuteDate': DateTime.now(),
      'endDate': endData,
      'transactionId': widget.transactionId
    };
    await fireStoreController.updateDocument(
        collection: 'users', doc: user['id'].trim(), data: user);
  }

  Future<void> incrementSubscription({user, duration}) async {
    var currentEndDate = user['subscription']['endDate'];
    var currentDuration = user['subscription']['duration'];
    var newEndDate = currentEndDate.add(new Duration(days: duration));
    user['subscription']['endDate'] = newEndDate;
    user['subscription']['duration'] = currentDuration + duration;
    await fireStoreController.updateDocument(
        collection: 'users', doc: user['id'].trim(), data: user);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    activationSubscription();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: Tex(
          content: "Activation Abonnement",
          color: Colors.white,
          size: 'h4',
          bold: FontWeight.bold,
        ),
      ),
      body: Container(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}
