import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nibjobs/api/flutterfire.dart';
import 'package:nibjobs/bloc/sort/sort_bloc.dart';
import 'package:nibjobs/global.dart' as global;
import 'package:nibjobs/model/commerce/job.dart';
import 'package:nibjobs/model/config/global.dart';
import 'package:nibjobs/model/profile/company.dart';
import 'package:nibjobs/rsr/locale/lang/language_key.dart';
import 'package:nibjobs/rsr/locale/string_rsr.dart';
import 'package:nibjobs/rsr/theme/color.dart';
import 'package:nibjobs/themes/light_color.dart';
import 'package:nibjobs/themes/nib_custom_icons_icons.dart';
import 'package:nibjobs/themes/theme.dart';
import 'package:nibjobs/widget/icon/icons.dart';
import 'package:nibjobs/widget/info/message.dart';
import 'package:nibjobs/widget/nav/category_menu.dart';
import 'package:nibjobs/widget/product/product_view.dart';
import 'package:nibjobs/widget/product/shop_view.dart';
import 'package:nibjobs/widget/title_text.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:share/share.dart';
import 'package:shimmer/shimmer.dart';

class KelemSearchPage extends StatefulWidget {
  KelemSearchPage({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  _KelemSearchPageState createState() => _KelemSearchPageState();
}

class _KelemSearchPageState extends State<KelemSearchPage> {
  bool sortUp = true;
  bool isCompanyInfo = false;
  bool localSearch = false;
  Widget _icon(IconData icon, {Color color = LightColor.iconColor}) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(13)),
        color: Theme.of(context).backgroundColor,
      ),
      child: Icon(
        icon,
        color: color,
      ),
    );
  }

  static const int JOB_LIMIT = 20;

  ScrollController _scrollController = ScrollController();
  DocumentSnapshot? _lastDocumentSnapShot;
  bool _noMoreItem = false;
  Category? category;
  bool _initialJobsLoaded = false;
  List<dynamic>? subCategories;
  String? subCategorie;
  Company? company;
  TextEditingController _searchController = TextEditingController();

  List<Job> allJobs = [];
  List<Job> searchJobs = [];
  bool _loading = false;
  final RefreshController _refresherControllerFull =
      RefreshController(initialRefresh: true);
  List<Job> _jobs = [];
  bool sortUpLocal = false;
  @override
  void initState() {
    super.initState();
    // Will be called when there is a change in the local config.
    // _scrollController.addListener(() {
    //   // Reached at 70% of bottom
    //   num currentPosition = _scrollController.position.pixels;
    //   num maxScrollExtent = _scrollController.position.maxScrollExtent * 0.7;
    //   if (currentPosition == maxScrollExtent) {
    //     setState(() {
    //       _loading = true;
    //     });
    //     //debugPrint("data here list");
    //     // Retrieving next jobs and adding to existing list.
    //     getJobs();
    //   }
    // });
    global.localConfig.addListener(() {
      // set state for sub categories.
      setState(() {
        category = global.localConfig.selectedCategory;
        subCategories = global.localConfig.selectedCategory.tags;
        //debugPrint("here subCategories $subCategories");
      });
    });
    if (global.localConfig.selectedCategory != null) {
      category = global.localConfig.selectedCategory;
      subCategories = global.localConfig.selectedCategory.tags;
    }
  }

  @override
  void dispose() {
    super.dispose();
    _searchController.dispose();
    //  global.localConfig.removeListener(() {});
  }

  List<Job> sortFun(List<Job> list) {
    //debugPrint("sortFun sortFun");
    // if (sortUp) {
    //   list.sort((a, b) => a.price!.compareTo(b.price!));
    // } else {
    //   list.sort((a, b) => b.price!.compareTo(a.price!));
    // }

    return list;
    // localSearch = true;
    // setState(() {});
  }

  Widget _jobWidget() {
    return BlocBuilder<SortBloc, SortState>(
      builder: (context, state) {
        if (state is SortInitial) {
          sortUp = state.sortUp;

          if (_jobs.isNotEmpty &&
              state.sortUpNow &&
              sortUp.toString() != sortUpLocal.toString()) {
            _jobs = sortFun(_jobs);
            sortUpLocal = sortUp;
          }
          return SmartRefresher(
            controller: _refresherControllerFull,
            enablePullUp: true,
            onRefresh: () async {
              //debugPrint("data pull load");
              _refresherControllerFull.refreshCompleted();
              List<Job> newJobs = await getJobs();
              if (newJobs.isNotEmpty) {
                _jobs.addAll(newJobs);
                //_jobs = sortFun(_jobs);
                _refresherControllerFull.refreshCompleted();
                if (mounted) setState(() {});
              } else if (newJobs.isEmpty) {
                _refresherControllerFull.resetNoData();
                _refresherControllerFull.refreshCompleted();
                _initialJobsLoaded = true;
                if (mounted) setState(() {});
              } else {
                _refresherControllerFull.refreshFailed();
              }
            },
            onLoading: () async {
              //debugPrint("data pull load");
              List<Job> newJobs = await getJobs();
              if (newJobs.isNotEmpty) {
                _jobs.addAll(newJobs);
                _initialJobsLoaded = false;
                //debugPrint("_jobs.length ${_jobs.length}");
                if (mounted) setState(() {});
                _refresherControllerFull.loadComplete();
              } else if (newJobs.isEmpty) {
                _refresherControllerFull.loadNoData();
              } else {
                _refresherControllerFull.loadFailed();
              }
            },
            child: Builder(builder: (context) {
              if (_initialJobsLoaded) {
                return Message(
                  message:
                      StringRsr.get(LanguageKey.NO_JOB_FOUND, firstCap: true),
                  icon: Icon(
                    Icons.cloud_off,
                    color: Theme.of(context).primaryColor,
                    size: 45,
                  ),
                );
              } else if (_jobs.isNotEmpty) {
                return GridView.builder(
                  controller: _scrollController,
                  shrinkWrap: true,
                  //hasNext: _jobs.length < 200,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: jobViewH(context) == .20 ||
                              jobViewH(context) == .37 ||
                              jobViewH(context) == .36
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
                    return JobView(_jobs[index]);
                  },
                  // nextData: this
                  //     ._refresherController
                  //     .requestLoading,
                );
              } else {
                return GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: jobViewH(context) == .20 ||
                              jobViewH(context) == .37 ||
                              jobViewH(context) == .36
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
                        borderRadius: BorderRadius.all(Radius.circular(10)),
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
                                                  BorderRadius.circular(24),
                                              color: Colors.white,
                                            ),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(4.0),
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                          highlightColor: Colors.grey[100]!,
                                          child: Container(
                                            width: 150,
                                            height: 20.0,
                                            color: Colors.white,
                                          ),
                                        ),

                                        // Job Author / Manufacturer
                                        Shimmer.fromColors(
                                          baseColor: Colors.grey[300]!,
                                          highlightColor: Colors.grey[100]!,
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
                                          MainAxisAlignment.spaceBetween,
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        SingleChildScrollView(
                                          scrollDirection: Axis.horizontal,
                                          child: Shimmer.fromColors(
                                            baseColor: Colors.grey[300]!,
                                            highlightColor: Colors.grey[100]!,
                                            child: Container(
                                              width: 30,
                                              height: 20.0,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                        SingleChildScrollView(
                                          scrollDirection: Axis.horizontal,
                                          child: GestureDetector(
                                            onTap: () {},
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                  color: Theme.of(context)
                                                      .primaryColor),
                                              padding: const EdgeInsets.only(
                                                left: 15,
                                                top: 5,
                                                bottom: 5,
                                                right: 15,
                                              ),
                                              child: Text(
                                                StringRsr.get(
                                                    LanguageKey.CALL)!,
                                                style: const TextStyle(
                                                    color: Colors.white),
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
    );
  }

  Widget _search() {
    return Container(
      margin: AppTheme.padding,
      child: Row(
        children: <Widget>[
          Expanded(
            child: Container(
              height: 40,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: LightColor.background,
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              child: TextField(
                controller: _searchController,
                onSubmitted: (search) {
                  if (search.isNotEmpty) {
                    //search = search.toLowerCase();
                    //search = '${search[0].toUpperCase()}${search.substring(1)}';
                    _searchController.text = search;
                    localSearch = true;
                    setState(() {});
                  } else {
                    localSearch = false;
                    setState(() {});
                  }
                },
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText:
                      StringRsr.get(LanguageKey.SEARCH_JOBS, firstCap: true),
                  hintStyle: const TextStyle(fontSize: 12),
                  contentPadding:
                      EdgeInsets.only(left: 10, right: 10, bottom: 0, top: 5),
                  prefixIcon: Icon(Icons.search, color: Colors.black54),
                  suffixIcon: Visibility(
                    visible: localSearch,
                    child: GestureDetector(
                        onTap: () {
                          _searchController.text = "";
                          localSearch = false;
                          setState(() {});
                        },
                        child: Icon(Icons.close, color: Colors.black54)),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 20),
          BlocBuilder<SortBloc, SortState>(
            builder: (context, state) {
              if (state is SortInitial) {
                return GestureDetector(
                    onTap: () {
                      //debugPrint("here");
                      BlocProvider.of<SortBloc>(context)
                          .add(SortPriceType(sortUp: !state.sortUp));
                    },
                    child: _icon(Icons.filter_list, color: Colors.black54));
              } else {
                return Container();
              }
            },
          )
        ],
      ),
    );
  }

  Future<List<Job>> searchFun() async {
    searchJobs = [];
    if (_searchController.text == null || _searchController.text == "") {
      return Future.value(_jobs);
    }
    _jobs.forEach((p) {
      //debugPrint(p.name);
      if (p.title!
          .toLowerCase()
          .contains(_searchController.text.toLowerCase())) {
        searchJobs.add(p);
      }
    });
    return Future.value(searchJobs);
    // localSearch = true;
    // setState(() {});
  }

  Widget _title(String title) {
    return Container(
        margin: AppTheme.padding,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            GestureDetector(
              onTap: () {
                isCompanyInfo = true;
                setState(() {});
              },
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                height: 30,
                width: 30,
                decoration: BoxDecoration(
                    color: LightColor.background,
                    borderRadius: BorderRadius.circular(50)),
                child: Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: CompanyView.getThumbnailView(company!,
                      size: CompanyView.SIZE_MEDIUM),
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                TitleText(
                  text: title,
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                ),
              ],
            ),
            Spacer(),
            CategoryMenu(
              menu: false,
              search: false,
              notification: false,
            ),
            // Container(
            //   padding: const EdgeInsets.all(10),
            //   child: Icon(
            //     Icons.more_horiz,
            //     color: LightColor.orange,
            //   ),
            // ).ripple(() {}, borderRadius: BorderRadius.all(Radius.circular(13)))
          ],
        ));
  }

  Widget _jobWidgetSearch(List<Job> jobs) {
    return GridView.builder(
        controller: _scrollController,
        shrinkWrap: false,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: jobViewH(context) == .20 ||
                    jobViewH(context) == .37 ||
                    jobViewH(context) == .36
                ? 2
                : 1,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            childAspectRatio: jobViewH(context) == .7
                ? 7 / 4
                : jobViewH(context) == .20
                    ? 7 / 3
                    : 7 / 3),
        itemCount: jobs.length,
        itemBuilder: (BuildContext context, int index) {
          return JobView(_jobs[index]);
        });
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

      actions: <Widget>[
        GestureDetector(
          onTap: () async {
            /// todo : here
            String url =
                "https://nibjobs.page.link/?link=https://nibjobs.com/job?companyId=${company.id}&apn=com.kelem.nibjobs&isi=1588695130&ibi=com.kelem.nibjobs";
            Share.share(url);
          },
          child: Container(
            padding: const EdgeInsets.only(right: 20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              color: Colors.white,
            ),
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Icon(
                NibCustomIcons.share,
                color: Theme.of(context).primaryColor,
                size: 20,
              ),
            ),
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
          child: getAppBar2(context, company!, showCategory: true)),
      body: SafeArea(
        child: WillPopScope(
          onWillPop: () {
            if (isCompanyInfo) {
              isCompanyInfo = false;
              setState(() {});
              return Future.value(false);
            }
            return Future.value(true);
          },
          child: Stack(
            children: [
              Container(
                padding: AppTheme.padding,
                color: LightColor.lightGrey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    _search(),
                    _title(company!.name!),
                    //
                    Builder(builder: (context) {
                      if (localSearch && _jobs.isNotEmpty) {
                        //debugPrint("localSearch");
                        return FutureBuilder(
                            future: searchFun(),
                            builder:
                                (BuildContext context, AsyncSnapshot snapshot) {
                              if (snapshot.connectionState ==
                                      ConnectionState.done &&
                                  snapshot.data == null) {
                                return Center(
                                    child: Message(
                                  icon: CustomIcons.noInternet(),
                                  message: "No $subCategorie Jobs found",
                                ));
                              } else if (snapshot.hasData &&
                                  snapshot.data != null &&
                                  snapshot.connectionState ==
                                      ConnectionState.done) {
                                List<Job> newJobs = snapshot.data;

                                return Expanded(
                                    child: _jobWidgetSearch(newJobs));
                              } else {
                                return GridView.builder(
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: jobViewH(context) ==
                                                      .20 ||
                                                  jobViewH(context) == .37 ||
                                                  jobViewH(context) == .36
                                              ? 2
                                              : 1,
                                          mainAxisSpacing: 10,
                                          childAspectRatio:
                                              jobViewH(context) == .7
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
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10)),
                                        // color:
                                        // isOutLine ? Colors.transparent : Theme.of(context).backgroundColor,
                                      ),
                                      child: Card(
                                        elevation: 0,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: <Widget>[
                                            // Image thumbnail or image place holder
                                            Expanded(
                                              flex: 1,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Stack(
                                                  fit: StackFit.expand,
                                                  children: [
                                                    Shimmer.fromColors(
                                                      baseColor:
                                                          Colors.grey[300]!,
                                                      highlightColor:
                                                          Colors.grey[100]!,
                                                      child: Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          color: Colors.grey,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(24),
                                                        ),
                                                      ),
                                                    ),
                                                    Align(
                                                      alignment:
                                                          Alignment.topRight,
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                right: 10.0,
                                                                top: 5),
                                                        child: GestureDetector(
                                                          onTap: () async {},
                                                          child: Container(
                                                            decoration:
                                                                BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          24),
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(4.0),
                                                              child: Icon(
                                                                Icons.favorite,
                                                                color:
                                                                    Colors.red,
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
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 3,
                                                        horizontal: 15),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceAround,
                                                  children: <Widget>[
                                                    // Job name
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Shimmer.fromColors(
                                                          baseColor:
                                                              Colors.grey[300]!,
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
                                                          baseColor:
                                                              Colors.grey[300]!,
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
                                                      baseColor:
                                                          Colors.grey[300]!,
                                                      highlightColor:
                                                          Colors.grey[100]!,
                                                      child: Container(
                                                        width: 150,
                                                        height: 20.0,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                    Shimmer.fromColors(
                                                      baseColor:
                                                          Colors.grey[300]!,
                                                      highlightColor:
                                                          Colors.grey[100]!,
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
                                                      baseColor:
                                                          Colors.grey[300]!,
                                                      highlightColor:
                                                          Colors.grey[100]!,
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
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      children: [
                                                        SingleChildScrollView(
                                                          scrollDirection:
                                                              Axis.horizontal,
                                                          child: Shimmer
                                                              .fromColors(
                                                            baseColor: Colors
                                                                .grey[300]!,
                                                            highlightColor:
                                                                Colors
                                                                    .grey[100]!,
                                                            child: Container(
                                                              width: 30,
                                                              height: 20.0,
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                          ),
                                                        ),
                                                        SingleChildScrollView(
                                                          scrollDirection:
                                                              Axis.horizontal,
                                                          child:
                                                              GestureDetector(
                                                            onTap: () {},
                                                            child: Container(
                                                              decoration: BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              20),
                                                                  color: Theme.of(
                                                                          context)
                                                                      .primaryColor),
                                                              padding:
                                                                  const EdgeInsets
                                                                      .only(
                                                                left: 15,
                                                                top: 5,
                                                                bottom: 5,
                                                                right: 15,
                                                              ),
                                                              child: Text(
                                                                StringRsr.get(
                                                                    LanguageKey
                                                                        .CALL)!,
                                                                style: const TextStyle(
                                                                    color: Colors
                                                                        .white),
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
                            });
                      } else {
                        return Expanded(
                          child: _jobWidget(),
                        );
                      }
                    }),
                    // const SizedBox(
                    //   height: 50,
                    // )
                  ],
                ),
              ),
              Visibility(
                visible: isCompanyInfo,
                child: GestureDetector(
                  onTap: () {
                    isCompanyInfo = false;
                    setState(() {});
                  },
                  child: Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.grey.withOpacity(0.5)),
                        ),
                      ),
                      Container(
                        width: AppTheme.fullWidth(context),
                        height: 250,
                        color: Colors.white,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const SizedBox(
                                  height: 30,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      company!.name!,
                                      style: const TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                        color: CustomColor.TEXT_DARK,
                                      ),
                                    ),
                                    Visibility(
                                      visible: company!.verified!,
                                      child: const Padding(
                                        padding: EdgeInsets.only(
                                            right: 8.0, left: 2.0),
                                        child: Icon(
                                          Icons.verified_user,
                                          color: Colors.lightGreen,
                                          size: 12,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        if (company!.primaryPhone != null) {
                                          makeWebCall(
                                              "tel: ${company!.primaryPhone}");
                                        }
                                      },
                                      child: Text(
                                        company!.primaryPhone!,
                                        style: const TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.bold,
                                          color: CustomColor.GRAY,
                                        ),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        if (company!.secondaryPhone != null) {
                                          makeWebCall(
                                              "tel: ${company!.secondaryPhone}");
                                        }
                                      },
                                      child: Text(
                                        company!.secondaryPhone!,
                                        style: const TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.bold,
                                          color: CustomColor.GRAY,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 10.0),
                              child: Column(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      if (company!.website != "") {
                                        makeWebCall(
                                            "https:${company!.website}");
                                      }
                                    },
                                    child: Text(
                                      company!.website != ""
                                          ? company!.website!
                                          : StringRsr.get(
                                              LanguageKey.NO_WEBSITE,
                                              firstCap: true)!,
                                      style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: CustomColor.GRAY_LIGHT,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    company!.physicalAddress != ""
                                        ? company!.physicalAddress!
                                        : StringRsr.get(
                                            LanguageKey.NO_PHYSICAL_ADDRESS,
                                            firstCap: true)!,
                                    style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                      color: CustomColor.GRAY_LIGHT,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      Positioned(
                        bottom: 210,
                        child: Container(
                          height: 80,
                          width: 80,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(40)),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: CachedNetworkImage(
                              imageUrl: company!.logo!,
                              imageBuilder: (context, imageProvider) {
                                return Container(
                                  width: 20,
                                  decoration: BoxDecoration(
                                    color: Colors.red,
                                    borderRadius: BorderRadius.circular(40),
                                    image: DecorationImage(
                                      image: imageProvider,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                );
                              },
                              useOldImageOnUrlChange: true,
                              fit: BoxFit.cover,
                              placeholderFadeInDuration:
                                  const Duration(microseconds: 200),
                              placeholder:
                                  (BuildContext context, String imageURL) {
                                return Container();
                              },
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
      ),
    );
  }

  Future<List<Job>> getJobs() async {
    // await getBookByQuery(query: search ?? "b");

    QuerySnapshot querySnapshot = _lastDocumentSnapShot != null
        ? await FirebaseFirestore.instance
            .collection(Job.COLLECTION_NAME)
            //.where(Job.CATEGORY, isEqualTo: category.name)
            .limit(JOB_LIMIT)
            .where(Job.CATEGORY, isEqualTo: company!.category)
            .where("company.name", isEqualTo: company!.name)
            .orderBy(Job.LAST_MODIFIED, descending: true)
            .startAfterDocument(_lastDocumentSnapShot!)
            .get()
        // if there is a previous document query begins searching from the last document.
        : await FirebaseFirestore.instance
            .collection(Job.COLLECTION_NAME)
            //.where(Job.CATEGORY, isEqualTo: category.name)
            .limit(JOB_LIMIT)
            .where(Job.CATEGORY, isEqualTo: company!.category)
            .where("company.name", isEqualTo: company!.name)
            .orderBy(Job.LAST_MODIFIED, descending: true)
            .get();

    List<QueryDocumentSnapshot> documentSnapshot = querySnapshot.docs;
    //debugPrint("documentSnapshot er $documentSnapshot");
    if (documentSnapshot.isNotEmpty) {
      _lastDocumentSnapShot = documentSnapshot.last;

      _noMoreItem = false;
    } else {
      //debugPrint("data no");
      _noMoreItem = true;
    }
    List<Job> jobs = documentSnapshot.map((DocumentSnapshot documentSnapshot1) {
      //debugPrint("documentSnapshot1 ${documentSnapshot1.data()}");
      Job p = Job.toModel(documentSnapshot1.data());
      //this is only for test
      p.id = documentSnapshot1.id;
      return p;
    }).toList();

    //debugPrint("jobs ${jobs.length > 0}");
    if (!(jobs.isNotEmpty)) {
      jobs = [];
    }
    return jobs;
  }
}
