import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nibjobs/api/flutterfire.dart';
import 'package:nibjobs/model/ad_model.dart';
import 'package:nibjobs/model/commerce/job.dart';
import 'package:nibjobs/model/profile/company.dart';
import 'package:nibjobs/route/route.dart';
import 'package:nibjobs/themes/theme.dart';

Container buildAdsContainer(
    BuildContext context, List imageList, List<Ad> adList) {
  return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: CarouselSlider(
        options: CarouselOptions(
          height: jobViewH(context) == .20 ||
                  jobViewH(context) == .37 ||
                  jobViewH(context) == .36
              ? 130
              : 80, //520,300
          autoPlay: true,
          viewportFraction: 1,
          aspectRatio: 2.0,
          enlargeCenterPage: false,
          initialPage: 0,
          autoPlayInterval: Duration(seconds: 10),
        ),
        items: adList == [] || adList == null
            ? imageList.map(
                (url) {
                  return Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      image: DecorationImage(
                        image: AssetImage(
                          url,
                        ),
                        fit: BoxFit.fill,
                      ),
                    ),
                    margin:
                        EdgeInsets.only(left: 2.0, top: 0, right: 2, bottom: 0),
//                             child: Image.asset(
//                               url,
//                               fit: BoxFit.contain,
// //                              height: 200.0,
//                             ),
                  );
                },
              ).toList()
            : adList.map(
                (Ad ads) {
                  return GestureDetector(
                    onTap: () async {
                      if (ads.contactUs!) {
                        Navigator.of(context)
                            .pushNamed(RouteTo.INFO_CONTACT_US);
                      } else if (ads.job != "") {
                        String linkData = ads.job!;
                        debugPrint("linkData job $linkData");
                        DocumentSnapshot documentSnapshot =
                            await FirebaseFirestore.instance
                                .collection(Job.COLLECTION_NAME)
                                .doc(linkData)
                                .get();
                        if (documentSnapshot.data() != null) {
                          Job p = Job.toModel(documentSnapshot.data());
                          //this is only for test
                          p.jobId = documentSnapshot.id;
                          Navigator.pushNamed(context, RouteTo.JOB_DETAIL,
                              arguments: p);
                        }
                      } else if (ads.company != "") {
                        String linkData = ads.company!;
                        //debugPrint("linkData $linkData");
                        DocumentSnapshot documentSnapshot =
                            await FirebaseFirestore.instance
                                .collection(Company.COLLECTION_NAME)
                                .doc(linkData)
                                .get();
                        if (documentSnapshot.data() != null) {
                          Company p = Company.toModel(
                              documentSnapshot.data() as Map<String, dynamic>);
                          //this is only for test
                          p.companyId = documentSnapshot.id;
                          Navigator.pushNamed(context, RouteTo.JOB_SEARCH,
                              arguments: p);
                        }
                      } else if (ads.link != "") {
                        makeWebCall(ads.link!);
                      }
                    },
                    child: Container(
                      margin: const EdgeInsets.only(
                          left: 2.0, top: 0, right: 2, bottom: 0),
                      child: CachedNetworkImage(
                        imageUrl: ads.image!,
                        useOldImageOnUrlChange: true,
                        imageBuilder: (context, imagePath) {
                          return Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              image: DecorationImage(
                                image: imagePath,
                                fit: BoxFit.fill,
                              ),
                            ),
                          );
                        },
                        placeholderFadeInDuration: Duration(seconds: 1),
                        placeholder: (BuildContext context, String imageURL) {
                          return Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              image: DecorationImage(
                                image: AssetImage(
                                  imageList[0],
                                ),
                                fit: BoxFit.fill,
                              ),
                            ),
                            margin: EdgeInsets.only(
                                left: 2.0, top: 0, right: 2, bottom: 0),
//                             child: Image.asset(
//                               url,
//                               fit: BoxFit.contain,
// //                              height: 200.0,
//                             ),
                          );
                        },
                        errorWidget:
                            (BuildContext context, String imageURL, dynamic) {
                          return Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              image: DecorationImage(
                                image: AssetImage(
                                  imageList[0],
                                ),
                                fit: BoxFit.fill,
                              ),
                            ),
                            margin: EdgeInsets.only(
                                left: 2.0, top: 0, right: 2, bottom: 0),
//                             child: Image.asset(
//                               url,
//                               fit: BoxFit.contain,
// //                              height: 200.0,
//                             ),
                          );
                        },
                      ),
                    ),
                  );
                },
              ).toList(),
      ));
}
