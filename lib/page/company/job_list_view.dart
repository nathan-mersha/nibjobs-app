import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nibjobs/bloc/sort/sort_bloc.dart';
import 'package:nibjobs/model/profile/company.dart';
import 'package:nibjobs/route/route.dart';
import 'package:nibjobs/rsr/locale/lang/language_key.dart';
import 'package:nibjobs/rsr/locale/string_rsr.dart';
import 'package:nibjobs/rsr/theme/color.dart';
import 'package:nibjobs/themes/light_color.dart';
import 'package:nibjobs/themes/theme.dart';
import 'package:nibjobs/widget/product/product_view.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shimmer/shimmer.dart';

import '../../model/commerce/job.dart';
import '../../widget/info/message.dart';

class CompanyJobPage extends StatefulWidget {
  @override
  _CompanyJobPageState createState() => _CompanyJobPageState();
}

class _CompanyJobPageState extends State<CompanyJobPage> {
  String? numPro;
  Company? company;
  static const int JOB_LIMIT = 20;

  List<Job> _jobs = [];
  bool _initialJobsLoaded = false;
  bool _initialJobs = false;
  DocumentSnapshot? _lastDocumentSnapShot;

  final RefreshController _refresherController =
      RefreshController(initialRefresh: true);
  Widget getAppBar2(BuildContext context, String job,
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
        StringRsr.get(LanguageKey.MY_JOBS, firstCap: false)!,
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
                    Navigator.pushNamed(context, RouteTo.SHOP_ADD_ITEM,
                        arguments: company);
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: Icon(
                    Icons.add,
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
    company = ModalRoute.of(context)!.settings.arguments as Company?;

    return Scaffold(
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(100),
          child: getAppBar2(context, "company list")),
//      drawer: Menu.getSideDrawer(context),
      body: Container(
        padding: AppTheme.padding,
        // color: Colors.red,
        child: Column(
          children: [buildSimilarItemsSection(company!)],
        ),
      ),
    );
  }

  Future<List<Job>> getRefreshedData(Company company) async {
    QuerySnapshot? querySnapshot;
    try {
      querySnapshot = await FirebaseFirestore.instance
          .collection(Job.COLLECTION_NAME)
          .where("company.companyId", isEqualTo: company.companyId)
          .limit(JOB_LIMIT)
          .orderBy(Job.LAST_MODIFIED, descending: true)
          .get();
    } on Exception catch (e) {
      // TODO
      debugPrint("eeee $e");
    }

    List<DocumentSnapshot> documentSnapshot = querySnapshot!.docs;

    List<Job> jobs = documentSnapshot.map((DocumentSnapshot documentSnapshot) {
      Job p = Job.toModel(documentSnapshot.data());
      return p;
    }).toList();

    return jobs;
  }

