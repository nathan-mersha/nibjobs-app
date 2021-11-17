import 'dart:ui';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:nibjobs/api/flutterfire.dart';
import 'package:nibjobs/bloc/description/description_cubit.dart';
import 'package:nibjobs/bloc/images/image_cubit.dart';
import 'package:nibjobs/db/k_shared_preference.dart';
import 'package:nibjobs/model/commerce/job.dart';
import 'package:nibjobs/model/profile/company.dart';
import 'package:nibjobs/model/profile/user.dart';
import 'package:nibjobs/route/route.dart';
import 'package:nibjobs/rsr/locale/lang/language_key.dart';
import 'package:nibjobs/rsr/locale/string_rsr.dart';
import 'package:nibjobs/rsr/theme/color.dart';
import 'package:nibjobs/themes/light_color.dart';
import 'package:nibjobs/themes/nib_custom_icons_icons.dart';
import 'package:nibjobs/themes/theme.dart';
import 'package:nibjobs/widget/icon/icons.dart';
import 'package:nibjobs/widget/info/message.dart';
import 'package:nibjobs/widget/product/product_placeholder.dart';
import 'package:nibjobs/widget/product/product_view.dart';
import 'package:share/share.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:url_launcher/url_launcher.dart';

class JobDetailPage extends StatefulWidget {
  @override
  _JobDetailPageState createState() => _JobDetailPageState();

  static getRatingStarView(Job job) {
    return RatingBar(
      itemSize: 20,
      initialRating: job.rating!.toDouble() ,
      minRating: 1,
      direction: Axis.horizontal,
      glow: true,
      maxRating: 5,
      allowHalfRating: true,
      itemCount: 5,
      onRatingUpdate: (rating) {
        // Send rating information to server
        // show pop animation and notify user of the updated rating info.
      },
      ratingWidget: RatingWidget(
        full: const Icon(
          Icons.star,
          color: Colors.amber,
        ),
        half: const Icon(
          Icons.star,
          color: Colors.amber,
        ),
        empty: const Icon(
          Icons.star,
          color: Colors.amber,
        ),
      ),
    );
  }
}

class _JobDetailPageState extends State<JobDetailPage> {
  final currencyFormat = NumberFormat("#,##0.00", "en_US");
  HSharedPreference hSharedPreference = GetHSPInstance.hSharedPreference;

  final num relatedJobLimit = 8;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  bool isSelected = false;
  bool isSet = false;
  bool isCompanyInfo = false;
  List<Job> cartItem = [];
  String? cart;
  Job? job;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  Future<void> seeInList() async {
    List<String> proFavList =
        await hSharedPreference.get(HSharedPreference.LIST_OF_FAV) ?? [];
    if (proFavList.contains(job!.jobId)) {
      isSet = true;
      setState(() {
        isSelected = true;
      });
    } else {
      isSet = true;
      setState(() {
        isSelected = false;
      });
    }
  }

  Future<void> addToList() async {
    List<String> proFavList =
        await hSharedPreference.get(HSharedPreference.LIST_OF_FAV) ?? [];
    proFavList.add(job!.jobId!);

    await hSharedPreference.set(HSharedPreference.LIST_OF_FAV, proFavList);
  }

  Future<void> removeInList() async {
    List<String> proFavList =
        await hSharedPreference.get(HSharedPreference.LIST_OF_FAV) ?? [];
    proFavList.remove(job!.jobId);
    await hSharedPreference.set(HSharedPreference.LIST_OF_FAV, proFavList);
  }

