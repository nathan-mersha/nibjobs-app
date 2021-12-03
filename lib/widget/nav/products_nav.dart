import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nibjobs/bloc/nav/nav_bloc.dart';
import 'package:nibjobs/bloc/search/search_bloc.dart';
import 'package:nibjobs/global.dart' as global;
import 'package:nibjobs/model/ad_model.dart';
import 'package:nibjobs/model/config/global.dart';
import 'package:nibjobs/rsr/locale/lang/language_key.dart';
import 'package:nibjobs/rsr/locale/string_rsr.dart';
import 'package:nibjobs/rsr/theme/color.dart';
import 'package:nibjobs/themes/light_color.dart';
import 'package:nibjobs/widget/icon/icons.dart';
import 'package:nibjobs/widget/info/message.dart';
import 'package:nibjobs/widget/nav/search.dart';
import 'package:nibjobs/widget/product/product_list.dart';

class JobNavigation extends StatefulWidget {
  final String? fromWhere;
  JobNavigation({this.fromWhere});
  @override
  State<StatefulWidget> createState() {
    return _JobNavigationState();
  }
}

class _JobNavigationState extends State<JobNavigation> {
  Category? category;
  List<Category>? categories;
  Map<String, dynamic>? amCategories;
  List<dynamic>? subCategories;
  List googleBooks = [];
  List<Ad> adList = [];
  String searchBooks = "a";
  bool seter = false;
  static const String _ad1 = "assets/images/covid19_prevention/ad1.png";
  static const String _ad2 = "assets/images/covid19_prevention/ad2.png";
  List imageList = [
    _ad1,
    _ad2,
  ];
  @override
  void initState() {
    super.initState();
    // Will be called when there is a change in the local config.

    if (widget.fromWhere == null) {
      global.localConfig.addListener(() {
        // set state for sub categories.
        // setState(() {
        //   adList = global.globalConfig.ad!;
        //   amCategories = global.localConfig.amCategory;
        //   categories = global.localConfig.categories;
        //   category = global.localConfig.selectedCategory;
        //   subCategories = global.localConfig.selectedCategory.tags;
        // });
        if (mounted) {
          BlocProvider.of<NavBloc>(context).add(NavStatusEvent(
            adList: global.globalConfig.ad ?? [],
            amCategories: global.localConfig.amCategory,
            categories: global.localConfig.categories,
            category: global.localConfig.selectedCategory,
            subCategories: global.localConfig.selectedCategory.tags ?? [],
          ));
        }
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    if (widget.fromWhere == null) {
      global.localConfig.removeListener(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NavBloc, NavState>(
      builder: (context, state) {
        if (state is NavInitial) {
          return Center(
              child: Message(
            icon: CustomIcons.getHorizontalLoading(),
            message:
                StringRsr.get(LanguageKey.WAITING_FOR_DATA, firstCap: true),
          ));
        } else if (state is NavLoaded) {
          adList = state.adList;
          amCategories = state.amCategories;
          categories = state.categories;
          category = state.category;
          subCategories = state.adList;
          return subCategories == null
              ? Center(
                  child: Message(
                  icon: CustomIcons.getHorizontalLoading(),
                  message: StringRsr.get(LanguageKey.WAITING_FOR_DATA,
                      firstCap: true),
                ))
              : Container(
                  color: LightColor.lightGrey,
                  child: Column(
                    children: <Widget>[
                      SearchView(
                        onComplete: (String search) {
                          //global.localConfig.selectedSearchBook = search;
                          BlocProvider.of<SearchBloc>(context).add(
                              SearchJobEvent(
                                  document: "job",
                                  searchData: search,
                                  fields: "name"));
                          // getBookByQuery(search);
                        },
                      ),
                      // buildAdsContainer(context, imageList, adList),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 8),
                          child: DefaultTabController(
                            length: categories!.length,
                            child: Scaffold(
                              backgroundColor: LightColor.lightGrey,
                              body: SafeArea(
                                child: Column(
                                  children: [
                                    TabBar(
                                        //controller: _tabController,
                                        isScrollable: true,
                                        indicatorColor:
                                            Theme.of(context).primaryColor,
                                        unselectedLabelColor: CustomColor.GRAY,
                                        indicatorSize: TabBarIndicatorSize.tab,
                                        labelColor: CustomColor.TEXT_COLOR_GRAY,
                                        indicator: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            color:
                                                Theme.of(context).primaryColor),
                                        tabs: categories!
                                            .map((Category category) {
                                          //  var index = categories.indexOf(category);
                                          return Tab(
                                            child: Text(
                                              category.name.toString() == "all"
                                                  ? StringRsr.get(
                                                      LanguageKey.LATEST)!
                                                  : StringRsr.locale != "et_am"
                                                      ? category.name.toString()
                                                      : category.name
                                                          .toString(),
                                              // : amCategories!["am"][category.name.toString()],
                                            ),
                                          );
                                        }).toList()),
                                    Expanded(
                                      child: Container(
                                        // margin: EdgeInsets.only(top: 3),
                                        child: TabBarView(
                                            children: categories!
                                                .map((Category category) {
                                          return JobList(
                                            category,
                                            category.name.toString(),
                                            searchBooks,
                                            fromWhere: widget.fromWhere,
                                          );
                                        }).toList()),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                );
        }
        return subCategories == null
            ? Center(
                child: Message(
                icon: CustomIcons.getHorizontalLoading(),
                message:
                    StringRsr.get(LanguageKey.WAITING_FOR_DATA, firstCap: true),
              ))
            : Container(
                color: LightColor.lightGrey,
                child: Column(
                  children: <Widget>[
                    SearchView(
                      onComplete: (String search) {
                        //global.localConfig.selectedSearchBook = search;
                        BlocProvider.of<SearchBloc>(context).add(SearchJobEvent(
                            document: "job",
                            searchData: search,
                            fields: "name"));
                        // getBookByQuery(search);
                      },
                    ),
                    // buildAdsContainer(context, imageList, adList),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 8),
                        child: DefaultTabController(
                          length: categories!.length,
                          child: Scaffold(
                            backgroundColor: LightColor.lightGrey,
                            body: SafeArea(
                              child: Column(
                                children: [
                                  TabBar(
                                      //controller: _tabController,
                                      isScrollable: true,
                                      indicatorColor:
                                          Theme.of(context).primaryColor,
                                      unselectedLabelColor: CustomColor.GRAY,
                                      indicatorSize: TabBarIndicatorSize.tab,
                                      labelColor: Colors.white,
                                      indicator: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          color:
                                              Theme.of(context).primaryColor),
                                      tabs:
                                          categories!.map((Category category) {
                                        //  var index = categories.indexOf(category);
                                        return Tab(
                                          child: Text(
                                            category.name.toString() == "all"
                                                ? StringRsr.get(
                                                    LanguageKey.LATEST)
                                                : StringRsr.locale != "et_am"
                                                    ? category.name.toString()
                                                    : amCategories!["am"][
                                                        category.name
                                                            .toString()],
                                          ),
                                        );
                                      }).toList()),
                                  Expanded(
                                    child: Container(
                                      // margin: EdgeInsets.only(top: 3),
                                      child: TabBarView(
                                          children: categories!
                                              .map((Category category) {
                                        return JobList(
                                          category,
                                          category.name.toString(),
                                          searchBooks,
                                          fromWhere: widget.fromWhere,
                                        );
                                      }).toList()),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              );
      },
    );
  }
}
