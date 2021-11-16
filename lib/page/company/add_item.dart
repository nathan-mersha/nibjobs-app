import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:material_tag_editor/tag_editor.dart';
import 'package:nibjobs/api/flutterfire.dart';
import 'package:nibjobs/global.dart' as global;
import 'package:nibjobs/model/commerce/job.dart';
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
import 'package:uuid/uuid.dart';

class AddItemPage extends StatefulWidget {
  @override
  _AddItemPageState createState() => _AddItemPageState();
}

class _AddItemPageState extends State<AddItemPage> {
  File? imageFile;
  List<dynamic> metaData = [];
  TextEditingController valueController = TextEditingController();
  TextEditingController keyController = TextEditingController();

  final GlobalKey<FormState> _globalAllFormStateKey = GlobalKey<FormState>();
  TextEditingController categoryController = TextEditingController();
  TextEditingController subcategoryController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController authorController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController availableController = TextEditingController();
  TextEditingController tagController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  bool absorbing = false;
  List<dynamic> tagList = [];
  final picker = ImagePicker();
  bool allSeen = false;
  List jobImage = [];
  String? jobId;
  Company? company;
  Job? jobOld;
  bool imageSelected = false;
  String title = "Add Item";
  String? selectedCategory;
  String? selectedSubCategory;
  List<Category>? categories;
  Category? category;
  void setSelectedSubCategory(String newSelectedLanguage) {
    setState(() {
      selectedSubCategory = newSelectedLanguage;
    });
  }

  void setSelectedCategory(String newSelectedLanguage) {
    setState(() {
      selectedCategory = newSelectedLanguage;
    });
  }

