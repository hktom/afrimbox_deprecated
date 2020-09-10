import 'package:afrimbox/widgets/progressModal.dart';
import 'package:afrimbox/controller/firestoreController.dart';
import 'package:afrimbox/helpers/tex.dart';
import 'package:afrimbox/provider/userProvider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class SubscriptionSuccess extends StatefulWidget {
  final int amount;
  final bool couponPay;
  final Map coupon;
  final String transactionId;

  SubscriptionSuccess(
      {Key key,
      this.amount,
      this.transactionId,
      this.coupon,
      this.couponPay: false});

  @override
  _SubscriptionSuccessState createState() => _SubscriptionSuccessState();
}

class _SubscriptionSuccessState extends State<SubscriptionSuccess> {
  FireStoreController fireStoreController = new FireStoreController();
  var duration = 0;
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

  void _getDuration() {
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
  }

  Future<void> activationSubscription() async {
    //progressModal();
    if (widget.couponPay) {
      duration = widget.coupon['duration'];
    } else {
      _getDuration();
    }

    var model = Provider.of<UserProvider>(context, listen: false);
    Map<String, dynamic> dataUser = model.currentUser[0];

    if (model.subscriptionRemainDays() > 0) {
      await incrementSubscription(user: dataUser, duration: duration);
    } else {
      await newSubscription(user: dataUser, duration: duration);
    }
    //refresh dataUser
    await _refreshUserProfile(dataUser['id'], model);
    //await model.getCurrentUser([dataUser]);
  }

  Future<void> _refreshUserProfile(uid, model) async {
    var fireStoreUser =
        await fireStoreController.getDocument(collection: 'users', doc: uid);
    await model.getCurrentUser(fireStoreUser);
    Get.offAllNamed('/routeStack');
  }

  void updateCoupons(user) {
    if (user['coupons'] != null) {
      user['coupons'].add(widget.coupon['value']);
    } else {
      user['coupons'] = [widget.coupon['value']];
    }
  }

  Future<void> newSubscription({user, duration}) async {
    var today = new DateTime.now();
    var endDate = today.add(new Duration(days: duration));
    user['subscription'] = {
      'duration': duration,
      'debuteDate': DateTime.now(),
      'endDate': endDate,
      'transactionId': widget.transactionId
    };
    //upadate coupons
    if (widget.couponPay) {
      updateCoupons(user);
    }

    await fireStoreController.updateDocument(
        collection: 'users', doc: user['id'].trim(), data: user);
  }

  Future<void> incrementSubscription({user, duration}) async {
    Timestamp _timestamp = user['subscription']['endDate'];
    DateTime currentEndDate = new DateTime.fromMicrosecondsSinceEpoch(
        _timestamp.microsecondsSinceEpoch);
    var currentDuration = user['subscription']['duration'];
    var newEndDate = currentEndDate.add(new Duration(days: duration));
    user['subscription']['endDate'] = newEndDate;
    user['subscription']['duration'] = currentDuration + duration;
    //upadate coupons
    if (widget.couponPay) {
      updateCoupons(user);
    }
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
