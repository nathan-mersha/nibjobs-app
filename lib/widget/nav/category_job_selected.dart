import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nibjobs/bloc/search/search_bloc.dart';
import 'package:nibjobs/global.dart' as global;
import 'package:nibjobs/model/config/global.dart';
import 'package:nibjobs/rsr/locale/lang/language_key.dart';
import 'package:nibjobs/rsr/locale/string_rsr.dart';
import 'package:nibjobs/themes/theme.dart';
import 'package:nibjobs/widget/icon/icons.dart';
import 'package:nibjobs/widget/info/message.dart';
import 'package:nibjobs/widget/nav/search.dart';
import 'package:nibjobs/widget/product/product_list.dart';

class CategorySelectedJobNavigation extends StatefulWidget {
  final String? fromWhere;
  CategorySelectedJobNavigation({this.fromWhere});
  @override
  State<StatefulWidget> createState() {
    return _CategorySelectedJobNavigationState();
  }
}

class _CategorySelectedJobNavigationState
    extends State<CategorySelectedJobNavigation> {
  Category? category;
  List<Category>? categories;
  List<dynamic>? subCategories;
  List googleBooks = [];
  String searchBooks = "a";
  bool seter = false;
  Map<String, dynamic>? amCategories;
  static const String _ad1 = "assets/images/covid19_prevention/ad1.png";
  static const String _ad2 = "assets/images/covid19_prevention/ad2.png";
  List imageList = [
    _ad1,
    _ad2,
  ];
  @override
  void initState() {
    super.initState();
    amCategories = global.localConfig.amCategory;

    // Will be called when there is a change in the local config.
  }

  @override
  void dispose() {
    super.dispose();
    // if (widget.fromWhere == null) {
    //   global.localConfig.dispose();
    // }
  }

  Widget getAppBar2(BuildContext context, String job,
      {bool showCategory = false}) {
    return AppBar(
      //backgroundColor: LightColor.lightGrey,
      backgroundColor: Theme.of(context).backgroundColor,

      leading: IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        color: Theme.of(context).iconTheme.color,
        icon: const Icon(Icons.arrow_back_outlined),
      ),
      title: Text(
        StringRsr.locale != "et_am" ? job : amCategories!["am"][job] ?? job,
        style: Theme.of(context).textTheme.subtitle1,
      ),
      actions: <Widget>[],
      //showCategory ? CategoryMenu() : Container()
      //backgroundColor: LightColor.lightGrey,
      elevation: 0,
    );
  }

  @override
  Widget build(BuildContext context) {
    Category category1 = ModalRoute.of(context)!.settings.arguments as Category;
    subCategories = category1.tags;

    return Scaffold(
        appBar: PreferredSize(
            preferredSize: const Size.fromHeight(50),
            child: getAppBar2(context, category1.name!)),
        body: subCategories == null
            ? Center(
                child: Message(
                icon: CustomIcons.getHorizontalLoading(),
                message:
                    StringRsr.get(LanguageKey.WAITING_FOR_DATA, firstCap: true),
              ))
            : Container(
                color: Theme.of(context).backgroundColor,
                //color: LightColor.lightGrey,
                child: Column(
                  children: <Widget>[
                    SearchView(
                      onComplete: (String search) {
                        // global.localConfig.selectedSearchBook = search;
                        BlocProvider.of<SearchBloc>(context).add(SearchJobEvent(
                            document: "job",
                            searchData: search,
                            fields: "name"));
                        // getBookByQuery(search);
                      },
                    ),
                    Expanded(
                      child: Padding(
                        padding: AppTheme.padding,
                        child: DefaultTabController(
                          length: subCategories!.length,
                          child: Scaffold(
                            backgroundColor: Theme.of(context).backgroundColor,
                            //  backgroundColor: LightColor.lightGrey,
                            body: SafeArea(
                              child: Column(
                                children: [
                                  TabBar(
                                      //controller: _tabController,
                                      isScrollable: true,
                                      indicatorColor:
                                          Theme.of(context).primaryColor,
                                      unselectedLabelColor: Theme.of(context)
                                          .unselectedWidgetColor,
                                      indicatorSize: TabBarIndicatorSize.tab,
                                      labelStyle:
                                          Theme.of(context).textTheme.bodyText1,
                                      indicator: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          color:
                                              Theme.of(context).primaryColor),
                                      tabs: subCategories!.map((category) {
                                        //  var index = categories.indexOf(category);
                                        return Tab(
                                          child: Text(
                                            category,
                                          ),
                                        );
                                      }).toList()),
                                  Expanded(
                                    child: TabBarView(
                                        children:
                                            subCategories!.map((category) {
                                      return JobList(
                                        category1,
                                        category.toString(),
                                        searchBooks,
                                        fromWhere: "nu",
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
              ));
  }
}
