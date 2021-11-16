import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:nibjobs/api/flutterfire.dart';
import 'package:nibjobs/global.dart' as global;
import 'package:nibjobs/model/config/global.dart';
import 'package:nibjobs/model/profile/company.dart';
import 'package:nibjobs/route/route.dart';
import 'package:nibjobs/rsr/locale/lang/language_key.dart';
import 'package:nibjobs/rsr/locale/string_rsr.dart';
import 'package:nibjobs/rsr/theme/color.dart';
import 'package:nibjobs/themes/light_color.dart';
import 'package:nibjobs/widget/icon/icons.dart';
import 'package:nibjobs/widget/info/message.dart';
import 'package:path/path.dart';

class EditCompanyPage extends StatefulWidget {
  final bundle;
  EditCompanyPage({this.bundle});
  @override
  _EditCompanyPageState createState() => _EditCompanyPageState();
}

class _EditCompanyPageState extends State<EditCompanyPage> {
  File? imageFile;

  final GlobalKey<FormState> _globalAllFormStateKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController tinController = TextEditingController();
  TextEditingController primaryPhoneController = TextEditingController();
  TextEditingController secondaryPhoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController websiteController = TextEditingController();
  TextEditingController physicalAddressController = TextEditingController();
  String primaryPhoneCodeNumber = "+251";
  String secondaryPhoneCodeNumber = "+251";
  String primaryPhoneCode = "";
  String secondaryPhoneCode = "";
  bool absorbing = false;
  String? companyLogo;
  bool allSeen = false;
  bool imageSelected = false;
  String? docId;
  String? selectedLanguage;
  List<Category>? categories;

  final picker = ImagePicker();
  setSelectedCategory(String newSelectedLanguage) {
    setState(() {
      selectedLanguage = newSelectedLanguage;
    });
  }

