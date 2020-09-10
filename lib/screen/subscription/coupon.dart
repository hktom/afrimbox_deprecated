import 'package:afrimbox/helpers/tex.dart';
import 'package:afrimbox/screen/subscription/subscriptionSuccess.dart';
import 'package:flutter/material.dart';
import 'package:afrimbox/provider/userProvider.dart';
import 'package:provider/provider.dart';
import 'package:get/get.dart';

class Coupon extends StatefulWidget {
  @override
  _CouponState createState() => _CouponState();
}

class _CouponState extends State<Coupon> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  UserProvider model;
  String error = '';
  String _usercoupon = '';

  void couponPay(value) {
    Map _coupon = model.checkCoupons(value);
    if (_coupon['valide']) {
      Get.back();
      Get.to(SubscriptionSuccess(
        amount: 0000,
        transactionId: _coupon['value'],
        couponPay: true,
        coupon: _coupon,
      ));
    } else {
      this.setState(() {
        error = "Ce coupon n'est pas valide";
      });
    }
  }

  @override
  void initState() {
    model = Provider.of<UserProvider>(context, listen: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          TextFormField(
            //enabled: !pending,
            initialValue: '',
            onChanged: (value) {
              this.setState(() => _usercoupon = value);
            },
            decoration: InputDecoration(
              prefixIcon: Icon(
                Icons.ac_unit,
                color: Theme.of(context).hintColor,
              ),
              filled: true,
              fillColor: Color.fromRGBO(255, 255, 255, 0.3),
              border: UnderlineInputBorder(),
              hintText: 'ex: special coupon ',
              contentPadding:
                  EdgeInsets.only(left: 14.0, bottom: 8.0, top: 8.0),
            ),
            style: TextStyle(color: Colors.black),
            keyboardType: TextInputType.text,
            validator: (value) {
              if (value.isEmpty) {
                return "Ne peut pas rester vide";
              }
            },
          ),
          SizedBox(
            height: 0.5,
          ),
          Tex(
            content: error,
            color: Colors.red,
            align: TextAlign.center,
          ),
          SizedBox(
            height: 10,
          ),
          Tex(
            content:
                "Si vous n'avez pas de coupon veuillez vous renseigner au près de votre fournisseur",
            align: TextAlign.center,
          ),
          SizedBox(
            height: 10,
          ),

          // _internationalNumber(),
          // button submit
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.50,
            child: RaisedButton(
              color: Theme.of(context).primaryColor,
              textColor: Colors.white,
              onPressed: () {
                if (_formKey.currentState.validate()) {
                  couponPay(_usercoupon);
                }
                print('pay by coupons');
                //Get.offAllNamed('/home');
              },
              child: Tex(content: "VALIDER", color: Colors.white),
            ),
          ),

          //SizedBox(child:Tex.p(color: Colors.red, text: error)),
        ],
      ),
    );
  }
}
