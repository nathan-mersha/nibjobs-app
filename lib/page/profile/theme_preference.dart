import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nibjobs/bloc/theme/theme_bloc.dart';
import 'package:nibjobs/consetance/enums.dart';
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
  int? val;
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
  initState() {
    super.initState();
    themeSet();
  }

  Future<void> themeSet() async {
    String theme =
        await hSharedPreference.get(HSharedPreference.THEME_MODE) ?? "";
    if (theme == "") {
      val = 1;
    } else {
      val = theme == "AppData.Light" ? 1 : 2;
    }
    print("theme $theme");
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () async {
            await hSharedPreference.set(HSharedPreference.THEME_MODE,
                val == 1 ? AppData.Light : AppData.Dark);

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
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Column(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        if (val != 1) {
                                          BlocProvider.of<ThemeBloc>(context)
                                              .add(ThemeChange(
                                                  appData: AppData.Light));
                                          setState(() {
                                            val = 1;
                                          });
                                        }
                                      },
                                      child: SizedBox(
                                        width: AppTheme.fullWidth(context) * .3,
                                        height:
                                            AppTheme.fullHeight(context) * .5,
                                        child: Image.asset(
                                            "assets/images/light.png"),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        children: [
                                          Radio(
                                              value: 1,
                                              groupValue: val,
                                              onChanged: (value) {
                                                BlocProvider.of<ThemeBloc>(
                                                        context)
                                                    .add(ThemeChange(
                                                        appData:
                                                            AppData.Light));
                                                setState(() {
                                                  val = value as int;
                                                });
                                              }),
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
                                    GestureDetector(
                                      onTap: () {
                                        if (val != 2) {
                                          BlocProvider.of<ThemeBloc>(context)
                                              .add(ThemeChange(
                                                  appData: AppData.Dark));
                                          setState(() {
                                            val = 2;
                                          });
                                        }
                                      },
                                      child: SizedBox(
                                        width: AppTheme.fullWidth(context) * .3,
                                        height:
                                            AppTheme.fullHeight(context) * .5,
                                        child: Image.asset(
                                            "assets/images/dark.png"),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        children: [
                                          Radio(
                                              value: 2,
                                              groupValue: val,
                                              onChanged: (value) {
                                                BlocProvider.of<ThemeBloc>(
                                                        context)
                                                    .add(ThemeChange(
                                                        appData: AppData.Dark));
                                                setState(() {
                                                  val = value as int;
                                                });
                                              }),
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
                                  await hSharedPreference.set(
                                      HSharedPreference.THEME_MODE,
                                      val == 1 ? AppData.Light : AppData.Dark);
                                  Navigator.pushReplacementNamed(
                                      context, RouteTo.HOME);
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
