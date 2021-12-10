import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:nibjobs/api/flutterfire.dart';
import 'package:nibjobs/db/k_shared_preference.dart';
import 'package:nibjobs/global.dart' as global;
import 'package:nibjobs/model/config/global.dart';
import 'package:nibjobs/route/route.dart';
import 'package:nibjobs/rsr/locale/lang/language_key.dart';
import 'package:nibjobs/rsr/locale/string_rsr.dart';
import 'package:nibjobs/themes/light_color.dart';
import 'package:nibjobs/themes/theme.dart';
import 'package:nibjobs/widget/product/category_view_small.dart';
import 'package:shimmer/shimmer.dart';

class ThemePreferencePage extends StatefulWidget {
  const ThemePreferencePage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _ThemePreferencePageState();
  }
}

class _ThemePreferencePageState extends State<ThemePreferencePage> {
  // LocalPreference aSP = GetLocalPreferenceInstance.localPreference;
  HSharedPreference hSharedPreference = GetHSPInstance.hSharedPreference;
  Future<List<Category>> getCategory() async {
    List<String> list =
        await hSharedPreference.get(HSharedPreference.LIST_OF_CATEGORY_ORDER) ??
            [];
    List<Category> categories = global.localConfig.categories;
    List<Category> categoriesSorted = [];

    for (var e in categories) {
      if (list.contains(e.name)) {
        categoriesSorted.insert(0, e);
      } else {
        categoriesSorted.add(e);
      }
    }

    return Future.value(categoriesSorted);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () async {
            Navigator.of(context).pop();
          },
          icon: Icon(
            Icons.arrow_back_ios,
            color: Theme.of(context).iconTheme.color,
            size: 20,
          ),
        ),
        elevation: 0,
        backgroundColor: Theme.of(context).backgroundColor,
      ),
      body: Container(
        width: double.infinity,
        color: Theme.of(context).backgroundColor,
        child: SizedBox(
          width: AppTheme.fullWidth(context),
          child: SizedBox.expand(
            child: Container(
              color: Theme.of(context).backgroundColor,
              child: Card(
                  color: Theme.of(context).backgroundColor,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0)),
                  elevation: 0.3,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                        horizontal:
                            AppTheme.fullWidth(context) < 361 ? 10 : 15),
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
                                  StringRsr.get(LanguageKey.PICK_A_THEME,
                                      firstCap: true)!,
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline6!
                                      .copyWith(fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  StringRsr.get(
                                      LanguageKey
                                          .YOU_CAN_ALWAYS_CHANGE_IT_IN_SETTINGS,
                                      firstCap: true)!,
                                  style: Theme.of(context)
                                      .textTheme
                                      .subtitle2!
                                      .copyWith(fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                  children: [
                                    Container(
                                      height: 400,
                                      child: Image.asset(
                                          "assets/images/light.png"),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        children: [
                                          // Radio(value: value, groupValue: groupValue, onChanged: onChanged)
                                          Icon(
                                            Icons.account_circle,
                                            color: Theme.of(context)
                                                .iconTheme
                                                .color,
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            "Light theme",
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyText1,
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Column(
                                  children: [
                                    Container(
                                      height: 400,
                                      child:
                                          Image.asset("assets/images/dark.png"),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.account_circle,
                                            color: Theme.of(context)
                                                .iconTheme
                                                .color,
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            "Dark theme",
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyText1,
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Center(
                            child: SizedBox(
                              width: 200,
                              height: 40,
                              child: ElevatedButton(
                                onPressed: () async {
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
                                      Navigator.pushReplacementNamed(
                                          context, RouteTo.HOME);
                                    } else {
                                      showInfoToUser(
                                        context,
                                        DialogType.ERROR,
                                        StringRsr.get(LanguageKey.ERROR,
                                            firstCap: true),
                                        StringRsr.get(
                                            LanguageKey
                                                .PLEASE_CHOOSE_A_CATEGORY,
                                            firstCap: true),
                                        onOk: () {},
                                      );
                                    }
                                  }

                                  // // setState(() {
                                  //   showInfo = false;
                                  // });
                                },
                                child: Center(
                                  child: Text(
                                    StringRsr.get(LanguageKey.CONTINUE)!,
                                    style: TextStyle(
                                        color: Theme.of(context).primaryColor),
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
    );
  }

  Widget buildCategoryViewSmall(List<Category> newCategories, int i) {
    //return CategoryViewSmall(newCategories[index]);
    return ListForCategory(
      category: newCategories[i],
      viewJob: i == 0,
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
