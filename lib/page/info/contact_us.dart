import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:nibjobs/api/flutterfire.dart';
import 'package:nibjobs/db/k_shared_preference.dart';
import 'package:nibjobs/model/profile/contact_us.dart';
import 'package:nibjobs/rsr/locale/lang/language_key.dart';
import 'package:nibjobs/rsr/locale/string_rsr.dart';
import 'package:nibjobs/rsr/theme/color.dart';
import 'package:nibjobs/themes/light_color.dart';
import 'package:nibjobs/themes/theme.dart';
import 'package:uuid/uuid.dart';

class ContactUsPage extends StatefulWidget {
  @override
  _ContactUsPageState createState() => _ContactUsPageState();
}

class _ContactUsPageState extends State<ContactUsPage> {
  final _formKey = GlobalKey<FormState>();
  bool _absorb = false;

  String notificationMessage = "";
  Color notificationColor = Colors.green;
  double opacity = 0;
  TextEditingController nameController = TextEditingController();
  TextEditingController messageController = TextEditingController();
  // Device specific values
  EdgeInsets? containerMargin;
  EdgeInsets? containerPadding;
  double? contactUsFont;
  double? anythingFont;
  double? buttonHeight;
  double? buttonTopSpacing;

  String? title;
  String? body;
  bool onKeyboard = false;
  setDeviceSpecificValues(BuildContext context) {
    double height = MediaQuery.of(context).size.height;

    if (height < 500) {
      containerMargin = EdgeInsets.symmetric(vertical: 21, horizontal: 15);
      containerPadding = EdgeInsets.symmetric(horizontal: 16, vertical: 10);
      contactUsFont = 21;
      anythingFont = 11;
      buttonHeight = 40;
      buttonTopSpacing = 18;
    } else if (height >= 500 && height <= 600) {
      // Nexus S & HVGA 3.2
      containerMargin = EdgeInsets.symmetric(vertical: 40, horizontal: 15);
      containerPadding = EdgeInsets.symmetric(horizontal: 16, vertical: 10);
      contactUsFont = 21;
      anythingFont = 11;
      buttonHeight = 40;
      buttonTopSpacing = 18;
    } else if (height > 600 && height <= 700) {
      // Nexus 5x
      containerMargin = EdgeInsets.symmetric(vertical: 70, horizontal: 20);
      containerPadding = EdgeInsets.symmetric(horizontal: 16, vertical: 24);

      contactUsFont = 27;
      anythingFont = 13;
      buttonHeight = 45;
      buttonTopSpacing = 25;
    } else {
      // Pixel 3 xL
      containerMargin = EdgeInsets.symmetric(vertical: 100, horizontal: 20);
      containerPadding = EdgeInsets.symmetric(horizontal: 16, vertical: 24);

      contactUsFont = 27;
      anythingFont = 13;
      buttonHeight = 50;
      buttonTopSpacing = 25;
    }
  }

