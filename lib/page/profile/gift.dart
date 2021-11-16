import 'package:flutter/material.dart';
import 'package:nibjobs/db/k_shared_preference.dart';
import 'package:nibjobs/global.dart' as global;
import 'package:nibjobs/model/config/global.dart';
import 'package:nibjobs/route/route.dart';
import 'package:nibjobs/rsr/locale/lang/language_key.dart';
import 'package:nibjobs/rsr/locale/string_rsr.dart';
import 'package:nibjobs/rsr/theme/color.dart';
import 'package:nibjobs/themes/nib_custom_icons_icons.dart';
import 'package:nibjobs/themes/theme.dart';

class GiftPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _GiftPageState();
  }
}

class _GiftPageState extends State<GiftPage> {
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
          icon: const Icon(NibCustomIcons.home, color: Colors.black54),
          onPressed: () {
            hSharedPreference.set(HSharedPreference.SHOW_INFO, false);
            Navigator.of(context).pushNamed(RouteTo.HOME);
          },
        ),
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: Container(
        width: double.infinity,
        color: Colors.white,
        child: Container(
          width: AppTheme.fullWidth(context),
          child: SizedBox.expand(
            child: Container(
              child: Container(
                child: Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0)),
                    elevation: 0.3,
                    child: Container(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Builder(builder: (context) {
                              if (global
                                      .globalConfig.featuresConfig!.claimGift ==
                                  null) {
                                return Expanded(
                                    child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              NibCustomIcons.favorite,
                                              size: jobViewH(context) == .7
                                                  ? 40
                                                  : 50,
                                              color: Theme.of(context)
                                                  .primaryColor,
                                            ),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            Icon(
                                              NibCustomIcons.companies,
                                              size: jobViewH(context) == .7
                                                  ? 40
                                                  : 50,
                                              color: Colors.deepOrange,
                                            ),
                                          ],
                                        ),
                                        Icon(
                                          NibCustomIcons.category,
                                          size:
                                              jobViewH(context) == .7 ? 40 : 50,
                                          color: Colors.deepPurple,
                                        ),
                                      ],
                                    ),
                                    Column(
                                      children: [
                                        Text(
                                          StringRsr.get(
                                              LanguageKey.JOIN_OUR_COMMUNITY)!,
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline6!
                                              .copyWith(
                                                  color: CustomColor.TEXT_DARK,
                                                  fontWeight: FontWeight.bold),
                                          textAlign: TextAlign.center,
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                          StringRsr.get(LanguageKey
                                              .CREATE_SHOP_ADD_TO_FAVORITES_AND_SELL_YOUR_JOBS)!,
                                          style: Theme.of(context)
                                              .textTheme
                                              .subtitle2!
                                              .copyWith(
                                                  color: CustomColor.GRAY_LIGHT,
                                                  fontWeight: FontWeight.bold),
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    ),
                                    Column(
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            hSharedPreference.set(
                                                HSharedPreference.SHOW_INFO,
                                                false);
                                            Navigator.pushReplacementNamed(
                                                context,
                                                RouteTo.PROFILE_SIGN_IN);
                                          },
                                          child: Container(
                                            width: 200,
                                            height: 40,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                color: Theme.of(context)
                                                    .primaryColor),
                                            padding: const EdgeInsets.only(
                                              left: 15,
                                              top: 5,
                                              bottom: 10,
                                              right: 15,
                                            ),
                                            child: Center(
                                              child: Text(
                                                StringRsr.get(LanguageKey
                                                    .YES_I_WILL_SIGNUP)!,
                                                style: const TextStyle(
                                                    color: Colors.white),
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            // setState(() {
                                            //   showInfo = false;
                                            // });
                                            hSharedPreference.set(
                                                HSharedPreference.SHOW_INFO,
                                                false);

                                            Navigator.pushReplacementNamed(
                                                context,
                                                RouteTo.CATEGORY_PREFERENCE);
                                          },
                                          child: Text(
                                            StringRsr.get(LanguageKey
                                                .I_WILL_DO_IT_LATTER)!,
                                            style: const TextStyle(
                                                color: CustomColor.GRAY_LIGHT),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ));
                              }
                              if (!global
                                  .globalConfig.featuresConfig!.claimGift!) {
                                return Expanded(
                                    child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              NibCustomIcons.favorite,
                                              size: jobViewH(context) == .7
                                                  ? 60
                                                  : 70,
                                              color: Theme.of(context)
                                                  .primaryColor,
                                            ),
                                            const SizedBox(
                                              width: 20,
                                            ),
                                            Icon(
                                              NibCustomIcons.companies,
                                              size: jobViewH(context) == .7
                                                  ? 60
                                                  : 70,
                                              color: Colors.red,
                                            ),
                                          ],
                                        ),
                                        Icon(
                                          NibCustomIcons.category,
                                          size:
                                              jobViewH(context) == .7 ? 60 : 70,
                                          color: Colors.deepPurple,
                                        ),
                                      ],
                                    ),
                                    Column(
                                      children: [
                                        Text(
                                          StringRsr.get(
                                              LanguageKey.JOIN_OUR_COMMUNITY)!,
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline5!
                                              .copyWith(
                                                  color: CustomColor.TEXT_DARK,
                                                  fontWeight: FontWeight.bold),
                                          textAlign: TextAlign.center,
                                        ),
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        Text(
                                          StringRsr.get(LanguageKey
                                              .CREATE_SHOP_ADD_TO_FAVORITES_AND_SELL_YOUR_JOBS)!,
                                          style: Theme.of(context)
                                              .textTheme
                                              .subtitle2!
                                              .copyWith(
                                                  color: CustomColor.GRAY_LIGHT,
                                                  fontWeight: FontWeight.bold),
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    ),
                                    Column(
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            hSharedPreference.set(
                                                HSharedPreference.SHOW_INFO,
                                                false);
                                            Navigator.pushReplacementNamed(
                                                context,
                                                RouteTo.PROFILE_SIGN_IN);
                                          },
                                          child: Container(
                                            width: 200,
                                            height: 40,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                color: Theme.of(context)
                                                    .primaryColor),
                                            padding: const EdgeInsets.only(
                                              left: 15,
                                              top: 5,
                                              bottom: 10,
                                              right: 15,
                                            ),
                                            child: Center(
                                              child: Text(
                                                StringRsr.get(LanguageKey
                                                    .YES_I_WILL_SIGNUP)!,
                                                style: const TextStyle(
                                                    color: Colors.white),
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            hSharedPreference.set(
                                                HSharedPreference.SHOW_INFO,
                                                false);
                                            Navigator.pushReplacementNamed(
                                                context,
                                                RouteTo.CATEGORY_PREFERENCE);

                                            //
                                            // setState(() {
                                            //   showInfo = false;
                                            // });
                                          },
                                          child: Text(
                                            StringRsr.get(LanguageKey
                                                .I_WILL_DO_IT_LATTER)!,
                                            style: const TextStyle(
                                                color: CustomColor.GRAY_LIGHT),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ));
                              }
                              return Expanded(
                                  child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Icon(
                                    Icons.card_giftcard,
                                    size: jobViewH(context) == .7 ? 160 : 100,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                  Column(
                                    children: [
                                      Text(
                                        StringRsr.get(LanguageKey
                                            .CLAIM_YOUR_AIRTIME_GIFT)!,
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline5!
                                            .copyWith(
                                              color: CustomColor.GRAY_DARK,
                                              fontWeight: FontWeight.bold,
                                            ),
                                        textAlign: TextAlign.center,
                                      ),
                                      const SizedBox(height: 20),
                                      Text(
                                        StringRsr.get(
                                            LanguageKey
                                                .SIGNUP_AND_CLAIM_YOUR_AIRTIME_GIFT,
                                            firstCap: true)!,
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline6!
                                            .copyWith(
                                                color: CustomColor.GRAY,
                                                fontSize: 14,
                                                fontWeight: FontWeight.w400),
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          hSharedPreference.set(
                                              HSharedPreference.SHOW_INFO,
                                              false);

                                          Navigator.pushReplacementNamed(
                                              context, RouteTo.PROFILE_SIGN_IN);
                                          // setState(() {
                                          //   showInfo = false;
                                          // });
                                        },
                                        child: Container(
                                          width: 200,
                                          height: 40,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              color: Theme.of(context)
                                                  .primaryColor),
                                          padding: const EdgeInsets.only(
                                            left: 15,
                                            top: 5,
                                            bottom: 10,
                                            right: 15,
                                          ),
                                          child: Center(
                                            child: Text(
                                              StringRsr.get(LanguageKey
                                                  .YES_I_WILL_SIGNUP)!,
                                              style: const TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      TextButton(
                                        onPressed: () async {
                                          hSharedPreference.set(
                                              HSharedPreference.SHOW_INFO,
                                              false);

                                          Navigator.pushReplacementNamed(
                                              context,
                                              RouteTo.CATEGORY_PREFERENCE);

                                          // setState(() {
                                          //   showInfo = false;
                                          // });
                                        },
                                        child: Text(
                                          StringRsr.get(
                                            LanguageKey
                                                .NO_I_DONT_WANT_A_FREE_GIFT,
                                          )!,
                                          style: const TextStyle(
                                              color: CustomColor.GRAY_LIGHT),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ));
                            }),
                          ]),
                    )),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
