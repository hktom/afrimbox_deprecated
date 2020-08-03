import 'package:afrimbox/components/progressModal.dart';
import 'package:afrimbox/helpers/tex.dart';
import 'package:afrimbox/provider/userProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:afrimbox/provider/loginProvider.dart';
import 'package:afrimbox/controller/firestoreController.dart';

class UpdateProfile extends StatefulWidget {
  final int typeField;
  final String defaultValue;
  final Map<String, dynamic> profile;
  UpdateProfile({Key key, this.typeField, this.defaultValue, this.profile})
      : super(key: key);
  @override
  _UpdateProfileState createState() => _UpdateProfileState();
}

class _UpdateProfileState extends State<UpdateProfile> {
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();
  FireStoreController fireStoreController = new FireStoreController();
  var fieldController = TextEditingController();
  var userAuth;
  var currentUser;
  String userInput;

  @override
  void initState() {
    fieldController.text = widget.defaultValue;
    userInput = widget.defaultValue;
    super.initState();
  }

  Future<void> progressModal() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return ProgressModal(
          title: "Progression en cours",
        );
      },
    );
  }

  Future<bool> updateProfile({field, value}) async {
    widget.profile[field] = value;
    widget.profile['updated_at'] = DateTime.now();

    var result = await fireStoreController.updateDocument(
        collection: 'users',
        data: widget.profile,
        doc: widget.profile['id'].trim());

    await Provider.of<UserProvider>(context, listen: false)
        .getCurrentUser([widget.profile]);

    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: Tex(
          content: "Mettre à jour son profile",
          color: Colors.white,
          size: 'h4',
          bold: FontWeight.bold,
        ),
      ),
      body: Container(
        margin: EdgeInsets.only(top: 20),
        padding: EdgeInsets.symmetric(horizontal: 40),
        child: ListView(
          children: <Widget>[
            if (widget.typeField == 1) _formBuilder(label: 'Nom'),
            if (widget.typeField == 2)
              _formBuilder(label: 'Email', isEmail: true),
            if (widget.typeField == 3)
              _formBuilder(label: 'Télephone', isPhone: true),
            SizedBox(
              child: RaisedButton(
                color: Theme.of(context).primaryColor,
                onPressed: () async {
                  if (_fbKey.currentState.saveAndValidate()) {
                    var field;
                    if (widget.typeField == 1) field = "name";
                    if (widget.typeField == 2) field = "email";
                    if (widget.typeField == 3) field = "phone";

                    progressModal();
                    bool result =
                        await updateProfile(value: userInput, field: field);

                    Get.back();
                    Get.back();
                  }
                },
                child: Tex(
                  content: "Mettre à jour le profile",
                  color: Colors.white,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _formBuilder({String label, bool isEmail: false, isPhone: false}) {
    return FormBuilder(
      key: _fbKey,
      initialValue: {
        'field': '',
      },
      autovalidate: true,
      child: Column(
        children: <Widget>[
          FormBuilderTextField(
            controller: fieldController,
            attribute: "field",
            decoration: InputDecoration(labelText: label),
            onChanged: (value) {
              setState(() => userInput = value);
            },
            validators: [
              if (isPhone) FormBuilderValidators.numeric(),
              if (isEmail) FormBuilderValidators.email(),
              FormBuilderValidators.required(),
              FormBuilderValidators.max(100),
            ],
          ),
        ],
      ),
    );
  }
}
