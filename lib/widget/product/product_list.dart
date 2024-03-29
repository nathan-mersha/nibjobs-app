import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:keframe/keframe.dart';
import 'package:nibjobs/api/flutterfire.dart';
import 'package:nibjobs/bloc/ads/ad_helper.dart';
import 'package:nibjobs/bloc/ads/adses_cubit.dart';
import 'package:nibjobs/bloc/notification/notification_bloc.dart';
import 'package:nibjobs/bloc/search/search_bloc.dart';
import 'package:nibjobs/bloc/sort/sort_bloc.dart';
import 'package:nibjobs/dal/notification_job_dal.dart';
import 'package:nibjobs/db/k_shared_preference.dart';
import 'package:nibjobs/global.dart' as global;
import 'package:nibjobs/model/commerce/job.dart';
import 'package:nibjobs/model/config/global.dart';
import 'package:nibjobs/model/profile/company.dart';
import 'package:nibjobs/rsr/locale/lang/language_key.dart';
import 'package:nibjobs/rsr/locale/string_rsr.dart';
import 'package:nibjobs/themes/theme.dart';
import 'package:nibjobs/widget/icon/icons.dart';
import 'package:nibjobs/widget/info/message.dart';
import 'package:nibjobs/widget/product/product_view.dart';
import 'package:nibjobs/widget/product/shop_view.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shimmer/shimmer.dart';

import 'category_view.dart';

_JobListState? jobListState;

class JobList extends StatefulWidget {
  final Category? _category;
  final String? _subCategory;
  final String? _searchData;
  final String? fromWhere;

  JobList(this._category, this._subCategory, this._searchData,
      {this.fromWhere});

  @override
  State<StatefulWidget> createState() {
    jobListState = _JobListState();
    return jobListState!;
  }
}

class _JobListState extends State<JobList> {
  double? _childAspectRatio;
  HSharedPreference hSharedPreference = GetHSPInstance
      .hSharedPreference; // total amount of data to be retrieved once.
  static const int JOB_LIMIT = 10;
  int jobUnSeen = 0;
  static const int maxFailedLoadAttempts = 3;
  List googleBooks = [];
  String? uId;
  bool fav = false;
  // true if item is being retrieved from fire store
  bool _loading = false;
  bool _noMoreItem = false;
  bool _initialJobsLoaded = false;
  DocumentSnapshot? _lastDocumentSnapShot;
  List _jobs = [];
  final ScrollController _scrollController = ScrollController();
  String? _subCategory;
  Category? _category;
  Company? companyOne;
  Company? companyTwo;
  String? search;
  List<int> money = [125, 350, 560, 300, 400, 800];

  //add the name of the book you dont want to find here !!!!!
  List<String> notFoundList = ["wolf human", "cat"];

  //!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
  final RefreshController _refresherController =
      RefreshController(initialRefresh: true);
  final RefreshController _refresherControllerSearch = RefreshController();
  bool sortUp = true;
  bool sortUpLocal = false;
  bool bookNotFound = false;
  RewardedAd? _rewardedAd;
  int _numRewardedLoadAttempts = 0;
  static const AdRequest request = AdRequest(
    keywords: <String>['foo', 'bar'],
    contentUrl: 'http://foo.com/bar.html',
    nonPersonalizedAds: true,
  );
  @override
  void initState() {
    super.initState();
    uID();
    _category = widget._category;
    _subCategory = widget._subCategory;
    search = widget._searchData;

    // _scrollController.addListener(() {
    //   // Reached at 70% of bottom
    //   num currentPosition = _scrollController.position.pixels;
    //   num maxScrollExtent = _scrollController.position.maxScrollExtent * 0.9;
    //   if (currentPosition == maxScrollExtent) {
    //     // setState(() {
    //     //   _loading = true;
    //     // });
    //
    //     // Retrieving next jobs and adding to existing list.
    //     getJobs();
    //     // setState(() {
    //     //   _loading = false;
    //     // });
    //   }
    // });

    // listening on global config.
    // global.localConfig.addListener(() {
    //   setState(() {
    //     // Category value changed from the currently displayed.
    //     // _jobs.removeRange(0, _jobs.length);
    //     _category = global.localConfig.selectedCategory;
    //     _subCategory = global.localConfig.selectedSubCategory;
    //     search = global.localConfig.selectedSearchBook;
    //   });
    // });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _createRewardedAd();
  }

  void _createRewardedAd() {
    RewardedAd.load(
        adUnitId: AdHelper.rewardedAdUnitId,
        request: const AdRequest(),
        rewardedAdLoadCallback: RewardedAdLoadCallback(
          onAdLoaded: (RewardedAd ad) {
            print('$ad loaded.');
            _rewardedAd = ad;
            _numRewardedLoadAttempts = 0;
            setState(() {});
          },
          onAdFailedToLoad: (LoadAdError error) {
            print('RewardedAd failed to load: $error');
            _rewardedAd = null;
            _numRewardedLoadAttempts += 1;
            if (_numRewardedLoadAttempts <= maxFailedLoadAttempts) {
              _createRewardedAd();
            }
          },
        ));
  }

  void dispose() {
    super.dispose();
    _scrollController.dispose();
    _rewardedAd?.dispose();
  }

  Future<void> uID() async {
    uId = await hSharedPreference.get(HSharedPreference.KEY_USER_ID);
  }

