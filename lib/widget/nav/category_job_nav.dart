import 'package:flutter/material.dart';
import 'package:nibjobs/global.dart' as global;
import 'package:nibjobs/model/config/global.dart';
import 'package:nibjobs/rsr/locale/lang/language_key.dart';
import 'package:nibjobs/rsr/locale/string_rsr.dart';
import 'package:nibjobs/themes/light_color.dart';
import 'package:nibjobs/themes/theme.dart';
import 'package:nibjobs/widget/icon/icons.dart';
import 'package:nibjobs/widget/info/message.dart';
import 'package:nibjobs/widget/product/product_list.dart';

class CategoryJobNavigation extends StatefulWidget {
  final String? fromWhere;
  CategoryJobNavigation({this.fromWhere});
  @override
  State<StatefulWidget> createState() {
    return _CategoryJobNavigationState();
  }
}

class _CategoryJobNavigationState extends State<CategoryJobNavigation> {
  Category? category;
  List<Category>? categories;
  List<dynamic>? subCategories;
  List googleBooks = [];
  String searchBooks = "a";
  bool seter = false;

  @override
  void initState() {
    super.initState();
    // Will be called when there is a change in the local config.
    global.localConfig.addListener(() {
      // set state for sub categories.
      setState(() {
        categories = global.localConfig.categories;
        category = global.localConfig.selectedCategory;
        subCategories = global.localConfig.selectedCategory.subCategories;
      });
    });
  }
// else {
//   categories = global.localConfig.categories;
//   category = global.localConfig.selectedCategory;
//   subCategories = global.localConfig.selectedCategory.subCategories;
//
// }

  @override
  void dispose() {
    super.dispose();
    //if (widget.fromWhere == null) {
    //global.localConfig.dispose();
    //}
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
            color: LightColor.lightGrey,
            child: Column(
              children: <Widget>[
                Expanded(
                  child: Padding(
                    padding: AppTheme.padding,
                    child: DefaultTabController(
                      length: categories!.length,
                      child: Scaffold(
                        backgroundColor: LightColor.lightGrey,
                        body: SafeArea(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                StringRsr.get(LanguageKey.CATEGORY,
                                    firstCap: true)!,
                                style: const TextStyle(
                                    color: LightColor.black, fontSize: 20),
                              ),
                              Text(
                                StringRsr.get(LanguageKey.LIST_OF_CATEGORIES,
                                    firstCap: true)!,
                                style: const TextStyle(
                                    color: LightColor.darkgrey, fontSize: 20),
                              ),
                              const SizedBox(
                                height: 30,
                              ),
                              Expanded(
                                child: JobList(
                                  category!,
                                  category!.name.toString(),
                                  searchBooks,
                                  fromWhere: widget.fromWhere!,
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
}