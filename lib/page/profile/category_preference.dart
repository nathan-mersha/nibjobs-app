import 'package:flutter/material.dart';
import 'package:nibjobs/api/flutterfire.dart';
import 'package:nibjobs/db/k_shared_preference.dart';
import 'package:nibjobs/global.dart' as global;
import 'package:nibjobs/model/config/global.dart';
import 'package:nibjobs/route/route.dart';
import 'package:nibjobs/rsr/locale/lang/language_key.dart';
import 'package:nibjobs/rsr/locale/string_rsr.dart';
import 'package:nibjobs/rsr/theme/color.dart';
import 'package:nibjobs/themes/light_color.dart';
import 'package:nibjobs/themes/theme.dart';
import 'package:nibjobs/widget/info/message.dart';
import 'package:nibjobs/widget/product/category_view_small.dart';
import 'package:shimmer/shimmer.dart';

class CategoryPreferencePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _CategoryPreferencePageState();
  }
}

class _CategoryPreferencePageState extends State<CategoryPreferencePage> {
  // LocalPreference aSP = GetLocalPreferenceInstance.localPreference;
  HSharedPreference hSharedPreference = GetHSPInstance.hSharedPreference;
  Future<List<Category>> getCategory() async {
    return Future.value(global.localConfig.categories);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(
            Icons.arrow_back_ios,
            color: CustomColor.GRAY,
            size: 20,
          ),
        ),
        title: Text(
          "Notify me for jobs",
          style: Theme.of(context).textTheme.subtitle1,
        ),
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: Container(
        width: double.infinity,
        color: LightColor.lightGrey,
        child: SizedBox(
          width: AppTheme.fullWidth(context),
          child: SizedBox.expand(
            child: Container(
              color: LightColor.lightGrey,
              child: Container(
                child: Card(
                    color: LightColor.lightGrey,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0)),
                    elevation: 0.3,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          horizontal:
                              AppTheme.fullWidth(context) < 361 ? 30 : 40),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 28.0, bottom: 20),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    StringRsr.get(
                                        LanguageKey.CATEGORY_PREFERENCES,
                                        firstCap: true)!,
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline5!
                                        .copyWith(
                                            color: CustomColor.TEXT_DARK,
                                            fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  // BlocBuilder<CategoryBloc, CategoryState>(
                                  //   builder: (context, state) {
                                  //     if (state is CategoryInitial) {
                                  //       debugPrint(
                                  //           "state ${state.categoryNumber}");
                                  //       return Text(
                                  //         StringRsr.get(LanguageKey
                                  //                 .SELECT_UP_TO_5_CATEGORIES)!
                                  //             .replaceAll(
                                  //                 "5",
                                  //                 state.categoryNumber
                                  //                     .toString()),
                                  //         style: Theme.of(context)
                                  //             .textTheme
                                  //             .subtitle2!
                                  //             .copyWith(
                                  //                 color: CustomColor.GRAY_LIGHT,
                                  //                 fontWeight: FontWeight.bold),
                                  //       );
                                  //     }
                                  //     return Container();
                                  //   },
                                  // ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: FutureBuilder(
                                future: getCategory(),
                                builder: (BuildContext context,
                                    AsyncSnapshot snapshot) {
                                  if (snapshot.hasData &&
                                      snapshot.connectionState ==
                                          ConnectionState.done) {
                                    // Got data and connection is done
                                    Category? allCategory;
                                    List<Category> newCategories =
                                        snapshot.data;
                                    for (var element in newCategories) {
                                      if (element.name == "all") {
                                        allCategory = element;
                                      }
                                    }
                                    if (allCategory != null) {
                                      newCategories.remove(allCategory);
                                    }

                                    // Got data here
                                    return newCategories.isEmpty
                                        ? Message(
                                            message:
                                                "${StringRsr.get(LanguageKey.NO, firstCap: true)} ${StringRsr.get(LanguageKey.FOUND)}",
                                            icon: Icon(
                                              Icons.whatshot,
                                              color: Theme.of(context)
                                                  .primaryColor,
                                              size: 45,
                                            ),
                                          )
                                        : GridView.builder(
                                            // controller:
                                            // _scrollController,
                                            shrinkWrap: false,
                                            gridDelegate:
                                                SliverGridDelegateWithFixedCrossAxisCount(
                                                    crossAxisCount:
                                                        jobViewH(context) != .70
                                                            ? 1
                                                            : 1,
                                                    mainAxisSpacing: 5,
                                                    childAspectRatio: jobViewH(
                                                                context) ==
                                                            .7
                                                        ? 7 / 3
                                                        : jobViewH(context) ==
                                                                .20
                                                            ? 7 / 3
                                                            : 7 / 3),
                                            itemCount: newCategories.length,
                                            itemBuilder: (BuildContext context,
                                                int index) {
                                              return buildCategoryViewSmall(
                                                  newCategories, index);
                                            });
                                  } else {
                                    return buildGridViewLoading(context);
                                  }
                                },
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Center(
                              child: GestureDetector(
                                onTap: () async {
                                  hSharedPreference.set(
                                      HSharedPreference.SELECT_PREFERENCE,
                                      true);
                                  String uid = await hSharedPreference
                                          .get(HSharedPreference.KEY_USER_ID) ??
                                      "";
                                  if (uid != "") {
                                    List<String> list = await hSharedPreference
                                            .get(HSharedPreference
                                                .LIST_OF_FAV_CATEGORY) ??
                                        [];
                                    if (list.isNotEmpty) {
                                      final result =
                                          await updateUser(uid, list);
                                      if (result) {
                                        debugPrint("data good");
                                      } else {
                                        debugPrint("data error ");
                                      }
                                    }
                                  }
                                  Navigator.pushReplacementNamed(
                                      context, RouteTo.HOME);
                                  // // setState(() {
                                  //   showInfo = false;
                                  // });
                                },
                                child: Container(
                                  width: 200,
                                  height: 40,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: Theme.of(context).primaryColor),
                                  padding: const EdgeInsets.only(
                                    left: 15,
                                    top: 5,
                                    bottom: 10,
                                    right: 15,
                                  ),
                                  child: Center(
                                    child: Text(
                                      StringRsr.get(LanguageKey.CONTINUE)!,
                                      style:
                                          const TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                          ]),
                    )),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildCategoryViewSmall(List<Category> newCategories, int i) {
    //return CategoryViewSmall(newCategories[index]);
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      elevation: 0,
      color: LightColor.lightGrey,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                newCategories[i].name!,
                style: Theme.of(context).textTheme.subtitle1,
              ),
            ),
            Expanded(
              child: ListView(
                primary: true,
                shrinkWrap: false,
                children: [
                  Wrap(
                    alignment: WrapAlignment.start,
                    runSpacing: 4,
                    spacing: 3,
                    children: newCategories[i]
                        .tags!
                        .map((e) => CategoryViewSmall(e))
                        .toSet()
                        .toList(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  GridView buildGridViewLoading(BuildContext context) {
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
                  : 7 / 4),
      itemBuilder: (_, __) => Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(
                color: LightColor.iconColor, style: BorderStyle.none),
            borderRadius: const BorderRadius.all(Radius.circular(10)),
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
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        // Job name
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Shimmer.fromColors(
                                  baseColor: Colors.grey[300]!,
                                  highlightColor: Colors.grey[100]!,
                                  child: Container(
                                    width: 240,
                                    height: 20.0,
                                    color: Colors.white,
                                  ),
                                ),
                                Shimmer.fromColors(
                                  baseColor: Colors.grey[300]!,
                                  highlightColor: Colors.grey[100]!,
                                  child: Container(
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
                              height: 1,
                            ),
                            // Job Author / Manufacturer
                            Shimmer.fromColors(
                              baseColor: Colors.grey[300]!,
                              highlightColor: Colors.grey[100]!,
                              child: Container(
                                width: 200,
                                height: 15.0,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(
                          height: 3,
                        ),
                        Shimmer.fromColors(
                          baseColor: Colors.grey[300]!,
                          highlightColor: Colors.grey[100]!,
                          child: Container(
                            width: 350,
                            height: 15.0,
                            color: Colors.white,
                          ),
                        ),
                        Shimmer.fromColors(
                          baseColor: Colors.grey[300]!,
                          highlightColor: Colors.grey[100]!,
                          child: Container(
                            width: 300,
                            height: 15.0,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(
                          height: 3,
                        ),
                        Shimmer.fromColors(
                          baseColor: Colors.grey[300]!,
                          highlightColor: Colors.grey[100]!,
                          child: Container(
                            width: 80,
                            height: 15.0,
                            color: Colors.white,
                          ),
                        ),

                        // Price and regular price
                        const SizedBox(
                          height: 2,
                        ),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Shimmer.fromColors(
                                baseColor: Colors.grey[300]!,
                                highlightColor: Colors.grey[100]!,
                                child: Container(
                                  width: 60,
                                  height: 15.0,
                                  color: Colors.white,
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
}
