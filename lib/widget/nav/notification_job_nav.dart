import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nibjobs/bloc/search/search_bloc.dart';
import 'package:nibjobs/global.dart' as global;
import 'package:nibjobs/model/config/global.dart';
import 'package:nibjobs/rsr/locale/lang/language_key.dart';
import 'package:nibjobs/rsr/locale/string_rsr.dart';
import 'package:nibjobs/rsr/theme/color.dart';
import 'package:nibjobs/themes/light_color.dart';
import 'package:nibjobs/themes/theme.dart';
import 'package:nibjobs/widget/icon/icons.dart';
import 'package:nibjobs/widget/info/message.dart';
import 'package:nibjobs/widget/nav/search.dart';
import 'package:nibjobs/widget/product/product_list.dart';

class NotificationJobNav extends StatefulWidget {
  final String? fromWhere;
  NotificationJobNav({this.fromWhere});
  @override
  State<StatefulWidget> createState() {
    return _NotificationJobNavState();
  }
}

class _NotificationJobNavState extends State<NotificationJobNav> {
  Category? category;
  List<Category>? categories;
  List<Category>? subCategories;
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
    category = global.localConfig.selectedCategory;
    amCategories = global.localConfig.amCategory;

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
        // if (mounted) {
        //   setState(() {
        //     amCategories = global.localConfig.amCategory;
        //     categories = global.localConfig.categories;
        //     category1 = global.localConfig.selectedCategory;
        //     subCategories = global.localConfig.selectedCategory.tags;
        //   });
        // }
      });
    }
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
      backgroundColor: LightColor.lightGrey,

      leading: IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        color: CustomColor.GRAY_DARK,
        icon: const Icon(Icons.arrow_back_outlined),
      ),
      title: Text(
        StringRsr.locale != "et_am" ? job : amCategories!["am"][job],
        style: const TextStyle(color: CustomColor.GRAY_DARK),
      ),
      actions: <Widget>[],
      //showCategory ? CategoryMenu() : Container()
      //backgroundColor: LightColor.lightGrey,
      elevation: 0,
    );
  }

  @override
  Widget build(BuildContext context) {
    Category category1 = global.localConfig.selectedCategory;
    subCategories = global.localConfig.categories;

    return Scaffold(
        appBar: PreferredSize(
            preferredSize: const Size.fromHeight(50),
            child: getAppBar2(context, "job notification")),
        body: subCategories == null
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
                                      tabs: subCategories!.map((category) {
                                        //  var index = categories.indexOf(category);
                                        return Tab(
                                          child: Text(
                                            category.name!,
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
                                        fromWhere: "notification",
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