  var uuid = const Uuid();
  chooseImage(ImageSource source) async {
    final pickedFile = await picker.pickImage(source: source);
    setState(() {
      imageFile = File(pickedFile!.path);
      imageSelected = true;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Category categoryAll = Category();
    categories = global.localConfig.categories;
    for (var element in categories!) {
      if (element.name == "all") {
        categoryAll = element;
      }
    }

    categories!.remove(categoryAll);
    category = categories![0];
    categoryController.text = categories![0].name!;
    selectedCategory = categories![0].name;
  }

  @override
  void dispose() {
    valueController.dispose();
    keyController.dispose();
    categoryController.dispose();
    subcategoryController.dispose();
    nameController.dispose();
    authorController.dispose();
    priceController.dispose();
    availableController.dispose();
    tagController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  Widget getAppBar2(BuildContext context, Company? company,
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
        StringRsr?.get(LanguageKey.UPDATE_JOB, firstCap: false)!,
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
                  if (company != null) Navigator.pop(context);
                  // Navigator.pushNamed(context, RouteTo.SHOP_EDIT,
                  //     arguments: company);
                },
                child: Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: Icon(
                    Icons.shopping_basket,
                    color: company != null
                        ? Theme.of(context).primaryColor
                        : CustomColor.GRAY_LIGHT,
                    size: 25,
                  ),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              GestureDetector(
                onTap: () {
                  if (company != null) {
                    Navigator.pushNamed(context, RouteTo.SHOP_JOB_LIST,
                        arguments: company);
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: Icon(
                    Icons.list,
                    color: company != null
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
    try {
      company = ModalRoute.of(context)!.settings.arguments as Company;
    } catch (e) {
      jobOld = ModalRoute.of(context)!.settings.arguments as Job;
      if (jobOld != null && !allSeen) {
        title = "Edit Item";
        jobImage = jobOld!.image!;
        categoryController.text = jobOld!.category!;
        subcategoryController.text = jobOld!.subCategory!;
        selectedCategory = jobOld!.category;
        for (var element in categories!) {
          if (element.name == selectedCategory) {
            category = element;
          }
        }

        selectedSubCategory = jobOld!.subCategory;
        if (!category!.subCategories!.contains(selectedSubCategory)) {
          selectedSubCategory = "other";
        }

        nameController.text = jobOld!.name!;
        authorController.text = jobOld!.authorOrManufacturer!;
        priceController.text = jobOld!.price!.toString();
        availableController.text = jobOld!.availableStock.toString();
        tagList = jobOld!.tag!;
        descriptionController.text = jobOld!.description!;
        metaData = jobOld!.metaData!;
        jobId = jobOld!.jobId!;
        allSeen = true;

        setState(() {});
      }
    }
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(100),
          child: getAppBar2(context, company!)),
      //drawer: Menu.getSideDrawer(context),
      body: AbsorbPointer(
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
                                    title: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
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
                                                MainAxisAlignment.spaceAround,
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
                                                MainAxisAlignment.spaceAround,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              TextButton(
                                                  onPressed: () {
                                                    chooseImage(
                                                        ImageSource.gallery);
                                                    Navigator.pop(context);
                                                  },
                                                  child: const Icon(
                                                    Icons.image,
                                                    color: Color(0xffb81d00),
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
                                  );
                                });
                          },
                          child: SizedBox(
                            height: 100,
                            width: 150,
                            child: allSeen &&
                                    imageFile == null &&
                                    jobImage.isNotEmpty
                                ? CachedNetworkImage(
                                    imageUrl: jobImage[0],
                                    imageBuilder: (context, imagePath) {
                                      return ClipRRect(
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(20)),
                                        child: Image(
                                          image: imagePath,
                                          fit: BoxFit.cover,
                                        ),
                                      );
                                    },
                                    useOldImageOnUrlChange: false,
                                    placeholderFadeInDuration:
                                        const Duration(seconds: 1),
                                    placeholder: (BuildContext context,
                                        String imageURL) {
                                      return CircleAvatar(
                                        backgroundColor:
                                            Theme.of(context).primaryColor,
                                        radius: 50,
                                        child: Text(
                                          jobOld!.name!
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
                                        backgroundColor:
                                            Theme.of(context).primaryColor,
                                        radius: 50,
                                        child: Text(
                                          jobOld!.name!
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
                                              BorderRadius.circular(20),
                                          image: DecorationImage(
                                            image: FileImage(imageFile!),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      )
                                    : Container(
                                        height: 100,
                                        width: 150,
                                        decoration: BoxDecoration(
                                          color: CustomColor.GRAY_LIGHT,
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
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
                              Text(
                                StringRsr.get(LanguageKey.CATEGORY,
                                    firstCap: true)!,
                                style: const TextStyle(
                                    color: Colors.black54, fontSize: 12),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 8.0),
                                child: DropdownButton<String>(
                                  isExpanded: true,
                                  hint: Text(
                                    StringRsr.get(LanguageKey.SELECT_CATEGORY,
                                        firstCap: true)!,
                                  ),
                                  onChanged: (studentId) {
                                    // on package change
                                    setSelectedCategory(studentId!);
                                    categoryController.text = studentId;

                                    for (var element in categories!) {
                                      if (element.name == selectedCategory) {
                                        category = element;
                                      }
                                      subcategoryController.text = "";
                                      selectedSubCategory = null;
                                      setState(() {});
                                    }
                                  },
                                  value: selectedCategory,
                                  items: categories!.map((Category package) {
                                    return DropdownMenuItem<String>(
                                        value: package.name,
                                        child: Text(
                                          package.name!,
                                        ));
                                  }).toList(),
                                ),
                              ),
                              Text(
                                StringRsr.get(LanguageKey.SUBCATEGORY,
                                    firstCap: true)!,
                                style: const TextStyle(
                                    color: Colors.black54, fontSize: 12),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 0),
                                child: DropdownButton<String>(
                                  isExpanded: true,
                                  hint: Text(
                                    StringRsr.get(
                                        LanguageKey.SELECT_SUBCATEGORY,
                                        firstCap: true)!,
                                  ),
                                  onChanged: (studentId) {
                                    // on package change
                                    setSelectedSubCategory(studentId!);
                                    subcategoryController.text = studentId;
                                  },
                                  value: selectedSubCategory,
                                  items: category != null
                                      ? category!.subCategories!.map((package) {
                                          return DropdownMenuItem<String>(
                                              value: package,
                                              child: Text(
                                                package,
                                              ));
                                        }).toList()
                                      : ["select category first"]
                                          .map((package) {
                                          return DropdownMenuItem<String>(
                                              value: package,
                                              child: Text(
                                                package,
                                              ));
                                        }).toList(),
                                ),
                              ),

                              TextFormField(
                                controller: nameController,
                                decoration: InputDecoration(
                                    labelText: StringRsr.get(LanguageKey.NAME,
                                        firstCap: true)),
                                validator: (value) {
                                  if (value == "") {
                                    return StringRsr.get(
                                        LanguageKey.NAME_CANT_BE_EMPTY,
                                        firstCap: true);
                                  }
                                  return null;
                                },
                              ),
                              TextFormField(
                                decoration: InputDecoration(
                                    labelText: StringRsr.get(
                                        LanguageKey.AUTHOR_MANUFACTURE,
                                        firstCap: true)),
                                controller: authorController,
                                validator: (value) {
                                  if (value == "") {
                                    return StringRsr.get(
                                        LanguageKey
                                            .AUTHOR_MANUFACTURE_CANT_BE_EMPTY,
                                        firstCap: true);
                                  }
                                  return null;
                                },
                              ),
                              TextFormField(
                                decoration: InputDecoration(
                                    labelText: StringRsr.get(LanguageKey.PRICE,
                                        firstCap: true)),
                                controller: priceController,
                                keyboardType: TextInputType.number,
                                validator: (value) {
                                  if (value == "") {
                                    return StringRsr.get(
                                        LanguageKey.PRICE_CANT_BE_EMPTY,
                                        firstCap: true);
                                  }
                                  return null;
                                },
                              ),
                              TextFormField(
                                decoration: InputDecoration(
                                    labelText: StringRsr.get(
                                        LanguageKey.AVAILABLE_STOCK,
                                        firstCap: true)),
                                controller: availableController,
                                keyboardType: TextInputType.number,
                                validator: (value) {
                                  if (value == "") {
                                    return StringRsr.get(
                                        LanguageKey
                                            .AVAILABLE_STOCK_CANT_BE_EMPTY,
                                        firstCap: true);
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              TagEditor(
                                length: tagList.length,
                                delimiters: const [',', ' '],
                                hasAddButton: true,
                                inputDecoration: const InputDecoration(
                                  hintText: "tag",
                                ),
                                onTagChanged: (value) {
                                  tagList.add(value);
                                  setState(() {});
                                },
                                tagBuilder: (context, index) {
                                  return _Chip(
                                    index: index,
                                    label: tagList[index],
                                    onDeleted: onDelete,
                                  );
                                },
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              TextFormField(
                                decoration: InputDecoration(
                                    labelText: StringRsr.get(
                                        LanguageKey.DESCRIPTION,
                                        firstCap: true)),
                                controller: descriptionController,
                                keyboardType: TextInputType.multiline,
                                validator: (value) {
                                  if (value == "") {
                                    return StringRsr.get(
                                        LanguageKey.DESCRIPTION_CANT_BE_EMPTY,
                                        firstCap: true);
                                  }
                                  return null;
                                },
                              ),
                              // const SizedBox(
                              //   height: 20,
                              // ),
                              // Text("meta-data"),
                              // const SizedBox(
                              //   height: 10,
                              // ),
                              // Form(
                              //   key: _globalFormStateKey,
                              //   child: Column(
                              //     children: [
                              //       Row(
                              //         mainAxisAlignment:
                              //             MainAxisAlignment.spaceEvenly,
                              //         children: [
                              //           Flexible(
                              //             child: Container(
                              //               decoration: BoxDecoration(
                              //                 border: Border.all(
                              //                   color: Colors.grey,
                              //                   width: 1.0,
                              //                 ),
                              //               ),
                              //               child: TextFormField(
                              //                 controller: keyController,
                              //                 validator: (value) {
                              //                   if (value == "") {
                              //                     return "${StringRsr.get(LanguageKey.KEY_CANT_BE_EMPTY, firstCap: true)}";
                              //                   }
                              //                   return null;
                              //                 },
                              //                 textAlignVertical:
                              //                     TextAlignVertical.center,
                              //                 textAlign: TextAlign.center,
                              //                 decoration: InputDecoration(
                              //                   contentPadding:
                              //                       EdgeInsets.only(
                              //                           bottom: 10),
                              //                   hintText: StringRsr.get(
                              //                       LanguageKey.KEY,
                              //                       firstCap: true),
                              //                   border: InputBorder.none,
                              //                 ),
                              //               ),
                              //             ),
                              //           ),
                              //           const SizedBox(
                              //             width: 10,
                              //           ),
                              //           Flexible(
                              //             child: Container(
                              //               decoration: BoxDecoration(
                              //                 border: Border.all(
                              //                   color: Colors.grey,
                              //                   width: 1.0,
                              //                 ),
                              //               ),
                              //               child: TextFormField(
                              //                 controller: valueController,
                              //                 validator: (value) {
                              //                   if (value == "") {
                              //                     return StringRsr.get(
                              //                         LanguageKey
                              //                             .VALUE_CANT_BE_EMPTY,
                              //                         firstCap: true);
                              //                   }
                              //                   return null;
                              //                 },
                              //                 textAlignVertical:
                              //                     TextAlignVertical.center,
                              //                 textAlign: TextAlign.center,
                              //                 decoration: InputDecoration(
                              //                   contentPadding:
                              //                       EdgeInsets.only(
                              //                           bottom: 10),
                              //                   hintText: StringRsr.get(
                              //                       LanguageKey.VALUE,
                              //                       firstCap: true),
                              //                   border: InputBorder.none,
                              //                 ),
                              //               ),
                              //             ),
                              //           ),
                              //           GestureDetector(
                              //               onTap: () {
                              //                 if (_globalFormStateKey
                              //                     .currentState
                              //                     .validate()) {
                              //                   Map<String, String> data = {
                              //                     "key": keyController.text,
                              //                     "value":
                              //                         valueController.text
                              //                   };
                              //                   metaData.add(data);
                              //                   valueController.text = "";
                              //                   keyController.text = "";
                              //                   FocusScope.of(context)
                              //                       .unfocus();
                              //                   setState(() {});
                              //                 }
                              //               },
                              //               child: Icon(Icons.add)),
                              //         ],
                              //       ),
                              //     ],
                              //   ),
                              // ),
                              // ListView.builder(
                              //     shrinkWrap: true,
                              //     primary: false,
                              //     itemCount: metaData.length,
                              //     itemBuilder: (context, index) {
                              //       return Padding(
                              //         padding:
                              //             const EdgeInsets.only(top: 10.0),
                              //         child: Row(
                              //           mainAxisAlignment:
                              //               MainAxisAlignment.spaceBetween,
                              //           children: [
                              //             Expanded(
                              //               child: Padding(
                              //                 padding:
                              //                     const EdgeInsets.all(8.0),
                              //                 child: Center(
                              //                     child: Text(metaData[index]
                              //                         ["key"])),
                              //               ),
                              //             ),
                              //             const SizedBox(
                              //               width: 10,
                              //             ),
                              //             Expanded(
                              //               child: Padding(
                              //                 padding:
                              //                     const EdgeInsets.all(8.0),
                              //                 child: Center(
                              //                     child: Text(metaData[index]
                              //                         ["value"])),
                              //               ),
                              //             ),
                              //             GestureDetector(
                              //                 onTap: () {
                              //                   int dataCode = index;
                              //                   //debugPrint(
                              //                       "index $dataCode $metaData");
                              //                   metaData.removeAt(dataCode);
                              //                   //debugPrint(
                              //                       "index $dataCode $metaData");
                              //
                              //                   setState(() {});
                              //                 },
                              //                 child: Icon(Icons.remove)),
                              //           ],
                              //         ),
                              //       );
                              //     }),
                              const SizedBox(
                                height: 30,
                              ),
                              Builder(builder: (context) {
                                if (jobOld == null) {
                                  return Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      GestureDetector(
                                        onTap: () async {
                                          uploadJob(context);
                                        },
                                        child: Container(
                                          width: 250,
                                          height: 35,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              color: Theme.of(context)
                                                  .primaryColor),
                                          padding: const EdgeInsets.only(
                                            left: 15,
                                            top: 8,
                                            bottom: 8,
                                            right: 15,
                                          ),
                                          child: Center(
                                            child: Text(
                                              jobOld != null
                                                  ? StringRsr.get(
                                                      LanguageKey.UPDATE)!
                                                  : StringRsr.get(
                                                      LanguageKey.SAVE)!,
                                              style: const TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                }
                                return Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    GestureDetector(
                                      onTap: () async {
                                        uploadJob(context);
                                      },
                                      child: Container(
                                        width: 130,
                                        height: 35,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            color: Colors.deepPurple),
                                        padding: const EdgeInsets.only(
                                          left: 15,
                                          top: 5,
                                          bottom: 5,
                                          right: 15,
                                        ),
                                        child: Center(
                                          child: Text(
                                            jobOld != null
                                                ? StringRsr.get(
                                                    LanguageKey.UPDATE)!
                                                : StringRsr.get(
                                                    LanguageKey.SAVE)!,
                                            style: const TextStyle(
                                                color: Colors.white),
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 30,
                                    ),
                                    GestureDetector(
                                      onTap: () async {
                                        if (jobOld != null) {
                                          // AwesomeDialog(
                                          //   btnOkText: StringRsr.get(
                                          //       LanguageKey.OK,
                                          //       firstCap: true),
                                          //   btnCancelText: StringRsr.get(
                                          //       LanguageKey.CANCEL,
                                          //       firstCap: true),
                                          //   context: context,
                                          //   dialogType:
                                          //       DialogType.INFO_REVERSED,
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
                                          //       LanguageKey.DELETE,
                                          //       firstCap: true),
                                          //   desc: StringRsr.get(
                                          //       LanguageKey
                                          //           .DO_YOU_WANT_TO_DELETE_THE_JOB,
                                          //       firstCap: true),
                                          //   showCloseIcon: true,
                                          //   btnCancelOnPress: () {},
                                          //   btnOkOnPress: () async {
                                          //     final result = await deleteJob(jobOld!);
                                          //     if (result) {
                                          //       AwesomeDialog(
                                          //         btnOkText: StringRsr.get(
                                          //             LanguageKey.OK,
                                          //             firstCap: true),
                                          //         btnCancelText:
                                          //             StringRsr.get(
                                          //                 LanguageKey.CANCEL,
                                          //                 firstCap: true),
                                          //         context: context,
                                          //         dialogType:
                                          //             DialogType.SUCCES,
                                          //         borderSide: const BorderSide(
                                          //             color:
                                          //                 Colors.transparent,
                                          //             width: 2),
                                          //         width: 380,
                                          //         buttonsBorderRadius:
                                          //             const BorderRadius.all(
                                          //                 Radius.circular(2)),
                                          //         headerAnimationLoop: false,
                                          //         animType:
                                          //             AnimType.BOTTOMSLIDE,
                                          //         title: StringRsr.get(
                                          //             LanguageKey.SUCCESSFUL,
                                          //             firstCap: true),
                                          //         desc: StringRsr.get(
                                          //             LanguageKey
                                          //                 .YOU_HAVE_SUCCESSFUL_DELETED_THE_JOB,
                                          //             firstCap: true),
                                          //         showCloseIcon: true,
                                          //         btnOkOnPress: () {
                                          //           Navigator.popAndPushNamed(
                                          //               context,
                                          //               RouteTo.SHOP_JOB_LIST,
                                          //               arguments:
                                          //                   jobOld!.company);
                                          //         },
                                          //       ).show();
                                          //     } else {
                                          //       AwesomeDialog(
                                          //         btnOkText: StringRsr.get(
                                          //             LanguageKey.OK,
                                          //             firstCap: true),
                                          //         btnCancelText:
                                          //             StringRsr.get(
                                          //                 LanguageKey.CANCEL,
                                          //                 firstCap: true),
                                          //         context: context,
                                          //         dialogType:
                                          //             DialogType.ERROR,
                                          //         borderSide: const BorderSide(
                                          //             color:
                                          //                 Colors.transparent,
                                          //             width: 2),
                                          //         width: 380,
                                          //         buttonsBorderRadius:
                                          //             const BorderRadius.all(
                                          //                 Radius.circular(2)),
                                          //         headerAnimationLoop: false,
                                          //         animType:
                                          //             AnimType.BOTTOMSLIDE,
                                          //         title: StringRsr.get(
                                          //             LanguageKey.ERROR,
                                          //             firstCap: true),
                                          //         desc: StringRsr.get(
                                          //             LanguageKey
                                          //                 .PLEASE_TRY_AGAIN,
                                          //             firstCap: true),
                                          //         showCloseIcon: true,
                                          //         btnOkOnPress: () {},
                                          //       ).show();
                                          //     }
                                          //   },
                                          // ).show();
                                          showInfoToUser(
                                              context,
                                              DialogType.INFO_REVERSED,
                                              StringRsr.get(LanguageKey.DELETE,
                                                  firstCap: true),
                                              StringRsr.get(
                                                  LanguageKey
                                                      .DO_YOU_WANT_TO_DELETE_THE_JOB,
                                                  firstCap: true),
                                              onOk: () async {
                                            final result =
                                                await deleteJob(jobOld!);
                                            if (result) {
                                              // AwesomeDialog(
                                              //   btnOkText: StringRsr.get(
                                              //       LanguageKey.OK,
                                              //       firstCap: true),
                                              //   btnCancelText:
                                              //   StringRsr.get(
                                              //       LanguageKey.CANCEL,
                                              //       firstCap: true),
                                              //   context: context,
                                              //   dialogType:
                                              //   DialogType.SUCCES,
                                              //   borderSide: const BorderSide(
                                              //       color:
                                              //       Colors.transparent,
                                              //       width: 2),
                                              //   width: 380,
                                              //   buttonsBorderRadius:
                                              //   const BorderRadius.all(
                                              //       Radius.circular(2)),
                                              //   headerAnimationLoop: false,
                                              //   animType:
                                              //   AnimType.BOTTOMSLIDE,
                                              //   title: StringRsr.get(
                                              //       LanguageKey.SUCCESSFUL,
                                              //       firstCap: true),
                                              //   desc: StringRsr.get(
                                              //       LanguageKey
                                              //           .YOU_HAVE_SUCCESSFUL_DELETED_THE_JOB,
                                              //       firstCap: true),
                                              //   showCloseIcon: true,
                                              //   btnOkOnPress: () {
                                              //     Navigator.popAndPushNamed(
                                              //         context,
                                              //         RouteTo.SHOP_JOB_LIST,
                                              //         arguments:
                                              //         jobOld!.company);
                                              //   },
                                              // ).show();
                                              showInfoToUser(
                                                context,
                                                DialogType.SUCCES,
                                                StringRsr.get(
                                                    LanguageKey.SUCCESSFUL,
                                                    firstCap: true),
                                                StringRsr.get(
                                                    LanguageKey
                                                        .YOU_HAVE_SUCCESSFUL_DELETED_THE_JOB,
                                                    firstCap: true),
                                                onOk: () {
                                                  Navigator.popAndPushNamed(
                                                      context,
                                                      RouteTo.SHOP_JOB_LIST,
                                                      arguments:
                                                          jobOld!.company);
                                                },
                                              );
                                            } else {
                                              // AwesomeDialog(
                                              //   btnOkText: StringRsr.get(
                                              //       LanguageKey.OK,
                                              //       firstCap: true),
                                              //   btnCancelText:
                                              //   StringRsr.get(
                                              //       LanguageKey.CANCEL,
                                              //       firstCap: true),
                                              //   context: context,
                                              //   dialogType:
                                              //   DialogType.ERROR,
                                              //   borderSide: const BorderSide(
                                              //       color:
                                              //       Colors.transparent,
                                              //       width: 2),
                                              //   width: 380,
                                              //   buttonsBorderRadius:
                                              //   const BorderRadius.all(
                                              //       Radius.circular(2)),
                                              //   headerAnimationLoop: false,
                                              //   animType:
                                              //   AnimType.BOTTOMSLIDE,
                                              //   title: StringRsr.get(
                                              //       LanguageKey.ERROR,
                                              //       firstCap: true),
                                              //   desc: StringRsr.get(
                                              //       LanguageKey
                                              //           .PLEASE_TRY_AGAIN,
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
                                                        .PLEASE_TRY_AGAIN,
                                                    firstCap: true),
                                                onOk: () {},
                                              );
                                            }
                                          });
                                        }
                                      },
                                      child: Container(
                                        width: 130,
                                        height: 35,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            color: CustomColor.PRIM_DARK),
                                        padding: const EdgeInsets.only(
                                          left: 15,
                                          top: 5,
                                          bottom: 5,
                                          right: 15,
                                        ),
                                        child: Center(
                                          child: Text(
                                            StringRsr.get(LanguageKey.DELETE)!,
                                            style: const TextStyle(
                                                color: Colors.white),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              }),
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
    );
  }

  Future<void> uploadJob(BuildContext context) async {
    if (_globalAllFormStateKey.currentState!.validate() &&
        categoryController.text != "" &&
        subcategoryController.text != "") {
      setState(() {
        absorbing = true;
      });
      String? urlImage;
      if (imageSelected) {
        urlImage = await uploadFile();
        if (urlImage == null && imageFile != null) {
          setState(() {
            absorbing = false;
          });
          return;
        }
        jobImage.add(urlImage);
      }
      if (jobImage.isEmpty) {
        // AwesomeDialog(
        //   btnOkText: StringRsr.get(LanguageKey.OK, firstCap: true),
        //   btnCancelText: StringRsr.get(LanguageKey.CANCEL, firstCap: true),
        //   context: context,
        //   dialogType: DialogType.INFO,
        //   borderSide: const BorderSide(color: Colors.transparent, width: 2),
        //   width: 380,
        //   buttonsBorderRadius: const BorderRadius.all(Radius.circular(2)),
        //   headerAnimationLoop: false,
        //   animType: AnimType.BOTTOMSLIDE,
        //   title: StringRsr.get(LanguageKey.ERROR, firstCap: true),
        //   desc:
        //       StringRsr.get(LanguageKey.PLEASE_CHOOSE_A_IMAGE, firstCap: true),
        //   showCloseIcon: true,
        //   btnOkOnPress: () {},
        // ).show();
        showInfoToUser(
          context,
          DialogType.INFO,
          StringRsr.get(LanguageKey.ERROR, firstCap: true),
          StringRsr.get(LanguageKey.PLEASE_CHOOSE_A_IMAGE, firstCap: true),
          onOk: () {},
        );
        setState(() {
          absorbing = false;
        });
        return;
      }
      Job job = Job(
        company: company ?? jobOld!.company,
        jobId: jobId ?? uuid.v1(),
        image: jobImage,
        approved: false,
        name: nameController.text,
        price: num.parse(priceController.text),
        description: descriptionController.text,
        category: categoryController.text,
        subCategory: subcategoryController.text,
        availableStock: num.parse(availableController.text),
        authorOrManufacturer: authorController.text,
        tag: tagList,
        metaData: metaData,
        deliverable: true,
        publishedStatus: "publishedFromApp",
        rating: 0,
      );
      // todo edit or add job
      if (jobOld!.firstModified == null) {
        job.firstModified = DateTime.now();
        job.lastModified = DateTime.now();
      } else {
        job.lastModified = DateTime.now();
      }

      final result = await addJob(job);
      absorbing = false;
      if (result) {
        // AwesomeDialog(
        //   btnOkText: StringRsr.get(LanguageKey.OK, firstCap: true),
        //   btnCancelText: StringRsr.get(LanguageKey.CANCEL, firstCap: true),
        //   context: context,
        //   dialogType: DialogType.SUCCES,
        //   borderSide: const BorderSide(color: Colors.transparent, width: 2),
        //   width: 380,
        //   buttonsBorderRadius: const BorderRadius.all(Radius.circular(2)),
        //   headerAnimationLoop: false,
        //   animType: AnimType.BOTTOMSLIDE,
        //   title: StringRsr.get(LanguageKey.SUCCESSFUL, firstCap: true),
        //   desc:
        //       '${StringRsr.get(LanguageKey.YOU_HAVE_SUCCESSFUL_ADDED, firstCap: true)} ${job.name}',
        //   showCloseIcon: true,
        //   btnOkOnPress: () {
        //     cleaner();
        //   },
        //
        // ).show();
        showInfoToUser(
          context,
          DialogType.SUCCES,
          StringRsr.get(LanguageKey.SUCCESSFUL, firstCap: true),
          '${StringRsr.get(LanguageKey.YOU_HAVE_SUCCESSFUL_ADDED, firstCap: true)} ${job.name}',
          onOk: () {
            cleaner();
          },
        );
      } else {
        // AwesomeDialog(
        //   btnOkText: StringRsr.get(LanguageKey.OK, firstCap: true),
        //   btnCancelText: StringRsr.get(LanguageKey.CANCEL, firstCap: true),
        //   context: context,
        //   dialogType: DialogType.ERROR,
        //   borderSide: const BorderSide(color: Colors.transparent, width: 2),
        //   width: 380,
        //   buttonsBorderRadius: const BorderRadius.all(Radius.circular(2)),
        //   headerAnimationLoop: false,
        //   animType: AnimType.BOTTOMSLIDE,
        //   title: StringRsr.get(LanguageKey.ERROR, firstCap: true),
        //   desc: StringRsr.get(LanguageKey.PLEASE_TRY_AGAIN, firstCap: true),
        //   showCloseIcon: true,
        //   btnOkOnPress: () {},
        // ).show();
        showInfoToUser(
          context,
          DialogType.ERROR,
          StringRsr.get(LanguageKey.ERROR, firstCap: true),
          StringRsr.get(LanguageKey.PLEASE_TRY_AGAIN, firstCap: true),
          onOk: () {},
        );
      }
      setState(() {});
    } else if (categoryController.text == "" ||
        subcategoryController.text == "") {
      // AwesomeDialog(
      //   btnOkText: StringRsr.get(LanguageKey.OK, firstCap: true),
      //   btnCancelText: StringRsr.get(LanguageKey.CANCEL, firstCap: true),
      //   context: context,
      //   dialogType: DialogType.ERROR,
      //   borderSide:const BorderSide(color: Colors.transparent, width: 2),
      //   width: 380,
      //   buttonsBorderRadius:const BorderRadius.all( Radius.circular(2)),
      //   headerAnimationLoop: false,
      //   animType: AnimType.BOTTOMSLIDE,
      //   title: StringRsr.get(LanguageKey.ERROR, firstCap: true),
      //   desc: StringRsr.get(LanguageKey.PLEASE_CHOOSE_A_CATEGORY_SUBCATEGORY,
      //       firstCap: true),
      //   showCloseIcon: true,
      //   btnOkOnPress: () {},
      // ).show();
      showInfoToUser(
        context,
        DialogType.ERROR,
        StringRsr.get(LanguageKey.ERROR, firstCap: true),
        StringRsr.get(LanguageKey.PLEASE_CHOOSE_A_CATEGORY_SUBCATEGORY,
            firstCap: true),
        onOk: () {},
      );
    }
  }

  Future<String?> uploadFile() async {
    if (imageFile == null) return null;
    final fileName = basename(imageFile!.path);
    final String destination = 'jobs/$fileName';
    UploadTask? task = uploadFileStore(destination, imageFile!);
    if (task == null) return null;
    final snapshot = await task.whenComplete(() => null);
    final urlDownload = await snapshot.ref.getDownloadURL();

    return urlDownload;
  }

  void cleaner() {
    nameController.text = "";
    priceController.text = "";
    descriptionController.text = "";
    availableController.text = "";
    authorController.text = "";
    selectedSubCategory = null;
    // tagList = [];
    jobImage = [];
    metaData = [];
    imageFile = null;
    setState(() {});
  }

  void onDelete(int index) {
    tagList.removeAt(index);
    setState(() {});
  }
}

class _Chip extends StatelessWidget {
  const _Chip({
    required this.label,
    required this.onDeleted,
    required this.index,
  });

  final String label;
  final ValueChanged<int> onDeleted;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Chip(
      labelPadding: const EdgeInsets.only(left: 8.0),
      label: Text(label),
      deleteIcon: const Icon(
        Icons.close,
        size: 18,
      ),
      onDeleted: () {
        onDeleted(index);
      },
    );
  }
}
