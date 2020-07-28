import 'package:afrimbox/helpers/tex.dart';
import 'package:afrimbox/screen/subscription/subscriptionSuccess.dart';
import 'package:flutter/material.dart';
import 'package:expansion_card/expansion_card.dart';
import 'package:get/get.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
// kkiapay
import 'package:kkiapay_flutter_sdk/kkiapayConf.sample.dart';
import 'package:kkiapay_flutter_sdk/kkiapayWebview.dart';
import 'package:kkiapay_flutter_sdk/utils/Kkiapay.dart';

class Subscription extends StatefulWidget {
  @override
  _SubscriptionState createState() => _SubscriptionState();
}

class _SubscriptionState extends State<Subscription> {
  //call after transaction
  void sucessCallback(response, context) {
    print(response);
    Get.back();
    Get.to(SubscriptionSuccess(
        amount: response['amount'], transactionId: response['transactionId']));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: Tex(
          content: "l'abonnement",
          color: Colors.white,
          size: 'h4',
          bold: FontWeight.bold,
        ),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: ListView(
          children: <Widget>[
            Container(
              alignment: Alignment.center,
              margin: EdgeInsets.symmetric(vertical: 20),
            ),
            _subscription(
                color: Color.fromRGBO(255, 93, 94, 1),
                type: 1,
                price: 500,
                description:
                    "Abonnement Solo \n Uniquement pour les films et séries",
                session: '48 heures / 2 jours'),
            _subscription(
                color: Color.fromRGBO(255, 187, 52, 1),
                type: 2,
                price: 1000,
                description:
                    "Abonnement Premium \n Films, Séries et Chaines TV",
                session: '96 heures / 4 jours '),
            _subscription(
                color: Color.fromRGBO(166, 116, 247, 1),
                type: 3,
                price: 2500,
                description:
                    "Abonnement Premium + \n Uniquement pour les films et séries plus: Bons carburant, Bons restaurant, Bons Momo",
                session: '10 jours'),
            // _subscription(price: 1000.0),
            // _subscription(price: 2500.00),
          ],
        ),
      ),
    );
  }

  Widget _subscription(
      {int price, int type, String description, String session, Color color}) {
    return Card(
      color: color,
      child: ListTile(
        onTap: () {
          Get.to(KKiaPay(
            apikey: 'bb4c2370cbc011ea84cb097ce4c306b7',
            amount: price,
            phone: '97000000',
            data: description,
            sandbox: true,
            callback: sucessCallback,
          ));
        },
        contentPadding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        title: Tex(
          content: "${price.toString()} FCFA",
          size: 'h1',
          bold: FontWeight.bold,
          color: Colors.black,
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Tex(
              content: session,
              size: 'h6',
              //bold: FontWeight.bold,
              color: Colors.black,
            ),
            Tex(
              content: description,
              size: 'p',
              // /bold: FontWeight.bold,
              color: Colors.black,
            ),
          ],
        ),
        trailing: SmoothStarRating(
          starCount: type,
          color: Colors.blue,
          borderColor: Colors.white,
          isReadOnly: true,
        ),
      ),
    );
  }
}