  chooseImage(ImageSource source) async {
    final pickedFile = await picker.pickImage(source: source);
    setState(() {
      imageSelected = true;
      imageFile = File(pickedFile!.path);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Category? categoryAll;
    categories = global.localConfig.categories;
    for (var element in categories!) {
      if (element.name == "all") {
        categoryAll = element;
      }
    }
    categories!.remove(categoryAll);
  }

  @override
  void dispose() {
    nameController.dispose();
    tinController.dispose();
    primaryPhoneController.dispose();
    secondaryPhoneController.dispose();
    emailController.dispose();

    websiteController.dispose();
    physicalAddressController.dispose();
    super.dispose();
  }

  bool isEmail(String em) {
    String p =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

    RegExp regExp = RegExp(p);

    return regExp.hasMatch(em);
  }

  Widget getAppBar2(BuildContext context, Company company,
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
      title: Text(
        StringRsr.get(LanguageKey.MY_SHOP, firstCap: false)!,
        style: const TextStyle(color: CustomColor.GRAY_LIGHT),
      ),
      actions: <Widget>[
        Padding(
          padding: const EdgeInsets.only(right: 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              GestureDetector(
                onTap: () {
                  if (allSeen) {
                    Navigator.pushNamed(context, RouteTo.SHOP_ADD_ITEM,
                        arguments: company);
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: Icon(
                    Icons.add,
                    color: allSeen
                        ? Theme.of(context).primaryColor
                        : CustomColor.GRAY_LIGHT,
                    size: 30,
                  ),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              GestureDetector(
                onTap: () {
                  if (allSeen) {
                    Navigator.pushNamed(context, RouteTo.SHOP_JOB_LIST,
                        arguments: company);
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: Icon(
                    Icons.list,
                    color: allSeen
                        ? Theme.of(context).primaryColor
                        : CustomColor.GRAY_LIGHT,
                    size: 30,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
      //showCategory ? CategoryMenu() : Container()
      //backgroundColor: LightColor.lightGrey,
      elevation: 0,
    );
  }

  @override
  Widget build(BuildContext context) {
    Company? company = ModalRoute.of(context)!.settings.arguments as Company?;
    if (company != null && !allSeen) {
      // imageFile = File(company.logo);
      companyLogo = company.logo ?? "";

      nameController.text = company.name ?? "";
      tinController.text = company.category ?? "";
      selectedLanguage = company.category;
      primaryPhoneController.text = "";
      secondaryPhoneController.text = "";
      primaryPhoneController.text = company.primaryPhone ?? "";
      secondaryPhoneController.text = company.secondaryPhone ?? "";
      // primaryPhoneCodeController.text=company.primaryPhone.substring(0,) ?? "";
      //secondaryPhoneCodeController.text = company.secondaryPhone ?? "";
      emailController.text = company.email ?? "";
      websiteController.text = company.website ?? "";
      physicalAddressController.text = company.physicalAddress ?? "";
      allSeen = true;
      setState(() {});
    }
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(100),
          child: getAppBar2(context, company!)),
      // drawer: Menu.getSideDrawer(context),
      body: WillPopScope(
        onWillPop: () {
          Navigator.pop(context);
          return Future.value(true);
        },
        child: AbsorbPointer(
          absorbing: absorbing,
          child: Stack(
            children: [
              ListView(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(40, 15, 40, 10),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Column(
                        children: [
                          GestureDetector(
                            onTap: () {
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: Container(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            ElevatedButton(
                                              onPressed: () {},
                                              style: ButtonStyle(
                                                backgroundColor:
                                                    MaterialStateProperty.all<
                                                        Color>(Colors.white),
                                                elevation: MaterialStateProperty
                                                    .all<double>(0),
                                              ),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceAround,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  TextButton(
                                                      onPressed: () {
                                                        chooseImage(
                                                            ImageSource.camera);
                                                        Navigator.pop(context);
                                                      },
                                                      child: Icon(
                                                        Icons.camera_alt,
                                                        color: Theme.of(context)
                                                            .primaryColor,
                                                        size: 45,
                                                      )),
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                  Text(
                                                    StringRsr.get(
                                                        LanguageKey.CAMERA)!,
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .subtitle1,
                                                  ),
                                                ],
                                              ),
                                            ),

                                            ElevatedButton(
                                              style: ButtonStyle(
                                                backgroundColor:
                                                    MaterialStateProperty.all<
                                                        Color>(Colors.white),
                                                elevation: MaterialStateProperty
                                                    .all<double>(0),
                                              ),
                                              onPressed: () {},
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceAround,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  TextButton(
                                                      onPressed: () {
                                                        chooseImage(ImageSource
                                                            .gallery);
                                                        Navigator.pop(context);
                                                      },
                                                      child: const Icon(
                                                        Icons.image,
                                                        color:
                                                            Color(0xffb81d00),
                                                        size: 45,
                                                      )),
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                  Text(
                                                    StringRsr.get(
                                                        LanguageKey.GALLERY)!,
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .subtitle1,
                                                  ),
                                                ],
                                              ),
                                            ),
                                            // ElevatedButton(
                                            //     onPressed: () {
                                            //       chooseImage(
                                            //           ImageSource.camera);
                                            //       Navigator.pop(context);
                                            //     },
                                            //     child: Text(StringRsr.get(
                                            //         LanguageKey.CAMERA))),
                                            // ElevatedButton(
                                            //     onPressed: () {
                                            //       chooseImage(
                                            //           ImageSource.gallery);
                                            //       Navigator.pop(context);
                                            //     },
                                            //     child: Text(StringRsr.get(
                                            //         LanguageKey.GALLEY))),
                                          ],
                                        ),
                                      ),
                                    );
                                  });
                            },
                            child: SizedBox(
                              height: 80,
                              width: 80,
                              child: imageFile != null || allSeen
                                  ? allSeen && !imageSelected
                                      ? CachedNetworkImage(
                                          imageUrl: company.logo,
                                          fit: BoxFit.cover,
                                          useOldImageOnUrlChange: false,
                                          imageBuilder: (context, imagePath) {
                                            return ClipRRect(
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(40)),
                                              child: Image(
                                                image: imagePath,
                                                fit: BoxFit.cover,
                                              ),
                                            );
                                          },
                                          placeholderFadeInDuration:
                                              const Duration(seconds: 1),
                                          placeholder: (BuildContext context,
                                              String imageURL) {
                                            return CircleAvatar(
                                              backgroundColor: Theme.of(context)
                                                  .primaryColor,
                                              radius: 50,
                                              child: Text(
                                                company.name!
                                                    .substring(0, 1)
                                                    .toUpperCase(),
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 40,
                                                ),
                                              ),
                                            );
                                          },
                                          errorWidget: (BuildContext context,
                                              String imageURL, dynamic) {
                                            return CircleAvatar(
                                              backgroundColor: Theme.of(context)
                                                  .primaryColor,
                                              radius: 50,
                                              child: Text(
                                                company.name!
                                                    .substring(0, 1)
                                                    .toUpperCase(),
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 40,
                                                ),
                                              ),
                                            );
                                          },
                                        )
                                      : imageFile != null
                                          ? Container(
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(40),
                                                image: DecorationImage(
                                                  image: FileImage(imageFile!),
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            )
                                          : Container(
                                              height: 80,
                                              width: 80,
                                              decoration: BoxDecoration(
                                                  color: CustomColor.GRAY_LIGHT,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          40)),
                                              child: Icon(
                                                Icons.camera_alt,
                                                size: 40,
                                                color: Theme.of(context)
                                                    .primaryColor,
                                              ),
                                            )
                                  : Container(
                                      height: 80,
                                      width: 80,
                                      decoration: BoxDecoration(
                                          color: CustomColor.GRAY_LIGHT,
                                          borderRadius:
                                              BorderRadius.circular(40)),
                                      child: Icon(
                                        Icons.camera_alt,
                                        size: 40,
                                        color: Theme.of(context).primaryColor,
                                      ),
                                    ),
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Form(
                            key: _globalAllFormStateKey,
                            child: ListView(
                              shrinkWrap: true,
                              primary: false,
                              children: [
                                TextFormField(
                                  decoration: InputDecoration(
                                      labelText: StringRsr.get(LanguageKey.NAME,
                                          firstCap: true)),
                                  controller: nameController,
                                  validator: (value) {
                                    if (value == "") {
                                      return StringRsr.get(
                                          LanguageKey.NAME_CANT_BE_EMPTY,
                                          firstCap: true);
                                    }
                                    return null;
                                  },
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 15.0, bottom: 15.0),
                                  child: DropdownButton<String>(
                                    isExpanded: true,
                                    hint: Text(
                                      StringRsr.get(LanguageKey.SELECT_CATEGORY,
                                          firstCap: true)!,
                                    ),
                                    onChanged: (studentId) {
                                      // on package change
                                      setSelectedCategory(studentId!);
                                      tinController.text = studentId;
                                    },
                                    value: selectedLanguage,
                                    items: categories!.map((Category package) {
                                      return DropdownMenuItem<String>(
                                          value: package.name,
                                          child: Text(
                                            package.name!,
                                          ));
                                    }).toList(),
                                  ),
                                ),
                                // TextFormField(
                                //   controller: tinController,
                                //   decoration: InputDecoration(
                                //       labelText: StringRsr.get(
                                //           LanguageKey.TIN,
                                //           firstCap: true)),
                                //   keyboardType: TextInputType.number,
                                //   maxLength: 11,
                                //   validator: (value) {
                                //     if (value == "") {
                                //       return StringRsr.get(
                                //           LanguageKey.TIN_CANT_BE_EMPTY,
                                //           firstCap: true);
                                //     } else if (value.length != 11) {
                                //       return StringRsr.get(
                                //           LanguageKey
                                //               .TIN_MUST_BE_11_DIGIT_LONG,
                                //           firstCap: true);
                                //     }
                                //     return null;
                                //   },
                                // ),
                                Builder(builder: (context) {
                                  if (!allSeen) {
                                    return Column(
                                      children: [
                                        IntlPhoneField(
                                          keyboardType: TextInputType.phone,
                                          controller: primaryPhoneController,
                                          onCountryChanged: (phone) {
                                            primaryPhoneCodeNumber =
                                                phone.countryISOCode!;
                                          },
                                          decoration: InputDecoration(
                                            labelText: StringRsr.get(
                                                LanguageKey.PRIMARY_PHONE,
                                                firstCap: true),
                                          ),
                                          initialCountryCode: 'ET',
                                          validator: (value) {
                                            if (value == "") {
                                              return StringRsr.get(
                                                  LanguageKey
                                                      .PRIMARY_PHONE_CANT_BE_EMPTY,
                                                  firstCap: true);
                                            }
                                            return null;
                                          },
                                        ),
                                        IntlPhoneField(
                                          keyboardType: TextInputType.phone,
                                          controller: secondaryPhoneController,
                                          decoration: InputDecoration(
                                            labelText: StringRsr.get(
                                                LanguageKey.SECONDARY_PHONE,
                                                firstCap: true),
                                          ),
                                          onCountryChanged: (phone) {
                                            secondaryPhoneCode =
                                                phone.countryISOCode!;
                                          },
                                          initialCountryCode: 'ET',
                                          validator: (value) {
                                            if (value ==
                                                primaryPhoneController.text) {
                                              return StringRsr.get(
                                                  LanguageKey
                                                      .SECONDARY_PHONE_SAME_AS_PRIMARY_PHONE,
                                                  firstCap: true);
                                            }
                                            return null;
                                          },
                                        ),
                                      ],
                                    );
                                  }
                                  return Column(
                                    children: [
                                      TextFormField(
                                        controller: primaryPhoneController,
                                        decoration: InputDecoration(
                                            labelText: StringRsr.get(
                                                LanguageKey.PRIMARY_PHONE,
                                                firstCap: true)),
                                        keyboardType: TextInputType.phone,
                                        validator: (value) {
                                          if (value == "") {
                                            return StringRsr.get(
                                                LanguageKey
                                                    .PRIMARY_PHONE_CANT_BE_EMPTY,
                                                firstCap: true);
                                          }
                                          return null;
                                        },
                                      ),
                                      TextFormField(
                                        decoration: InputDecoration(
                                            labelText: StringRsr.get(
                                                LanguageKey.SECONDARY_PHONE,
                                                firstCap: true)),
                                        controller: secondaryPhoneController,
                                        keyboardType: TextInputType.phone,
                                        validator: (value) {
                                          // if (value == "" || value == null) {
                                          //   return null;
                                          // }
                                          // if (value.length < 9) {
                                          //   return null;
                                          // }
                                          // if (value ==
                                          //     primaryPhoneController.text) {
                                          //   return StringRsr.get(
                                          //       LanguageKey
                                          //           .SECONDARY_PHONE_SAME_AS_PRIMARY_PHONE,
                                          //       firstCap: true);
                                          // }
                                          return null;
                                        },
                                      ),
                                    ],
                                  );
                                }),

                                TextFormField(
                                  decoration: InputDecoration(
                                      labelText: StringRsr.get(
                                          LanguageKey.EMAIL,
                                          firstCap: true)),
                                  controller: emailController,
                                  keyboardType: TextInputType.emailAddress,
                                  validator: (value) {
                                    if (value == "") {
                                      return StringRsr.get(
                                          LanguageKey.EMAIL_CANT_BE_EMPTY,
                                          firstCap: true);
                                    } else if (!isEmail(value!)) {
                                      return StringRsr.get(
                                          LanguageKey.EMAIL_FORMAT_NOT_CORRECT,
                                          firstCap: true);
                                    }
                                    return null;
                                  },
                                ),
                                TextFormField(
                                  decoration: InputDecoration(
                                      labelText: StringRsr.get(
                                          LanguageKey.WEBSITE,
                                          firstCap: true)),
                                  controller: websiteController,
                                  keyboardType: TextInputType.url,
                                  validator: (value) {
                                    if (value!.isNotEmpty &&
                                        !value.contains(".")) {
                                      return StringRsr.get(
                                          LanguageKey
                                              .WEBSITE_FORMAT_NOT_CORRECT,
                                          firstCap: true);
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                TextFormField(
                                  decoration: InputDecoration(
                                      labelText: StringRsr.get(
                                          LanguageKey.PHYSICAL_ADDRESS,
                                          firstCap: true)),
                                  keyboardType: TextInputType.streetAddress,
                                  controller: physicalAddressController,
                                  validator: (value) {
                                    if (value == "") {
                                      return StringRsr.get(
                                          LanguageKey
                                              .PHYSICAL_ADDRESS_CANT_BE_EMPTY,
                                          firstCap: true);
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Text(StringRsr.get(LanguageKey.PIN_ON_MAP,
                                    firstCap: true)!),
                                const SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    GestureDetector(
                                      onTap: () async {
                                        debugPrint(
                                            "primaryPhoneController ${primaryPhoneController.text}");
                                        if (_globalAllFormStateKey.currentState!
                                                .validate() &&
                                            tinController.text != "") {
                                          setState(() {
                                            absorbing = true;
                                          });
                                          String? urlImage;
                                          if (imageSelected) {
                                            urlImage = await uploadFile();
                                            if (urlImage == null &&
                                                imageFile != null) {
                                              setState(() {
                                                absorbing = false;
                                              });
                                              return;
                                            }
                                          } else {
                                            urlImage = companyLogo!;
                                          }

                                          Company companyUpdate = Company(
                                            name: nameController.text,
                                            logo: urlImage,
                                            category: tinController.text,
                                            primaryPhone: !allSeen
                                                ? primaryPhoneCodeNumber +
                                                    primaryPhoneController.text
                                                : primaryPhoneController.text,
                                            secondaryPhone: !allSeen
                                                ? secondaryPhoneCodeNumber +
                                                    secondaryPhoneController
                                                        .text
                                                : secondaryPhoneController.text,
                                            coOrdinates: ["0", "0"],
                                            email: emailController.text,
                                            website: websiteController.text,
                                            physicalAddress:
                                                physicalAddressController.text,
                                            isVerified: false,
                                            isVirtual: false,
                                          );
                                          // todo edit or add job
                                          if (company.firstModified != null) {
                                            companyUpdate.firstModified =
                                                DateTime.now();
                                            companyUpdate.lastModified =
                                                DateTime.now();
                                          } else {
                                            companyUpdate.lastModified =
                                                DateTime.now();
                                          }

                                          final result =
                                              await addCompany(companyUpdate);
                                          absorbing = false;
                                          if (result) {
                                            AwesomeDialog(
                                              btnOkText: StringRsr.get(
                                                  LanguageKey.OK,
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
                                              desc:
                                                  '${StringRsr.get(LanguageKey.YOU_HAVE_SUCCESSFUL_ADDED, firstCap: true)} ${company.name}',
                                              showCloseIcon: true,
                                              btnOkOnPress: () {
                                                Navigator.pop(context);
                                              },
                                            ).show();
                                            nameController.text = "";
                                            tinController.text = "";
                                            selectedLanguage = null;
                                            primaryPhoneController.text = "";
                                            secondaryPhoneController.text = "";
                                            emailController.text = "";
                                            websiteController.text = "";
                                            physicalAddressController.text = "";

                                            imageFile = null;

                                            FocusScope.of(context).unfocus();
                                          } else {
                                            AwesomeDialog(
                                              btnOkText: StringRsr.get(
                                                  LanguageKey.OK,
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
                                              title: StringRsr.get(
                                                  LanguageKey.ERROR,
                                                  firstCap: true),
                                              desc: StringRsr.get(
                                                  LanguageKey.PLEASE_TRY_AGAIN,
                                                  firstCap: true),
                                              showCloseIcon: true,
                                              btnOkOnPress: () {},
                                            ).show();
                                          }
                                          setState(() {
                                            absorbing = false;
                                          });
                                        } else if (tinController.text == "") {
                                          // AwesomeDialog(
                                          //   btnOkText: StringRsr.get(
                                          //       LanguageKey.OK,
                                          //       firstCap: true),
                                          //   btnCancelText: StringRsr.get(
                                          //       LanguageKey.CANCEL,
                                          //       firstCap: true),
                                          //   context: context,
                                          //   dialogType: DialogType.ERROR,
                                          //   borderSide: const BorderSide(
                                          //       color: Colors.transparent,
                                          //       width: 2),
                                          //   width: 380,
                                          //   buttonsBorderRadius:
                                          //       const BorderRadius.all(
                                          //           Radius.circular(2)),
                                          //   headerAnimationLoop: false,
                                          //   animType: AnimType.BOTTOMSLIDE,
                                          //   title: StringRsr.get(
                                          //       LanguageKey.ERROR,
                                          //       firstCap: true),
                                          //   desc: StringRsr.get(
                                          //       LanguageKey
                                          //           .PLEASE_CHOOSE_A_CATEGORY,
                                          //       firstCap: true),
                                          //   showCloseIcon: true,
                                          //   btnOkOnPress: () {},
                                          // ).show();

                                          showInfoToUser(
                                              context,
                                              DialogType.ERROR,
                                              StringRsr.get(LanguageKey.ERROR,
                                                  firstCap: true),
                                              StringRsr.get(
                                                  LanguageKey
                                                      .PLEASE_CHOOSE_A_CATEGORY,
                                                  firstCap: true),
                                              onOk: () {});
                                        }
                                      },
                                      child: Container(
                                        width: 250,
                                        height: 35,
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            color:
                                                Theme.of(context).primaryColor),
                                        padding: const EdgeInsets.only(
                                          left: 15,
                                          top: 5,
                                          bottom: 5,
                                          right: 15,
                                        ),
                                        child: Center(
                                          child: Text(
                                            StringRsr.get(
                                                allSeen
                                                    ? LanguageKey.UPDATE
                                                    : LanguageKey.CREATE,
                                                firstCap: true)!,
                                            style: const TextStyle(
                                                color: Colors.white),
                                          ),
                                        ),
                                      ),
                                    ),
                                    // const SizedBox(
                                    //   width: 10,
                                    // ),
                                    // Expanded(
                                    //   child: ElevatedButton(
                                    //     style: ElevatedButton.styleFrom(
                                    //       primary:
                                    //           Theme.of(context).primaryColor,
                                    //     ),
                                    //     child: Text("delete"),
                                    //     onPressed: () {},
                                    //   ),
                                    // ),
                                    // const SizedBox(
                                    //   width: 30,
                                    // ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Visibility(
                visible: absorbing,
                child: Center(
                  child: Message(
                    icon: CustomIcons.getHorizontalLoading(),
                    message: StringRsr.get(LanguageKey.LOADING, firstCap: true),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<String?> uploadFile() async {
    if (imageFile == null) return null;
    final fileName = basename(imageFile!.path);
    final String destination = 'companys/$fileName';
    UploadTask? task = uploadFileStore(destination, imageFile!);
    if (task == null) return null;
    final snapshot = await task.whenComplete(() => null);
    final urlDownload = await snapshot.ref.getDownloadURL();

    return urlDownload;
  }
}
