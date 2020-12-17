import 'package:afrimbox/helpers/tex.dart';
import 'package:afrimbox/provider/userProvider.dart';
import 'package:afrimbox/screen/subscription/coupon.dart';
import 'package:afrimbox/screen/subscription/subscriptionSuccess.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:kkiapay_flutter_sdk/kkiapayWebview.dart';

class SubscriptionPage extends StatefulWidget {
  final bool firstStep;
  SubscriptionPage({Key key, this.firstStep: false}) : super(key: key);
  //final
  @override
  _SubscriptionPageState createState() => _SubscriptionPageState();
}

class _SubscriptionPageState extends State<SubscriptionPage>
    with AutomaticKeepAliveClientMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  //call after transaction
  void sucessCallback(response, context) {
    print(response);
    Get.back();
    Get.to(SubscriptionSuccess(
        amount: response['amount'], transactionId: response['transactionId']));
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      key: _scaffoldKey,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.ac_unit),
        onPressed: () {
          showMaterialModalBottomSheet(
            context: context,
            builder: (context, scrollController) => Container(
              height: MediaQuery.of(context).size.height * 0.8,
              padding: EdgeInsets.fromLTRB(10, 20, 10, 0),
              child: Coupon(),
            ),
          );
        },
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
                price: 1250,
                description:
                    "Abonnement Premium \n Films, Séries et Chaines TV",
                session: '96 heures / 4 jours '),
            _subscription(
                color: Color.fromRGBO(166, 116, 247, 1),
                type: 3,
                price: 3000,
                description:
                    "Abonnement Premium + \n Uniquement pour les films et séries plus: Bons carburant, Bons restaurant, Bons Momo",
                session: '10 jours'),
            SizedBox(
              height: 10,
            ),
            widget.firstStep
                ? RaisedButton(
                    onPressed: () {
                      Get.offAllNamed('/home');
                    },
                    color: Theme.of(context).primaryColor,
                    child: Tex(
                      content: "Remettre à plus tard",
                      color: Colors.white,
                    ),
                  )
                : SizedBox.shrink()
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
            apikey: 'bd4ea720990711e99551a5d587ddabb7',
            amount: price,
            phone: Provider.of<UserProvider>(context, listen: false)
                .currentUser[0]['phone']
                .toString()
                .substring(4),
            data: description,
            sandbox: false,
            callback: sucessCallback,
            theme: '#9E1919',
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