  @override
  Widget build(BuildContext context) {
    _childAspectRatio = widget._category!.name == "book" ? 0.6 : 0.8;

    return Stack(
      children: [
        Column(
          children: <Widget>[
            Builder(builder: (context) {
              if (widget.fromWhere != "Category" &&
                  widget.fromWhere != "Company") {
                return Visibility(
                  visible: widget.fromWhere != "Category" &&
                      widget.fromWhere != "Company",
                  child: Expanded(
                    child: BlocBuilder<SearchBloc, SearchViewState>(
                      builder: (context, state) {
                        if (state is SearchLoaded) {
                          if (state.searchInData.isEmpty) {
                            return Message(
                              message: StringRsr.get(LanguageKey.NO_DATA_FOUND,
                                  firstCap: true),
                              icon: Icon(
                                Icons.whatshot,
                                color: Theme.of(context).primaryColor,
                                size: 45,
                              ),
                            );
                          }

                          return SmartRefresher(
                            controller: _refresherControllerSearch,
                            enablePullUp: true,
                            onRefresh: () {
                              BlocProvider.of<SearchBloc>(context)
                                  .add(SearchViewEvent(searchInView: true));
                            },
                            onLoading: () {
                              BlocProvider.of<SearchBloc>(context)
                                  .add(SearchViewEvent(searchInView: true));
                            },
                            child: StaggeredGridView.countBuilder(
                                controller: _scrollController,
                                shrinkWrap: false,
                                crossAxisCount: jobViewH(context) == .20 ||
                                        jobViewH(context) == .37 ||
                                        jobViewH(context) == .36
                                    ? 2
                                    : 1,
                                mainAxisSpacing: 10,
                                itemCount: state.searchInData.length,
                                staggeredTileBuilder: (index) =>
                                    StaggeredTile.fit(1),
                                itemBuilder: (BuildContext context, int index) {
                                  if (state.searchInData[index] is Map) {
                                    return AspectRatio(
                                      aspectRatio: jobViewH(context) == .7
                                          ? 7 / 4
                                          : jobViewH(context) == .20
                                              ? 7 / 3
                                              : 7 / 3,
                                      child: JobView(
                                          Job.toModel(state.searchInData[index]
                                              ["document"]),
                                          rewardedAd: _rewardedAd,
                                          onADs: _createRewardedAd),
                                    );
                                  }
                                  return BlocBuilder<AdsesCubit, AdsesState>(
                                    builder: (context, state) {
                                      return SizedBox(
                                        height: 50,
                                        child: AdWidget(
                                          ad: BannerAd(
                                              size: AdSize.banner,
                                              adUnitId: state is AdsesInitial
                                                  ? state.adState.bannerAdUnitId
                                                  : "",
                                              listener: state is AdsesInitial
                                                  ? state.adState.listener
                                                  : const BannerAdListener(),
                                              request: const AdRequest())
                                            ..load(),
                                        ),
                                      );
                                    },
                                  );
                                }),
                          );
                        } else if (state is SearchLoading) {
                          return Center(
                              child: Message(
                            icon: CustomIcons.getHorizontalLoading(),
                            message: StringRsr.get(LanguageKey.WAITING_FOR_DATA,
                                firstCap: true),
                          ));
                        } else if (state is SearchError) {
                          return Message(
                            message: "No data found",
                            icon: Icon(
                              Icons.whatshot,
                              color: Theme.of(context).primaryColor,
                              size: 45,
                            ),
                          );
                        }
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
                              return BlocBuilder<AdsesCubit, AdsesState>(
                                builder: (context, state) {
                                  if (state is AdsesInitial) {
                                    return SmartRefresher(
                                      controller: _refresherController,
                                      enablePullUp: true,
                                      onRefresh: () async {
                                        _refresherController.refreshCompleted();
                                        List? newJobs = await getJobs();
                                        if (newJobs.isNotEmpty) {
                                          jobUnSeen = 0;

                                          await state.adState.initialized
                                              .then((value) async {
                                            bool bannerAdsSeen = global
                                                    .globalConfig
                                                    .featuresConfig!
                                                    .bannerAdsSeen ??
                                                false;

                                            if (bannerAdsSeen) {
                                              newJobs.insert(
                                                0,
                                                Job(title: "googleAdsKelem"),
                                              );
                                              for (var i = newJobs.length - 4;
                                                  i >= 1;
                                                  i -= 4) {
                                                newJobs.insert(
                                                  i,
                                                  Job(title: "googleAdsKelem"),
                                                );
                                              }
                                            }

                                            _jobs.addAll(newJobs);
                                            BlocProvider.of<NotificationBloc>(
                                                    context)
                                                .add(
                                                    const NotificationEventAdder(
                                                        counter: 0));
                                            await counterUpdater(_jobs);
                                          });

                                          _refresherController
                                              .refreshCompleted();
                                          _initialJobsLoaded = false;

                                          if (mounted) setState(() {});
                                        } else if (newJobs.isEmpty) {
                                          _refresherController.resetNoData();
                                          _refresherController
                                              .refreshCompleted();
                                          if (_jobs.isEmpty) {
                                            _initialJobsLoaded = true;
                                          } else {
                                            _refresherController.loadNoData();
                                          }
                                          if (mounted) setState(() {});
                                        } else {
                                          _refresherController.refreshFailed();
                                        }
                                      },
                                      onLoading: () async {
                                        List<Job>? newJobs =
                                            await getJobs() as List<Job>;
                                        if (newJobs.isNotEmpty) {
                                          _initialJobsLoaded = false;

                                          await state.adState.initialized
                                              .then((value) async {
                                            bool bannerAdsSeen = global
                                                    .globalConfig
                                                    .featuresConfig!
                                                    .bannerAdsSeen ??
                                                false;

                                            if (bannerAdsSeen) {
                                              newJobs.insert(
                                                0,
                                                Job(title: "googleAdsKelem"),
                                              );
                                              for (var i = newJobs.length - 4;
                                                  i >= 1;
                                                  i -= 4) {
                                                debugPrint(
                                                    "here must be ads 2");

                                                newJobs.insert(
                                                  i,
                                                  Job(title: "googleAdsKelem"),
                                                );
                                                debugPrint(
                                                    "here must be ads 3");
                                              }
                                            }
                                            _jobs.addAll(newJobs);
                                            BlocProvider.of<NotificationBloc>(
                                                    context)
                                                .add(
                                                    const NotificationEventAdder(
                                                        counter: 0));
                                            await counterUpdater(_jobs);
                                          });
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
                                            message: StringRsr.get(
                                                LanguageKey.NO_JOB_FOUND,
                                                firstCap: true),
                                            icon: Icon(
                                              Icons.cloud_off,
                                              color: Theme.of(context)
                                                  .primaryColor,
                                              size: 45,
                                            ),
                                          );
                                        } else if (_jobs.isNotEmpty) {
                                          return SizeCacheWidget(
                                            child:
                                                StaggeredGridView.countBuilder(
                                              controller: _scrollController,
                                              shrinkWrap: true,
                                              crossAxisCount:
                                                  jobViewH(context) == .20 ||
                                                          jobViewH(context) ==
                                                              .37 ||
                                                          jobViewH(context) ==
                                                              .36
                                                      ? 2
                                                      : 1,
                                              mainAxisSpacing: 10,

                                              staggeredTileBuilder: (index) {
                                                return const StaggeredTile.fit(
                                                    1);
                                              },
                                              itemCount: _jobs != null
                                                  ? _jobs.length
                                                  : 0,
                                              itemBuilder:
                                                  (BuildContext context,
                                                      int index) {
                                                if (_jobs[index].title !=
                                                    "googleAdsKelem") {
                                                  return FrameSeparateWidget(
                                                    index: index,
                                                    placeHolder: Card(
                                                      elevation: 0,
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(20),
                                                      ),
                                                      child: Row(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: <Widget>[
                                                          // Image thumbnail or image place holder

                                                          Expanded(
                                                            flex: 1,
                                                            child: Container(
                                                              padding: const EdgeInsets
                                                                      .symmetric(
                                                                  vertical: 10,
                                                                  horizontal:
                                                                      15),
                                                              child: Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceAround,
                                                                children: <
                                                                    Widget>[
                                                                  // Job name
                                                                  Column(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.spaceBetween,
                                                                        children: [
                                                                          Shimmer
                                                                              .fromColors(
                                                                            baseColor:
                                                                                Colors.grey[300]!,
                                                                            highlightColor:
                                                                                Colors.grey[100]!,
                                                                            child:
                                                                                Container(
                                                                              width: AppTheme.fullWidth(context) < 361 ? 140 : 240,
                                                                              height: 20.0,
                                                                              color: Colors.white,
                                                                            ),
                                                                          ),
                                                                          Shimmer
                                                                              .fromColors(
                                                                            baseColor:
                                                                                Colors.grey[300]!,
                                                                            highlightColor:
                                                                                Colors.grey[100]!,
                                                                            child:
                                                                                Container(
                                                                              width: 40,
                                                                              height: 40.0,
                                                                              decoration: BoxDecoration(
                                                                                color: Colors.white,
                                                                                borderRadius: BorderRadius.circular(40),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      const SizedBox(
                                                                        height:
                                                                            1,
                                                                      ),
                                                                      // Job Author / Manufacturer
                                                                      Shimmer
                                                                          .fromColors(
                                                                        baseColor:
                                                                            Colors.grey[300]!,
                                                                        highlightColor:
                                                                            Colors.grey[100]!,
                                                                        child:
                                                                            Container(
                                                                          width:
                                                                              200,
                                                                          height:
                                                                              15.0,
                                                                          color:
                                                                              Colors.white,
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),

                                                                  const SizedBox(
                                                                    height: 3,
                                                                  ),
                                                                  Shimmer
                                                                      .fromColors(
                                                                    baseColor:
                                                                        Colors.grey[
                                                                            300]!,
                                                                    highlightColor:
                                                                        Colors.grey[
                                                                            100]!,
                                                                    child:
                                                                        Container(
                                                                      width:
                                                                          350,
                                                                      height:
                                                                          15.0,
                                                                      color: Colors
                                                                          .white,
                                                                    ),
                                                                  ),
                                                                  Shimmer
                                                                      .fromColors(
                                                                    baseColor:
                                                                        Colors.grey[
                                                                            300]!,
                                                                    highlightColor:
                                                                        Colors.grey[
                                                                            100]!,
                                                                    child:
                                                                        Container(
                                                                      width:
                                                                          300,
                                                                      height:
                                                                          15.0,
                                                                      color: Colors
                                                                          .white,
                                                                    ),
                                                                  ),
                                                                  const SizedBox(
                                                                    height: 3,
                                                                  ),
                                                                  Shimmer
                                                                      .fromColors(
                                                                    baseColor:
                                                                        Colors.grey[
                                                                            300]!,
                                                                    highlightColor:
                                                                        Colors.grey[
                                                                            100]!,
                                                                    child:
                                                                        Container(
                                                                      width: 80,
                                                                      height:
                                                                          15.0,
                                                                      color: Colors
                                                                          .white,
                                                                    ),
                                                                  ),

                                                                  // Price and regular price
                                                                  const SizedBox(
                                                                    height: 2,
                                                                  ),

                                                                  Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceBetween,
                                                                    mainAxisSize:
                                                                        MainAxisSize
                                                                            .max,
                                                                    children: [
                                                                      SingleChildScrollView(
                                                                        scrollDirection:
                                                                            Axis.horizontal,
                                                                        child: Shimmer
                                                                            .fromColors(
                                                                          baseColor:
                                                                              Colors.grey[300]!,
                                                                          highlightColor:
                                                                              Colors.grey[100]!,
                                                                          child:
                                                                              Container(
                                                                            width:
                                                                                60,
                                                                            height:
                                                                                15.0,
                                                                            color:
                                                                                Colors.white,
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
                                                    child: AspectRatio(
                                                      aspectRatio: jobViewH(
                                                                  context) ==
                                                              .7
                                                          ? 7 / 4
                                                          : jobViewH(context) ==
                                                                  .20
                                                              ? 7 / 3
                                                              : 7 / 3,
                                                      child: JobView(
                                                          _jobs[index],
                                                          fav:
                                                              widget.fromWhere ??
                                                                  "",
                                                          rewardedAd:
                                                              _rewardedAd,
                                                          onADs:
                                                              _createRewardedAd),
                                                    ),
                                                  );
                                                }

                                                return FrameSeparateWidget(
                                                  index: index,
                                                  placeHolder: Container(),
                                                  child: SizedBox(
                                                    height: 50,
                                                    child: AdWidget(
                                                      ad: BannerAd(
                                                          size: AdSize.banner,
                                                          adUnitId: state
                                                              .adState
                                                              .bannerAdUnitId,
                                                          listener: state
                                                              .adState.listener,
                                                          request:
                                                              const AdRequest())
                                                        ..load(),
                                                    ),
                                                  ),
                                                );
                                              },
                                              // nextData: this
                                              //     ._refresherController
                                              //     .requestLoading,
                                            ),
                                          );
                                        } else {
                                          return buildGridViewLoading(context);
                                        }
                                      }),
                                    );
                                  }

                                  return SmartRefresher(
                                    controller: _refresherController,
                                    enablePullUp: true,
                                    onRefresh: () async {
                                      _refresherController.refreshCompleted();
                                      List<Job>? newJobs =
                                          await getJobs() as List<Job>;
                                      if (newJobs.isNotEmpty) {
                                        _jobs.addAll(newJobs);
                                        //       _jobs = sortFun(_jobs);
                                        _refresherController.refreshCompleted();
                                        _initialJobsLoaded = false;
                                        if (mounted) setState(() {});
                                      } else if (newJobs.isEmpty) {
                                        _refresherController.resetNoData();
                                        _refresherController.refreshCompleted();
                                        if (_jobs.isEmpty) {
                                          _initialJobsLoaded = true;
                                        } else {
                                          _refresherController.loadNoData();
                                        }
                                        if (mounted) setState(() {});
                                      } else {
                                        _refresherController.refreshFailed();
                                      }
                                    },
                                    onLoading: () async {
                                      List? newJobs = await getJobs();
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
                                          message: StringRsr.get(
                                              LanguageKey.NO_JOB_FOUND,
                                              firstCap: true),
                                          icon: Icon(
                                            Icons.cloud_off,
                                            color:
                                                Theme.of(context).primaryColor,
                                            size: 45,
                                          ),
                                        );
                                      } else if (_jobs.isNotEmpty) {
                                        return SizeCacheWidget(
                                          child: GridView.builder(
                                            cacheExtent: 500,
                                            controller: _scrollController,
                                            shrinkWrap: true,
                                            //hasNext: _jobs.length < 200,
                                            gridDelegate:
                                                SliverGridDelegateWithFixedCrossAxisCount(
                                                    crossAxisCount: jobViewH(
                                                                    context) ==
                                                                .20 ||
                                                            jobViewH(context) ==
                                                                .37 ||
                                                            jobViewH(context) ==
                                                                .36
                                                        ? 2
                                                        : 1,
                                                    mainAxisSpacing: 10,
                                                    childAspectRatio: jobViewH(
                                                                context) ==
                                                            .7
                                                        ? 7 / 4
                                                        : jobViewH(context) ==
                                                                .20
                                                            ? 7 / 3
                                                            : 7 / 3),
                                            itemCount: _jobs != null
                                                ? _jobs.length
                                                : 0,
                                            itemBuilder: (BuildContext context,
                                                int index) {
                                              return FrameSeparateWidget(
                                                index: index,
                                                placeHolder: Card(
                                                  elevation: 0,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                  ),
                                                  child: Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: <Widget>[
                                                      // Image thumbnail or image place holder

                                                      Expanded(
                                                        flex: 1,
                                                        child: Container(
                                                          padding:
                                                              const EdgeInsets
                                                                      .symmetric(
                                                                  vertical: 10,
                                                                  horizontal:
                                                                      15),
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
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
                                                                  Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceBetween,
                                                                    children: [
                                                                      Shimmer
                                                                          .fromColors(
                                                                        baseColor:
                                                                            Colors.grey[300]!,
                                                                        highlightColor:
                                                                            Colors.grey[100]!,
                                                                        child:
                                                                            Container(
                                                                          width: AppTheme.fullWidth(context) < 361
                                                                              ? 140
                                                                              : 240,
                                                                          height:
                                                                              20.0,
                                                                          color:
                                                                              Colors.white,
                                                                        ),
                                                                      ),
                                                                      Shimmer
                                                                          .fromColors(
                                                                        baseColor:
                                                                            Colors.grey[300]!,
                                                                        highlightColor:
                                                                            Colors.grey[100]!,
                                                                        child:
                                                                            Container(
                                                                          width:
                                                                              40,
                                                                          height:
                                                                              40.0,
                                                                          decoration:
                                                                              BoxDecoration(
                                                                            color:
                                                                                Colors.white,
                                                                            borderRadius:
                                                                                BorderRadius.circular(40),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  const SizedBox(
                                                                    height: 1,
                                                                  ),
                                                                  // Job Author / Manufacturer
                                                                  Shimmer
                                                                      .fromColors(
                                                                    baseColor:
                                                                        Colors.grey[
                                                                            300]!,
                                                                    highlightColor:
                                                                        Colors.grey[
                                                                            100]!,
                                                                    child:
                                                                        Container(
                                                                      width:
                                                                          200,
                                                                      height:
                                                                          15.0,
                                                                      color: Colors
                                                                          .white,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),

                                                              const SizedBox(
                                                                height: 3,
                                                              ),
                                                              Shimmer
                                                                  .fromColors(
                                                                baseColor:
                                                                    Colors.grey[
                                                                        300]!,
                                                                highlightColor:
                                                                    Colors.grey[
                                                                        100]!,
                                                                child:
                                                                    Container(
                                                                  width: 350,
                                                                  height: 15.0,
                                                                  color: Colors
                                                                      .white,
                                                                ),
                                                              ),
                                                              Shimmer
                                                                  .fromColors(
                                                                baseColor:
                                                                    Colors.grey[
                                                                        300]!,
                                                                highlightColor:
                                                                    Colors.grey[
                                                                        100]!,
                                                                child:
                                                                    Container(
                                                                  width: 300,
                                                                  height: 15.0,
                                                                  color: Colors
                                                                      .white,
                                                                ),
                                                              ),
                                                              const SizedBox(
                                                                height: 3,
                                                              ),
                                                              Shimmer
                                                                  .fromColors(
                                                                baseColor:
                                                                    Colors.grey[
                                                                        300]!,
                                                                highlightColor:
                                                                    Colors.grey[
                                                                        100]!,
                                                                child:
                                                                    Container(
                                                                  width: 80,
                                                                  height: 15.0,
                                                                  color: Colors
                                                                      .white,
                                                                ),
                                                              ),

                                                              // Price and regular price
                                                              const SizedBox(
                                                                height: 2,
                                                              ),

                                                              Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .max,
                                                                children: [
                                                                  SingleChildScrollView(
                                                                    scrollDirection:
                                                                        Axis.horizontal,
                                                                    child: Shimmer
                                                                        .fromColors(
                                                                      baseColor:
                                                                          Colors
                                                                              .grey[300]!,
                                                                      highlightColor:
                                                                          Colors
                                                                              .grey[100]!,
                                                                      child:
                                                                          Container(
                                                                        width:
                                                                            60,
                                                                        height:
                                                                            15.0,
                                                                        color: Colors
                                                                            .white,
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
                                                child: JobView(_jobs[index],
                                                    fav: widget.fromWhere!,
                                                    rewardedAd: _rewardedAd,
                                                    onADs: _createRewardedAd),
                                              );
                                            },
                                            // nextData: this
                                            //     ._refresherController
                                            //     .requestLoading,
                                          ),
                                        );
                                      } else {
                                        return buildGridViewLoading(context);
                                      }
                                    }),
                                  );
                                },
                              );
                            } else {
                              return Container();
                            }
                          },
                        );
                      },
                    ),
                  ),
                );
              } else if (widget.fromWhere == "Category") {
                return Visibility(
                  visible: widget.fromWhere == "Category",
                  child: Expanded(
                    child: FutureBuilder(
                      future: getCategory(),
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        if (snapshot.connectionState == ConnectionState.done &&
                            snapshot.data == null) {
                          // Connection terminated and no data available

                          return Center(
                              child: Message(
                            icon: CustomIcons.noInternet(),
                            message: StringRsr.get(LanguageKey.NO_INTERNET,
                                firstCap: true),
                          ));
                        } else if (snapshot.hasData &&
                            snapshot.connectionState == ConnectionState.done) {
                          // Got data and connection is done

                          List<Category> newCategories = snapshot.data;
                          //       newCategories.removeAt(0);

                          // Got data here
                          return newCategories.isEmpty
                              ? Message(
                                  message:
                                      "${StringRsr.get(LanguageKey.NO, firstCap: true)} ${_category!.name}s ${StringRsr.get(LanguageKey.FOUND)}",
                                  icon: Icon(
                                    Icons.whatshot,
                                    color: Theme.of(context).primaryColor,
                                    size: 45,
                                  ),
                                )
                              : GridView.builder(
                                  controller: _scrollController,
                                  shrinkWrap: false,
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: jobViewH(context) ==
                                                      .20 ||
                                                  jobViewH(context) == .37 ||
                                                  jobViewH(context) == .36 ||
                                                  jobViewH(context) == .35
                                              ? 3
                                              : AppTheme.fullWidth(context) <
                                                      361
                                                  ? 1
                                                  : 2,
                                          mainAxisSpacing: 10,
                                          childAspectRatio: jobViewH(context) ==
                                                  .7
                                              ? AppTheme.fullWidth(context) <
                                                      361
                                                  ? 7 / 4
                                                  : 7 / 7
                                              : jobViewH(context) == .20
                                                  ? 7 / 4
                                                  : 7 / 5),
                                  itemCount: newCategories.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return CategoryView(newCategories[index]);
                                  });
                        } else {
                          return buildGridViewLoading(context);
                        }
                      },
                    ),
                  ),
                );
              } else if (widget.fromWhere == "Company") {
                return Visibility(
                  visible: widget.fromWhere == "Company",
                  child: Expanded(
                    child: BlocBuilder<SearchBloc, SearchViewState>(
                      builder: (context, state) {
                        if (state is SearchLoaded) {
                          if (state.searchInData.isEmpty) {
                            return Message(
                              message: "No data found",
                              icon: Icon(
                                Icons.whatshot,
                                color: Theme.of(context).primaryColor,
                                size: 45,
                              ),
                            );
                          }
                          return SmartRefresher(
                            controller: _refresherControllerSearch,
                            enablePullUp: true,
                            onRefresh: () {
                              BlocProvider.of<SearchBloc>(context)
                                  .add(SearchViewEvent(searchInView: true));
                            },
                            onLoading: () {
                              BlocProvider.of<SearchBloc>(context)
                                  .add(SearchViewEvent(searchInView: true));
                            },
                            child: GridView.builder(
                                controller: _scrollController,
                                shrinkWrap: true,
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount:
                                            jobViewH(context) == .20 ||
                                                    jobViewH(context) == .37 ||
                                                    jobViewH(context) == .36
                                                ? 3
                                                : 2,
                                        mainAxisSpacing: 10,
                                        childAspectRatio:
                                            jobViewH(context) == .7
                                                ? 7 / 7
                                                : jobViewH(context) == .20
                                                    ? 7 / 4
                                                    : 7 / 5),
                                itemCount: state.searchInData.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return CompanyView(
                                      Company.toModel(state.searchInData[index]
                                          ["document"]),
                                      _subCategory!);
                                }),
                          );
                        } else if (state is SearchError) {
                          return Message(
                            message: "No data found",
                            icon: Icon(
                              Icons.whatshot,
                              color: Theme.of(context).primaryColor,
                              size: 45,
                            ),
                          );
                        } else if (state is SearchLoading) {
                          return buildGridViewLoading(context);
                        }

                        return FutureBuilder(
                          future: getJobs(),
                          builder:
                              (BuildContext context, AsyncSnapshot snapshot) {
                            if (snapshot.connectionState ==
                                    ConnectionState.done &&
                                snapshot.data == null) {
                              // Connection terminated and no data available

                              return Center(
                                  child: Message(
                                icon: CustomIcons.noInternet(),
                                message: StringRsr.get(LanguageKey.NO_INTERNET,
                                    firstCap: true),
                              ));
                            } else if (snapshot.hasData &&
                                snapshot.connectionState ==
                                    ConnectionState.done) {
                              // Got data and connection is done

                              List<Company> newJobs = snapshot.data;
                              if (newJobs.isNotEmpty) {
                                //  _jobs.addAll(newJobs);
                                _initialJobsLoaded = true;
                              }

                              // Got data here
                              return newJobs.isEmpty
                                  ? Message(
                                      message:
                                          "${StringRsr.get(LanguageKey.NO, firstCap: true)} ${_category!.name}s ${StringRsr.get(LanguageKey.FOUND)}",
                                      icon: Icon(
                                        Icons.whatshot,
                                        color: Theme.of(context).primaryColor,
                                        size: 45,
                                      ),
                                    )
                                  : GridView.builder(
                                      controller: _scrollController,
                                      shrinkWrap: false,
                                      gridDelegate:
                                          SliverGridDelegateWithFixedCrossAxisCount(
                                              crossAxisCount:
                                                  jobViewH(context) == .20 ||
                                                          jobViewH(context) ==
                                                              .37 ||
                                                          jobViewH(context) ==
                                                              .36
                                                      ? 3
                                                      : 2,
                                              mainAxisSpacing: 10,
                                              childAspectRatio:
                                                  jobViewH(context) == .7
                                                      ? 7 / 7
                                                      : jobViewH(context) == .20
                                                          ? 7 / 4
                                                          : 7 / 5),
                                      itemCount: newJobs.length,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return CompanyView(
                                            newJobs[index], _subCategory!);
                                      });
                            } else {
                              return buildGridViewLoading(context);
                            }
                          },
                        );
                      },
                    ),
                  ),
                );
              } else {
                return Container();
              }
            }),
            _loading && !_noMoreItem
                ? SpinKitThreeBounce(
                    color: Theme.of(context).primaryColor,
                    size: 20,
                  )
                : Container(),
            Visibility(
              visible: widget.fromWhere != "nu",
              child: const SizedBox(
                height: 50,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Future<void> counterUpdater(List _jobs) async {
    String dateFile = await hSharedPreference.get(
          HSharedPreference.KEY_USER_LAST_SEEN,
        ) ??
        "";
    for (int i = 0; i < _jobs.length; i++) {
      if (_jobs[i].title != "googleAdsKelem") {
        if (dateFile == "") {
          jobUnSeen += 1;
          BlocProvider.of<NotificationBloc>(context)
              .add(NotificationEventAdder(counter: jobUnSeen));
        } else {
          DateTime dateLast = DateTime.parse(dateFile);
          if (dateLast.isBefore(_jobs[i].lastModified!)) {
            jobUnSeen += 1;
            BlocProvider.of<NotificationBloc>(context)
                .add(NotificationEventAdder(counter: jobUnSeen));
          }
        }
      }
    }
  }

  Future<List<Category>> getCategory() async {
    List<Category> newCategories = global.localConfig.categories;
    if (newCategories[0].name == "all") {
      newCategories.removeAt(0);
    }

    return Future.value(newCategories);
  }

  Future<List> getJobs() async {
    // await getBookByQuery(query: search ?? "b");
    if (_subCategory == null) {
      DefaultTabController.of(context)!.index = 0;
      _subCategory = "all";
    }
    if (widget.fromWhere == null || widget.fromWhere == "") {
      fav = false;
      jobUnSeen = 0;
      QuerySnapshot querySnapshot;
      debugPrint("_subCategory $_subCategory");
      if (_subCategory == "all") {
        List<String> categoryList = await hSharedPreference
                .get(HSharedPreference.LIST_OF_FAV_CATEGORY) ??
            [];
        if (categoryList.isNotEmpty) {
          debugPrint("categoryList $categoryList");
          querySnapshot = _lastDocumentSnapShot != null
              ? await FirebaseFirestore.instance
                  .collection(Job.COLLECTION_NAME)
                  .where(Job.APPROVED, isEqualTo: true)
                  .where(Job.TAGS,
                      arrayContainsAny: categoryList.sublist(0,
                          categoryList.length > 10 ? 10 : categoryList.length))
                  .limit(JOB_LIMIT)
                  .orderBy(Job.LAST_MODIFIED, descending: true)
                  .orderBy("company.rank", descending: true)
                  .startAfterDocument(_lastDocumentSnapShot!)
                  .get()
              // if there is a previous document query begins searching from the last document.
              : await FirebaseFirestore.instance
                  .collection(Job.COLLECTION_NAME)
                  .where(Job.APPROVED, isEqualTo: true)
                  .where(Job.TAGS,
                      arrayContainsAny: categoryList.sublist(0,
                          categoryList.length > 10 ? 10 : categoryList.length))
                  .limit(JOB_LIMIT)
                  .orderBy("company.rank", descending: true)
                  .orderBy(Job.LAST_MODIFIED, descending: true)
                  .get();
        } else {
          querySnapshot = _lastDocumentSnapShot != null
              ? await FirebaseFirestore.instance
                  .collection(Job.COLLECTION_NAME)
                  .where(Job.APPROVED, isEqualTo: true)
                  .limit(JOB_LIMIT)
                  .orderBy(Job.LAST_MODIFIED, descending: true)
                  .orderBy("company.rank", descending: true)
                  .startAfterDocument(_lastDocumentSnapShot!)
                  .get()
              // if there is a previous document query begins searching from the last document.
              : await FirebaseFirestore.instance
                  .collection(Job.COLLECTION_NAME)
                  .where(Job.APPROVED, isEqualTo: true)
                  .limit(JOB_LIMIT)
                  .orderBy("company.rank", descending: true)
                  .orderBy(Job.LAST_MODIFIED, descending: true)
                  .get();
        }
      } else {
        querySnapshot = _lastDocumentSnapShot != null
            ? await FirebaseFirestore.instance
                .collection(Job.COLLECTION_NAME)
                .where(Job.CATEGORY, isEqualTo: _subCategory)
                .limit(JOB_LIMIT)
                .orderBy("company.rank", descending: true)
                .where(Job.APPROVED, isEqualTo: true)
                .orderBy(Job.LAST_MODIFIED, descending: true)
                .startAfterDocument(_lastDocumentSnapShot!)
                .get()
            // if there is a previous document query begins searching from the last document.
            : await FirebaseFirestore.instance
                .collection(Job.COLLECTION_NAME)
                .where(Job.CATEGORY, isEqualTo: _subCategory)
                .limit(JOB_LIMIT)
                .orderBy("company.rank", descending: true)
                .where(Job.APPROVED, isEqualTo: true)
                .orderBy(Job.LAST_MODIFIED, descending: true)
                .get();
      }

      List<QueryDocumentSnapshot> documentSnapshot = querySnapshot.docs;
      // Assigning the last document snapshot for future query
      if (documentSnapshot.isNotEmpty) {
        _lastDocumentSnapShot = documentSnapshot.last;

        _noMoreItem = false;
      } else {
        _noMoreItem = true;
      }
      int i = 0;
      List jobs = documentSnapshot.map((DocumentSnapshot documentSnapshot1) {
        Job p = Job.toModel(documentSnapshot1.data());
        //this is only for test

        p.id = documentSnapshot1.id;
        return p;
      }).toList();
      // _jobs.addAll(jobs);
      jobs = sortFun(jobs);

      return jobs;
    } else if (widget.fromWhere == "nu") {
      fav = false;

      QuerySnapshot querySnapshot;
      if (_subCategory == "all") {
        querySnapshot = _lastDocumentSnapShot != null
            ? await FirebaseFirestore.instance
                .collection(Job.COLLECTION_NAME)
                .limit(JOB_LIMIT)
                .orderBy(Job.LAST_MODIFIED, descending: true)
                .orderBy("company.rank", descending: true)
                .where(Job.APPROVED, isEqualTo: true)
                .startAfterDocument(_lastDocumentSnapShot!)
                .get()
            // if there is a previous document query begins searching from the last document.
            : await FirebaseFirestore.instance
                .collection(Job.COLLECTION_NAME)
                .limit(JOB_LIMIT)
                .orderBy(Job.LAST_MODIFIED, descending: true)
                .orderBy("company.rank", descending: true)
                .where(Job.APPROVED, isEqualTo: true)
                .get();
      } else {
        querySnapshot = _lastDocumentSnapShot != null
            ? await FirebaseFirestore.instance
                .collection(Job.COLLECTION_NAME)
                .where(Job.CATEGORY, isEqualTo: widget._category!.name)
                //.where(Job.SUB_CATEGORY, isEqualTo: _subCategory)
                .limit(JOB_LIMIT)
                .orderBy("company.rank", descending: true)
                .where(Job.APPROVED, isEqualTo: true)
                .orderBy(Job.LAST_MODIFIED, descending: true)
                .startAfterDocument(_lastDocumentSnapShot!)
                .get()
            // if there is a previous document query begins searching from the last document.
            : await FirebaseFirestore.instance
                .collection(Job.COLLECTION_NAME)
                .where(Job.CATEGORY, isEqualTo: widget._category!.name)
                //.where(Job.SUB_CATEGORY, isEqualTo: _subCategory)
                .orderBy("company.rank", descending: true)
                .where(Job.APPROVED, isEqualTo: true)
                .limit(JOB_LIMIT)
                .orderBy(Job.LAST_MODIFIED, descending: true)
                .get();
      }

      List<QueryDocumentSnapshot> documentSnapshot = querySnapshot.docs;

      // Assigning the last document snapshot for future query
      if (documentSnapshot.isNotEmpty) {
        _lastDocumentSnapShot = documentSnapshot.last;

        _noMoreItem = false;
      } else {
        _noMoreItem = true;
      }
      int i = 0;
      List jobs = documentSnapshot.map((DocumentSnapshot documentSnapshot1) {
        Job p = Job.toModel(documentSnapshot1.data());
        //this is only for test

        p.id = documentSnapshot1.id;
        return p;
      }).toList();
      jobs = sortFun(jobs);
      return jobs;
    } else if (widget.fromWhere == "Fav") {
      QuerySnapshot querySnapshot;
      fav = true;
      if (uId != null || uId != "") {
        if (_subCategory == "all") {
          querySnapshot = _lastDocumentSnapShot != null
              ? await FirebaseFirestore.instance
                  .collection("favoriteJob")
                  //.where(Job.CATEGORY, isEqualTo: _subCategory)
                  .doc(uId)
                  .collection("job")
                  .limit(JOB_LIMIT)
                  .orderBy(Job.LAST_MODIFIED, descending: true)
                  .startAfterDocument(_lastDocumentSnapShot!)
                  .get()
              // if there is a previous document query begins searching from the last document.
              : await FirebaseFirestore.instance
                  .collection("favoriteJob")
                  //.where(Job.CATEGORY, isEqualTo: _subCategory)
                  .doc(uId)
                  .collection("job")
                  .limit(JOB_LIMIT)
                  .orderBy(Job.LAST_MODIFIED, descending: true)
                  .get();
        } else {
          querySnapshot = _lastDocumentSnapShot != null
              ? await FirebaseFirestore.instance
                  .collection("favoriteJob")
                  .doc(uId)
                  .collection("job")
                  .where(Job.CATEGORY, isEqualTo: widget._category!.name)
                  .limit(JOB_LIMIT)
                  .orderBy(Job.LAST_MODIFIED, descending: true)
                  .startAfterDocument(_lastDocumentSnapShot!)
                  .get()
              // if there is a previous document query begins searching from the last document.
              : await FirebaseFirestore.instance
                  .collection("favoriteJob")
                  .doc(uId)
                  .collection("job")
                  //.where(Job.CATEGORY, isEqualTo: _subCategory)
                  .where(Job.CATEGORY, isEqualTo: widget._category!.name)
                  .limit(JOB_LIMIT)
                  .orderBy(Job.LAST_MODIFIED, descending: true)
                  .get();
        }

        List<QueryDocumentSnapshot> documentSnapshot = querySnapshot.docs;

        // Assigning the last document snapshot for future query
        if (documentSnapshot.isNotEmpty) {
          _lastDocumentSnapShot = documentSnapshot.last;

          _noMoreItem = false;
        } else {
          _noMoreItem = true;
        }
        int i = 0;
        List jobs = documentSnapshot.map((DocumentSnapshot documentSnapshot1) {
          Job p = Job.toModel(documentSnapshot1.data());
          //this is only for test

          p.id = documentSnapshot1.id;
          return p;
        }).toList();
        jobs = sortFun(jobs);
        return jobs;
      }

      return [];
    } //
    else if (widget.fromWhere == "notification") {
      print("job notification");
      List<Job> listJob;
      fav = true;
      if (uId != null || uId != "") {
        if (_subCategory == "all") {
          listJob = await NotificationJobDAL.find();
        } else {
          listJob = await NotificationJobDAL.find();
        }

        //listJob = sortFun(listJob);
        return listJob;
      }

      return [];
    } else if (widget.fromWhere == "Company") {
      fav = false;

      QuerySnapshot querySnapshot;
      if (widget._category!.name == "all") {
        querySnapshot = _lastDocumentSnapShot != null
            ? await FirebaseFirestore.instance
                .collection("company")
                .where(Company.VERIFIED, isEqualTo: true)
                //.where(Company.TOTAL_APPROVED_JOBS, isNotEqualTo: "0")
                //.orderBy(Company.TOTAL_JOBS, descending: true)
                //.startAfterDocument(_lastDocumentSnapShot)
                .get()
            // if there is a previous document query begins searching from the last document.
            : await FirebaseFirestore.instance
                .collection("company")
                .where(Company.VERIFIED, isEqualTo: true)
                //.where(Company.TOTAL_APPROVED_JOBS, isNotEqualTo: "0")
                // .orderBy(Company.TOTAL_JOBS, descending: true)
                //.where(Job.CATEGORY, isEqualTo: _subCategory)
                .get();
      } else {
        querySnapshot = _lastDocumentSnapShot != null
            ? await FirebaseFirestore.instance
                .collection("company")
                .where(Company.VERIFIED, isEqualTo: true)
                .where(Company.CATEGORY, isEqualTo: widget._category!.name)
                //.startAfterDocument(_lastDocumentSnapShot)
                // .orderBy(Company.TOTAL_JOBS, descending: true)
                .get()
            // if there is a previous document query begins searching from the last document.
            : await FirebaseFirestore.instance
                .collection("company")
                .where(Company.VERIFIED, isEqualTo: true)
                .where(Company.CATEGORY, isEqualTo: widget._category!.name)
                //.orderBy(Company.TOTAL_JOBS, descending: true)
                //.where(Job.CATEGORY, isEqualTo: _subCategory)
                .get();
      }

      List<QueryDocumentSnapshot> documentSnapshot = querySnapshot.docs;

      // Assigning the last document snapshot for future query
      if (documentSnapshot.length > 0) {
        _lastDocumentSnapShot = documentSnapshot.last;
        _noMoreItem = false;
      } else {
        _noMoreItem = true;
      }
      int i = 0;
      List<Company> jobs =
          documentSnapshot.map((DocumentSnapshot documentSnapshot1) {
        Company p =
            Company.toModel(documentSnapshot1.data() as Map<String, dynamic>);
        //this is only for test

        p.id = documentSnapshot1.id;
        return p;
      }).toList();
      return jobs;
    } else {
      return [];
    }
  }

  List sortFun(List list) {
    // if (sortUp) {
    //   list.sort((a, b) => a.price.compareTo(b.price));
    // } else {
    //   list.sort((a, b) => b.price.compareTo(a.price));
    // }
    return list;
    // localSearch = true;
    // setState(() {});
  }
}