  Future<List<Job>> getRelatedJob(Company company) async {
    QuerySnapshot? querySnapshot;
    try {
      querySnapshot = _lastDocumentSnapShot != null
          ? await FirebaseFirestore.instance
              .collection(Job.COLLECTION_NAME)
              .where("company.companyId", isEqualTo: company.companyId)
              .limit(JOB_LIMIT)
              .orderBy(Job.LAST_MODIFIED, descending: true)
              .startAfterDocument(_lastDocumentSnapShot!)
              .get()
          // if there is a previous document query begins searching from the last document.
          : await FirebaseFirestore.instance
              .collection(Job.COLLECTION_NAME)
              .where("company.companyId", isEqualTo: company.companyId)
              .limit(JOB_LIMIT)
              .orderBy(Job.LAST_MODIFIED, descending: true)
              .get();
    } on Exception catch (e) {
      // TODO

    }

    List<DocumentSnapshot>? documentSnapshot = querySnapshot!.docs;
    if (documentSnapshot.isNotEmpty) {
      _lastDocumentSnapShot = documentSnapshot.last;
    } else {}
    List<Job> jobs = documentSnapshot.map((DocumentSnapshot documentSnapshot) {
      Job p = Job.toModel(documentSnapshot.data());
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
          Expanded(
            child: BlocBuilder<SortBloc, SortState>(
              builder: (context, state) {
                if (state is SortInitial) {
                  return SmartRefresher(
                    controller: _refresherController,
                    enablePullUp: true,
                    onRefresh: () async {
                      _refresherController.refreshCompleted();
                      List<Job> newJobs = await getRelatedJob(company);
                      if (newJobs.isNotEmpty) {
                        _jobs.addAll(newJobs);
                        //_jobs = sortFun(_jobs);
                        _refresherController.refreshCompleted();
                        _initialJobsLoaded = false;
                        _initialJobs = true;
                        if (mounted) setState(() {});
                      } else if (newJobs.isEmpty && !_initialJobs) {
                        _refresherController.resetNoData();
                        _refresherController.refreshCompleted();
                        _initialJobsLoaded = true;
                        if (mounted) setState(() {});
                      } else {
                        _refresherController.refreshFailed();
                      }
                    },
                    onLoading: () async {
                      List<Job> newJobs = await getRelatedJob(company);
                      if (newJobs.isNotEmpty) {
                        _jobs.addAll(newJobs);
                        _initialJobsLoaded = false;

                        if (mounted) setState(() {});
                        _refresherController.loadComplete();
                      } else if (newJobs.isEmpty) {
                        _refresherController.loadNoData();
                      } else {
                        _refresherController.loadFailed();
                      }
                    },
                    child: Builder(builder: (context) {
                      if (_initialJobsLoaded) {
                        return Message(
                          message: StringRsr.get(LanguageKey.NO_JOB_FOUND,
                              firstCap: true),
                          icon: Icon(
                            Icons.cloud_off,
                            color: Theme.of(context).primaryColor,
                            size: 45,
                          ),
                        );
                      } else if (_jobs.isNotEmpty) {
                        return GridView.builder(
                          shrinkWrap: true,
                          //hasNext: _jobs.length < 200,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: jobViewH(context) == .20 ||
                                          jobViewH(context) == .37 ||
                                          jobViewH(context) == .36 ||
                                          jobViewH(context) == .35
                                      ? 2
                                      : 1,
                                  mainAxisSpacing: 10,
                                  childAspectRatio: jobViewH(context) == .7
                                      ? 7 / 4
                                      : jobViewH(context) == .20
                                          ? 7 / 3
                                          : 7 / 3),
                          itemCount: _jobs != null ? _jobs.length : 0,
                          itemBuilder: (BuildContext context, int index) {
                            return JobView(
                              _jobs[index],
                              pageAdmin: true,
                              onComplete: () async {
                                debugPrint("hhhhh");
                                _jobs = await getRefreshedData(company);
                                setState(() {});
                              },
                            );
                          },
                          // nextData: this
                          //     ._refresherController
                          //     .requestLoading,
                        );
                      } else {
                        return GridView.builder(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: jobViewH(context) == .20 ||
                                          jobViewH(context) == .37 ||
                                          jobViewH(context) == .36 ||
                                          jobViewH(context) == .35
                                      ? 2
                                      : 1,
                                  mainAxisSpacing: 10,
                                  childAspectRatio: jobViewH(context) == .7
                                      ? 7 / 4
                                      : jobViewH(context) == .20
                                          ? 7 / 3
                                          : 7 / 3),
                          itemBuilder: (_, __) => Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color: LightColor.iconColor,
                                    style: BorderStyle.none),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                                // color:
                                // isOutLine ? Colors.transparent : Theme.of(context).backgroundColor,
                              ),
                              child: Card(
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    // Image thumbnail or image place holder
                                    Expanded(
                                      flex: 1,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Stack(
                                          fit: StackFit.expand,
                                          children: [
                                            Shimmer.fromColors(
                                              baseColor: Colors.grey[300]!,
                                              highlightColor: Colors.grey[100]!,
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color: Colors.grey,
                                                  borderRadius:
                                                      BorderRadius.circular(24),
                                                ),
                                              ),
                                            ),
                                            Align(
                                              alignment: Alignment.topRight,
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    right: 10.0, top: 5),
                                                child: GestureDetector(
                                                  onTap: () async {},
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              24),
                                                      color: Colors.white,
                                                    ),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              4.0),
                                                      child: Icon(
                                                        Icons.favorite,
                                                        color: Colors.red,
                                                        size: 15,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),

                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 3, horizontal: 15),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: <Widget>[
                                            // Job name
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Shimmer.fromColors(
                                                  baseColor: Colors.grey[300]!,
                                                  highlightColor:
                                                      Colors.grey[100]!,
                                                  child: Container(
                                                    width: 150,
                                                    height: 20.0,
                                                    color: Colors.white,
                                                  ),
                                                ),

                                                // Job Author / Manufacturer
                                                Shimmer.fromColors(
                                                  baseColor: Colors.grey[300]!,
                                                  highlightColor:
                                                      Colors.grey[100]!,
                                                  child: Container(
                                                    width: 70,
                                                    height: 20.0,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ],
                                            ),

                                            const SizedBox(
                                              height: 1,
                                            ),
                                            Shimmer.fromColors(
                                              baseColor: Colors.grey[300]!,
                                              highlightColor: Colors.grey[100]!,
                                              child: Container(
                                                width: 150,
                                                height: 20.0,
                                                color: Colors.white,
                                              ),
                                            ),
                                            Shimmer.fromColors(
                                              baseColor: Colors.grey[300]!,
                                              highlightColor: Colors.grey[100]!,
                                              child: Container(
                                                width: 70,
                                                height: 20.0,
                                                color: Colors.white,
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 1,
                                            ),
                                            Shimmer.fromColors(
                                              baseColor: Colors.grey[300]!,
                                              highlightColor: Colors.grey[100]!,
                                              child: Container(
                                                width: 60,
                                                height: 20.0,
                                                color: Colors.white,
                                              ),
                                            ),

                                            // Price and regular price
                                            const SizedBox(
                                              height: 1,
                                            ),

                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                SingleChildScrollView(
                                                  scrollDirection:
                                                      Axis.horizontal,
                                                  child: Shimmer.fromColors(
                                                    baseColor:
                                                        Colors.grey[300]!,
                                                    highlightColor:
                                                        Colors.grey[100]!,
                                                    child: Container(
                                                      width: 30,
                                                      height: 20.0,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ),
                                                SingleChildScrollView(
                                                  scrollDirection:
                                                      Axis.horizontal,
                                                  child: GestureDetector(
                                                    onTap: () {},
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(20),
                                                          color: Theme.of(
                                                                  context)
                                                              .primaryColor),
                                                      padding:
                                                          const EdgeInsets.only(
                                                        left: 15,
                                                        top: 5,
                                                        bottom: 5,
                                                        right: 15,
                                                      ),
                                                      child: Text(
                                                        StringRsr.get(
                                                            LanguageKey.CALL)!,
                                                        style: const TextStyle(
                                                            color:
                                                                Colors.white),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            )

                                            // Job price and regular price
                                          ],
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                          itemCount: 20,
                        );
                      }
                    }),
                  );
                } else {
                  return Container();
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
