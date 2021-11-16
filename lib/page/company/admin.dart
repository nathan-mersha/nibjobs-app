import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:nibjobs/route/route.dart';
import 'package:nibjobs/rsr/locale/lang/language_key.dart';
import 'package:nibjobs/rsr/locale/string_rsr.dart';
import 'package:nibjobs/widget/nav/menu.dart';
import 'package:nibjobs/widget/product/product_view.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../model/commerce/job.dart';
import '../../model/profile/company.dart';
import '../../rsr/theme/color.dart';
import '../../widget/icon/icons.dart';
import '../../widget/info/message.dart';

class CompanyAdminPage extends StatefulWidget {
  @override
  _CompanyAdminPageState createState() => _CompanyAdminPageState();
}

class _CompanyAdminPageState extends State<CompanyAdminPage> {
  Company? company;
  List<Job>? newJobs;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Menu.getAppBar(context, "Company Admin"),
      drawer: Menu.getSideDrawer(context),
      body: FutureBuilder(
        future: getCompany(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              !snapshot.hasData) {
            return Center(
                child: Message(
              icon: CustomIcons.noInternet(),
              message: StringRsr.get(LanguageKey.NO_INTERNET, firstCap: true),
            ));
          } else if (snapshot.hasData &&
              snapshot.connectionState == ConnectionState.done) {
            if (snapshot.data != false) {
              company = snapshot.data as Company?;
            } else {
              company = null;
            }

            return Column(
              children: [
                Builder(
                  builder: (context) {
                    if (company != null) {
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(0.0, 10, 0.0, 0.0),
                          child: Container(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.pop(context);
                                        Navigator.pushNamed(
                                            context, RouteTo.SHOP_EDIT,
                                            arguments: company);
                                      },
                                      child: CircleAvatar(
                                        radius: 50,
                                        child: company!.logo == null
                                            ? CircleAvatar(
                                                backgroundColor:
                                                    Theme.of(context)
                                                        .primaryColor,
                                                radius: 50,
                                                child: Text(
                                                  company!.name!
                                                      .substring(0, 1),
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 20,
                                                  ),
                                                ),
                                              )
                                            : CachedNetworkImage(
                                                imageUrl: company!.logo,
                                                useOldImageOnUrlChange: false,
                                                placeholderFadeInDuration:
                                                    Duration(seconds: 1),
                                                placeholder:
                                                    (BuildContext context,
                                                        String imageURL) {
                                                  return CircleAvatar(
                                                    backgroundColor:
                                                        Theme.of(context)
                                                            .primaryColor,
                                                    radius: 50,
                                                    child: Text(
                                                      company!.name!
                                                          .substring(0, 1)
                                                          .toUpperCase(),
                                                      style: const TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 40,
                                                      ),
                                                    ),
                                                  );
                                                },
                                              ),
                                        backgroundColor: Colors.transparent,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: Text(
                                          company!.name ?? "companyName",
                                          textScaleFactor: 1.2,
                                          style: const TextStyle(
                                              color: CustomColor.GRAY_DARK,
                                              fontSize: 20),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                      0.0, 0.0, 10, 0.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            8.0, 8.0, 0.0, 8.0),
                                        child: GestureDetector(
                                          onTap: () {
                                            Navigator.pushNamed(context,
                                                RouteTo.SHOP_ISSUE_COUPON,
                                                arguments: company);
                                          },
                                          child: Container(
                                            margin: const EdgeInsets.fromLTRB(
                                                8.0, 8.0, 0.0, 8.0),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                Text("issue coupon",
                                                    style: TextStyle(
                                                        color: Theme.of(context)
                                                            .primaryColor,
                                                        fontSize: 10)),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      Column(
                                        children: [
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Text(
                                            company!.primaryPhone ??
                                                "primaryPhone",
                                            textScaleFactor: 1.2,
                                            style: const TextStyle(
                                                color: CustomColor.GRAY_LIGHT,
                                                fontSize: 10),
                                          ),
                                          const SizedBox(
                                            height: 1,
                                          ),
                                          Text(
                                            company!.secondaryPhone ??
                                                "secondaryPhone",
                                            textScaleFactor: 1.2,
                                            style: const TextStyle(
                                                color: CustomColor.GRAY_LIGHT,
                                                fontSize: 10),
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Text(
                                            // "abebe.company@gmail.com",
                                            // style: const TextStyle(fontSize: 10),
                                            company!.email ?? "companyEmail",
                                            textScaleFactor: 1.2,
                                            style: const TextStyle(
                                                color: CustomColor.GRAY_LIGHT,
                                                fontSize: 10),
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          // Text("click here to verify company", style: const TextStyle(fontSize: 10,color: Colors.red[200]),),
                                          if (company!.isVerified!)
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: const <Widget>[
                                                Icon(
                                                  Icons.verified_user,
                                                  color: Colors.lightGreen,
                                                  size: 12,
                                                ),
                                                Text(
                                                  "verified",
                                                  textScaleFactor: 0.9,
                                                  style: TextStyle(
                                                      color: Colors.lightGreen),
                                                )
                                              ],
                                            )
                                          else
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: <Widget>[
                                                Icon(Icons.security,
                                                    color: Colors.red
                                                        .withOpacity(0.6)),
                                                Text("unverified")
                                              ],
                                            ),
                                        ],
                                      ),
                                      Container(
                                        child: Column(
                                          children: [
                                            GestureDetector(
                                              onTap: () {
                                                _lunchMapsUrl();
                                              },
                                              child: Column(
                                                children: [
                                                  Icon(
                                                    Icons.location_on,
                                                    color: Theme.of(context)
                                                        .primaryColor,
                                                  ),
                                                  Text("set Location",
                                                      style: TextStyle(
                                                          color:
                                                              Theme.of(context)
                                                                  .primaryColor,
                                                          fontSize: 10)),
                                                ],
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 40,
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                if (company!.isVerified!) {
                                                  Navigator.pushNamed(context,
                                                      RouteTo.SHOP_ADD_ITEM,
                                                      arguments: company);
                                                } else if (!company!
                                                        .isVerified! &&
                                                    newJobs!.length < 3) {
                                                  Navigator.pushNamed(context,
                                                      RouteTo.SHOP_ADD_ITEM,
                                                      arguments: company);
                                                } else {
                                                  AwesomeDialog(
                                                    btnOkText: StringRsr.get(
                                                        LanguageKey.OK,
                                                        firstCap: true),
                                                    btnCancelText:
                                                        StringRsr.get(
                                                            LanguageKey.CANCEL,
                                                            firstCap: true),
                                                    context: context,
                                                    dialogType: DialogType.INFO,
                                                    borderSide: BorderSide(
                                                        color:
                                                            Colors.transparent,
                                                        width: 2),
                                                    width: 380,
                                                    buttonsBorderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(2)),
                                                    headerAnimationLoop: false,
                                                    animType:
                                                        AnimType.BOTTOMSLIDE,
                                                    title: 'Limit',
                                                    desc:
                                                        'you have reached the limit of this account get a pro account to add more items',
                                                    showCloseIcon: true,
                                                    btnOkOnPress: () {},
                                                  )..show();
                                                }
                                              },
                                              child: Column(
                                                children: [
                                                  Icon(
                                                    Icons.add,
                                                    color: Theme.of(context)
                                                        .primaryColor,
                                                  ),
                                                  Text("Add Item",
                                                      style: TextStyle(
                                                          color:
                                                              Theme.of(context)
                                                                  .primaryColor,
                                                          fontSize: 10)),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }
                    return Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                              Navigator.pushNamed(context, RouteTo.SHOP_EDIT);
                            },
                            child: Text(
                              "click here",
                              style: TextStyle(
                                  color: Theme.of(context).accentColor),
                            ),
                          ),
                          const Text(
                            "to setup your first company",
                            style: TextStyle(
                              color: CustomColor.GRAY_LIGHT,
                            ),
                          )
                        ],
                      ),
                    );
                  },
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                  child: Container(
                    height: 40,
                    color: CustomColor.GRAY_VERY_LIGHT,
                    padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                    child: Builder(
                      builder: (context) {
                        if (company != null) {
                          return GestureDetector(
                            onTap: () {},
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "click here",
                                  style: TextStyle(
                                      color: Theme.of(context).primaryColor),
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  "to upgrade to premium package",
                                  textScaleFactor: 1.2,
                                  style: const TextStyle(
                                    color: CustomColor.GRAY,
                                  ),
                                )
                              ],
                            ),
                          );
                        }
                        return Container();
                      },
                    ),
                  ),
                ),
                Container(
                  child: Builder(
                    builder: (context) {
                      if (company != null) {
                        //to do
                        return buildSimilarItemsSection(company!);
                      }
                      return Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "click here",
                              style: TextStyle(
                                  color: Theme.of(context).accentColor),
                            ),
                            Text(
                              "to setup your first company",
                              style: const TextStyle(
                                color: CustomColor.GRAY_LIGHT,
                              ),
                            )
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          } else {
            return Message(
              icon: SpinKitFadingFour(
                color: Theme.of(context).primaryColor,
              ),
              message: "loading company",
            );
          }
        },
      ),
    );
  }

  Future<List<Job>> getRelatedJob(Company company) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection(Job.COLLECTION_NAME)
        .where(Job.CATEGORY, isEqualTo: company.category)
        .where("company.name", isEqualTo: company.name)
        .orderBy(Job.LAST_MODIFIED, descending: true)
        .get();

    List<DocumentSnapshot> documentSnapshot = querySnapshot.docs;

    List<Job> jobs = documentSnapshot.map((DocumentSnapshot documentSnapshot) {
      Job p = Job.toModel(documentSnapshot.data());
      p.jobId = documentSnapshot.id;
      return p;
    }).toList();

    return jobs;
  }

  Expanded buildSimilarItemsSection(Company company) {
    return Expanded(
      flex: 7,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          FutureBuilder(
              future: getRelatedJob(company),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.connectionState == ConnectionState.done &&
                    !snapshot.hasData) {
                  return Message(
                    message: "Could not find company items",
                  );
                } else if (snapshot.connectionState == ConnectionState.done &&
                    snapshot.hasData) {
                  newJobs = snapshot.data;
                  return newJobs!.isEmpty
                      ? Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                  Navigator.pushNamed(
                                      context, RouteTo.SHOP_ADD_ITEM,
                                      arguments: company);
                                },
                                child: Text(
                                  "click here",
                                  style: TextStyle(
                                      color: Theme.of(context).accentColor),
                                ),
                              ),
                              const Text(
                                "to setup your first company",
                                style: TextStyle(
                                  color: CustomColor.GRAY_LIGHT,
                                ),
                              )
                            ],
                          ),
                        )
                      : Expanded(
                          child: GridView.builder(
                              shrinkWrap: false,
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                mainAxisSpacing: 4,
                              ),
                              itemCount: newJobs!.length,
                              itemBuilder: (BuildContext context, int index) {
                                return JobView(newJobs![index],
                                    pageAdmin: true);
                              }),
                        );
                } else if (snapshot.hasError) {
                  return Center(
                      child: Text(
                    snapshot.error.toString(),
                    style: const TextStyle(color: Colors.black45),
                  ));
                } else {
                  return Expanded(
                    child: Center(
                      child: Message(
                        icon: CustomIcons.getHorizontalLoading(),
                        message:
                            StringRsr.get(LanguageKey.LOADING, firstCap: true),
                      ),
                    ),
                  );
                }
              })
        ],
      ),
    );
  }

  void _lunchMapsUrl() async {
    final url = 'https://www.google.com/maps';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not Launch $url';
    }
  }

  Future<dynamic> getCompany() async {
    // await getBookByQuery(query: search ?? "b");
    var uid = FirebaseAuth.instance.currentUser!.uid;
    DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
        .collection(Company.COLLECTION_NAME)
        .doc(uid)
        .get();

    if (documentSnapshot.data() == null) return false;

    Company companyData =
        Company.toModel(documentSnapshot.data() as Map<String, dynamic>);
    return companyData;
  }
}
