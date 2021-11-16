import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nibjobs/model/profile/company.dart';
import 'package:nibjobs/rsr/locale/lang/language_key.dart';
import 'package:nibjobs/rsr/locale/string_rsr.dart';
import 'package:nibjobs/widget/nav/menu.dart';
import 'package:nibjobs/widget/product/product_view.dart';

import '../../model/commerce/job.dart';
import '../../widget/icon/icons.dart';
import '../../widget/info/message.dart';

class WishListPage extends StatelessWidget {
  Company? company;
  @override
  Widget build(BuildContext context) {
    company = ModalRoute.of(context)!.settings.arguments as Company?;

    return Scaffold(
      appBar: Menu.getAppBar(context, "Wishlist"),
      drawer: Menu.getSideDrawer(context),
      body: Container(
        child: Column(
          children: [buildSimilarItemsSection()],
        ),
      ),
    );
  }

  Future<List<Job>> getRelatedJob() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection(Job.COLLECTION_NAME)
        .orderBy(Job.LAST_MODIFIED, descending: true)
        .get();
    List<DocumentSnapshot> documentSnapshot = querySnapshot.docs;

    List<Job> jobs = documentSnapshot.map((DocumentSnapshot documentSnapshot) {
      Job p = Job.toModel(documentSnapshot.data());
      return p;
    }).toList();

    return jobs;
  }

  Expanded buildSimilarItemsSection() {
    return Expanded(
      flex: 7,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          FutureBuilder(
              future: getRelatedJob(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.connectionState == ConnectionState.done &&
                    !snapshot.hasData) {
                  return Message(
                    message: "Could not find related items",
                  );
                } else if (snapshot.connectionState == ConnectionState.done &&
                    snapshot.hasData) {
                  List<Job> newJobs = snapshot.data;
                  return newJobs.isEmpty
                      ? Message(
                          message: "Could not find related items",
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
}
