import 'package:afrimbox/widgets/progressModal.dart';
import 'package:afrimbox/controller/firestoreController.dart';
import 'package:afrimbox/helpers/tex.dart';
import 'package:afrimbox/provider/userProvider.dart';
import 'package:afrimbox/screen/subscription/subscriptionPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cool_stepper/cool_stepper.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:provider/provider.dart';

class CreateProfile extends StatefulWidget {
  //final String authMethod;
  final FirebaseUser user;
  CreateProfile({Key key, this.user}) : super(key: key);
  @override
  _CreateProfileState createState() => _CreateProfileState();
}

class _CreateProfileState extends State<CreateProfile> {
  bool startConfiguration = false;
  final GlobalKey<FormBuilderState> _phoneKey = GlobalKey<FormBuilderState>();
  final GlobalKey<FormBuilderState> _emailKey = GlobalKey<FormBuilderState>();
  final GlobalKey<FormBuilderState> _nameKey = GlobalKey<FormBuilderState>();
  FireStoreController fireStoreController = new FireStoreController();
  var phoneNumberController = TextEditingController();
  var emailController = TextEditingController();
  var nameController = TextEditingController();
  Map<String, dynamic> userProfile = {};
  PhoneNumber number = PhoneNumber(isoCode: 'NG');

  Future<void> createProfile() async {
    showProgressModal();
    userProfile['id'] = widget.user.uid;
    userProfile['photoUrl'] = widget.user.photoUrl;
    userProfile['created_at'] = DateTime.now();
    userProfile['updated_at'] = DateTime.now();
    //userProfile['authMethod'] = widget.authMethod;
    //String userId = widget.user.uid;

    bool result = await fireStoreController.insertDocument(
        collection: 'users', data: userProfile, doc: widget.user.uid);

    if (result) {
      //get current profile
      bool result = await Provider.of<UserProvider>(context, listen: false)
          .getProfile(widget.user.uid);
      Get.back();
      if (result) {
        Get.offAll(SubscriptionPage(
          firstStep: true,
        ));
      }
    }
  }

  Future<void> showProgressModal() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return ProgressModal(
          title: "Création du profile",
        );
      },
    );
  }

  @override
  void initState() {
    if (widget.user.phoneNumber != null)
      phoneNumberController.text = widget.user.phoneNumber.substring(4);
    else
      phoneNumberController.text = '';
    emailController.text = widget.user.email;
    nameController.text = widget.user.displayName;
    userProfile['phone'] = phoneNumberController.text;
    userProfile['email'] = emailController.text;
    userProfile['name'] = nameController.text;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // sepper
    List<CoolStep> steps = [
      CoolStep(
          title: "Votre numéro de télephone",
          subtitle: "Vous ne pourrez plus le changer ultérieurement",
          content: confiurePhoneNumber(),
          validation: () {
            return null;
          }),
      CoolStep(
          title: "Votre adresse email",
          subtitle: "",
          content: confiureEmail(),
          validation: () {
            return null;
          }),
      CoolStep(
          title: "Votre nom",
          subtitle: "",
          content: confiureName(),
          validation: () {
            return null;
          }),
    ];

    var stepper = CoolStepper(
      onCompleted: () async {
        await createProfile();
        print("Steps completed!");
      },
      steps: steps,
      config: CoolStepperConfig(backText: "PRECEDENT", nextText: "SUIVANT"),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: this.startConfiguration
            ? IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () =>
                    this.setState(() => this.startConfiguration = false))
            : SizedBox.shrink(),
        centerTitle: true,
        title: Tex(
          content: "Profile Configuration",
          color: Colors.white,
          size: 'h4',
          bold: FontWeight.bold,
        ),
      ),
      body: Container(
        child: startConfiguration ? stepper : stepOne(),
      ),
    );
  }

  Widget stepOne() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
      child: Column(children: <Widget>[
        Tex(
          content: "Bienvenu sur AfrimBox",
          size: 'h4',
        ),
        SizedBox(
          height: 10,
        ),
        Tex(
          content:
              "Pour profiter de toutes les fonctionnalités, vous devez crée un profile",
          size: 'p',
          align: TextAlign.center,
        ),
        SizedBox(
          height: 20,
        ),
        SizedBox(
          width: double.infinity,
          child: RaisedButton(
            color: Theme.of(context).primaryColor,
            onPressed: () => this.setState(() => startConfiguration = true),
            child: Tex(
              content: "Créer son profile",
              color: Colors.white,
            ),
          ),
        )
      ]),
    );
  }

  Widget _internationalNumber() {
    return InternationalPhoneNumberInput(
        countries: ["CD", "BJ"],
        onInputChanged: (PhoneNumber number) {
          setState(() {
            userProfile['phone'] = number.phoneNumber.toString().trim();
          });
        },
        onInputValidated: (bool value) {},
        //autoFocus: true,
        errorMessage: 'Numero de télephone incorrect',
        ignoreBlank: false,
        autoValidate: false,
        selectorTextStyle: TextStyle(color: Colors.black),
        initialValue: number,
        textFieldController: phoneNumberController,
        inputBorder: UnderlineInputBorder(),
        inputDecoration: InputDecoration(
            hintText: 'Numero de télephone', border: UnderlineInputBorder()));
  }

  Widget confiurePhoneNumber() {
    return Form(
      key: _phoneKey,
      child: Column(
        children: <Widget>[
          _internationalNumber(),
        ],
      ),
    );
  }

  Widget _confiurePhoneNumber() {
    return FormBuilder(
      key: _phoneKey,
      initialValue: {
        'phoneNumber': '',
      },
      autovalidate: true,
      child: Column(
        children: <Widget>[
          FormBuilderPhoneField(
            controller: phoneNumberController,
            attribute: "phoneNumber",
            decoration: InputDecoration(labelText: "Numero de télephone"),
            onChanged: (value) {
              setState(() => userProfile['phone'] = value);
            },
            validators: [
              FormBuilderValidators.numeric(),
              FormBuilderValidators.required(),
              FormBuilderValidators.max(10),
            ],
          ),
        ],
      ),
    );
  }

  Widget confiureEmail() {
    return FormBuilder(
      key: _emailKey,
      initialValue: {
        'email': '',
      },
      autovalidate: true,
      child: Column(
        children: <Widget>[
          FormBuilderTextField(
            controller: emailController,
            attribute: "email",
            decoration: InputDecoration(labelText: "Email"),
            onChanged: (value) {
              setState(() => userProfile['email'] = value);
            },
            validators: [
              FormBuilderValidators.email(),
              FormBuilderValidators.required(),
              FormBuilderValidators.max(255),
            ],
          ),
        ],
      ),
    );
  }

  Widget confiureName() {
    return FormBuilder(
      key: _nameKey,
      initialValue: {
        'name': '',
      },
      autovalidate: true,
      child: Column(
        children: <Widget>[
          FormBuilderTextField(
            controller: nameController,
            attribute: "name",
            decoration: InputDecoration(labelText: "Nom"),
            onChanged: (value) {
              setState(() => userProfile['name'] = value);
            },
            validators: [
              FormBuilderValidators.minLength(1),
              FormBuilderValidators.max(255),
            ],
          ),
        ],
      ),
    );
  }
}