  Widget getAppBar2(BuildContext context, Job job,
      {bool showCategory = false}) {
    return AppBar(
      backgroundColor: LightColor.background,
      leading: IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        color: CustomColor.GRAY_DARK,
        icon: const Icon(Icons.arrow_back_outlined),
      ),
      actions: <Widget>[
        GestureDetector(
          onTap: () async {
            isSelected = !isSelected;
            if (isSelected) {
              final result = await addFavJob(job);
              if (result) {
                addToList();
                Fluttertoast.showToast(
                    msg:
                        "${job.name} ${StringRsr.get(LanguageKey.JOB_ADDED_TO_FAVORITE_LIST)}",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.CENTER,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.green,
                    textColor: Colors.white,
                    fontSize: 16.0);
              } else {}
            } else {
              final result = await deleteFavJob(job);
              if (result) {
                removeInList();
                Fluttertoast.showToast(
                    msg:
                        "${job.name} ${StringRsr.get(LanguageKey.JOB_REMOVED_FROM_FAVORITE_LIST)}",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.CENTER,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.red,
                    textColor: Colors.white,
                    fontSize: 16.0);
              } else {}
            }
            setState(() {});
          },
          child: Container(
            padding: const EdgeInsets.only(right: 20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              color: Colors.white,
            ),
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Icon(
                Icons.favorite,
                color: isSelected ? Colors.red : LightColor.lightGrey,
                size: 20,
              ),
            ),
          ),
        ),
        GestureDetector(
          onTap: () async {
            /// todo : here
            String url =
                "https://kelem.page.link/?link=https://kelem.et/job?id=${job.jobId}&apn=com.kelem.kelemapp&isi=1588695130&ibi=com.kelem.kelemapp";
            Share.share(url);
          },
          child: Container(
            padding: const EdgeInsets.only(right: 20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              color: Colors.white,
            ),
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Icon(
                NibCustomIcons.share,
                color: Theme.of(context).primaryColor,
                size: 20,
              ),
            ),
          ),
        ),
      ],
      //showCategory ? CategoryMenu() : Container()
      //backgroundColor: LightColor.lightGrey,
      elevation: 0,
    );
  }

  @override
  Widget build(BuildContext context) {
    job = ModalRoute.of(context)!.settings.arguments as Job?;
    if (!isSet) {
      seeInList();
    }
    return Scaffold(
      key: _scaffoldKey,
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(100),
          child: getAppBar2(context, job!)),
      // drawer: Menu.getSideDrawer(context),
      body: SafeArea(
        child: WillPopScope(
          onWillPop: () {
            if (isCompanyInfo) {
              isCompanyInfo = false;
              setState(() {});
              return Future.value(false);
            }
            return Future.value(true);
          },
          child: Stack(
            children: [
              Container(
                  child: ListView(
                shrinkWrap: false,
                primary: true,
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      // Section 1, Image, title, add to cart rating.
                      Container(
                        padding: AppTheme.padding,
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            buildJobViewSection(job!, context),
                            buildInfoData(job!),
                          ],
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          alignment: Alignment.bottomCenter,
                          padding: AppTheme.padding,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              buildSimilarItemsSection(job!),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          currencyFormat
                                              .format(job!.price)
                                              .toString(),
                                          style: const TextStyle(
                                            fontSize: 30,
                                            color: Color(0xff404040),
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          StringRsr.get(LanguageKey.BR)!,
                                          style: const TextStyle(
                                            color: Color(0xff404040),
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                    GestureDetector(
                                      onTap: () async {
                                        var uid = await hSharedPreference
                                            .get(HSharedPreference.KEY_USER_ID);
                                        var email = await hSharedPreference.get(
                                            HSharedPreference.KEY_USER_EMAIL);
                                        var phone = await hSharedPreference.get(
                                            HSharedPreference.KEY_USER_PHONE);
                                        var userName = await hSharedPreference
                                            .get(HSharedPreference
                                                .KEY_USER_NAME);
                                        var userImage = await hSharedPreference
                                            .get(HSharedPreference
                                                .KEY_USER_IMAGE_URL);
                                        List<String> list =
                                            await hSharedPreference.get(
                                                    HSharedPreference
                                                        .LIST_OF_FAV_CATEGORY) ??
                                                [];
                                        UserModel user = UserModel(
                                          userId: uid ??
                                              FirebaseAuth
                                                  .instance.currentUser!.uid,
                                          email: email,
                                          profilePicture: userImage,
                                          phoneNumber: phone,
                                          userName: userName,
                                          categoryList: list,
                                        );

                                        CalledJob calledJob = CalledJob(
                                          job: job,
                                          user: user,
                                          lastModified: DateTime.now(),
                                        );
                                        await addCallJob(calledJob);
                                        makePhoneCall(
                                            "tel://${job!.company!.primaryPhone!.replaceAll(" ", "")}");
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            color: Color(0xff9c0044)),
                                        padding: const EdgeInsets.only(
                                          left: 15,
                                          top: 5,
                                          bottom: 10,
                                          right: 15,
                                        ),
                                        child: Text(
                                          StringRsr.get(LanguageKey.CALL)!,
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 17),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      // Section 2, Introduction
                      //buildIntroductionSection(job),

                      // Divider(
                      //   height: 20,
                      // ),
                      // Section 3, Company Information

                      //buildCompanyInformationSection(company, context, job),

                      // Divider(
                      //   color: Theme.of(context).primaryColor,
                      //   height: 20,
                      // ),
                      // Section 4, Similar Items
                      //buildSimilarItemsSection(job)
                    ],
                  ),
                ],
              )),
              Visibility(
                visible: isCompanyInfo,
                child: GestureDetector(
                  onTap: () {
                    isCompanyInfo = false;
                    setState(() {});
                  },
                  child: Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.grey.withOpacity(0.5)),
                        ),
                      ),
                      Container(
                        width: AppTheme.fullWidth(context),
                        height: 250,
                        color: Colors.white,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const SizedBox(
                                  height: 30,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      job!.company!.name!,
                                      style: const TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                        color: CustomColor.TEXT_DARK,
                                      ),
                                    ),
                                    Visibility(
                                      visible: job!.company!.isVerified!,
                                      child: const Padding(
                                        padding: EdgeInsets.only(
                                            right: 8.0, left: 2.0),
                                        child: Icon(
                                          Icons.verified_user,
                                          color: Colors.lightGreen,
                                          size: 12,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        if (job!.company!.primaryPhone !=
                                            null) {
                                          makePhoneCall(
                                              "tel://${job!.company!.primaryPhone!.replaceAll(" ", "")}");
                                        }
                                      },
                                      child: Text(
                                        job!.company!.primaryPhone!,
                                        style: const TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.bold,
                                          color: CustomColor.GRAY,
                                        ),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        if (job!.company!.secondaryPhone !=
                                            null) {
                                          makePhoneCall(
                                              "tel://${job!.company!.secondaryPhone!.replaceAll(" ", "")}");
                                        }
                                      },
                                      child: Text(
                                        job!.company!.secondaryPhone!,
                                        style: const TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.bold,
                                          color: CustomColor.GRAY,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 10.0),
                              child: Column(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      if (job!.company!.website != "") {
                                        makeWebCall(
                                            "https:${job!.company!.website}");
                                      }
                                    },
                                    child: Text(
                                      job!.company!.website != ""
                                          ? job!.company!.website!
                                          : StringRsr.get(
                                              LanguageKey.NO_WEBSITE,
                                              firstCap: true)!,
                                      style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: CustomColor.GRAY_LIGHT,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    job!.company!.physicalAddress != ""
                                        ? job!.company!.physicalAddress!
                                        : StringRsr.get(
                                            LanguageKey.NO_PHYSICAL_ADDRESS,
                                            firstCap: true)!,
                                    style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                      color: CustomColor.GRAY_LIGHT,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      Positioned(
                        bottom: 210,
                        child: Container(
                          height: 80,
                          width: 80,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(40)),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: CachedNetworkImage(
                              imageUrl: job!.company!.logo!,
                              imageBuilder: (context, imageProvider) {
                                return Container(
                                  width: 20,
                                  decoration: BoxDecoration(
                                    color: Colors.red,
                                    borderRadius: BorderRadius.circular(40),
                                    image: DecorationImage(
                                      image: imageProvider,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                );
                              },
                              useOldImageOnUrlChange: true,
                              fit: BoxFit.cover,
                              placeholderFadeInDuration:
                                  Duration(microseconds: 200),
                              placeholder:
                                  (BuildContext context, String imageURL) {
                                return JobPlaceholder(job: job);
                              },
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> makePhoneCall(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Widget buildJobViewSection(Job job, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Container(
        height: 200,
        child: BlocBuilder<ImageCubit, ImageState>(
          builder: (context, state) {
            if (state is ImageInitial) {
              return Stack(
                //crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  CachedNetworkImage(
                    imageUrl: job.image![state.currentIndex],
                    imageBuilder: (context, imageProvider) {
                      return Container(
                        decoration: BoxDecoration(
                            image: DecorationImage(
                              image: imageProvider,
                              fit: BoxFit.cover,
                            ),
                            borderRadius: BorderRadius.circular(20)),
                      );
                    },
                    useOldImageOnUrlChange: true,
                    fit: BoxFit.cover,
                    placeholderFadeInDuration: Duration(microseconds: 200),
                    placeholder: (BuildContext context, String imageURL) {
                      return BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.grey.withOpacity(0.0)),
                        ),
                      );
                    },
                  ),
                  Container(
                    // decoration: BoxDecoration(
                    //   image: DecorationImage(
                    //     image: NetworkImage(job.image),
                    //     fit: BoxFit.cover,
                    //   ),
                    // ),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.grey.withOpacity(0.2)),
                      ),
                    ),
                  ),
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      //fit: StackFit.expand,
                      children: [
                        Stack(
                          //fit: StackFit.expand,
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (_) {
                                  return DetailScreen(
                                      image: job.image![state.currentIndex]);
                                }));
                              },
                              child: Hero(
                                tag: 'imageHero',
                                child: Container(
                                  width: 230,
                                  height: 199,
                                  child: JobView.getThumbnailView(job,
                                      expand: false, size: JobView.SIZE_SMALL),
                                ),
                              ),
                            ),
                          ],
                        ),
                        // const SizedBox(
                        //   height: 10,
                        // ),
                      ],
                    ),
                  ),
                  Visibility(
                    visible: job.image!.length > 1,
                    child: Align(
                      alignment: Alignment.center,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 4.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                                onPressed: () {
                                  // imageIndex =
                                  //     imageIndex > 0 ? imageIndex - 1 : imageIndex;
                                  //
                                  // setState(() {});
                                  BlocProvider.of<ImageCubit>(context)
                                      .emitPreviceImage(job.image!.length);
                                },
                                icon: const Icon(
                                  Icons.arrow_back_ios,
                                  color: CustomColor.GRAY_VERY_LIGHT,
                                  size: 20,
                                )),
                            IconButton(
                                onPressed: () {
                                  // imageIndex =
                                  //     imageIndex < 2 ? imageIndex + 1 : imageIndex;
                                  //
                                  // setState(() {});
                                  BlocProvider.of<ImageCubit>(context)
                                      .emitNextImage(job.image!.length);
                                },
                                icon: const Icon(
                                  Icons.arrow_forward_ios,
                                  color: CustomColor.GRAY_VERY_LIGHT,
                                  size: 20,
                                )),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Visibility(
                        visible: job.image!.length > 1,
                        child: Container(
                          alignment: Alignment.bottomCenter,
                          height: 20,
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 4.0),
                            child: ListView.builder(
                                itemCount: job.image!.length,
                                shrinkWrap: true,
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.only(right: 2.0),
                                    child: Icon(
                                      Icons.circle,
                                      size: 10,
                                      color: state.currentIndex == index
                                          ? Colors.white
                                          : Theme.of(context).accentColor,
                                    ),
                                  );
                                }),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              );
            }
            return Container();
          },
        ),
      ),
    );
  }

  Widget buildInfoData(Job job) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15, 0, 0, 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 250,
                child: AutoSizeText(
                  job.name!,
                  style: const TextStyle(
                    fontSize: 20,
                    color: CustomColor.TEXT_DARK,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.fade,
                ),
              ),
              GestureDetector(
                onTap: () {
                  // BlocProvider.of<DownBloc>(context).add(
                  //     DownSelectedEvent(job: job, key: _scaffoldKey,context: context));
                  // _scaffoldKey.currentState.showBottomSheet(
                  //   (context) {
                  //
                  //     return WillPopScope(
                  //       onWillPop: () {
                  //         BlocProvider.of<DownBloc>(context)
                  //             .add(DownUnSelectedEvent());
                  //         return Future.value(true);
                  //       },
                  //       child: buildJobViewSectionBottomSheet(
                  //           job, context),
                  //     );
                  //   },
                  //   elevation: 3,
                  // );
                  isCompanyInfo = true;
                  setState(() {});
                },
                child: CircleAvatar(
                  child: job.company!.logo == null
                      ? Text(
                          job.company!.name!.substring(0, 1),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                          ),
                        )
                      : CachedNetworkImage(
                          imageUrl: job.company!.logo,
                          imageBuilder: (context, imageProvider) {
                            return Container(
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: imageProvider,
                                    fit: BoxFit.cover,
                                  ),
                                  borderRadius: BorderRadius.circular(40)),
                            );
                          },
                          useOldImageOnUrlChange: false,
                          placeholderFadeInDuration: Duration(seconds: 1),
                          placeholder: (BuildContext context, String imageURL) {
                            return Text(
                              job.company!.name!.substring(0, 1).toUpperCase(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 40,
                              ),
                            );
                          },
                        ),
                  backgroundColor: Theme.of(context).accentColor,
                ),
              ),
            ],
          ),
          AutoSizeText(
            job.authorOrManufacturer!,
            style: TextStyle(
              color: Theme.of(context).primaryColor,
            ),
          ),
          // Column(
          //   mainAxisAlignment: MainAxisAlignment.end,
          //   crossAxisAlignment: CrossAxisAlignment.start,
          //   children: <Widget>[
          //     JobView.getPricingView(context, job,
          //         size: JobView.SIZE_LARGE),
          //     Text(
          //       job.tag.toString().replaceAll("[", "").replaceAll("]", ""),
          //       style: const TextStyle(color: CustomColor.GRAY_LIGHT),
          //     ),
          //     Row(
          //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //       children: <Widget>[
          //         JobDetailPage.getRatingStarView(job),
          //         TextButton(
          //           child: Text(
          //             "to wishlist",
          //             textScaleFactor: 0.9,
          //           ),
          //           onPressed: () {
          //             // todo : Add to wish list
          //           },
          //         ),
          //         cardButton(job),
          //       ],
          //     ),
          //   ],
          // ),
          buildIntroductionSection(job),
          Container(
            alignment: Alignment.topRight,
            child: Text(
              timeago.format(job.lastModified!),
              maxLines: 1,
              overflow: TextOverflow.fade,
              textAlign: TextAlign.right,
              softWrap: false,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: CustomColor.GRAY_DARK,
              ),
            ),
          ),
          Center(
            child: BlocBuilder<DescriptionCubit, DescriptionState>(
              builder: (context, state) {
                if (state is DescriptionInitial) {
                  return IconButton(
                      onPressed: () {
                        // showDescription = !showDescription;
                        // setState(() {});
                        BlocProvider.of<DescriptionCubit>(context)
                            .emitDescription();
                      },
                      icon: state.showDescription
                          ? Icon(Icons.keyboard_arrow_up_outlined)
                          : Icon(Icons.keyboard_arrow_down_outlined));
                }
                return Container();
              },
            ),
          ),
          const SizedBox(
            height: 5,
          ),
        ],
      ),
    );
  }

  Widget buildIntroductionSection(Job job) {
    return BlocBuilder<DescriptionCubit, DescriptionState>(
      builder: (context, state) {
        if (state is DescriptionInitial && state.showDescription) {
          return Container(
            padding: const EdgeInsets.only(top: 4),
            height: AppTheme.fullWidth(context) >= 800 ? 500 : 100,
            width: AppTheme.fullWidth(context),
            child: SingleChildScrollView(
              child: Text(
                job.description!,
                softWrap: true,
                textAlign: TextAlign.justify,
                style: const TextStyle(
                  color: CustomColor.TEXT_DARK,
                ),
              ),
            ),
          );
        }

        return Container(
          padding: const EdgeInsets.only(top: 4),
          child: Text(
            job.description!,
            softWrap: true,
            maxLines: 2,
            overflow: TextOverflow.fade,
            textAlign: TextAlign.justify,
            style: const TextStyle(color: CustomColor.TEXT_DARK),
          ),
        );
      },
    );
  }

  Container buildCompanyInformationSection(
      Company company, BuildContext context, Job _job) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          GestureDetector(
            onTap: () {
              /// Navigating to item company page
              Navigator.pushNamed(context, RouteTo.SHOP_DETAIL,
                  arguments: _job);
            },
            child: Text(
              company.name ?? "a",
              textScaleFactor: 1.2,
              style: const TextStyle(
                color: CustomColor.GRAY_DARK,
              ),
            ),
          ),
          company.isVerified!
              ? Row(
                  children: const <Widget>[
                    Icon(
                      Icons.verified_user,
                      color: Colors.lightGreen,
                      size: 12,
                    ),
                    Text(
                      "verified",
                      textScaleFactor: 0.9,
                      style: TextStyle(color: Colors.lightGreen),
                    )
                  ],
                )
              : Row(
                  children: <Widget>[
                    Icon(Icons.security, color: Colors.red.withOpacity(0.6)),
                    const Text("unverified")
                  ],
                ),
          const SizedBox(
            height: 8,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      company.primaryPhone ?? "no phone number found",
                      style: const TextStyle(color: CustomColor.GRAY_LIGHT),
                      textScaleFactor: 0.9,
                    ),
                    Text(
                      company.secondaryPhone ?? "-",
                      style: const TextStyle(color: CustomColor.GRAY_LIGHT),
                      textScaleFactor: 0.9,
                    ),
                    Text(
                      company.email ?? "no email found",
                      style: const TextStyle(color: CustomColor.GRAY_LIGHT),
                      textScaleFactor: 0.9,
                    ),
                    Row(
                      children: <Widget>[
                        Text(
                          company.physicalAddress ?? "no physical address",
                          style: const TextStyle(color: CustomColor.GRAY),
                          textScaleFactor: 0.7,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        GestureDetector(
                          onTap: () {
                            _lunchMapsUrl(company.coOrdinates![0],
                                company.coOrdinates![1]);
                            // Open map application to show the companys physical location
                          },
                          child: Text(
                            "view on map",
                            style: TextStyle(
                              color: Theme.of(context).accentColor,
                            ),
                            textScaleFactor: 0.9,
                          ),
                        )
                      ],
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.facebook,
                          color: Theme.of(context).accentColor,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Icon(
                          Icons.facebook,
                          color: Theme.of(context).accentColor,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Icon(
                          Icons.facebook,
                          color: Theme.of(context).accentColor,
                        ),
                      ],
                    )
                  ],
                ),
              ),

              // todo : change this with company's logo
              CircleAvatar(
                child: company.logo == null
                    ? Text(
                        company.name!.substring(0, 1),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      )
                    : CachedNetworkImage(
                        imageUrl: company.logo,
                        imageBuilder: (context, imageProvider) {
                          return Container(
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: imageProvider,
                                  fit: BoxFit.cover,
                                ),
                                borderRadius: BorderRadius.circular(40)),
                          );
                        },
                        useOldImageOnUrlChange: false,
                        placeholderFadeInDuration: Duration(seconds: 1),
                        placeholder: (BuildContext context, String imageURL) {
                          return Text(
                            company.name!.substring(0, 1).toUpperCase(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 40,
                            ),
                          );
                        },
                      ),
                backgroundColor: Theme.of(context).accentColor,
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget buildSimilarItemsSection(Job job) {
    return Container(
      height: 155,
      child: Column(
        children: [
          FutureBuilder(
              future: getRelatedJob(job),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.connectionState == ConnectionState.done &&
                    !snapshot.hasData) {
                  return Message(
                    message: "Could not find related items",
                  );
                } else if (snapshot.connectionState == ConnectionState.done &&
                    snapshot.hasData) {
                  List<Job> newJobs = snapshot.data;
                  return newJobs.isEmpty
                      ? Message(
                          message: "Could not find related items",
                        )
                      : Expanded(
                          child: ListView.builder(
                              shrinkWrap: false,
                              scrollDirection: Axis.horizontal,
                              itemCount: newJobs.length,
                              itemBuilder: (BuildContext context, int index) {
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: AspectRatio(
                                    aspectRatio: 0.7,
                                    child: GestureDetector(
                                      onTap: () {
                                        Navigator.pushNamed(
                                            context, RouteTo.JOB_DETAIL,
                                            arguments: newJobs[index]);
                                      },
                                      child: CachedNetworkImage(
                                        imageUrl: newJobs[index].image![0],
                                        imageBuilder: (context, imageProvider) {
                                          return Container(
                                            decoration: BoxDecoration(
                                                image: DecorationImage(
                                                  image: imageProvider,
                                                  fit: BoxFit.cover,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(20)),
                                          );
                                        },
                                        useOldImageOnUrlChange: true,
                                        placeholderFadeInDuration:
                                            const Duration(microseconds: 100),
                                        errorWidget: (BuildContext context,
                                            String imageURL, dynamic) {
                                          return JobPlaceholder(job: job);
                                        },
                                        placeholder: (BuildContext context,
                                            String imageURL) {
                                          return BackdropFilter(
                                            filter: ImageFilter.blur(
                                                sigmaX: 10.0, sigmaY: 10.0),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                  color: Colors.grey
                                                      .withOpacity(0.0)),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                );
                              }),
                        );
                } else if (snapshot.hasError) {
                  return Container(
                    child: Center(
                        child: Text(
                      snapshot.error.toString(),
                      style: const TextStyle(color: Colors.black45),
                    )),
                  );
                } else {
                  return Expanded(
                    child: Center(
                      child: Message(
                        icon: CustomIcons.getHorizontalLoading(),
                        message:
                            StringRsr.get(LanguageKey.LOADING, firstCap: true),
                      ),
                    ),
                  );
                }
              }),
        ],
      ),
    );
  }

  Future<List<Job>> getRelatedJob(Job job) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection(Job.COLLECTION_NAME)
        .where(Job.CATEGORY, isEqualTo: job.category)
        .where(Job.SUB_CATEGORY, isEqualTo: job.subCategory)
        .where(Job.TAG, arrayContainsAny: job.tag)
        .limit(relatedJobLimit as int)
        .orderBy(Job.LAST_MODIFIED, descending: true)
        .get();

    List<DocumentSnapshot> documentSnapshot = querySnapshot.docs;

    List<Job> jobs = documentSnapshot.map((DocumentSnapshot documentSnapshot) {
      Job p = Job.toModel(documentSnapshot.data());
      p.jobId = documentSnapshot.id;

      return p;
    }).toList();

    return jobs;
  }

  void _lunchMapsUrl(double lat, double long) async {
    final url = 'https://www.google.com/maps/search/?api=1&query=$lat,$long';
    if (await canLaunch(url)) {
      try {
        await launch(url);
      } catch (e) {}
    } else {}
  }
}

class DetailScreen extends StatelessWidget {
  final String? image;

  const DetailScreen({Key? key, this.image}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        child: Center(
          child: Hero(
            tag: 'imageHero',
            child: CachedNetworkImage(
              imageUrl: image!,
              imageBuilder: (context, imageProvider) {
                return Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: imageProvider,
                    ),
                  ),
                );
              },
              useOldImageOnUrlChange: true,
              fit: BoxFit.cover,
              placeholderFadeInDuration: Duration(microseconds: 200),
              placeholder: (BuildContext context, String imageURL) {
                return BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.grey.withOpacity(0.0)),
                  ),
                );
              },
            ),
          ),
        ),
        onTap: () {
          Navigator.pop(context);
        },
      ),
    );
  }
}