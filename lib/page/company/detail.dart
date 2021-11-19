import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nibjobs/model/commerce/job.dart';
import 'package:nibjobs/model/profile/company.dart';
import 'package:nibjobs/route/route.dart';
import 'package:nibjobs/rsr/locale/lang/language_key.dart';
import 'package:nibjobs/rsr/locale/string_rsr.dart';
import 'package:nibjobs/rsr/theme/color.dart';
import 'package:nibjobs/widget/icon/icons.dart';
import 'package:nibjobs/widget/info/message.dart';
import 'package:nibjobs/widget/nav/menu.dart';
import 'package:nibjobs/widget/product/product_view.dart';
import 'package:url_launcher/url_launcher.dart';

class CompanyDetailPage extends StatefulWidget {
  @override
  _CompanyDetailPageState createState() => _CompanyDetailPageState();
}

class _CompanyDetailPageState extends State<CompanyDetailPage> {
  @override
  Widget build(BuildContext context) {
    Job? job = ModalRoute.of(context)!.settings.arguments as Job?;

    final Company? company = job!.company;
    return Scaffold(
      appBar: Menu.getAppBar(context, "Company Detail Page"),
      drawer: Menu.getSideDrawer(context),
      body: Container(
        child: Column(
          children: [
            Center(
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
                          CircleAvatar(
                            radius: 50,
                            child: company!.logo == null
                                ? Text(
                                    company.name!.substring(0, 1),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                    ),
                                  )
                                : CachedNetworkImage(
                                    imageUrl: company.logo!,
                                    useOldImageOnUrlChange: false,
                                    placeholderFadeInDuration:
                                        const Duration(seconds: 1),
                                    placeholder: (BuildContext context,
                                        String imageURL) {
                                      return Text(
                                        company.name!
                                            .substring(0, 1)
                                            .toUpperCase(),
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 40,
                                        ),
                                      );
                                    },
                                  ),
                            backgroundColor: Theme.of(context).primaryColor,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Text(
                                company.name ?? "companyName",
                                textScaleFactor: 1.2,
                                style: const TextStyle(
                                    color: CustomColor.GRAY_DARK, fontSize: 20),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0.0, 0.0, 10, 0.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(8.0, 8.0, 0.0, 8.0),
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.pushNamed(
                                      context, RouteTo.SHOP_ISSUE_COUPON,
                                      arguments: company);
                                },
                                child: Container(
                                  margin: const EdgeInsets.fromLTRB(
                                      8.0, 8.0, 0.0, 8.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
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
                                  company.primaryPhone ?? "primaryPhone",
                                  textScaleFactor: 1.2,
                                  style: const TextStyle(
                                      color: CustomColor.GRAY_LIGHT,
                                      fontSize: 10),
                                ),
                                const SizedBox(
                                  height: 1,
                                ),
                                Text(
                                  company.secondaryPhone ?? "secondaryPhone",
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
                                  company.email ?? "companyEmail",
                                  textScaleFactor: 1.2,
                                  style: const TextStyle(
                                      color: CustomColor.GRAY_LIGHT,
                                      fontSize: 10),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                // Text("click here to verify company", style: const TextStyle(fontSize: 10,color: Colors.red[200]),),
                                if (company.verified!)
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
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
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Icon(Icons.security,
                                          color: Colors.red.withOpacity(0.6)),
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
                                          color: Theme.of(context).primaryColor,
                                        ),
                                        Text("get Location",
                                            style: TextStyle(
                                                color: Theme.of(context)
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
                                      Navigator.pushNamed(
                                          context, RouteTo.SHOP_ADD_ITEM,
                                          arguments: company);
                                    },
                                    child: Column(
                                      children: [
                                        Icon(
                                          Icons.add,
                                          color: Theme.of(context).primaryColor,
                                        ),
                                        Text("Add Item",
                                            style: TextStyle(
                                                color: Theme.of(context)
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
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
              child: Container(
                color: CustomColor.GRAY_VERY_LIGHT,
                padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                child: GestureDetector(
                  onTap: () {},
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "click here",
                        style: TextStyle(color: Theme.of(context).primaryColor),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      const Text(
                        "to upgrade to premium package",
                        textScaleFactor: 1.2,
                        style: TextStyle(
                          color: CustomColor.GRAY,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            buildSimilarItemsSection(company)
          ],
        ),
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
      p.id = documentSnapshot.id;
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
                    message: "Could not find other items",
                  );
                } else if (snapshot.connectionState == ConnectionState.done &&
                    snapshot.hasData) {
                  List<Job> newJobs = snapshot.data;
                  return newJobs.isEmpty
                      ? Message(
                          message: "Could not find other items",
                        )
                      : Expanded(
                          child: GridView.builder(
                              shrinkWrap: false,
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                mainAxisSpacing: 4,
                              ),
                              itemCount: newJobs.length,
                              itemBuilder: (BuildContext context, int index) {
                                return JobView(newJobs[index]);
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

  Future<Company> getCompany() async {
    // await getBookByQuery(query: search ?? "b");

    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection(Company.COLLECTION_NAME)
        .where(Company.NAME, isEqualTo: "Book World")
        .get();

    List<DocumentSnapshot>? documentSnapshot = querySnapshot.docs;

    Company companyData =
        Company.toModel(documentSnapshot[0].data() as Map<String, dynamic>);

    return companyData;
  }
}