  Widget getAppBar2(BuildContext context, String? job,
      {bool showCategory = false}) {
    return AppBar(
      backgroundColor: LightColor.background,
      leading: IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        color: CustomColor.GRAY_DARK,
        icon: const Icon(Icons.arrow_back_outlined),
      ),
      actions: <Widget>[],
      //showCategory ? CategoryMenu() : Container()
      //backgroundColor: LightColor.lightGrey,
      elevation: 0,
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    messageController.dispose();
    nameController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    setDeviceSpecificValues(context);
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: getAppBar2(context, "Contact us")),
      // drawer: Menu.getSideDrawer(context),
      body: Container(
        color: LightColor.background,
        padding: AppTheme.padding,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.only(left: 8, top: 8),
              alignment: Alignment.centerLeft,
              child: Text(
                StringRsr.get(LanguageKey.CONTACT_US, firstCap: true)!,
                style: const TextStyle(
                    fontSize: 24,
                    color: CustomColor.GRAY_DARK,
                    fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              padding: const EdgeInsets.only(left: 8),
              alignment: Alignment.centerLeft,
              child: Text(
                  StringRsr.get(LanguageKey.ANYTHING_YOU_LIKE_TO_TELL,
                      firstCap: true)!,
                  style: const TextStyle(
                      fontSize: 18,
                      color: CustomColor.GRAY_LIGHT,
                      fontWeight: FontWeight.bold)),
            ),
            Expanded(
              flex: 3,
              child: Container(
                margin: containerPadding,
                child: ListView(
                  children: <Widget>[
                    Form(
                      key: _formKey,
                      child: SingleChildScrollView(
                        child: Column(
                          children: <Widget>[
                            TextFormField(
                              controller: nameController,
                              onChanged: (titleVal) {
                                title = titleVal;
                              },
                              onFieldSubmitted: (titleVal) {
                                title = titleVal;
                              },
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return StringRsr.get(
                                      LanguageKey.PLEASE_ENTER_TITLE,
                                      firstCap: true);
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                hintStyle: const TextStyle(
                                    color: CustomColor.GRAY_LIGHT),
                                hintText: StringRsr.get(
                                    LanguageKey.WHAT_IS_IT_ABOUT,
                                    firstCap: true),
                              ),
                              // decoration: AppTheme.getDecorationTFF("TITLE",
                              //     enableLabel: true),
                              // style: AppTheme.getconst TextStyleTFF(context),
                            ),
                            const SizedBox(height: 23),
                            TextFormField(
                              controller: messageController,
                              onChanged: (bodyVal) {
                                body = bodyVal;
                              },
                              onFieldSubmitted: (bodyVal) {
                                body = bodyVal;
                              },
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return StringRsr.get(
                                      LanguageKey.PLEASE_ENTER_BODY,
                                      firstCap: true);
                                }
                                return null;
                              },
                              minLines: 5,
                              maxLines: 13,
                              decoration: InputDecoration(
                                hintStyle: const TextStyle(
                                    color: CustomColor.GRAY_LIGHT),
                                hintText: StringRsr.get(LanguageKey.MESSAGE,
                                    firstCap: true),
                              ),
                              // decoration: AppTheme.getDecorationTFF("body",
                              //     enableLabel: true),
                              // style: AppTheme.getconst TextStyleTFF(context),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            SizedBox(height: buttonTopSpacing),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    Container(
                      padding: const EdgeInsets.only(right: 10, bottom: 5),
                      alignment: Alignment.center,
                      child: GestureDetector(
                        onTap: () {
                          if (_formKey.currentState!.validate()) {
                            setState(() {
                              _absorb = true;
                            });
                          }
                        },
                        child: _absorb
                            ? const CircularProgressIndicator(
                                backgroundColor: Colors.white,
                                strokeWidth: 2,
                              )
                            : GestureDetector(
                                onTap: () async {
                                  if (_formKey.currentState!.validate()) {
                                    var uid = Uuid();
                                    HSharedPreference hSharedPreference =
                                        GetHSPInstance.hSharedPreference;
                                    String userId = await hSharedPreference.get(
                                            HSharedPreference.KEY_USER_EMAIL) ??
                                        "anonymous";

                                    ContactUsModel contactUs = ContactUsModel(
                                      id: uid.v1(),
                                      from: userId,
                                      title: nameController.text,
                                      body: messageController.text,
                                      resolved: false,
                                      firstModified: DateTime.now(),
                                      lastModified: DateTime.now(),
                                    );
                                    final result =
                                        await addContactUs(contactUs);
                                    if (result) {
                                      AwesomeDialog(
                                        btnOkText: StringRsr.get(LanguageKey.OK,
                                            firstCap: true),
                                        btnCancelText: StringRsr.get(
                                            LanguageKey.CANCEL,
                                            firstCap: true),
                                        context: context,
                                        dialogType: DialogType.SUCCES,
                                        borderSide: const BorderSide(
                                            color: Colors.transparent,
                                            width: 2),
                                        width: 380,
                                        buttonsBorderRadius:
                                            const BorderRadius.all(
                                                Radius.circular(2)),
                                        headerAnimationLoop: false,
                                        animType: AnimType.BOTTOMSLIDE,
                                        title: StringRsr.get(
                                            LanguageKey.SUCCESSFUL,
                                            firstCap: true),
                                        desc: StringRsr.get(
                                            LanguageKey
                                                .THANK_YOU_FOR_YOUR_FEEDBACK,
                                            firstCap: true),
                                        showCloseIcon: true,
                                        btnOkOnPress: () async {
                                          nameController.text = "";
                                          messageController.text = "";
                                          Navigator.pop(context);
                                        },
                                      ).show();
                                    } else {
                                      AwesomeDialog(
                                        btnOkText: StringRsr.get(LanguageKey.OK,
                                            firstCap: true),
                                        btnCancelText: StringRsr.get(
                                            LanguageKey.CANCEL,
                                            firstCap: true),
                                        context: context,
                                        dialogType: DialogType.ERROR,
                                        borderSide: const BorderSide(
                                            color: Colors.transparent,
                                            width: 2),
                                        width: 380,
                                        buttonsBorderRadius:
                                            const BorderRadius.all(
                                                Radius.circular(2)),
                                        headerAnimationLoop: false,
                                        animType: AnimType.BOTTOMSLIDE,
                                        title: StringRsr.get(LanguageKey.ERROR,
                                            firstCap: true),
                                        desc: StringRsr.get(
                                            LanguageKey.PLEASE_TRY_AGAIN,
                                            firstCap: true),
                                        showCloseIcon: true,
                                        btnCancelOnPress: () {},
                                        btnOkOnPress: () async {},
                                      ).show();
                                    }
                                  }
                                },
                                child: Container(
                                  width: 200,
                                  height: 40,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: Theme.of(context).primaryColor),
                                  padding: const EdgeInsets.only(
                                    left: 15,
                                    top: 5,
                                    bottom: 10,
                                    right: 15,
                                  ),
                                  child: Center(
                                    child: Text(
                                      StringRsr.get(LanguageKey.SEND)!,
                                      style:
                                          const TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
