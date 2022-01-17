import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nibjobs/bloc/search/search_bloc.dart';
import 'package:nibjobs/global.dart' as global;
import 'package:nibjobs/model/ad_model.dart';
import 'package:nibjobs/model/config/global.dart';
import 'package:nibjobs/rsr/locale/lang/language_key.dart';
import 'package:nibjobs/rsr/locale/string_rsr.dart';
import 'package:nibjobs/themes/theme.dart';
import 'package:nibjobs/widget/icon/icons.dart';
import 'package:nibjobs/widget/info/message.dart';
import 'package:nibjobs/widget/nav/search.dart';
import 'package:nibjobs/widget/product/product_list.dart';

class CompanyJobNavigation extends StatefulWidget {
  final String? fromWhere;
  CompanyJobNavigation({this.fromWhere});
  @override
  State<StatefulWidget> createState() {
    return _CompanyJobNavigationState();
  }
}

class _CompanyJobNavigationState extends State<CompanyJobNavigation> {
  Category? category;
  List<Category>? categories;
  List<dynamic>? subCategories;
  List googleBooks = [];
  Map<String, dynamic>? amCategories;

  String searchBooks = "a";
  bool seter = false;
  List<Ad> adList = [];

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
    // amCategories = global.localConfig.amCategory;
    // categories = global.localConfig.categories;
    // category = global.localConfig.selectedCategory;
    // subCategories = global.localConfig.selectedCategory.tags;

    global.localConfig.addListener(() {
      // set state for sub categories.
      if (mounted) {
        setState(() {
          adList = global.globalConfig.ad!;
          amCategories = global.localConfig.amCategory;
          categories = global.localConfig.categories;
          category = global.localConfig.selectedCategory;
          subCategories = global.localConfig.selectedCategory.tags;
        });
      }
    });
  }
// else {
//   categories = global.localConfig.categories;
//   category = global.localConfig.selectedCategory;
//   subCategories = global.localConfig.selectedCategory.tags;
//
// }

  @override
  void dispose() {
    super.dispose();
    if (widget.fromWhere == null) {
      global.localConfig.removeListener(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return subCategories == null
        ? Center(
            child: Message(
            icon: CustomIcons.getHorizontalLoading(),
            message:
                StringRsr.get(LanguageKey.WAITING_FOR_DATA, firstCap: true),
          ))
        : Container(
            color: Theme.of(context).backgroundColor,
            child: Column(
              children: <Widget>[
                SearchView(
                  query: "company",
                  onComplete: (String search) {
                    // global.localConfig.selectedSearchBook = search;
                    BlocProvider.of<SearchBloc>(context).add(SearchJobEvent(
                        document: "company",
                        searchData: search,
                        fields: "name"));

                    // getBookByQuery(search);
                  },
                ),
                // buildAdsContainer(context, imageList, adList),
                Expanded(
                  child: Padding(
                    padding: AppTheme.padding,
                    child: DefaultTabController(
                      length: categories!.length,
                      child: Scaffold(
                        backgroundColor: Theme.of(context).backgroundColor,
                        body: SafeArea(
                          child: Column(
                            children: [
                              TabBar(
                                  isScrollable: true,
                                  indicatorColor:
                                      Theme.of(context).primaryColor,
                                  unselectedLabelColor:
                                      Theme.of(context).unselectedWidgetColor,
                                  indicatorSize: TabBarIndicatorSize.tab,
                                  //labelColor: CustomColor.TEXT_COLOR_GRAY,
                                  labelStyle:
                                      Theme.of(context).textTheme.bodyText1,
                                  indicator: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: Theme.of(context).primaryColor),
                                  tabs: categories!.map((Category category) {
                                    return Tab(
                                      child: Text(
                                        category.name.toString() == "all"
                                            ? StringRsr.get(LanguageKey.ALL)
                                            : StringRsr.locale != "et_am"
                                                ? category.name.toString()
                                                : amCategories!["am"][category
                                                        .name
                                                        .toString()] ??
                                                    category.name.toString(),
                                      ),
                                    );
                                  }).toList()),
                              Expanded(
                                child: TabBarView(
                                    children:
                                        categories!.map((Category category) {
                                  return JobList(
                                    category,
                                    category.name.toString(),
                                    searchBooks,
                                    fromWhere: widget.fromWhere!,
                                  );
                                }).toList()),
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
}
